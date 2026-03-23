// SVG parsing via usvg — returns flat list of Shapes with Y already flipped for DXF.

use usvg::{Group, Node, Tree};
use usvg::tiny_skia_path::PathSegment;
use crate::geom::{Point, Polyline, Shape};

/// Parse SVG text and return all path shapes.
/// Y coordinates are flipped (DXF uses Y-up, SVG uses Y-down).
pub fn parse_svg(data: &str) -> Result<(Vec<Shape>, f64, f64), String> {
    // dpi=25.4 → 1 user unit = 1 mm (SVG mm attributes preserved as-is).
    let opt = usvg::Options { dpi: 25.4, ..Default::default() };
    let tree = Tree::from_str(data, &opt).map_err(|e| e.to_string())?;

    let size = tree.size();
    let width = size.width() as f64;
    let height = size.height() as f64;

    let mut shapes = Vec::new();
    collect_group(tree.root(), height, &mut shapes);

    Ok((shapes, width, height))
}

fn collect_group(group: &Group, height: f64, out: &mut Vec<Shape>) {
    for node in group.children() {
        match node {
            Node::Path(path) => {
                let segs = path_to_polylines(path.data().segments(), height);
                out.extend(segs);
            }
            Node::Group(g) => collect_group(g, height, out),
            _ => {}
        }
    }
}

/// Split a path's segments at Move commands into separate Polylines.
fn path_to_polylines<I>(segments: I, height: f64) -> Vec<Shape>
where
    I: Iterator<Item = PathSegment>,
{
    let mut result = Vec::new();
    let mut current: Vec<Point> = Vec::new();
    let mut closed = false;

    let flip = |y: f32| height - y as f64;

    for seg in segments {
        match seg {
            PathSegment::MoveTo(p) => {
                flush(&mut current, closed, &mut result);
                closed = false;
                current.push(Point { x: p.x as f64, y: flip(p.y) });
            }
            PathSegment::LineTo(p) => {
                current.push(Point { x: p.x as f64, y: flip(p.y) });
            }
            // Approximate curves as their end point only — source SVG uses polygon approximations.
            PathSegment::QuadTo(_, p) | PathSegment::CubicTo(_, _, p) => {
                current.push(Point { x: p.x as f64, y: flip(p.y) });
            }
            PathSegment::Close => {
                closed = true;
                flush(&mut current, closed, &mut result);
                closed = false;
            }
        }
    }
    flush(&mut current, closed, &mut result);
    result
}

fn flush(pts: &mut Vec<Point>, closed: bool, out: &mut Vec<Shape>) {
    if pts.len() < 2 {
        pts.clear();
        return;
    }
    // Remove explicit duplicate of first point that some exporters add before Close.
    if closed && pts.len() >= 3 {
        let n = pts.len();
        let first = &pts[0];
        let last = &pts[n - 1];
        if (first.x - last.x).abs() < 1e-6 && (first.y - last.y).abs() < 1e-6 {
            pts.pop();
        }
    }
    if pts.len() >= 2 {
        out.push(Shape::Poly(Polyline {
            points: std::mem::take(pts),
            closed,
        }));
    } else {
        pts.clear();
    }
}
