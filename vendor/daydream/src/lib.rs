#[macro_use]
extern crate rutie;
extern crate delaunator;
extern crate image;
extern crate imageproc;
extern crate nanorand;
extern crate uuid;

use delaunator::{triangulate, Point};
use image::{ImageBuffer, RgbaImage};
use imageproc::drawing;
use imageproc::point::Point as DrawPoint;
use nanorand::{Rng, WyRand};
use rutie::{Class, Integer, Object, RString};
use std::fs;
use core::cmp::{min,max};
use uuid::Uuid;

class!(Dream);

methods!(
    Dream,
    _rtself,
    fn pub_image(width: Integer, height: Integer) -> RString {
        let result_width = width.unwrap().to_u32();
        let result_height = height.unwrap().to_u32();

        let mut image: RgbaImage = ImageBuffer::new(result_width, result_height);

        let colors = [
            image::Rgba([21, 114, 161,255]),
            image::Rgba([154, 208, 236,255]),
            image::Rgba([239, 218, 215,255]),
            image::Rgba([227, 190, 198,255]),
        ];

        let mut points = vec![
            Point { x: 0., y: 0. },
            Point {
                x: f64::from(result_width - 1),
                y: 0.,
            },
        ];

        let mut rng = WyRand::new();
        let num_points = result_width * result_height / 100;
        for _i in 0..num_points {
            points.push(Point {
                x: rng.generate_range(1_u32..result_width - 1) as f64,
                y: rng.generate_range(1_u32..result_height - 1) as f64,
            })
        }
        points.push(Point {
            x: f64::from(result_width - 1),
            y: f64::from(result_height - 1),
        });
        points.push(Point {
            x: 0.0,
            y: f64::from(result_height - 1),
        });

        let result = triangulate(&points);
        for triangle in result.triangles.chunks(3) {
            let mut draw_points = Vec::new();
            for index in triangle {
                let point: &Point = &points[*index];
                draw_points.push(DrawPoint {
                    x: point.x as i32,
                    y: point.y as i32,
                })
            }

            let color = colors[rng.generate_range(0_usize..colors.len())];
            draw_polygon_antialiased_mut(&mut image, &draw_points, color);
        }

        fs::create_dir_all("tmp/dream").unwrap();
        let file_name = format!("tmp/dream/{}.png", Uuid::new_v4());

        image.save(&file_name).unwrap();
        RString::new_utf8(&file_name)
    }
);

fn draw_polygon_antialiased_mut(canvas: &mut RgbaImage, poly: &[DrawPoint<i32>], color: image::Rgba<u8>)
{
    if poly.is_empty() {
        return;
    }
    if poly[0] == poly[poly.len() - 1] {
        panic!(
            "First point {:?} == last point {:?}",
            poly[0],
            poly[poly.len() - 1]
        );
    }

    let mut y_min = i32::MAX;
    let mut y_max = i32::MIN;
    for p in poly {
        y_min = min(y_min, p.y);
        y_max = max(y_max, p.y);
    }

    let (width, height) = canvas.dimensions();

    // Intersect polygon vertical range with image bounds
    y_min = max(0, min(y_min, height as i32 - 1));
    y_max = max(0, min(y_max, height as i32 - 1));

    let mut closed: Vec<DrawPoint<i32>> = poly.iter().copied().collect();
    closed.push(poly[0]);

    let edges: Vec<&[DrawPoint<i32>]> = closed.windows(2).collect();
    let mut intersections = Vec::new();

    for y in y_min..y_max + 1 {
        for edge in &edges {
            let p0 = edge[0];
            let p1 = edge[1];

            if p0.y <= y && p1.y >= y || p1.y <= y && p0.y >= y {
                if p0.y == p1.y {
                    // Need to handle horizontal lines specially
                    intersections.push(p0.x);
                    intersections.push(p1.x);
                } else if p0.y == y || p1.y == y {
                    if p1.y > y {
                        intersections.push(p0.x);
                    }
                    if p0.y > y {
                        intersections.push(p1.x);
                    }
                } else {
                    let fraction = (y - p0.y) as f32 / (p1.y - p0.y) as f32;
                    let inter = p0.x as f32 + fraction * (p1.x - p0.x) as f32;
                    intersections.push(inter.round() as i32);
                }
            }
        }

        intersections.sort_unstable();
        intersections.chunks(2).for_each(|range| {
            let mut from = min(range[0], width as i32);
            let mut to = min(range[1], width as i32 - 1);
            if from < width as i32 && to >= 0 {
                // draw only if range appears on the canvas
                from = max(0, from);
                to = max(0, to);

                for x in from..to + 1 {
                    canvas.put_pixel(x as u32, y as u32, color);
                }
            }
        });

        intersections.clear();
    }

    for edge in &edges {
        let start = (edge[0].x, edge[0].y);
        let end = (edge[1].x, edge[1].y);
        drawing::draw_antialiased_line_segment_mut(
            canvas,
            start,
            end,
            color,
            imageproc::pixelops::interpolate,
        );
    }
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_dream() {
    Class::new("Dream", None).define(|klass| {
        klass.def_self("image", pub_image);
    });
}
