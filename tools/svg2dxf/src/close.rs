// Edge-close (edge-banding) detection.
//
// OpenSCAD renders close strips as thin filled rectangles along the panel
// boundary.  After AABB stripping they appear as highly elongated loops whose
// thin dimension abuts one of the four AABB edges.  We collect all such loops,
// group them by edge, and report one EdgeClose per edge.

use crate::geom::{Edge, Rect, Shape};

/// Rendering adds a 0.1 mm gap so all detected widths are 0.1 mm short.
const CLOSE_GAP_CORRECTION: f64 = 0.1;
/// Maximum close width we care about (anything thicker is not a close strip).
const MAX_CLOSE_MM: f64 = 5.0;
const TOL: f64 = 0.05;

#[derive(Debug, Clone)]
pub struct EdgeClose {
    pub edge:  Edge,
    pub width: f64,   // mm
}

/// Classify one shape as an edge-close strip, or return None.
///
/// The thin dimension is identified first to avoid matching Front/Rear strips
/// as Left/Right when their long edge coincides with the outer bounding box.
fn as_edge_close(shape: &Shape, bb: &Rect) -> Option<EdgeClose> {
    let r = shape.bbox()?;
    let dx = r.max.x - r.min.x;
    let dy = r.max.y - r.min.y;

    let (edge, width) = if dx <= dy {
        // Thinner (or equal) in X → Left or Right strip.
        if (r.min.x - bb.min.x).abs() < TOL {
            (Edge::Left, dx)
        } else if (r.max.x - bb.max.x).abs() < TOL {
            (Edge::Right, dx)
        } else {
            return None;
        }
    } else {
        // Thinner in Y → Front or Rear strip.
        if (r.min.y - bb.min.y).abs() < TOL {
            (Edge::Front, dy)
        } else if (r.max.y - bb.max.y).abs() < TOL {
            (Edge::Rear, dy)
        } else {
            return None;
        }
    };

    if width >= MAX_CLOSE_MM { return None; }
    Some(EdgeClose { edge, width: width + CLOSE_GAP_CORRECTION })
}

/// Partition shapes into (edge-close annotations, everything else).
/// Multiple fragments on the same edge are merged into one EdgeClose.
pub fn extract_closes(shapes: Vec<Shape>, bb: &Rect) -> (Vec<EdgeClose>, Vec<Shape>) {
    let mut closes: std::collections::BTreeMap<Edge, f64> = std::collections::BTreeMap::new();
    let mut rest = Vec::new();

    for shape in shapes {
        if let Some(ec) = as_edge_close(&shape, bb) {
            // Keep the largest observed width for this edge (fragments should agree).
            let entry = closes.entry(ec.edge).or_insert(0.0);
            if ec.width > *entry { *entry = ec.width; }
            continue; // don't add to rest
        }
        rest.push(shape);
    }

    let annotations = closes.into_iter()
        .map(|(edge, width)| EdgeClose { edge, width })
        .collect();

    (annotations, rest)
}
