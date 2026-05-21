// Assign shapes to DXF layers based on geometry properties.

use crate::geom::{Primitive, Rect, Shape};

/// A shape paired with its layer/depth classification.
///
/// Each variant wraps a `&Shape` so a `Vec<Classification>` is self-contained —
/// no parallel shape vec required.
///
/// `Back` and `Top` embed their drill depth directly because both vary with
/// `top_thickness` (resolved before calling `classify`).  `Top` also covers
/// marker holes (radius < 3 mm), which always get 2 mm depth regardless.
pub enum Classification<'a> {
    Back(f64, &'a Shape),
    Top(f64, &'a Shape),
    Saw(&'a Shape),
    Left(&'a Shape),
    Right(&'a Shape),
    Front(&'a Shape),
    Rear(&'a Shape),
    ArcCut(&'a Shape),
    HandleCut(&'a Shape),
    Unclassified(&'a Shape),
}

impl<'a> Classification<'a> {
    pub fn shape(&self) -> &'a Shape {
        match self {
            Self::Back(_, s) | Self::Top(_, s) | Self::Saw(s)
            | Self::Left(s) | Self::Right(s) | Self::Front(s) | Self::Rear(s)
            | Self::ArcCut(s) | Self::HandleCut(s) | Self::Unclassified(s) => s,
        }
    }

    pub fn layer_name(&self) -> &'static str {
        match self {
            Self::Back(..)        => "BACK",
            Self::Top(..)         => "TOP",
            Self::Saw(_)          => "SAW",
            Self::Left(_)         => "LEFT",
            Self::Right(_)        => "RIGHT",
            Self::Front(_)        => "FRONT",
            Self::Rear(_)         => "REAR",
            Self::ArcCut(_)       => "ARC_CUT",
            Self::HandleCut(_)    => "HANDLE_CUT",
            Self::Unclassified(_) => "unclassified",
        }
    }

    pub fn depth(&self) -> f64 {
        match self {
            Self::Back(d, _) | Self::Top(d, _) => *d,
            Self::Saw(_)          =>  8.0,
            Self::Left(_) | Self::Right(_) | Self::Front(_) | Self::Rear(_) => 9.0,
            Self::ArcCut(_)       => 18.0,
            Self::HandleCut(_)    => 13.5,
            Self::Unclassified(_) =>  0.0,
        }
    }
}

/// Returns true when `shape` is a handle-cut pocket (~138×33 mm closed poly).
/// Used by callers to resolve `top_thickness` before calling `classify`.
pub fn is_handle_cut(shape: &Shape) -> bool {
    if let Shape::Poly(p) = shape {
        if !p.closed { return false; }
        let r = p.bbox();
        let w = r.max.x - r.min.x;
        let h = r.max.y - r.min.y;
        let short = w.min(h);
        let long  = w.max(h);
        (short - 33.0).abs() < 5.0 && (long - 138.0).abs() < 5.0
    } else {
        false
    }
}

/// Classify a shape against the inner panel bounding rect.
///
/// `top_thickness` must be resolved before calling (check via `is_handle_cut`).
///
/// Rules:
/// - Circle, radius > 10 mm → `Back(top_thickness)`
/// - Circle, radius < 3 mm (2 mm / 4 mm diameter marks) → `Top(2.0)` (marker hole)
/// - Circle → `Top(top_thickness)`
/// - Closed poly, ~138×33 mm recessed pocket → `HandleCut`
/// - Closed poly, 8×32 mm abutting a panel edge → `Left`/`Right`/`Front`/`Rear`
/// - Closed poly, 4.5 < short < 11 mm, long < 80 mm → `Top(top_thickness)`
/// - Closed poly, AR > 8, short < 12 mm → `Saw`
/// - Arc → `ArcCut`
/// - `Shape::Rect`, AR > 8, short < 12 mm → `Saw`
/// - Anything else → `Unclassified`
pub fn classify<'a>(shape: &'a Shape, panel: &Rect, top_thickness: f64) -> Classification<'a> {
    match shape {
        Shape::Circle(c) => {
            if c.radius > 10.0     { Classification::Back(top_thickness, shape) }
            else if c.radius < 3.0 { Classification::Top(2.0, shape) }
            else                   { Classification::Top(top_thickness, shape) }
        }
        Shape::Poly(p) => {
            if !p.closed {
                return Classification::Unclassified(shape);
            }
            let ar = p.aspect_ratio();
            let r = p.bbox();
            let w = r.max.x - r.min.x;
            let h = r.max.y - r.min.y;
            let short = w.min(h);
            let long  = w.max(h);

            if (short - 33.0).abs() < 5.0 && (long - 138.0).abs() < 5.0 {
                return Classification::HandleCut(shape);
            }

            // Edge slots (8 mm wide × 32 mm deep): assign to the matching side face.
            if (short - 8.0).abs() < 0.5 && (long - 32.0).abs() < 1.0 {
                return match panel.abutting_edge(r, 1.0) {
                    Some(edge) => match edge {
                        crate::geom::Edge::Left  => Classification::Left(shape),
                        crate::geom::Edge::Right => Classification::Right(shape),
                        crate::geom::Edge::Front => Classification::Front(shape),
                        crate::geom::Edge::Rear  => Classification::Rear(shape),
                    },
                    None => Classification::Unclassified(shape),
                };
            }

            // Top-face slots (small oblong features drilled from above).
            if 4.5 < short && short < 11.0 && long < 80.0 {
                return Classification::Top(top_thickness, shape);
            }

            // Narrow elongated closed shapes are grooves.
            if ar > 8.0 && short < 12.0 {
                return Classification::Saw(shape);
            }
            Classification::Unclassified(shape)
        }
        Shape::Arc(_) => Classification::ArcCut(shape),
        Shape::Rect(r) => {
            let w = r.max.x - r.min.x;
            let h = r.max.y - r.min.y;
            let short = w.min(h);
            let long  = w.max(h);
            let ar    = if short < 1e-6 { f64::INFINITY } else { long / short };
            if ar > 8.0 && short < 12.0 { Classification::Saw(shape) } else { Classification::Unclassified(shape) }
        }
    }
}
