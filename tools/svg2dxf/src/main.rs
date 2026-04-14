mod geom;
mod svg;
mod xor;
mod classify;
mod close;
mod dxf;

use std::collections::BTreeMap;
use std::env;
use std::fs;
use geom::{Shape, detect_circles, detect_slots};
use xor::{Aabb, feature_loops};
use close::extract_closes;
use classify::layer;

/// Keep only shapes belonging to one tile of a potentially repeated layout.
///
/// Finds the largest-area bounding box across all shapes, expands it by
/// TILE_MARGIN mm, and discards anything not fully inside.
/// Single-tile panels pass through unchanged.
fn keep_one_tile(shapes: Vec<Shape>) -> Vec<Shape> {
    const TILE_MARGIN: f64 = 3.0;

    let largest = match shapes.iter().filter_map(|s| s.bbox())
        .max_by(|a, b| a.area().partial_cmp(&b.area()).unwrap())
    {
        Some(r) => r,
        None    => return shapes,
    };

    let tile = largest.expand(TILE_MARGIN);

    let before = shapes.len();
    let result: Vec<Shape> = shapes.iter()
        .filter(|s| s.bbox().map_or(false, |r| tile.contains(r)))
        .cloned()
        .collect();

    let after = result.len();
    if after < before {
        if before % after != 0 {
            eprintln!("Tile dedup: {before} → {after} shapes, not a clean multiple — skipping");
            return shapes;
        }
        eprintln!("Tile dedup: kept {after} of {before} shapes ({}x repeat)", before / after);
    }
    result
}

fn run(input_path: &str, output_path: &str) -> Result<(), String> {
    let data = fs::read_to_string(input_path)
        .map_err(|e| format!("Cannot read {input_path}: {e}"))?;

    let (raw_shapes, width, height) = svg::parse_svg(&data)?;
    eprintln!("Parsed {} raw shapes ({}×{} mm)", raw_shapes.len(), width as i64, height as i64);

    // 0. Discard tiled copies — keep only shapes belonging to one tile.
    let raw_shapes = keep_one_tile(raw_shapes);

    // 1. Compute outer AABB (includes close strips) for close detection.
    let outer_bb = Aabb::from_shapes(&raw_shapes)
        .ok_or("No geometry found")?;

    // 2. Extract close strips — they live on the outer boundary.
    let (closes, remaining) = extract_closes(raw_shapes, &outer_bb);
    for ec in &closes { eprintln!("  close {}: {:.2}mm", ec.edge.label(), ec.width); }

    // 3. Inner panel AABB — computed without the close strips.
    let bb = Aabb::from_shapes(&remaining)
        .ok_or("No geometry after close removal")?;

    // 4. Extract individual feature loops by dropping segments on the panel boundary.
    let loops = feature_loops(&remaining, &bb);
    eprintln!("Feature loops after boundary strip: {}", loops.len());
    let loop_shapes: Vec<Shape> = loops.into_iter().map(Shape::Poly).collect();

    // 5. Circle and slot detection.
    let panel_cx = (bb.min_x + bb.max_x) / 2.0;
    let panel_cy = (bb.min_y + bb.max_y) / 2.0;
    let shapes = detect_circles(loop_shapes, 0.05);
    let shapes = detect_slots(shapes, panel_cx, panel_cy);
    eprintln!("After detection: {}", shapes.len());

    // 6. Translate everything so the panel's bottom-left corner sits at the origin.
    let (dx, dy) = (-bb.min_x, -bb.min_y);
    let shapes: Vec<Shape> = shapes.into_iter().map(|s| s.translate(dx, dy)).collect();
    let bb       = bb.translate(dx, dy);
    let outer_bb = outer_bb.translate(dx, dy);
    eprintln!("Translated by ({dx:.2}, {dy:.2}) — panel now at origin");

    // 7. Layer assignment.
    let mut by_layer: BTreeMap<String, Vec<&Shape>> = BTreeMap::new();
    for shape in &shapes {
        by_layer.entry(layer(shape)).or_default().push(shape);
    }
    for (l, v) in &by_layer { eprintln!("  layer {l}: {} shapes", v.len()); }

    // Inner boundary (informational — raw panel outline before close strips).
    by_layer.entry("RAW_PANEL".to_string()).or_default().push(
        Box::leak(Box::new(Shape::Poly(bb.as_polyline())))
    );
    // Outer boundary (includes close strips) — this is the PANEL the machine uses.
    by_layer.entry("PANEL".to_string()).or_default().push(
        Box::leak(Box::new(Shape::Poly(outer_bb.as_polyline())))
    );

    let mut drawing = dxf::build_drawing(&by_layer);
    dxf::add_close_layers(&mut drawing, &closes, &outer_bb);
    drawing.save_file(output_path)
        .map_err(|e| format!("Cannot write {output_path}: {e}"))?;

    eprintln!("Wrote {output_path}");
    Ok(())
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: svg2dxf <input.svg> [output.dxf]");
        std::process::exit(1);
    }
    let output_path = if args.len() >= 3 {
        args[2].clone()
    } else {
        std::path::Path::new(&args[1]).with_extension("dxf").to_string_lossy().into_owned()
    };

    if let Err(e) = run(&args[1], &output_path) {
        eprintln!("Error: {e}");
        std::process::exit(1);
    }
}
