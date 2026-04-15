// Geometric primitives and circle/slot detection from polygon approximations.

#[derive(Debug, Clone, Copy)]
pub struct Point {
    pub x: f64,
    pub y: f64,
}

#[derive(Debug, Clone, Copy)]
pub struct Rect {
    pub min: Point,
    pub max: Point,
}

impl Rect {
    pub fn new(x0: f64, y0: f64, x1: f64, y1: f64) -> Self {
        Rect { min: Point { x: x0, y: y0 }, max: Point { x: x1, y: y1 } }
    }

    pub fn area(&self) -> f64 {
        (self.max.x - self.min.x) * (self.max.y - self.min.y)
    }

    pub fn expand(&self, margin: f64) -> Self {
        Rect {
            min: Point { x: self.min.x - margin, y: self.min.y - margin },
            max: Point { x: self.max.x + margin, y: self.max.y + margin },
        }
    }

    pub fn contains(&self, other: Rect) -> bool {
        other.min.x >= self.min.x && other.min.y >= self.min.y &&
        other.max.x <= self.max.x && other.max.y <= self.max.y
    }

    pub fn translate(&self, dx: f64, dy: f64) -> Self {
        Rect {
            min: Point { x: self.min.x + dx, y: self.min.y + dy },
            max: Point { x: self.max.x + dx, y: self.max.y + dy },
        }
    }

    pub fn as_polyline(&self) -> Polyline {
        Polyline {
            points: vec![
                Point { x: self.min.x, y: self.min.y },
                Point { x: self.max.x, y: self.min.y },
                Point { x: self.max.x, y: self.max.y },
                Point { x: self.min.x, y: self.max.y },
            ],
            closed: true,
        }
    }
}

#[derive(Debug, Clone)]
pub struct Circle {
    pub center: Point,
    pub radius: f64,
}

impl Circle {
    pub fn bbox(&self) -> Rect {
        Rect::new(
            self.center.x - self.radius,
            self.center.y - self.radius,
            self.center.x + self.radius,
            self.center.y + self.radius,
        )
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
        Some(Rect::new(x0, y0, x1, y1))
    }

    pub fn aspect_ratio(&self) -> f64 {
        if let Some(r) = self.bbox() {
            let w = r.max.x - r.min.x;
            let h = r.max.y - r.min.y;
            if w.min(h) < 1e-6 { return f64::INFINITY; }
            w.max(h) / w.min(h)
        } else {
            0.0
        }
    }
}

#[derive(Debug, Clone)]
pub struct Arc {
    pub center:      Point,
    pub radius:      f64,
    pub start_angle: f64, // degrees, CCW from +X axis (DXF convention)
    pub end_angle:   f64, // degrees, CCW from +X axis
}

impl Arc {
    pub fn bbox(&self) -> Rect {
        // Conservative: full circle bounding box. Arc is always contained within it.
        Rect::new(
            self.center.x - self.radius, self.center.y - self.radius,
            self.center.x + self.radius, self.center.y + self.radius,
        )
    }
}

#[derive(Debug, Clone)]
pub enum Shape {
    Circle(Circle),
    Arc(Arc),
    Poly(Polyline),
    Rect(Rect),
}

impl Shape {
    pub fn bbox(&self) -> Option<Rect> {
        match self {
            Shape::Circle(c) => Some(c.bbox()),
            Shape::Arc(a)    => Some(a.bbox()),
            Shape::Poly(p)   => p.bbox(),
            Shape::Rect(r)   => Some(*r),
        }
    }

    pub fn translate(&self, dx: f64, dy: f64) -> Shape {
        match self {
            Shape::Circle(c) => Shape::Circle(Circle {
                center: Point { x: c.center.x + dx, y: c.center.y + dy },
                radius: c.radius,
            }),
            Shape::Arc(a) => Shape::Arc(Arc {
                center: Point { x: a.center.x + dx, y: a.center.y + dy },
                ..*a
            }),
            Shape::Poly(p) => Shape::Poly(Polyline {
                points: p.points.iter().map(|pt| Point { x: pt.x + dx, y: pt.y + dy }).collect(),
                closed: p.closed,
            }),
            Shape::Rect(r) => Shape::Rect(r.translate(dx, dy)),
        }
    }
}

