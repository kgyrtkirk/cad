// PDF output: renders the same geometry as the DXF with measurement annotations.
//
// Coordinates stay in mm throughout.  The panel sits in the upper-right corner of the
// page; DIM_SPACE mm are reserved below and to the left for dimension lines; MARGIN mm
// of blank space surrounds everything.  The whole drawing is scaled to fit within an
// A3 landscape page if the panel is larger than the usable working area.

use std::collections::BTreeMap;
use std::f64::consts::TAU;
use std::fs;

use printpdf::path::{PaintMode, WindingOrder};
use printpdf::*;

use crate::close::EdgeClose;
use crate::geom::{Arc as GArc, Edge, Rect, Shape};

const BEZIER_K: f64 = 0.5522847498; // cubic Bezier circle approximation constant

// ── Colour helpers ────────────────────────────────────────────────────────────

fn rgb(r: f64, g: f64, b: f64) -> Color {
    Color::Rgb(Rgb::new(r as f32, g as f32, b as f32, None))
}

fn layer_color(name: &str) -> Color {
    match name {
        "PANEL"      => rgb(0.5, 0.0, 0.7),
        "raw_panel"  => rgb(0.5, 0.5, 0.5),
        "TOP"        => rgb(0.0, 0.7, 0.7),
        "SAW"        => rgb(1.0, 0.5, 0.0),
        "LEFT"       => rgb(0.9, 0.0, 0.0),
        "RIGHT"      => rgb(0.0, 0.7, 0.0),
        "FRONT"      => rgb(0.0, 0.0, 0.9),
        "REAR"       => rgb(0.8, 0.0, 0.8),
        "ARC_CUT"    => rgb(1.0, 0.4, 0.0),
        "HANDLE_CUT" => rgb(0.8, 0.8, 0.0),
        "BACK"       => rgb(0.5, 0.0, 0.6),
        _            => rgb(0.4, 0.4, 0.4),
    }
}

// ── Point helpers ─────────────────────────────────────────────────────────────

fn lp(x: f64, y: f64) -> (Point, bool) {
    (Point::new(Mm(x as f32), Mm(y as f32)), false)
}

fn cp(x: f64, y: f64) -> (Point, bool) {
    (Point::new(Mm(x as f32), Mm(y as f32)), true) // Bezier control point
}

// ── Shape approximations ──────────────────────────────────────────────────────

fn circle_pts(cx: f64, cy: f64, r: f64) -> Vec<(Point, bool)> {
    let k = BEZIER_K * r;
    vec![
        lp(cx + r, cy),
        cp(cx + r, cy + k), cp(cx + k, cy + r), lp(cx,     cy + r),
        cp(cx - k, cy + r), cp(cx - r, cy + k), lp(cx - r, cy    ),
        cp(cx - r, cy - k), cp(cx - k, cy - r), lp(cx,     cy - r),
        cp(cx + k, cy - r), cp(cx + r, cy - k),
    ]
}

fn arc_pts(cx: f64, cy: f64, r: f64, start_deg: f64, end_deg: f64) -> Vec<(Point, bool)> {
    const STEPS: u32 = 48;
    let sa = start_deg.to_radians();
    let mut ea = end_deg.to_radians();
    while ea <= sa { ea += TAU; }
    (0..=STEPS)
        .map(|i| {
            let a = sa + (ea - sa) * (i as f64 / STEPS as f64);
            lp(cx + r * a.cos(), cy + r * a.sin())
        })
        .collect()
}

// ── Layer drawing helpers ─────────────────────────────────────────────────────

fn stroke(layer: &PdfLayerReference, col: Color, width: f32) {
    layer.set_outline_color(col);
    layer.set_outline_thickness(width);
}

fn line_seg(layer: &PdfLayerReference, x0: f64, y0: f64, x1: f64, y1: f64) {
    layer.add_line(Line { points: vec![lp(x0, y0), lp(x1, y1)], is_closed: false });
}

fn draw_text(layer: &PdfLayerReference, font: &IndirectFontRef,
             x: f64, y: f64, text: &str, size: f32, col: Color) {
    layer.set_fill_color(col);
    layer.use_text(text, size, Mm(x as f32), Mm(y as f32), font);
}

fn poly_stroke(layer: &PdfLayerReference, pts: Vec<(Point, bool)>) {
    layer.add_polygon(Polygon {
        rings: vec![pts],
        mode: PaintMode::Stroke,
        winding_order: WindingOrder::NonZero,
    });
}

fn open_stroke(layer: &PdfLayerReference, pts: Vec<(Point, bool)>) {
    layer.add_line(Line { points: pts, is_closed: false });
}

// ── Dimension lines ───────────────────────────────────────────────────────────

