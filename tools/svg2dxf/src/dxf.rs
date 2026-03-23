// DXF writer using the `dxf` crate — POLYLINE+VERTEX and CIRCLE, AC1009 compatible.

use std::collections::BTreeMap;
use dxf::Drawing;
use dxf::entities::{Circle, Polyline, Vertex, Entity, EntityType};
use dxf::tables::Layer;
use dxf::{Color, Point as DxfPoint};
use crate::geom::Shape;

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
