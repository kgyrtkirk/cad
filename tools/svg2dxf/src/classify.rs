// Assign shapes to DXF layers based on geometry properties.

use crate::geom::{Shape, Rect};

/// Layer name for a shape.
///
/// `panel_w` and `panel_h` are the panel dimensions after origin translation (used to
/// determine which side face an edge slot belongs to).
///
/// Rules:
/// - Circle → `TOP` (vertical drilling; depth encoded as entity thickness)
/// - Closed poly, 4.5 < short < 11 mm, long < 80 mm → `TOP` (top-face slot)
/// - Closed poly, aspect ratio > 8, short < 12 mm → `SAW` (groove)
/// - Closed poly, 8 mm wide × 32 mm deep abutting a panel edge → `LEFT`/`RIGHT`/`FRONT`/`REAR`
/// - Panel inner AABB → `RAW_PANEL`
/// - Outer AABB (incl. close strips) → `PANEL`
/// - Anything else → `unclassified`
pub fn layer(shape: &Shape, panel_w: f64, panel_h: f64) -> String {
    match shape {
        Shape::Circle(_) => "TOP".to_string(),
        Shape::Poly(p) => {
            if !p.closed {
                return "unclassified".to_string();
            }
            let ar = p.aspect_ratio();
            if let Some(Rect { x0, y0, x1, y1 }) = p.bbox() {
                let w = x1 - x0;
                let h = y1 - y0;
                let short = w.min(h);
                let long  = w.max(h);

                // Top-face slots (small oblong features drilled from above).
                if 4.5 < short && short < 11.0 && long < 80.0 {
                    return "TOP".to_string();
                }

                // Narrow elongated closed shapes are grooves — SAW layer (depth set on entity).
                if ar > 8.0 && short < 12.0 {
                    return "SAW".to_string();
                }

                // Edge slots (8 mm wide × 32 mm deep): assign to the matching side face layer.
                if (short - 8.0).abs() < 0.5 && (long - 32.0).abs() < 1.0 {
                    return edge_slot_layer(x0, y0, x1, y1, panel_w, panel_h).to_string();
                }
            }
            "unclassified".to_string()
        }
    }
}

/// Determine which side-face layer an edge slot belongs to by checking which panel
/// edge the slot rectangle abuts (within 1 mm tolerance after origin translation).
fn edge_slot_layer(x0: f64, y0: f64, x1: f64, y1: f64, panel_w: f64, panel_h: f64) -> &'static str {
    const TOL: f64 = 1.0;
    if x0.abs() < TOL          { "LEFT"  }
    else if (x1 - panel_w).abs() < TOL { "RIGHT" }
    else if y0.abs() < TOL          { "FRONT" }
    else if (y1 - panel_h).abs() < TOL { "REAR"  }
    else                            { "unclassified" }
}