/// Horizontal dimension line at `dim_y`, with extension lines dropping from `panel_y`.
fn dim_h(layer: &PdfLayerReference, font: &IndirectFontRef,
         x0: f64, x1: f64, dim_y: f64, panel_y: f64, label: &str) {
    let col = rgb(0.0, 0.0, 0.55);
    stroke(layer, col.clone(), 0.3);
    let t = 1.5;
    line_seg(layer, x0, panel_y, x0, dim_y + t);
    line_seg(layer, x1, panel_y, x1, dim_y + t);
    line_seg(layer, x0, dim_y, x1, dim_y);
    line_seg(layer, x0, dim_y - t, x0, dim_y + t);
    line_seg(layer, x1, dim_y - t, x1, dim_y + t);
    let lx = (x0 + x1) / 2.0 - label.len() as f64 * 0.95;
    draw_text(layer, font, lx, dim_y - 5.5, label, 6.0, col);
}

/// Vertical dimension line at `dim_x`, with extension lines reaching left from `panel_x`.
fn dim_v(layer: &PdfLayerReference, font: &IndirectFontRef,
         y0: f64, y1: f64, dim_x: f64, panel_x: f64, label: &str) {
    let col = rgb(0.0, 0.0, 0.55);
    stroke(layer, col.clone(), 0.3);
    let t = 1.5;
    line_seg(layer, panel_x, y0, dim_x - t, y0);
    line_seg(layer, panel_x, y1, dim_x - t, y1);
    line_seg(layer, dim_x, y0, dim_x, y1);
    line_seg(layer, dim_x - t, y0, dim_x + t, y0);
    line_seg(layer, dim_x - t, y1, dim_x + t, y1);
    let lx = dim_x - label.len() as f64 * 1.85 - 3.0;
    let ly = (y0 + y1) / 2.0 - 2.0;
    draw_text(layer, font, lx, ly, label, 6.0, col);
}

// ── Main writer ───────────────────────────────────────────────────────────────

