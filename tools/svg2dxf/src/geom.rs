// Geometric primitives and circle detection from polygon approximations.

#[derive(Debug, Clone)]
pub struct Point {
    pub x: f64,
    pub y: f64,
}

#[derive(Debug, Clone)]
pub struct Circle {
    pub center: Point,
    pub radius: f64,
}

#[derive(Debug, Clone)]
pub struct Polyline {
    pub points: Vec<Point>,
    pub closed: bool,
}

impl Polyline {
    /// Shoelace formula — signed area, zero for open or degenerate.
    pub fn area(&self) -> f64 {
        if !self.closed || self.points.len() < 3 {
            return 0.0;
        }
        let n = self.points.len();
        let mut sum = 0.0;
        for i in 0..n {
            let j = (i + 1) % n;
            sum += self.points[i].x * self.points[j].y;
            sum -= self.points[j].x * self.points[i].y;
        }
        (sum / 2.0).abs()
    }

    pub fn bbox(&self) -> Option<(f64, f64, f64, f64)> {
        if self.points.is_empty() {
            return None;
        }
        let min_x = self.points.iter().map(|p| p.x).fold(f64::INFINITY, f64::min);
        let max_x = self.points.iter().map(|p| p.x).fold(f64::NEG_INFINITY, f64::max);
        let min_y = self.points.iter().map(|p| p.y).fold(f64::INFINITY, f64::min);
        let max_y = self.points.iter().map(|p| p.y).fold(f64::NEG_INFINITY, f64::max);
        Some((min_x, min_y, max_x, max_y))
    }

    pub fn aspect_ratio(&self) -> f64 {
        if let Some((min_x, min_y, max_x, max_y)) = self.bbox() {
            let w = max_x - min_x;
            let h = max_y - min_y;
            if w.min(h) < 1e-6 {
                return f64::INFINITY;
            }
            w.max(h) / w.min(h)
        } else {
            0.0
        }
    }
}

#[derive(Debug, Clone)]
pub enum Shape {
    Circle(Circle),
    Poly(Polyline),
}

/// Try to fit a circle to a closed polygon.
/// All vertices must lie within `tol` fractional deviation from the mean radius.
fn try_fit_circle(poly: &Polyline, tol: f64) -> Option<Circle> {
    // Require at least 5 vertices (rectangles have 4 corners — keeping them out).
    if !poly.closed || poly.points.len() < 5 {
        return None;
    }
    // Bounding-box aspect ratio must be close to 1 (circles are round).
    if poly.aspect_ratio() > 1.5 {
        return None;
    }
    let n = poly.points.len() as f64;
    let cx = poly.points.iter().map(|p| p.x).sum::<f64>() / n;
    let cy = poly.points.iter().map(|p| p.y).sum::<f64>() / n;
    let dists: Vec<f64> = poly
        .points
        .iter()
        .map(|p| f64::hypot(p.x - cx, p.y - cy))
        .collect();
    let mean_r = dists.iter().sum::<f64>() / n;
    if mean_r < 0.5 {
        return None; // degenerate
    }
    let max_err = dists
        .iter()
        .map(|d| (d - mean_r).abs())
        .fold(0.0_f64, f64::max);
    if max_err / mean_r <= tol {
        Some(Circle {
            center: Point { x: cx, y: cy },
            radius: mean_r,
        })
    } else {
        None
    }
}

/// Replace polygon approximations of circles with Circle shapes.
pub fn detect_circles(shapes: Vec<Shape>, tol: f64) -> Vec<Shape> {
    shapes
        .into_iter()
        .map(|shape| {
            if let Shape::Poly(ref poly) = shape {
                if let Some(circle) = try_fit_circle(poly, tol) {
                    return Shape::Circle(circle);
                }
            }
            shape
        })
        .collect()
}

/// Canonical deduplication key — rotation-invariant, direction-invariant.
pub fn shape_key(shape: &Shape) -> String {
    match shape {
        Shape::Circle(c) => format!(
            "C:{:.2},{:.2},{:.2}",
            c.center.x, c.center.y, c.radius
        ),
        Shape::Poly(p) => poly_key(p),
    }
}

fn poly_key(poly: &Polyline) -> String {
    if poly.points.is_empty() {
        return String::new();
    }
    let pts: Vec<(i64, i64)> = poly
        .points
        .iter()
        .map(|p| ((p.x * 100.0).round() as i64, (p.y * 100.0).round() as i64))
        .collect();

    let n = pts.len();
    let min_idx = pts
        .iter()
        .enumerate()
        .min_by_key(|(_, p)| *p)
        .map(|(i, _)| i)
        .unwrap_or(0);

    if poly.closed && n > 2 {
        let fwd: String = (0..n)
            .map(|i| {
                let (x, y) = pts[(i + min_idx) % n];
                format!("{},{}", x, y)
            })
            .collect::<Vec<_>>()
            .join("|");
        let bwd: String = (0..n)
            .map(|i| {
                let (x, y) = pts[(n + min_idx - i) % n];
                format!("{},{}", x, y)
            })
            .collect::<Vec<_>>()
            .join("|");
        format!("PC:{}", if fwd <= bwd { fwd } else { bwd })
    } else {
        let fwd: String = pts
            .iter()
            .map(|(x, y)| format!("{},{}", x, y))
            .collect::<Vec<_>>()
            .join("|");
        let bwd: String = pts
            .iter()
            .rev()
            .map(|(x, y)| format!("{},{}", x, y))
            .collect::<Vec<_>>()
            .join("|");
        format!("PO:{}", if fwd <= bwd { fwd } else { bwd })
    }
}
