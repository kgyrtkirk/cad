use crate::geom::{Point, Polyline, Shape, Rect};

const TOL: f64 = 0.01; // mm tolerance for "on AABB edge" test

// ── Aabb ──────────────────────────────────────────────────────────────────────

// FIXME: isn't this a Rect?
// FIXME: bad placement; should be inside geom
pub struct Aabb {
    pub min_x: f64,
    pub min_y: f64,
    pub max_x: f64,
    pub max_y: f64,
}

impl Aabb {
    pub fn from_shapes(shapes: &[Shape]) -> Option<Self> {
        let mut a = Aabb { min_x: f64::INFINITY, min_y: f64::INFINITY,
                           max_x: f64::NEG_INFINITY, max_y: f64::NEG_INFINITY };
        for s in shapes {
            if let Some(Rect { x0, y0, x1, y1 }) = s.bbox() {
                a.min_x = a.min_x.min(x0); a.min_y = a.min_y.min(y0);
                a.max_x = a.max_x.max(x1); a.max_y = a.max_y.max(y1);
            }
        }
        if a.min_x.is_infinite() { None } else { Some(a) }
    }

    pub fn translate(&self, dx: f64, dy: f64) -> Aabb {
        Aabb { min_x: self.min_x + dx, min_y: self.min_y + dy,
               max_x: self.max_x + dx, max_y: self.max_y + dy }
    }

    pub fn as_polyline(&self) -> Polyline {
        Polyline {
            points: vec![
                Point { x: self.min_x, y: self.min_y },
                Point { x: self.max_x, y: self.min_y },
                Point { x: self.max_x, y: self.max_y },
                Point { x: self.min_x, y: self.max_y },
            ],
            closed: true,
        }
    }
}

// ── Line ──────────────────────────────────────────────────────────────────────

// FIXME: bad placement; should be inside geom
struct Line {
    start: Point,
    end:   Point,
}

impl Line {
    fn is_on_aabb_edge(&self, bb: &Aabb) -> bool {
        let a = &self.start;
        let b = &self.end;
        ((a.x - bb.min_x).abs() < TOL && (b.x - bb.min_x).abs() < TOL) ||
        ((a.x - bb.max_x).abs() < TOL && (b.x - bb.max_x).abs() < TOL) ||
        ((a.y - bb.min_y).abs() < TOL && (b.y - bb.min_y).abs() < TOL) ||
        ((a.y - bb.max_y).abs() < TOL && (b.y - bb.max_y).abs() < TOL)
    }
}


/// Remove the last point if it duplicates the first (closed-path artifact from line expansion).
fn dedup_endpoints(pts: &mut Vec<Point>) {
    if pts.len() >= 2 {
        let first = &pts[0];
        let last  = &pts[pts.len() - 1];
        if (first.x - last.x).abs() < TOL && (first.y - last.y).abs() < TOL {
            pts.pop();
        }
    }
}

// FIXME: impl Into or From  for Polyline
fn poly_to_lines(p: &Polyline) -> Vec<Line> {
    let n = p.points.len();
    let limit = if p.closed { n } else { n - 1 };
    (0..limit).map(|i| Line {
        start: p.points[i].clone(),
        end:   p.points[(i + 1) % n].clone(),
    }).collect()
}

// ── Feature extraction ────────────────────────────────────────────────────────

/// Drop boundary lines, split the remainder into closed feature loops.
///
/// The logic follows the sequence:
///   lines.map(l -> l.is_on_aabb_edge ? null : l)
///   new object starts after each null
pub fn feature_loops(shapes: &[Shape], bb: &Aabb) -> Vec<Polyline> {
    let mut result = Vec::new();
    let mut discarded: Vec<Vec<Point>> = Vec::new();

    for shape in shapes {
        let Shape::Poly(poly) = shape else { continue };
        let lines = poly_to_lines(poly);

        let mut current: Vec<Point> = Vec::new();

        for line in &lines {
            if line.is_on_aabb_edge(bb) {
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
                    current.push(line.start.clone());
                }
                current.push(line.end.clone());
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
    // Stitch exactly 2 discarded single-segment runs into a closed loop.
    // This recovers shapes like full-width grooves whose short ends sit on the boundary.
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
