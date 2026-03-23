mod geom;
mod svg;
mod classify;
mod dxf;

use std::collections::{BTreeMap, HashSet};
use std::env;
use std::fs;
use geom::{detect_circles, shape_key};
use classify::layer;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        eprintln!("Usage: svg2dxf <input.svg> <output.dxf>");
        std::process::exit(1);
    }
    let input = &args[1];
    let output = &args[2];

    let data = fs::read_to_string(input)
        .unwrap_or_else(|e| { eprintln!("Cannot read {input}: {e}"); std::process::exit(1) });

    let (raw_shapes, width, height) = svg::parse_svg(&data)
        .unwrap_or_else(|e| { eprintln!("SVG parse error: {e}"); std::process::exit(1) });

    eprintln!("Parsed {} raw shapes ({}×{} mm)", raw_shapes.len(), width as i64, height as i64);

    // Circle detection
    let shapes = detect_circles(raw_shapes, 0.05);

    // Deduplication
    let mut seen = HashSet::new();
    let shapes: Vec<_> = shapes
        .into_iter()
        .filter(|s| seen.insert(shape_key(s)))
        .collect();

    eprintln!("After dedup + circle detection: {} shapes", shapes.len());

    // Layer assignment
    let mut by_layer: BTreeMap<String, Vec<&geom::Shape>> = BTreeMap::new();
    for shape in &shapes {
        by_layer.entry(layer(shape)).or_default().push(shape);
    }
    for (l, v) in &by_layer {
        eprintln!("  layer {l}: {} shapes", v.len());
    }

    let drawing = dxf::build_drawing(&by_layer);
    drawing.save_file(output)
        .unwrap_or_else(|e| { eprintln!("Cannot write {output}: {e}"); std::process::exit(1) });

    eprintln!("Wrote {output}");
}
