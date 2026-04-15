// DXF writer using the `dxf` crate — POLYLINE+VERTEX and CIRCLE, AC1009 compatible.

use std::collections::BTreeMap;
use dxf::Drawing;
use dxf::entities::{Circle, Polyline, Vertex, Text, Entity, EntityType};
use dxf::enums::{HorizontalTextJustification, VerticalTextJustification};
use dxf::tables::Layer;
use dxf::{Color, Point as DxfPoint};
use crate::geom::{Polyline as GPolyline, Rect, Shape};
use crate::close::{EdgeClose, Edge};

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
        "RAW_PANEL" => return 8,   // dark grey
        "TOP"       => return 4,   // cyan
        "SAW"       => return 30,  // orange
        "LEFT"      => return 1,   // red
        "RIGHT"     => return 3,   // green
        "FRONT"     => return 5,   // blue
        "REAR"      => return 6,   // magenta
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

fn layer_thickness(layer_name: &str) -> f64 {
    match layer_name {
        "PANEL"                       => 18.0, // board thickness mm
        "TOP"                         => 13.0, // top-face slot depth mm
        n if n.starts_with("SAW")     =>  8.0, // groove depth mm
        "LEFT"|"RIGHT"|"FRONT"|"REAR" =>  9.0, // Z: mid-board mm
        _ => 0.0,
    }
}

fn add_polyline_entity(drawing: &mut Drawing, p: &GPolyline, layer_name: &str) {
    let mut poly = Polyline::default();
    poly.flags = if p.closed { 1 } else { 0 };
    poly.thickness = layer_thickness(layer_name);
    for pt in &p.points {
        let v = Vertex::new(DxfPoint::new(pt.x, pt.y, 0.0));
        poly.add_vertex(drawing, v);
    }
    let mut entity = Entity::new(EntityType::Polyline(poly));
    entity.common.layer = layer_name.to_string();
    drawing.add_entity(entity);
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
                    circle.thickness = 13.0; // drill depth mm
                    let mut entity = Entity::new(EntityType::Circle(circle));
                    entity.common.layer = layer_name.clone();
                    drawing.add_entity(entity);
                }
                Shape::Poly(p) => add_polyline_entity(&mut drawing, p, layer_name),
                Shape::Rect(r) => add_polyline_entity(&mut drawing, &r.as_polyline(), layer_name),
            }
        }
    }

    drawing
}

/// Add per-edge close layers: each layer gets the strip rectangle + a text annotation.
pub fn add_close_layers(drawing: &mut Drawing, closes: &[EdgeClose], bb: &Rect) {
    let text_h = 5.0_f64;       // text height mm
    let offset  = text_h * 1.5; // gap from panel edge

    let cx = (bb.min.x + bb.max.x) / 2.0;
    let cy = (bb.min.y + bb.max.y) / 2.0;

    for ec in closes {
        let layer_name = format!("close_{}_{:.2}", ec.edge.label(), ec.width);

        let mut layer = Layer::default();
        layer.name = layer_name.clone();
        layer.color = Color::from_index(layer_color(&layer_name));
        drawing.add_layer(layer);

        // Strip rectangle (full-span along the edge).
        let rect: &[(f64, f64)] = &match ec.edge {
            Edge::Left   => [(bb.min.x,             bb.min.y), (bb.min.x + ec.width, bb.min.y),
                             (bb.min.x + ec.width,  bb.max.y), (bb.min.x,            bb.max.y)],
            Edge::Right  => [(bb.max.x - ec.width,  bb.min.y), (bb.max.x,            bb.min.y),
                             (bb.max.x,             bb.max.y), (bb.max.x - ec.width, bb.max.y)],
            Edge::Bottom => [(bb.min.x, bb.min.y),             (bb.max.x, bb.min.y),
                             (bb.max.x, bb.min.y + ec.width),  (bb.min.x, bb.min.y + ec.width)],
            Edge::Top    => [(bb.min.x, bb.max.y - ec.width),  (bb.max.x, bb.max.y - ec.width),
                             (bb.max.x, bb.max.y),             (bb.min.x, bb.max.y)],
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
            Edge::Left   => (bb.min.x - offset, cy),
            Edge::Right  => (bb.max.x + offset, cy),
            Edge::Bottom => (cx, bb.min.y - offset),
            Edge::Top    => (cx, bb.max.y + offset),
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
