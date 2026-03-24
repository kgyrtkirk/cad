mod geom;
mod svg;
mod xor;
mod classify;
mod close;
mod dxf;

use std::collections::{BTreeMap, HashSet};
use std::env;
use std::fs;
use geom::{Shape, detect_circles, detect_slots, shape_key};
use xor::{Aabb, feature_loops};
use close::extract_closes;
use classify::layer;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: svg2dxf <input.svg> [output.dxf]");
        std::process::exit(1);
    }
    let output_path = if args.len() >= 3 {
        args[2].clone()
    } else {
        let p = std::path::Path::new(&args[1]);
        p.with_extension("dxf").to_string_lossy().into_owned()
    };

    let data = fs::read_to_string(&args[1])
        .unwrap_or_else(|e| { eprintln!("Cannot read {}: {e}", args[1]); std::process::exit(1) });

    let (raw_shapes, width, height) = svg::parse_svg(&data)
        .unwrap_or_else(|e| { eprintln!("SVG parse error: {e}"); std::process::exit(1) });

    eprintln!("Parsed {} raw shapes ({}×{} mm)", raw_shapes.len(), width as i64, height as i64);

    // 1. Compute outer AABB (includes close strips) for close detection.
    let outer_bb = Aabb::from_shapes(&raw_shapes)
        .unwrap_or_else(|| { eprintln!("No geometry found"); std::process::exit(1) });

    // 2. Extract close strips first — they live on the outer boundary.
    let (closes, remaining) = extract_closes(raw_shapes, &outer_bb);
    for ec in &closes { eprintln!("  close {}: {:.2}mm", ec.edge.label(), ec.width); }

    // 3. Inner panel AABB — computed without the close strips.
    let bb = Aabb::from_shapes(&remaining)
        .unwrap_or_else(|| { eprintln!("No geometry after close removal"); std::process::exit(1) });

    // 4. Extract individual feature loops by dropping segments on the panel boundary.
    let loops = feature_loops(&remaining, &bb);
    eprintln!("Feature loops after boundary strip: {}", loops.len());
    let loop_shapes: Vec<Shape> = loops.into_iter().map(Shape::Poly).collect();

    // 5. Circle and slot detection + dedup.
    let panel_cx = (bb.min_x + bb.max_x) / 2.0;
    let panel_cy = (bb.min_y + bb.max_y) / 2.0;
    let shapes = detect_circles(loop_shapes, 0.05);
    let shapes = detect_slots(shapes, panel_cx, panel_cy);
    let mut seen = HashSet::new();
    let shapes: Vec<Shape> = shapes.into_iter().filter(|s| seen.insert(shape_key(s))).collect();

    eprintln!("After circle detection + dedup: {}", shapes.len());

    // 6. Layer assignment.
    let mut by_layer: BTreeMap<String, Vec<&Shape>> = BTreeMap::new();
    for shape in &shapes {
        by_layer.entry(layer(shape)).or_default().push(shape);
    }
    for (l, v) in &by_layer { eprintln!("  layer {l}: {} shapes", v.len()); }

    // Panel boundary (inner — the actual cut outline).
    by_layer.entry("panel".to_string()).or_default().push(
        Box::leak(Box::new(Shape::Poly(bb.as_polyline())))
    );

    // Outer boundary (includes close strips).
    by_layer.entry("extended_boundary".to_string()).or_default().push(
        Box::leak(Box::new(Shape::Poly(outer_bb.as_polyline())))
    );

    let mut drawing = dxf::build_drawing(&by_layer);
    dxf::add_close_layers(&mut drawing, &closes, &outer_bb);
    drawing.save_file(&output_path)
        .unwrap_or_else(|e| { eprintln!("Cannot write {}: {e}", output_path); std::process::exit(1) });

    eprintln!("Wrote {}", output_path);
}
