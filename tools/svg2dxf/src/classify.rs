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
            // Narrow elongated closed shapes are grooves (aspect ratio > 8, width < 12mm).
            if let Some((min_x, min_y, max_x, max_y)) = p.bbox() {
                let w = max_x - min_x;
                let h = max_y - min_y;
                let short = w.min(h);
                if ar > 8.0 && short < 12.0 {
                    return "groove".to_string();
                }
            }
            "unclassified".to_string()
        }
    }
}