impl Rect {
    /// Compute the bounding box of a slice of shapes.
    pub fn from_shapes(shapes: &[Shape]) -> Option<Self> {
        let mut x0 = f64::INFINITY;
        let mut y0 = f64::INFINITY;
        let mut x1 = f64::NEG_INFINITY;
        let mut y1 = f64::NEG_INFINITY;
        for s in shapes {
            if let Some(r) = s.bbox() {
                x0 = x0.min(r.min.x); y0 = y0.min(r.min.y);
                x1 = x1.max(r.max.x); y1 = y1.max(r.max.y);
            }
        }
        if x0.is_infinite() { None } else { Some(Rect::new(x0, y0, x1, y1)) }
    }
}

/// A directed line segment between two points.
pub struct Line {
    pub start: Point,
    pub end:   Point,
}

impl Line {
    /// True if this segment lies entirely on one of the four edges of `r`.
    pub fn is_on_rect_edge(&self, r: &Rect) -> bool {
        const TOL: f64 = 0.01;
        let a = &self.start;
        let b = &self.end;
        ((a.x - r.min.x).abs() < TOL && (b.x - r.min.x).abs() < TOL) ||
        ((a.x - r.max.x).abs() < TOL && (b.x - r.max.x).abs() < TOL) ||
        ((a.y - r.min.y).abs() < TOL && (b.y - r.min.y).abs() < TOL) ||
        ((a.y - r.max.y).abs() < TOL && (b.y - r.max.y).abs() < TOL)
    }
}

impl From<&Polyline> for Vec<Line> {
    fn from(p: &Polyline) -> Vec<Line> {
        let n = p.points.len();
        let limit = if p.closed { n } else { n - 1 };
        (0..limit).map(|i| Line {
            start: p.points[i],
            end:   p.points[(i + 1) % n],
        }).collect()
    }
}

/// Which edge of a panel an object abuts — matches the DXF layer names used by the CNC machine.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Edge { Front, Left, Right, Rear }

impl Edge {
    pub fn label(self) -> &'static str {
        match self { Edge::Front => "FRONT", Edge::Left => "LEFT", Edge::Right => "RIGHT", Edge::Rear => "REAR" }
    }
}

