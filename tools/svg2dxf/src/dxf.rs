// DXF writer using the `dxf` crate — POLYLINE+VERTEX and CIRCLE, AC1009 compatible.

use std::collections::BTreeMap;
use dxf::Drawing;
use dxf::entities::{Arc as DxfArc, Circle, Line as DxfLine, Polyline, Vertex, Text, Entity, EntityType};
use dxf::enums::{HorizontalTextJustification, VerticalTextJustification};
use dxf::tables::Layer;
use dxf::{Color, Point as DxfPoint};
use crate::geom::{Arc as GArc, Edge, Polyline as GPolyline, Rect, Shape};
use crate::close::EdgeClose;

/// Format a mm value for human display: omit ".0" for whole numbers.
pub fn fmt_dim(v: f64) -> String {
    if v.fract() == 0.0 { format!("{:.0}", v) } else { format!("{:.1}", v) }
}

/// Compute model-space text height readable at ~4 mm on A4 landscape paper.
pub fn a4_text_h(panel_w: f64, panel_h: f64) -> f64 {
    let s = (267.0_f64 / panel_w).min(180.0 / panel_h);
    (4.0 / s).clamp(4.0, 40.0)
}

/// Single source of truth for layer colours.
///
/// Named layers get a fixed colour; everything else gets a deterministic colour
/// derived from a djb2 hash of the layer name so the assignment is stable
/// regardless of how many layers are present or what order they are created.
///
/// DXF ACI index layout: within each hue band of 10 (e.g. 10-19 = reds)
/// higher offsets produce lighter/more pastel variants.  We use offset ~3
/// throughout to get lighter-than-pure but still clearly coloured values.
fn layer_color(name: &str) -> u8 {
    // Fixed colours for well-known layers.
    match name {
        "PANEL"     => return 200, // purple
        "raw_panel" => return 8,   // dark grey
        "TOP"       => return 4,   // cyan
        "SAW"       => return 30,  // orange
        "LEFT"      => return 1,   // red
        "RIGHT"     => return 3,   // green
        "FRONT"     => return 5,   // blue
        "REAR"       => return 6,   // magenta
        "ARC_CUT"    => return 40,  // orange
        "HANDLE_CUT" => return 2,   // yellow
        "BACK"       => return 160, // violet
        _ => {}
    }
    // Close layers: colour by thickness — thin=orange, thick=light-brown.
    if name.starts_with("close_") {
        let thickness: f64 = name.rsplit('_').next()
            .and_then(|s| s.parse().ok())
            .unwrap_or(1.0);
        return if thickness > 1.0 { 30 } else { 34 };
    }
    // General palette: original vivid style, extended to cover the full hue wheel.
    const PALETTE: &[u8] = &[
        1,   // red
        2,   // yellow
        3,   // green
        4,   // cyan
        5,   // blue
        6,   // magenta
        20,  // red-orange
        40,  // yellow-orange
        50,  // gold
        60,  // yellow-green
        70,  // lime
        80,  // blue-green
        90,  // cyan-green
        100, // cyan-blue
        110, // sky blue
        120, // cornflower
        140, // blue-violet
        150, // violet-blue
        160, // violet
        170, // purple
        180, // red-purple
        190, // magenta-pink
        210, // pink
        220, // rose
        230, // peach
        240, // light gold
	243, 13,23, 17
    ];
    let hash = name.bytes().fold(5380u64, |h, b| h.wrapping_mul(511).wrapping_add(b as u64));
    PALETTE[(hash as usize) % PALETTE.len()]
}

fn add_polyline_entity(drawing: &mut Drawing, p: &GPolyline, layer_name: &str, depth: f64) {
    let mut poly = Polyline::default();
    poly.flags = if p.closed { 1 } else { 0 };
    poly.thickness = depth;
    for pt in &p.points {
        let v = Vertex::new(DxfPoint::new(pt.x, pt.y, 0.0));
        poly.add_vertex(drawing, v);
    }
    let mut entity = Entity::new(EntityType::Polyline(poly));
    entity.common.layer = layer_name.to_string();
    drawing.add_entity(entity);
}

