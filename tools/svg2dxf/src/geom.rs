// Geometric primitives and circle/slot detection from polygon approximations.

#[derive(Debug, Clone, Copy)]
pub struct Rect {
    pub x0: f64,
    pub y0: f64,
    pub x1: f64,
    pub y1: f64,
}

impl Rect {
    pub fn area(&self) -> f64 {
        (self.x1 - self.x0) * (self.y1 - self.y0)
    }

    pub fn expand(&self, margin: f64) -> Self {
        Rect { x0: self.x0 - margin, y0: self.y0 - margin,
               x1: self.x1 + margin, y1: self.y1 + margin }
    }

    pub fn contains(&self, other: Rect) -> bool {
        other.x0 >= self.x0 && other.y0 >= self.y0 &&
        other.x1 <= self.x1 && other.y1 <= self.y1
    }
}

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

impl Circle {
    pub fn bbox(&self) -> Rect {
        Rect {
            x0: self.center.x - self.radius,
            y0: self.center.y - self.radius,
            x1: self.center.x + self.radius,
            y1: self.center.y + self.radius,
        }
    }
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

    pub fn bbox(&self) -> Option<Rect> {
        if self.points.is_empty() { return None; }
        let x0 = self.points.iter().map(|p| p.x).fold(f64::INFINITY,     f64::min);
        let x1 = self.points.iter().map(|p| p.x).fold(f64::NEG_INFINITY, f64::max);
        let y0 = self.points.iter().map(|p| p.y).fold(f64::INFINITY,     f64::min);
        let y1 = self.points.iter().map(|p| p.y).fold(f64::NEG_INFINITY, f64::max);
        Some(Rect { x0, y0, x1, y1 })
    }

    pub fn aspect_ratio(&self) -> f64 {
        if let Some(r) = self.bbox() {
            let w = r.x1 - r.x0;
            let h = r.y1 - r.y0;
            if w.min(h) < 1e-6 { return f64::INFINITY; }
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

impl Shape {
    pub fn bbox(&self) -> Option<Rect> {
        match self {
            Shape::Circle(c) => Some(c.bbox()),
            Shape::Poly(p)   => p.bbox(),
        }
    }
}

/// Try to fit a circle to a closed polygon.
/// All vertices must lie within `tol` fractional deviation from the mean radius.
fn try_fit_circle(poly: &Polyline, tol: f64) -> Option<Circle> {
    // Require at least 5 vertices (rectangles have 4 corners — keeping them out).
    if !poly.closed || poly.points.len() < 5 { return None; }
    // Bounding-box aspect ratio must be close to 1 (circles are round).
    if poly.aspect_ratio() > 1.5 { return None; }
    let n = poly.points.len() as f64;
    let cx = poly.points.iter().map(|p| p.x).sum::<f64>() / n;
    let cy = poly.points.iter().map(|p| p.y).sum::<f64>() / n;
    let dists: Vec<f64> = poly.points.iter()
        .map(|p| f64::hypot(p.x - cx, p.y - cy))
        .collect();
    let mean_r = dists.iter().sum::<f64>() / n;
    if mean_r < 0.5 { return None; }
    let max_err = dists.iter().map(|d| (d - mean_r).abs()).fold(0.0_f64, f64::max);
    if max_err / mean_r <= tol {
        Some(Circle { center: Point { x: cx, y: cy }, radius: mean_r })
    } else {
        None
    }
}

/// Expand 8mm-wide edge slots to 32mm-deep rectangles, anchoring on the panel-edge side.
pub fn detect_slots(shapes: Vec<Shape>, panel_cx: f64, panel_cy: f64) -> Vec<Shape> {
    shapes.into_iter().map(|shape| {
        if let Shape::Poly(ref poly) = shape {
            if let Some(expanded) = try_expand_slot(poly, panel_cx, panel_cy) {
                return Shape::Poly(expanded);
            }
        }
        shape
    }).collect()
}

fn try_expand_slot(poly: &Polyline, pcx: f64, pcy: f64) -> Option<Polyline> {
    if !poly.closed { return None; }
    let r = poly.bbox()?;
    let w = r.x1 - r.x0;
    let h = r.y1 - r.y0;
    let is_8 = |v: f64| (v - 8.0).abs() < 0.5;
    if !is_8(w) && !is_8(h) { return None; }
    if w.max(h) > 40.0 { return None; }

    let target = 32.0_f64;
    let cx = (r.x0 + r.x1) / 2.0;
    let cy = (r.y0 + r.y1) / 2.0;

    let (nx0, ny0, nx1, ny1) = if is_8(h) {
        if cx < pcx { (r.x0, r.y0, r.x0 + target, r.y1) }
        else        { (r.x1 - target, r.y0, r.x1, r.y1) }
    } else {
        if cy < pcy { (r.x0, r.y0, r.x1, r.y0 + target) }
        else        { (r.x0, r.y1 - target, r.x1, r.y1) }
    };

    Some(Polyline {
        points: vec![
            Point { x: nx0, y: ny0 }, Point { x: nx1, y: ny0 },
            Point { x: nx1, y: ny1 }, Point { x: nx0, y: ny1 },
        ],
        closed: true,
    })
}

/// Replace polygon approximations of circles with Circle shapes.
pub fn detect_circles(shapes: Vec<Shape>, tol: f64) -> Vec<Shape> {
    shapes.into_iter().map(|shape| {
        if let Shape::Poly(ref poly) = shape {
            if let Some(circle) = try_fit_circle(poly, tol) {
                return Shape::Circle(circle);
            }
        }
        shape
    }).collect()
}
