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

const COLORS: &[u8] = &[1, 2, 3, 4, 5, 6, 30, 40, 50, 70, 80, 90, 110, 130, 150, 170, 190, 210];

pub fn build_drawing(shapes_by_layer: &BTreeMap<String, Vec<&Shape>>) -> Drawing {
    let mut drawing = Drawing::new();

    for (idx, (layer_name, shapes)) in shapes_by_layer.iter().enumerate() {
        let mut layer = Layer::default();
        layer.name = layer_name.clone();
        layer.color = Color::from_index(COLORS[idx % COLORS.len()]);
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
        let layer_name = format!("close_{}", ec.edge.label());

        let mut layer = Layer::default();
        layer.name = layer_name.clone();
        layer.color = Color::from_index(3); // green
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
