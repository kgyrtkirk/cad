// PDF output: renders the panel geometry to a printable A4 landscape PDF.
// Uses the same colour scheme and annotation logic as the DXF measure/holes layers.

use std::collections::BTreeMap;
use std::f64::consts::TAU;
use std::fs;

use printpdf::path::{PaintMode, WindingOrder};
use printpdf::*;

use crate::close::EdgeClose;
use crate::dxf::{a4_text_h, fmt_dim};
use crate::geom::{Arc as GArc, Edge, Rect, Shape};

const BEZIER_K: f64 = 0.5522847498;
const DEJAVU: &str = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf";

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

// ── Geometry helpers ──────────────────────────────────────────────────────────

fn lp(x: f64, y: f64) -> (Point, bool) {
    (Point::new(Mm(x as f32), Mm(y as f32)), false)
}
fn cp(x: f64, y: f64) -> (Point, bool) {
    (Point::new(Mm(x as f32), Mm(y as f32)), true)
}

fn circle_pts(cx: f64, cy: f64, r: f64) -> Vec<(Point, bool)> {
    let k = BEZIER_K * r;
    vec![
        lp(cx+r,cy),  cp(cx+r,cy+k), cp(cx+k,cy+r), lp(cx,  cy+r),
        cp(cx-k,cy+r),cp(cx-r,cy+k), lp(cx-r,cy),   cp(cx-r,cy-k),
        cp(cx-k,cy-r),lp(cx,  cy-r), cp(cx+k,cy-r), cp(cx+r,cy-k),
    ]
}

fn arc_pts(cx: f64, cy: f64, r: f64, sa: f64, ea: f64) -> Vec<(Point, bool)> {
    let sa = sa.to_radians();
    let mut ea = ea.to_radians();
    while ea <= sa { ea += TAU; }
    (0..=48).map(|i| {
        let a = sa + (ea - sa) * (i as f64 / 48.0);
        lp(cx + r * a.cos(), cy + r * a.sin())
    }).collect()
}

fn stroke(layer: &PdfLayerReference, col: Color, w: f32) {
    layer.set_outline_color(col);
    layer.set_outline_thickness(w);
}

fn seg(layer: &PdfLayerReference, x0: f64, y0: f64, x1: f64, y1: f64) {
    layer.add_line(Line { points: vec![lp(x0,y0), lp(x1,y1)], is_closed: false });
}

fn txt(layer: &PdfLayerReference, font: &IndirectFontRef,
       x: f64, y: f64, s: &str, pt: f32, col: Color) {
    layer.set_fill_color(col);
    layer.use_text(s, pt, Mm(x as f32), Mm(y as f32), font);
}

/// Write text rotated 90° CCW (reads bottom-to-top), centred on (x, y).
fn txt_rot90(layer: &PdfLayerReference, font: &IndirectFontRef,
             x: f64, y: f64, s: &str, pt: f32, col: Color) {
    const MM_PT: f64 = 72.0 / 25.4;
    // Approximate half-width of the string in mm so we can centre it along Y.
    let half_w = s.len() as f64 * pt as f64 / MM_PT * 0.28;
    let x_pt = Pt(((x)         * MM_PT) as f32);
    let y_pt = Pt(((y - half_w) * MM_PT) as f32);
    layer.set_fill_color(col);
    layer.begin_text_section();
    layer.set_text_matrix(TextMatrix::TranslateRotate(x_pt, y_pt, 90.0));
    layer.set_font(font, pt);
    layer.write_text(s, font);
    layer.end_text_section();
}

// ── Main writer ───────────────────────────────────────────────────────────────

