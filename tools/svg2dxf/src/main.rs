mod geom;
mod svg;
mod xor;
mod classify;
mod dxf;

use std::collections::{BTreeMap, HashSet};
use std::env;
use std::fs;
use geom::{Shape, detect_circles, shape_key};
use xor::{Aabb, feature_loops};
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

    for (i, lp) in loops.iter().enumerate() {
        eprintln!("  loop {i:2}: {} pts  ar={:.1}  bbox={:?}", lp.points.len(), lp.aspect_ratio(), lp.bbox());
    }
    let loop_shapes: Vec<Shape> = loops.into_iter().map(Shape::Poly).collect();

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

    // Add the AABB rectangle as its own layer.
    let aabb_shape = Shape::Poly(bb.as_polyline());
    by_layer.entry("boundary".to_string()).or_default().push(
        // We need a reference with lifetime tied to a local — box it.
        Box::leak(Box::new(aabb_shape))
    );

    let drawing = dxf::build_drawing(&by_layer);
    drawing.save_file(&args[2])
        .unwrap_or_else(|e| { eprintln!("Cannot write {}: {e}", args[2]); std::process::exit(1) });

    eprintln!("Wrote {}", args[2]);
}
