// Geometric primitives and circle/slot detection from polygon approximations.
use enum_dispatch::enum_dispatch;

#[enum_dispatch]
pub trait Primitive {
    fn bbox(&self) -> Rect;
    fn translate(&self, dx: f64, dy: f64) -> Self;
}

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

    pub fn union(&self, other: Rect) -> Self {
        Rect::new(
            self.min.x.min(other.min.x), self.min.y.min(other.min.y),
            self.max.x.max(other.max.x), self.max.y.max(other.max.y),
        )
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

impl Primitive for Rect {
    fn bbox(&self) -> Rect { *self }
    fn translate(&self, dx: f64, dy: f64) -> Self { self.translate(dx, dy) }
}

#[derive(Debug, Clone)]
pub struct Circle {
    pub center: Point,
    pub radius: f64,
}

impl Primitive for Circle {
    fn bbox(&self) -> Rect {
        Rect::new(
            self.center.x - self.radius, self.center.y - self.radius,
            self.center.x + self.radius, self.center.y + self.radius,
        )
    }
    fn translate(&self, dx: f64, dy: f64) -> Self {
        Circle { center: Point { x: self.center.x + dx, y: self.center.y + dy }, radius: self.radius }
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

    pub fn aspect_ratio(&self) -> f64 {
        let r = self.bbox();
        let w = r.max.x - r.min.x;
        let h = r.max.y - r.min.y;
        if w.min(h) < 1e-6 { return f64::INFINITY; }
        w.max(h) / w.min(h)
    }
}

impl Primitive for Polyline {
    fn bbox(&self) -> Rect {
        assert!(!self.points.is_empty(), "Polyline::bbox called on empty polyline");
        let x0 = self.points.iter().map(|p| p.x).fold(f64::INFINITY,     f64::min);
        let x1 = self.points.iter().map(|p| p.x).fold(f64::NEG_INFINITY, f64::max);
        let y0 = self.points.iter().map(|p| p.y).fold(f64::INFINITY,     f64::min);
        let y1 = self.points.iter().map(|p| p.y).fold(f64::NEG_INFINITY, f64::max);
        Rect::new(x0, y0, x1, y1)
    }
    fn translate(&self, dx: f64, dy: f64) -> Self {
        Polyline {
            points: self.points.iter().map(|p| Point { x: p.x + dx, y: p.y + dy }).collect(),
            closed: self.closed,
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

impl Primitive for Arc {
    fn bbox(&self) -> Rect {
        // Conservative: full circle bounding box. Arc is always contained within it.
        Rect::new(
            self.center.x - self.radius, self.center.y - self.radius,
            self.center.x + self.radius, self.center.y + self.radius,
        )
    }
    fn translate(&self, dx: f64, dy: f64) -> Self {
        Arc { center: Point { x: self.center.x + dx, y: self.center.y + dy }, ..*self }
    }
}

#[enum_dispatch(Primitive)]
#[derive(Debug, Clone)]
pub enum Shape {
    Circle(Circle),
    Arc(Arc),
    Poly(Polyline),
    Rect(Rect),
}


impl Rect {
    /// Compute the bounding box of a slice of shapes.
    pub fn from_shapes(shapes: &[Shape]) -> Option<Self> {
        shapes.iter().map(|s| s.bbox()).reduce(|a, b| a.union(b))
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
    let r = poly.bbox();
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

/// True if `poly` is a closed 4-point axis-aligned rectangle.
fn is_axis_aligned_rect(poly: &Polyline) -> bool {
    if !poly.closed || poly.points.len() != 4 { return false; }
    let r = poly.bbox();
    const TOL: f64 = 0.01;
    poly.points.iter().all(|p| {
        let on_x = (p.x - r.min.x).abs() < TOL || (p.x - r.max.x).abs() < TOL;
        let on_y = (p.y - r.min.y).abs() < TOL || (p.y - r.max.y).abs() < TOL;
        on_x && on_y
    })
}

/// Convert 4-point axis-aligned closed polylines that match the SAW profile
/// (aspect ratio > 8, short side < 12 mm) into `Shape::Rect`.
///
/// This runs after `detect_slots` so expanded 8×32 slot stubs are left as
/// `Shape::Poly` and continue to be classified by abutting-edge rules.
pub fn detect_saw_rects(shapes: Vec<Shape>) -> Vec<Shape> {
    shapes.into_iter().map(|shape| {
        if let Shape::Poly(ref poly) = shape {
            if is_axis_aligned_rect(poly) {
                let r = poly.bbox();
                let w = r.max.x - r.min.x;
                let h = r.max.y - r.min.y;
                let short = w.min(h);
                let long  = w.max(h);
                let ar    = if short < 1e-6 { f64::INFINITY } else { long / short };
                if ar > 8.0 && short < 12.0 {
                    return Shape::Rect(r);
                }
            }
        }
        shape
    }).collect()
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
            // 4-point shapes are always rectangles, never arc approximations.
            if poly.points.len() <= 4 { return shape; }
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