pub fn build_drawing(shapes_by_layer: &BTreeMap<String, Vec<&Shape>>, layer_depths: &BTreeMap<String, f64>) -> Drawing {
    let mut drawing = Drawing::new();

    for (layer_name, shapes) in shapes_by_layer.iter() {
        let mut layer = Layer::default();
        layer.name = layer_name.clone();
        layer.color = Color::from_index(layer_color(layer_name));
        drawing.add_layer(layer);

        let depth = layer_depths.get(layer_name).copied().unwrap_or(0.0);
        for shape in shapes {
            match shape {
                Shape::Circle(c) => {
                    let mut circle = Circle::default();
                    circle.center = DxfPoint::new(c.center.x, c.center.y, 0.0);
                    circle.radius = c.radius;
                    circle.thickness = depth;
                    let mut entity = Entity::new(EntityType::Circle(circle));
                    entity.common.layer = layer_name.clone();
                    drawing.add_entity(entity);
                }
                Shape::Arc(GArc { center, radius, start_angle, end_angle }) => {
                    let mut arc = DxfArc::default();
                    arc.center = DxfPoint::new(center.x, center.y, 0.0);
                    arc.radius = *radius;
                    arc.start_angle = *start_angle;
                    arc.end_angle   = *end_angle;
                    arc.thickness   = depth;
                    let mut entity = Entity::new(EntityType::Arc(arc));
                    entity.common.layer = layer_name.clone();
                    drawing.add_entity(entity);
                }
                Shape::Poly(p) => add_polyline_entity(&mut drawing, p, layer_name, depth),
                Shape::Rect(r) => add_polyline_entity(&mut drawing, &r.as_polyline(), layer_name, depth),
            }
        }
    }

    drawing
}

fn add_line_entity(drawing: &mut Drawing, layer_name: &str, x0: f64, y0: f64, x1: f64, y1: f64) {
    let mut ent = Entity::new(EntityType::Line(DxfLine::new(
        DxfPoint::new(x0, y0, 0.0),
        DxfPoint::new(x1, y1, 0.0),
    )));
    ent.common.layer = layer_name.to_string();
    drawing.add_entity(ent);
}

fn add_text_entity(drawing: &mut Drawing, layer_name: &str,
                   x: f64, y: f64, s: &str, height: f64, rotation_deg: f64) {
    let mut text = Text::default();
    text.value       = s.to_string();
    text.location    = DxfPoint::new(x, y, 0.0);
    text.text_height = height;
    text.rotation    = rotation_deg;
    text.horizontal_text_justification = HorizontalTextJustification::Center;
    text.vertical_text_justification   = VerticalTextJustification::Middle;
    text.second_alignment_point        = DxfPoint::new(x, y, 0.0);
    let mut ent = Entity::new(EntityType::Text(text));
    ent.common.layer = layer_name.to_string();
    drawing.add_entity(ent);
}

/// Add a `measure` layer (panel dimensions) and a `holes` layer (hole diameters).
///
/// Text height is derived from panel size so annotations read ~4 mm on A4 landscape paper.
///
/// `measure`:
/// - Horizontal dim line below `outer_bb`; label below the line
/// - Vertical dim line left of `outer_bb`; label left of the line, rotated 90°
///
/// `holes`:
/// - Circles: horizontal indicator line centre→rim; ⌀XX label above the circle
/// - Arcs:    radius line centre→arc-midpoint;      ⌀XX label beyond the arc
pub fn add_measure_layer(
    drawing: &mut Drawing,
    shapes_by_layer: &BTreeMap<String, Vec<&Shape>>,
    _bb: &Rect,
    outer_bb: &Rect,
) {
    let panel_w = outer_bb.max.x - outer_bb.min.x;
    let panel_h = outer_bb.max.y - outer_bb.min.y;
    let text_h  = a4_text_h(panel_w, panel_h);
    let dim_off = text_h * 3.5;
    let tick    = text_h * 0.5;
    let gap     = text_h * 0.9;

    // ── measure layer ─────────────────────────────────────────────────────
    {
        const L: &str = "measure";
        let mut layer = Layer::default();
        layer.name  = L.to_string();
        layer.color = Color::from_index(3); // green
        drawing.add_layer(layer);

        // Width
        let y_dim   = outer_bb.min.y - dim_off;
        let x_left  = outer_bb.min.x;
        let x_right = outer_bb.max.x;
        add_line_entity(drawing, L, x_left,  outer_bb.min.y, x_left,  y_dim - tick);
        add_line_entity(drawing, L, x_right, outer_bb.min.y, x_right, y_dim - tick);
        add_line_entity(drawing, L, x_left, y_dim, x_right, y_dim);
        add_line_entity(drawing, L, x_left,  y_dim - tick, x_left,  y_dim + tick);
        add_line_entity(drawing, L, x_right, y_dim - tick, x_right, y_dim + tick);
        add_text_entity(drawing, L,
            (x_left + x_right) / 2.0, y_dim - gap,
            &fmt_dim(panel_w), text_h, 0.0);

        // Height
        let x_dim = outer_bb.min.x - dim_off;
        let y_bot = outer_bb.min.y;
        let y_top = outer_bb.max.y;
        add_line_entity(drawing, L, outer_bb.min.x, y_bot, x_dim - tick, y_bot);
        add_line_entity(drawing, L, outer_bb.min.x, y_top, x_dim - tick, y_top);
        add_line_entity(drawing, L, x_dim, y_bot, x_dim, y_top);
        add_line_entity(drawing, L, x_dim - tick, y_bot, x_dim + tick, y_bot);
        add_line_entity(drawing, L, x_dim - tick, y_top, x_dim + tick, y_top);
        add_text_entity(drawing, L,
            x_dim - gap, (y_bot + y_top) / 2.0,
            &fmt_dim(panel_h), text_h, 90.0);
    }

    // ── holes layer ───────────────────────────────────────────────────────
    {
        const L: &str = "holes";
        let mut layer = Layer::default();
        layer.name  = L.to_string();
        layer.color = Color::from_index(4); // cyan
        drawing.add_layer(layer);

        for shapes in shapes_by_layer.values() {
            for shape in shapes {
                match shape {
                    Shape::Circle(c) => {
                        let label = format!("d{}", fmt_dim(c.radius * 2.0));
                        add_text_entity(drawing, L,
                            c.center.x, c.center.y + c.radius + gap,
                            &label, text_h, 0.0);
                    }
                    Shape::Arc(a) => {
                        let mut ea = a.end_angle;
                        while ea <= a.start_angle { ea += 360.0; }
                        let mid_rad = ((a.start_angle + ea) / 2.0).to_radians();
                        let label = format!("R{}", fmt_dim(a.radius));
                        add_text_entity(drawing, L,
                            a.center.x + (a.radius + gap) * mid_rad.cos(),
                            a.center.y + (a.radius + gap) * mid_rad.sin(),
                            &label, text_h, 0.0);
                    }
                    _ => {}
                }
            }
        }
    }
}