pub fn write_pdf(
    path: &str,
    shapes_by_layer: &BTreeMap<String, Vec<&Shape>>,
    closes: &[EdgeClose],
    bb: &Rect,
    outer_bb: &Rect,
) -> Result<(), String> {
    const MARGIN: f64 = 12.0;
    const DIM_SPACE: f64 = 32.0;

    let panel_w = outer_bb.max.x - outer_bb.min.x;
    let panel_h = outer_bb.max.y - outer_bb.min.y;

    // Scale to fit A3 landscape working area (400 × 270 mm usable)
    let total_w = DIM_SPACE + panel_w + MARGIN;
    let total_h = DIM_SPACE + panel_h + MARGIN;
    let scale = (400.0_f64 / total_w).min(270.0 / total_h).min(1.0);

    let page_w = total_w * scale + 2.0 * MARGIN;
    let page_h = total_h * scale + 2.0 * MARGIN;

    // Panel origin on the page (coordinates come from main.rs translate-to-origin step)
    let ox = MARGIN + DIM_SPACE * scale;
    let oy = MARGIN + DIM_SPACE * scale;

    let tx = |x: f64| ox + x * scale;
    let ty = |y: f64| oy + y * scale;

    let (doc, page1, layer1) = PdfDocument::new(
        "Panel Drawing",
        Mm(page_w as f32),
        Mm(page_h as f32),
        "Layer 1",
    );

    let font = doc.add_builtin_font(BuiltinFont::Helvetica)
        .map_err(|e| format!("Font error: {e}"))?;
    let layer = doc.get_page(page1).get_layer(layer1);

    // ── Shapes ────────────────────────────────────────────────────────────────

    for (layer_name, shapes) in shapes_by_layer {
        let col = layer_color(layer_name);
        let lw: f32 = if layer_name == "PANEL" { 0.8 } else { 0.5 };
        stroke(&layer, col.clone(), lw);

        if layer_name == "raw_panel" {
            layer.set_line_dash_pattern(LineDashPattern {
                offset: 0, dash_1: Some(3), gap_1: Some(3),
                dash_2: None, gap_2: None, dash_3: None, gap_3: None,
            });
        }

        for shape in shapes {
            match shape {
                Shape::Circle(c) => {
                    poly_stroke(&layer,
                        circle_pts(tx(c.center.x), ty(c.center.y), c.radius * scale));
                }
                Shape::Arc(GArc { center, radius, start_angle, end_angle }) => {
                    open_stroke(&layer,
                        arc_pts(tx(center.x), ty(center.y),
                                *radius * scale, *start_angle, *end_angle));
                }
                Shape::Poly(p) => {
                    let pts: Vec<(Point, bool)> = p.points.iter()
                        .map(|q| lp(tx(q.x), ty(q.y)))
                        .collect();
                    if p.closed { poly_stroke(&layer, pts); }
                    else        { open_stroke(&layer, pts); }
                }
                Shape::Rect(r) => {
                    poly_stroke(&layer, vec![
                        lp(tx(r.min.x), ty(r.min.y)), lp(tx(r.max.x), ty(r.min.y)),
                        lp(tx(r.max.x), ty(r.max.y)), lp(tx(r.min.x), ty(r.max.y)),
                    ]);
                }
            }
        }

        if layer_name == "raw_panel" {
            layer.set_line_dash_pattern(LineDashPattern::default());
        }
    }

    // ── Close strips ──────────────────────────────────────────────────────────

    for ec in closes {
        let (x0, y0, x1, y1): (f64, f64, f64, f64) = match ec.edge {
            Edge::Left  => (outer_bb.min.x, outer_bb.min.y, outer_bb.min.x + ec.width, outer_bb.max.y),
            Edge::Right => (outer_bb.max.x - ec.width, outer_bb.min.y, outer_bb.max.x, outer_bb.max.y),
            Edge::Front => (outer_bb.min.x, outer_bb.min.y, outer_bb.max.x, outer_bb.min.y + ec.width),
            Edge::Rear  => (outer_bb.min.x, outer_bb.max.y - ec.width, outer_bb.max.x, outer_bb.max.y),
        };
        let col = rgb(0.55, 0.27, 0.07);
        stroke(&layer, col.clone(), 0.4);
        poly_stroke(&layer, vec![
            lp(tx(x0), ty(y0)), lp(tx(x1), ty(y0)),
            lp(tx(x1), ty(y1)), lp(tx(x0), ty(y1)),
        ]);
        let label = format!("{} {:.1}mm", ec.edge.label(), ec.width);
        let lx = tx((x0 + x1) / 2.0) - label.len() as f64 * 0.9;
        let ly = ty((y0 + y1) / 2.0) - 2.0;
        draw_text(&layer, &font, lx, ly, &label, 4.5, col);
    }

    // ── Radius labels ─────────────────────────────────────────────────────────

    for (layer_name, shapes) in shapes_by_layer {
        let col = layer_color(layer_name);
        for shape in shapes {
            match shape {
                Shape::Circle(c) => {
                    let cx = tx(c.center.x);
                    let cy = ty(c.center.y);
                    let r  = c.radius * scale;
                    stroke(&layer, col.clone(), 0.25);
                    line_seg(&layer, cx, cy, cx + r * 0.707, cy + r * 0.707);
                    let label = format!("r={:.1}", c.radius);
                    draw_text(&layer, &font,
                        cx + r * 0.707 + 1.0, cy + r * 0.707 - 2.0,
                        &label, 5.0, col.clone());
                }
                Shape::Arc(a) => {
                    let mut ea = a.end_angle;
                    while ea <= a.start_angle { ea += 360.0; }
                    let mid = ((a.start_angle + ea) / 2.0).to_radians();
                    let r   = a.radius * scale;
                    let lx  = tx(a.center.x) + r * 1.15 * mid.cos();
                    let ly  = ty(a.center.y) + r * 1.15 * mid.sin() - 2.0;
                    let label = format!("r={:.1}", a.radius);
                    draw_text(&layer, &font, lx, ly, &label, 5.0, col.clone());
                }
                _ => {}
            }
        }
    }

    // ── Dimension lines ───────────────────────────────────────────────────────

    let outer_w = outer_bb.max.x - outer_bb.min.x;
    let outer_h = outer_bb.max.y - outer_bb.min.y;

    dim_h(&layer, &font,
        tx(outer_bb.min.x), tx(outer_bb.max.x),
        oy - 12.0, oy,
        &format!("{:.1} mm", outer_w));
    dim_v(&layer, &font,
        ty(outer_bb.min.y), ty(outer_bb.max.y),
        ox - 12.0, ox,
        &format!("{:.1} mm", outer_h));

    // Inner panel dimensions when closes make them different from outer
    let inner_w = bb.max.x - bb.min.x;
    let inner_h = bb.max.y - bb.min.y;
    if (inner_w - outer_w).abs() > 0.2 || (inner_h - outer_h).abs() > 0.2 {
        dim_h(&layer, &font,
            tx(bb.min.x), tx(bb.max.x),
            oy - 22.0, oy,
            &format!("{:.1} mm (panel)", inner_w));
        dim_v(&layer, &font,
            ty(bb.min.y), ty(bb.max.y),
            ox - 22.0, ox,
            &format!("{:.1} mm (panel)", inner_h));
    }

    // ── Save ──────────────────────────────────────────────────────────────────

    let bytes = doc.save_to_bytes()
        .map_err(|e| format!("PDF encode error: {e}"))?;
    fs::write(path, bytes).map_err(|e| format!("Cannot write {path}: {e}"))
}
