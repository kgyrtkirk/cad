// Edge-close (edge-banding) detection.
//
// OpenSCAD renders close strips as thin filled rectangles along the panel
// boundary.  After AABB stripping they appear as highly elongated loops whose
// thin dimension abuts one of the four AABB edges.  We collect all such loops,
// group them by edge, and report one EdgeClose per edge.

use crate::geom::{Polyline, Shape};
use crate::xor::Aabb;

/// Rendering adds a 0.1 mm gap so all detected widths are 0.1 mm short.
const CLOSE_GAP_CORRECTION: f64 = 0.1;
/// Maximum close width we care about (anything thicker is not a close strip).
const MAX_CLOSE_MM: f64 = 5.0;
const TOL: f64 = 0.05;

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Edge { Bottom, Left, Right, Top }

impl Edge {
    pub fn label(self) -> &'static str {
        match self { Edge::Bottom => "B", Edge::Left => "L", Edge::Right => "R", Edge::Top => "T" }
    }
}

#[derive(Debug, Clone)]
pub struct EdgeClose {
    pub edge:  Edge,
    pub width: f64,   // mm
}

/// Classify one loop as an edge-close strip, or return None.
fn as_edge_close(poly: &Polyline, bb: &Aabb) -> Option<EdgeClose> {
    let (x0, y0, x1, y1) = poly.bbox()?;
    let w = x1 - x0;
    let h = y1 - y0;

    if (x0 - bb.min_x).abs() < TOL && w < MAX_CLOSE_MM {
        return Some(EdgeClose { edge: Edge::Left,   width: w + CLOSE_GAP_CORRECTION });
    }
    if (x1 - bb.max_x).abs() < TOL && w < MAX_CLOSE_MM {
        return Some(EdgeClose { edge: Edge::Right,  width: w + CLOSE_GAP_CORRECTION });
    }
    if (y0 - bb.min_y).abs() < TOL && h < MAX_CLOSE_MM {
        return Some(EdgeClose { edge: Edge::Bottom, width: h + CLOSE_GAP_CORRECTION });
    }
    if (y1 - bb.max_y).abs() < TOL && h < MAX_CLOSE_MM {
        return Some(EdgeClose { edge: Edge::Top,    width: h + CLOSE_GAP_CORRECTION });
    }
    None
}

/// Partition shapes into (edge-close annotations, everything else).
/// Multiple fragments on the same edge are merged into one EdgeClose.
pub fn extract_closes(shapes: Vec<Shape>, bb: &Aabb) -> (Vec<EdgeClose>, Vec<Shape>) {
    let mut closes: std::collections::BTreeMap<Edge, f64> = std::collections::BTreeMap::new();
    let mut rest = Vec::new();

    for shape in shapes {
        if let Shape::Poly(ref poly) = shape {
            if let Some(ec) = as_edge_close(poly, bb) {
                // Keep the largest observed width for this edge (fragments should agree).
                let entry = closes.entry(ec.edge).or_insert(0.0);
                if ec.width > *entry { *entry = ec.width; }
                continue; // don't add to rest
            }
        }
        rest.push(shape);
    }

    let annotations = closes.into_iter()
        .map(|(edge, width)| EdgeClose { edge, width })
        .collect();

    (annotations, rest)
}
