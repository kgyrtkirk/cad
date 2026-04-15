// Assign shapes to DXF layers based on geometry properties.

use crate::geom::{Rect, Shape};

/// Layer name for a shape.
///
/// `panel` is the inner panel bounding rect after origin translation.
///
/// Rules:
/// - Circle → `TOP`
/// - Closed poly, 8 mm wide × 32 mm deep abutting a panel edge → `LEFT`/`RIGHT`/`FRONT`/`REAR`
/// - Closed poly, 4.5 < short < 11 mm, long < 80 mm → `TOP` (top-face slot)
/// - Closed poly, aspect ratio > 8, short < 12 mm → `SAW` (groove)
/// - Anything else → `unclassified`
pub fn layer(shape: &Shape, panel: &Rect) -> String {
    match shape {
        Shape::Circle(_) => "TOP".to_string(),
        Shape::Poly(p) => {
            if !p.closed {
                return "unclassified".to_string();
            }
            let ar = p.aspect_ratio();
            if let Some(r) = p.bbox() {
                let w = r.max.x - r.min.x;
                let h = r.max.y - r.min.y;
                let short = w.min(h);
                let long  = w.max(h);

                // Edge slots (8 mm wide × 32 mm deep): assign to the matching side face layer.
                if (short - 8.0).abs() < 0.5 && (long - 32.0).abs() < 1.0 {
                    return match panel.abutting_edge(r, 1.0) {
                        Some(edge) => edge.label(),
                        None       => "unclassified",
                    }.to_string();
                }

                // Top-face slots (small oblong features drilled from above).
                if 4.5 < short && short < 11.0 && long < 80.0 {
                    return "TOP".to_string();
                }

                // Narrow elongated closed shapes are grooves — SAW layer (depth set on entity).
                if ar > 8.0 && short < 12.0 {
                    return "SAW".to_string();
                }
            }
            "unclassified".to_string()
        }
        Shape::Arc(_)  => "ARC_CUT".to_string(),
        Shape::Rect(_) => "unclassified".to_string(),
    }
}