impl Rect {
    /// Returns which edge of `self` the rect `other` abuts, within `tol` mm.
    pub fn abutting_edge(&self, other: Rect, tol: f64) -> Option<Edge> {
        if (other.min.x - self.min.x).abs() < tol { return Some(Edge::Left); }
        if (other.max.x - self.max.x).abs() < tol { return Some(Edge::Right); }
        if (other.min.y - self.min.y).abs() < tol { return Some(Edge::Front); }
        if (other.max.y - self.max.y).abs() < tol { return Some(Edge::Rear); }
        None
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
    let w = r.max.x - r.min.x;
    let h = r.max.y - r.min.y;
    let is_8 = |v: f64| (v - 8.0).abs() < 0.5;
    if !is_8(w) && !is_8(h) { return None; }
    if w.max(h) > 40.0 { return None; }

    let target = 32.0_f64;
    let cx = (r.min.x + r.max.x) / 2.0;
    let cy = (r.min.y + r.max.y) / 2.0;

    let (nx0, ny0, nx1, ny1) = if is_8(h) {
        if cx < pcx { (r.min.x, r.min.y, r.min.x + target, r.max.y) }
        else        { (r.max.x - target, r.min.y, r.max.x, r.max.y) }
    } else {
        if cy < pcy { (r.min.x, r.min.y, r.max.x, r.min.y + target) }
        else        { (r.min.x, r.max.y - target, r.max.x, r.max.y) }
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

/// Fit a circle to an arbitrary point set using the Kasa algebraic method.
///
/// Returns `(center, radius)` if all points lie within `tol` fractional error of
/// the fitted circle. Unlike the centroid approach, Kasa is unbiased for partial arcs.
fn kasa_fit(pts: &[Point], tol: f64) -> Option<(Point, f64)> {
    if pts.len() < 3 { return None; }
    let n = pts.len() as f64;
    // Shift to centroid of points for numerical stability.
    let mx = pts.iter().map(|p| p.x).sum::<f64>() / n;
    let my = pts.iter().map(|p| p.y).sum::<f64>() / n;
    let (mut sxx, mut syy, mut sxy) = (0.0_f64, 0.0_f64, 0.0_f64);
    let (mut sxxx, mut syyy, mut sxyy, mut sxxy) = (0.0_f64, 0.0_f64, 0.0_f64, 0.0_f64);
    for p in pts {
        let (x, y) = (p.x - mx, p.y - my);
        sxx += x*x; syy += y*y; sxy += x*y;
        sxxx += x*x*x; syyy += y*y*y; sxyy += x*y*y; sxxy += x*x*y;
    }
    let det = sxx * syy - sxy * sxy;
    if det.abs() < 1e-10 { return None; } // collinear
    let rhs1 = 0.5 * (sxxx + sxyy);
    let rhs2 = 0.5 * (syyy + sxxy);
    let a = (rhs1 * syy - rhs2 * sxy) / det;
    let b = (sxx * rhs2 - sxy * rhs1) / det;
    let cx = a + mx;
    let cy = b + my;
    let r = f64::sqrt(a*a + b*b + (sxx + syy) / n);
    if r < 0.5 { return None; }
    let max_err = pts.iter()
        .map(|p| (f64::hypot(p.x - cx, p.y - cy) - r).abs())
        .fold(0.0_f64, f64::max);
    if max_err / r > tol { return None; }
    Some((Point { x: cx, y: cy }, r))
}

/// Fit an Arc to a polyline whose endpoints lie on the panel boundary.
fn try_fit_arc(poly: &Polyline, tol: f64) -> Option<Arc> {
    if poly.points.len() < 3 { return None; }
    let (center, radius) = kasa_fit(&poly.points, tol)?;
    let first = *poly.points.first().unwrap();
    let last  = *poly.points.last().unwrap();
    let a0 = f64::atan2(first.y - center.y, first.x - center.x).to_degrees();
    let a1 = f64::atan2(last.y  - center.y, last.x  - center.x).to_degrees();
    // Determine winding: positive signed area = CCW in Y-up coords.
    let signed_area: f64 = {
        let pts = &poly.points;
        let m = pts.len();
        let mut s = 0.0_f64;
        for i in 0..m { let j = (i + 1) % m; s += pts[i].x * pts[j].y - pts[j].x * pts[i].y; }
        s
    };
    let (start_angle, end_angle) = if signed_area >= 0.0 { (a0, a1) } else { (a1, a0) };
    Some(Arc { center, radius, start_angle, end_angle })
}

fn is_on_boundary(p: Point, panel: &Rect, tol: f64) -> bool {
    (p.x - panel.min.x).abs() < tol || (p.x - panel.max.x).abs() < tol ||
    (p.y - panel.min.y).abs() < tol || (p.y - panel.max.y).abs() < tol
}

/// Replace polygon approximations of panel-edge arcs with Arc shapes.
///
/// Only polylines whose first and last points lie on the panel boundary are
/// candidates — these are open arc cuts that were split at the boundary by
/// `feature_loops`.
pub fn detect_arcs(shapes: Vec<Shape>, panel: &Rect, tol: f64) -> Vec<Shape> {
    const BOUNDARY_TOL: f64 = 0.5;
    shapes.into_iter().map(|shape| {
        if let Shape::Poly(ref poly) = shape {
            let first = poly.points.first().copied();
            let last  = poly.points.last().copied();
            if let (Some(f), Some(l)) = (first, last) {
                if is_on_boundary(f, panel, BOUNDARY_TOL) && is_on_boundary(l, panel, BOUNDARY_TOL) {
                    if let Some(arc) = try_fit_arc(poly, tol) {
                        return Shape::Arc(arc);
                    }
                }
            }
        }
        shape
    }).collect()
}
