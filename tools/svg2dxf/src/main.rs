mod geom;
mod svg;
mod xor;
mod classify;
mod close;
mod dxf;

use std::collections::{BTreeMap, HashSet};
use std::env;
use std::fs;
use geom::{Shape, detect_circles, shape_key};
use xor::{Aabb, feature_loops};
use close::{extract_closes, Edge};
use classify::layer;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        eprintln!("Usage: svg2dxf <input.svg> <output.dxf>");
        std::process::exit(1);
    }

    let data = fs::read_to_string(&args[1])
        .unwrap_or_else(|e| { eprintln!("Cannot read {}: {e}", args[1]); std::process::exit(1) });

    let (raw_shapes, width, height) = svg::parse_svg(&data)
        .unwrap_or_else(|e| { eprintln!("SVG parse error: {e}"); std::process::exit(1) });

    eprintln!("Parsed {} raw shapes ({}×{} mm)", raw_shapes.len(), width as i64, height as i64);

    let bb = Aabb::from_shapes(&raw_shapes)
        .unwrap_or_else(|| { eprintln!("No geometry found"); std::process::exit(1) });

    // Extract individual feature loops by dropping boundary segments.
    let loops = feature_loops(&raw_shapes, &bb);
    eprintln!("Feature loops after boundary strip: {}", loops.len());

let loop_shapes: Vec<Shape> = loops.into_iter().map(Shape::Poly).collect();

    // Separate edge-close strips from the rest.
    let (closes, loop_shapes) = extract_closes(loop_shapes, &bb);
    for ec in &closes { eprintln!("  close {}: {:.2}mm", ec.edge.label(), ec.width); }

    // Circle detection + dedup.
    let shapes = detect_circles(loop_shapes, 0.05);
    let mut seen = HashSet::new();
    let shapes: Vec<Shape> = shapes.into_iter().filter(|s| seen.insert(shape_key(s))).collect();

    eprintln!("After circle detection + dedup: {}", shapes.len());

    // Layer assignment.
    let mut by_layer: BTreeMap<String, Vec<&Shape>> = BTreeMap::new();
    for shape in &shapes {
        by_layer.entry(layer(shape)).or_default().push(shape);
    }
    for (l, v) in &by_layer { eprintln!("  layer {l}: {} shapes", v.len()); }

    // Inner panel boundary (shrunk by close widths — the actual cut outline).
    let mut p_min_x = bb.min_x;
    let mut p_max_x = bb.max_x;
    let mut p_min_y = bb.min_y;
    let mut p_max_y = bb.max_y;
    for ec in &closes {
        match ec.edge {
            Edge::Left   => p_min_x += ec.width,
            Edge::Right  => p_max_x -= ec.width,
            Edge::Bottom => p_min_y += ec.width,
            Edge::Top    => p_max_y -= ec.width,
        }
    }
    let panel_bb = Aabb { min_x: p_min_x, min_y: p_min_y, max_x: p_max_x, max_y: p_max_y };
    by_layer.entry("panel".to_string()).or_default().push(
        Box::leak(Box::new(Shape::Poly(panel_bb.as_polyline())))
    );

    // Outer AABB (includes close strips).
    by_layer.entry("boundary".to_string()).or_default().push(
        Box::leak(Box::new(Shape::Poly(bb.as_polyline())))
    );

    let mut drawing = dxf::build_drawing(&by_layer);
    dxf::add_close_layers(&mut drawing, &closes, &bb);
    drawing.save_file(&args[2])
        .unwrap_or_else(|e| { eprintln!("Cannot write {}: {e}", args[2]); std::process::exit(1) });

    eprintln!("Wrote {}", args[2]);
}
