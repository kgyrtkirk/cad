// DXF writer using the `dxf` crate — POLYLINE+VERTEX and CIRCLE, AC1009 compatible.

use std::collections::BTreeMap;
use dxf::Drawing;
use dxf::entities::{Circle, Polyline, Vertex, Text, Entity, EntityType};
use dxf::enums::{HorizontalTextJustification, VerticalTextJustification};
use dxf::tables::Layer;
use dxf::{Color, Point as DxfPoint};
use crate::geom::Shape;
use crate::close::{EdgeClose, Edge};
use crate::xor::Aabb;

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
        "panel"             => return 200, // purple
        "extended_boundary" => return 8,   // dark grey
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

pub fn build_drawing(shapes_by_layer: &BTreeMap<String, Vec<&Shape>>) -> Drawing {
    let mut drawing = Drawing::new();

    for (layer_name, shapes) in shapes_by_layer.iter() {
        let mut layer = Layer::default();
        layer.name = layer_name.clone();
        layer.color = Color::from_index(layer_color(layer_name));
        drawing.add_layer(layer);

        for shape in shapes {
            match shape {
                Shape::Circle(c) => {
                    let mut circle = Circle::default();
                    circle.center = DxfPoint::new(c.center.x, c.center.y, 0.0);
                    circle.radius = c.radius;
                    let mut entity = Entity::new(EntityType::Circle(circle));
                    entity.common.layer = layer_name.clone();
                    drawing.add_entity(entity);
                }
                Shape::Poly(p) => {
                    let mut poly = Polyline::default();
                    // flag bit 1 = closed
                    poly.flags = if p.closed { 1 } else { 0 };
                    for pt in &p.points {
                        let v = Vertex::new(DxfPoint::new(pt.x, pt.y, 0.0));
                        poly.add_vertex(&mut drawing, v);
                    }
                    let mut entity = Entity::new(EntityType::Polyline(poly));
                    entity.common.layer = layer_name.clone();
                    drawing.add_entity(entity);
                }
            }
        }
    }

    drawing
}

/// Add per-edge close layers: each layer gets the strip rectangle + a text annotation.
pub fn add_close_layers(drawing: &mut Drawing, closes: &[EdgeClose], bb: &Aabb) {
    let text_h = 5.0_f64;       // text height mm
    let offset  = text_h * 1.5; // gap from panel edge

    let cx = (bb.min_x + bb.max_x) / 2.0;
    let cy = (bb.min_y + bb.max_y) / 2.0;

    for ec in closes {
        let layer_name = format!("close_{}_{:.2}", ec.edge.label(), ec.width);

        let mut layer = Layer::default();
        layer.name = layer_name.clone();
        layer.color = Color::from_index(layer_color(&layer_name));
        drawing.add_layer(layer);

        // Strip rectangle (full-span along the edge).
        let rect: &[(f64, f64)] = &match ec.edge {
            Edge::Left   => [(bb.min_x,             bb.min_y), (bb.min_x + ec.width, bb.min_y),
                             (bb.min_x + ec.width,  bb.max_y), (bb.min_x,            bb.max_y)],
            Edge::Right  => [(bb.max_x - ec.width,  bb.min_y), (bb.max_x,            bb.min_y),
                             (bb.max_x,             bb.max_y), (bb.max_x - ec.width, bb.max_y)],
            Edge::Bottom => [(bb.min_x, bb.min_y),             (bb.max_x, bb.min_y),
                             (bb.max_x, bb.min_y + ec.width),  (bb.min_x, bb.min_y + ec.width)],
            Edge::Top    => [(bb.min_x, bb.max_y - ec.width),  (bb.max_x, bb.max_y - ec.width),
                             (bb.max_x, bb.max_y),             (bb.min_x, bb.max_y)],
        };
        let mut poly = Polyline::default();
        poly.flags = 1; // closed
        for &(x, y) in rect {
            poly.add_vertex(drawing, Vertex::new(DxfPoint::new(x, y, 0.0)));
        }
        let mut ent = Entity::new(EntityType::Polyline(poly));
        ent.common.layer = layer_name.clone();
        drawing.add_entity(ent);

        // Text annotation outside the panel edge.
        let (tx, ty) = match ec.edge {
            Edge::Left   => (bb.min_x - offset, cy),
            Edge::Right  => (bb.max_x + offset, cy),
            Edge::Bottom => (cx, bb.min_y - offset),
            Edge::Top    => (cx, bb.max_y + offset),
        };
        let mut text = Text::default();
        text.value           = format!("{}: {:.2}mm", ec.edge.label(), ec.width);
        text.location        = DxfPoint::new(tx, ty, 0.0);
        text.text_height     = text_h;
        text.horizontal_text_justification = HorizontalTextJustification::Center;
        text.vertical_text_justification   = VerticalTextJustification::Middle;
        text.second_alignment_point        = DxfPoint::new(tx, ty, 0.0);
        let mut ent = Entity::new(EntityType::Text(text));
        ent.common.layer = layer_name.clone();
        drawing.add_entity(ent);
    }
}