/// Add all close strips into a single `close` layer: one rectangle + text annotation per edge.
pub fn add_close_layers(drawing: &mut Drawing, closes: &[EdgeClose], bb: &Rect) {
    if closes.is_empty() { return; }

    let layer_name = "close";
    let mut layer = Layer::default();
    layer.name = layer_name.to_string();
    layer.color = Color::from_index(layer_color(layer_name));
    drawing.add_layer(layer);

    let text_h = a4_text_h(bb.max.x - bb.min.x, bb.max.y - bb.min.y);
    let offset  = text_h * 2.0;
    let cx = (bb.min.x + bb.max.x) / 2.0;
    let cy = (bb.min.y + bb.max.y) / 2.0;

    for ec in closes {
        // Strip rectangle (full-span along the edge).
        let rect: &[(f64, f64)] = &match ec.edge {
            Edge::Left  => [(bb.min.x,             bb.min.y), (bb.min.x + ec.width, bb.min.y),
                            (bb.min.x + ec.width,  bb.max.y), (bb.min.x,            bb.max.y)],
            Edge::Right => [(bb.max.x - ec.width,  bb.min.y), (bb.max.x,            bb.min.y),
                            (bb.max.x,             bb.max.y), (bb.max.x - ec.width, bb.max.y)],
            Edge::Front => [(bb.min.x, bb.min.y),             (bb.max.x, bb.min.y),
                            (bb.max.x, bb.min.y + ec.width),  (bb.min.x, bb.min.y + ec.width)],
            Edge::Rear  => [(bb.min.x, bb.max.y - ec.width),  (bb.max.x, bb.max.y - ec.width),
                            (bb.max.x, bb.max.y),             (bb.min.x, bb.max.y)],
        };
        let mut poly = Polyline::default();
        poly.flags = 1; // closed
        for &(x, y) in rect {
            poly.add_vertex(drawing, Vertex::new(DxfPoint::new(x, y, 0.0)));
        }
        let mut ent = Entity::new(EntityType::Polyline(poly));
        ent.common.layer = layer_name.to_string();
        drawing.add_entity(ent);

        // Text annotation outside the panel edge.
        let (tx, ty) = match ec.edge {
            Edge::Left  => (bb.min.x - offset, cy),
            Edge::Right => (bb.max.x + offset, cy),
            Edge::Front => (cx, bb.min.y - offset),
            Edge::Rear  => (cx, bb.max.y + offset),
        };
        let mut text = Text::default();
        text.value           = format!("{}: {:.2}mm", ec.edge.label(), ec.width);
        text.location        = DxfPoint::new(tx, ty, 0.0);
        text.text_height     = text_h;
        text.horizontal_text_justification = HorizontalTextJustification::Center;
        text.vertical_text_justification   = VerticalTextJustification::Middle;
        text.second_alignment_point        = DxfPoint::new(tx, ty, 0.0);
        let mut ent = Entity::new(EntityType::Text(text));
        ent.common.layer = layer_name.to_string();
        drawing.add_entity(ent);
    }
}
