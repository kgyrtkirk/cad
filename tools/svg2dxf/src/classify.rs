// Assign shapes to DXF layers based on geometry properties.

use crate::geom::Shape;

/// Layer name for a shape.
///
/// Rules:
/// - Circle with diameter ≤ 2.0 → `drill_d{diam_rounded}`
/// - Circle with diameter > 2.0 → `drill_d{diam_rounded}`  (all circles are drill holes)
/// - Closed polyline with area < groove threshold and very elongated → `groove`
/// - Otherwise closed → `unclassified`
/// - Open polyline → `unclassified`
pub fn layer(shape: &Shape) -> String {
    match shape {
        Shape::Circle(c) => {
            let d = (c.radius * 2.0).round() as i64;
            format!("drill_d{d}")
        }
        Shape::Poly(p) => {
            if !p.closed {
                return "unclassified".to_string();
            }
            let ar = p.aspect_ratio();
            if let Some((min_x, min_y, max_x, max_y)) = p.bbox() {
                let w = max_x - min_x;
                let h = max_y - min_y;
                let short = w.min(h);
                let long  = w.max(h);
                // Narrow elongated closed shapes are grooves — layer name includes width.
                if ar > 8.0 && short < 12.0 {
                    return format!("groove_{}", short.round() as i64);
                }
                // Expanded drill slots: 8 mm wide, ~32 mm deep.
                if (short - 8.0).abs() < 0.5 && (long - 32.0).abs() < 1.0 {
                    return "drill_slot_8x32".to_string();
                }
            }
            "unclassified".to_string()
        }
    }
}