pub fn write_pdf(
    path: &str,
    shapes_by_layer: &BTreeMap<String, Vec<&Shape>>,
    closes: &[EdgeClose],
    outer_bb: &Rect,
) -> Result<(), String> {
    let panel_w = outer_bb.max.x - outer_bb.min.x;
    let panel_h = outer_bb.max.y - outer_bb.min.y;

    // Model-space text height → PDF points at the print scale
    let text_h_model = a4_text_h(panel_w, panel_h);
    let dim_off      = text_h_model * 3.5;
    let gap          = text_h_model * 0.9;
    let tick_model   = text_h_model * 0.5;
    let margin       = 8.0_f64; // mm on page

    // Fit into A4 landscape (297×210 mm, leaving margins)
    let available_w = 297.0 - 2.0 * margin;
    let available_h = 210.0 - 2.0 * margin;
    let total_w = (dim_off - outer_bb.min.x.min(0.0)) + panel_w + margin;
    let total_h = (dim_off - outer_bb.min.y.min(0.0)) + panel_h + margin;
    let scale = (available_w / total_w).min(available_h / total_h);

    // Page-space origin of the panel coordinate system
    let ox = margin + (dim_off - outer_bb.min.x.min(0.0)) * scale;
    let oy = margin + (dim_off - outer_bb.min.y.min(0.0)) * scale;

    let tx = |x: f64| ox + x * scale;
    let ty = |y: f64| oy + y * scale;

    // All annotation sizes in page mm
    let dim  = dim_off * scale;
    let gap_p  = gap       * scale;
    let tick_p = tick_model * scale;
    let text_pt = (text_h_model * scale * 2.8346) as f32; // mm → pt

    let (doc, page1, layer1) = PdfDocument::new(
        "Panel Drawing", Mm(297.0), Mm(210.0), "Layer 1");

    let font = {
        if let Ok(mut f) = std::fs::File::open(DEJAVU) {
            doc.add_external_font(&mut f)
                .unwrap_or_else(|_| doc.add_builtin_font(BuiltinFont::Helvetica).unwrap())
        } else {
            doc.add_builtin_font(BuiltinFont::Helvetica)
                .map_err(|e| format!("Font: {e}"))?
        }
    };

    let layer = doc.get_page(page1).get_layer(layer1);

    // ── Shapes ───────────────────────────────────────────────────────────────

    for (layer_name, shapes) in shapes_by_layer {
        let col = layer_color(layer_name);
        let lw: f32 = if layer_name == "PANEL" { 0.5 } else { 0.3 };
        stroke(&layer, col, lw);

        if layer_name == "raw_panel" {
            layer.set_line_dash_pattern(LineDashPattern {
                offset: 0, dash_1: Some(3), gap_1: Some(3), ..Default::default()
            });
        }

        for shape in shapes {
            match shape {
                Shape::Circle(c) => {
                    let pts = circle_pts(tx(c.center.x), ty(c.center.y), c.radius * scale);
                    layer.add_polygon(Polygon { rings: vec![pts],
                        mode: PaintMode::Stroke, winding_order: WindingOrder::NonZero });
                }
                Shape::Arc(GArc { center, radius, start_angle, end_angle }) => {
                    let pts = arc_pts(tx(center.x), ty(center.y),
                                      *radius * scale, *start_angle, *end_angle);
                    layer.add_line(Line { points: pts, is_closed: false });
                }
                Shape::Poly(p) => {
                    let pts: Vec<(Point, bool)> =
                        p.points.iter().map(|q| lp(tx(q.x), ty(q.y))).collect();
                    if p.closed {
                        layer.add_polygon(Polygon { rings: vec![pts],
                            mode: PaintMode::Stroke, winding_order: WindingOrder::NonZero });
                    } else {
                        layer.add_line(Line { points: pts, is_closed: false });
                    }
                }
                Shape::Rect(r) => {
                    let pts = vec![
                        lp(tx(r.min.x), ty(r.min.y)), lp(tx(r.max.x), ty(r.min.y)),
                        lp(tx(r.max.x), ty(r.max.y)), lp(tx(r.min.x), ty(r.max.y)),
                    ];
                    layer.add_polygon(Polygon { rings: vec![pts],
                        mode: PaintMode::Stroke, winding_order: WindingOrder::NonZero });
                }
            }
        }

        if layer_name == "raw_panel" {
            layer.set_line_dash_pattern(LineDashPattern::default());
        }
    }

    // ── Close strips ─────────────────────────────────────────────────────────

    let close_col = rgb(0.55, 0.27, 0.07);
    for ec in closes {
        let (x0, y0, x1, y1): (f64, f64, f64, f64) = match ec.edge {
            Edge::Left  => (outer_bb.min.x, outer_bb.min.y, outer_bb.min.x + ec.width, outer_bb.max.y),
            Edge::Right => (outer_bb.max.x - ec.width, outer_bb.min.y, outer_bb.max.x, outer_bb.max.y),
            Edge::Front => (outer_bb.min.x, outer_bb.min.y, outer_bb.max.x, outer_bb.min.y + ec.width),
            Edge::Rear  => (outer_bb.min.x, outer_bb.max.y - ec.width, outer_bb.max.x, outer_bb.max.y),
        };
        stroke(&layer, close_col.clone(), 0.25);
        layer.add_polygon(Polygon {
            rings: vec![vec![
                lp(tx(x0), ty(y0)), lp(tx(x1), ty(y0)),
                lp(tx(x1), ty(y1)), lp(tx(x0), ty(y1)),
            ]],
            mode: PaintMode::Stroke, winding_order: WindingOrder::NonZero,
        });
        let label = format!("{} {}mm", ec.edge.label(), fmt_dim(ec.width));
        txt(&layer, &font,
            tx((x0+x1)/2.0) - label.len() as f64 * text_pt as f64 * 0.15,
            ty((y0+y1)/2.0) - text_pt as f64 * 0.18,
            &label, text_pt * 0.65, close_col.clone());
    }

    // ── Dimension lines ───────────────────────────────────────────────────────

    let dim_col = rgb(0.0, 0.0, 0.55);
    stroke(&layer, dim_col.clone(), 0.25);

    let y_dim   = ty(outer_bb.min.y) - dim;
    let x_left  = tx(outer_bb.min.x);
    let x_right = tx(outer_bb.max.x);
    seg(&layer, x_left,  ty(outer_bb.min.y), x_left,  y_dim - tick_p);
    seg(&layer, x_right, ty(outer_bb.min.y), x_right, y_dim - tick_p);
    seg(&layer, x_left, y_dim, x_right, y_dim);
    seg(&layer, x_left,  y_dim - tick_p, x_left,  y_dim + tick_p);
    seg(&layer, x_right, y_dim - tick_p, x_right, y_dim + tick_p);
    txt(&layer, &font,
        (x_left + x_right) / 2.0 - fmt_dim(panel_w).len() as f64 * text_pt as f64 * 0.15,
        y_dim - gap_p,
        &fmt_dim(panel_w), text_pt, dim_col.clone());

    let x_dim = tx(outer_bb.min.x) - dim;
    let y_bot = ty(outer_bb.min.y);
    let y_top = ty(outer_bb.max.y);
    seg(&layer, tx(outer_bb.min.x), y_bot, x_dim - tick_p, y_bot);
    seg(&layer, tx(outer_bb.min.x), y_top, x_dim - tick_p, y_top);
    seg(&layer, x_dim, y_bot, x_dim, y_top);
    seg(&layer, x_dim - tick_p, y_bot, x_dim + tick_p, y_bot);
    seg(&layer, x_dim - tick_p, y_top, x_dim + tick_p, y_top);
    // Height label: rotated 90° CCW so it reads bottom-to-top alongside the line
    txt_rot90(&layer, &font,
        x_dim - gap_p,
        (y_bot + y_top) / 2.0,
        &fmt_dim(panel_h), text_pt, dim_col.clone());

    // ── Save ─────────────────────────────────────────────────────────────────

    let bytes = doc.save_to_bytes()
        .map_err(|e| format!("PDF encode: {e}"))?;
    fs::write(path, bytes).map_err(|e| format!("Cannot write {path}: {e}"))
}
