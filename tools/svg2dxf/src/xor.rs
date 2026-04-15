use crate::geom::{Line, Point, Polyline, Rect, Shape};

const TOL: f64 = 0.01; // mm tolerance for dedup

/// Remove the last point if it duplicates the first (closed-path artifact from line expansion).
fn dedup_endpoints(pts: &mut Vec<Point>) {
    if pts.len() >= 2 {
        let first = pts[0];
        let last  = pts[pts.len() - 1];
        if (first.x - last.x).abs() < TOL && (first.y - last.y).abs() < TOL {
            pts.pop();
        }
    }
}

/// For a closed polyline, rotate points so the first segment follows a boundary segment.
///
/// Without rotation, a non-boundary run that wraps around the end/start of the point
/// list gets split into two pieces by the main loop, causing spurious discards.
fn rotate_after_boundary(poly: &Polyline, bb: &Rect) -> Option<Polyline> {
    if !poly.closed { return None; }
    let lines = Vec::<Line>::from(poly);
    let n = lines.len();
    // Find i: lines[i] is non-boundary, lines[i-1] is boundary → start accumulating here.
    let idx = (0..n).find(|&i| {
        !lines[i].is_on_rect_edge(bb) && lines[(i + n - 1) % n].is_on_rect_edge(bb)
    })?;
    if idx == 0 { return None; } // already positioned correctly
    let mut pts = poly.points.clone();
    pts.rotate_left(idx);
    Some(Polyline { points: pts, closed: true })
}

// ── Feature extraction ────────────────────────────────────────────────────────

/// Drop boundary lines, split the remainder into closed feature loops.
pub fn feature_loops(shapes: &[Shape], bb: &Rect) -> Vec<Polyline> {
    let mut result = Vec::new();
    let mut discarded: Vec<Vec<Point>> = Vec::new();

    for shape in shapes {
        let Shape::Poly(poly) = shape else { continue };
        let rotated = rotate_after_boundary(poly, bb);
        let poly = rotated.as_ref().unwrap_or(poly);
        let lines = Vec::<Line>::from(poly);

        let mut current: Vec<Point> = Vec::new();

        for line in &lines {
            if line.is_on_rect_edge(bb) {
                // boundary segment — flush current run as a closed loop
                dedup_endpoints(&mut current);
                if current.len() >= 3 {
                    result.push(Polyline { points: std::mem::take(&mut current), closed: true });
                } else if current.len() == 2 {
                    discarded.push(std::mem::take(&mut current));
                } else {
                    current.clear();
                }
            } else {
                if current.is_empty() {
                    current.push(line.start);
                }
                current.push(line.end);
            }
        }

        // flush trailing run
        dedup_endpoints(&mut current);
        if current.len() >= 3 {
            result.push(Polyline { points: std::mem::take(&mut current), closed: true });
        } else if current.len() == 2 {
            discarded.push(std::mem::take(&mut current));
        }
    }

    // Stitch exactly 2 discarded single-segment runs into a closed loop
    // (recovers shapes like full-width grooves whose short ends sit on the boundary).
    match discarded.len() {
        0 => {}
        2 => {
            let pts: Vec<Point> = discarded.into_iter().flatten().collect();
            result.push(Polyline { points: pts, closed: true });
        }
        n => eprintln!("WARNING: {n} discarded 2-pt runs from one polygon — cannot stitch"),
    }

    result
}
