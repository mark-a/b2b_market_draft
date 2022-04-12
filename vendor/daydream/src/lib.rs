#[macro_use]
extern crate rutie;
extern crate colorsys;
extern crate delaunator;
extern crate image;
extern crate imageproc;
extern crate nalgebra as na;
extern crate poisson;
extern crate rand;

use colorsys::{ColorTransform, Rgb};
use core::cmp::{max, min};
use delaunator::{triangulate, Point};
use image::{ImageBuffer, RgbaImage};
use imageproc::drawing;
use imageproc::point::Point as DrawPoint;
use poisson::{algorithm, Builder, Type};
use rand::rngs::SmallRng;
use rand::{distributions::Alphanumeric, Rng, SeedableRng};
use rutie::{Class, AnyException, Exception, Integer, Object, RString, VM};
use std::fs;
use std::path::Path;

class!(Dream);

methods!(
    Dream,
    _rtself,
    fn pub_image(width: Integer, height: Integer, color: RString, seed_number: Integer) -> RString {
        process_image(width,height,color,seed_number).map_err(|e| VM::raise_ex(e.0) ).unwrap()
    }
);

type MaybeRString = Result<rutie::RString, rutie::AnyException>;
type MaybeInteger = Result<rutie::Integer, rutie::AnyException>;

struct LocalException(AnyException);

impl From<colorsys::ParseError> for LocalException {
    fn from(error: colorsys::ParseError) -> Self {
        LocalException(AnyException::new("ArgumentError",Some(&error.message)))
    }
}

impl From<AnyException> for LocalException {
    fn from(exception: AnyException) -> Self {
        LocalException(exception)
    }
}
impl From<std::io::Error>for LocalException {
    fn from(error: std::io::Error) -> Self {
        LocalException(AnyException::new("IOError",Some(&format!("{}",error))))
    }
}
impl From<image::ImageError>for LocalException {
    fn from(error: image::ImageError) -> Self {
        LocalException(AnyException::new("StandardError",Some(&format!("{}",&error))))
    }
}

fn process_image(width: MaybeInteger, height: MaybeInteger, color: MaybeRString, seed_number: MaybeInteger) -> Result<RString, LocalException > {
    let result_width = width?.to_u32();
    let result_height = height?.to_u32();
    let max_width = f64::from(result_width - 1);
    let max_height = f64::from(result_height - 1);
    let base_rgb: Rgb = Rgb::from_hex_str(color?.to_str())?;
    let mut rgb: Rgb = base_rgb.clone();
    let seed = seed_number?.to_u64();

    fs::create_dir_all("tmp/dream")?;
    let mut rng = SmallRng::seed_from_u64(seed);
    let name: String = (&mut rng).sample_iter(&Alphanumeric)
        .take(12)
        .map(char::from)
        .collect();
    let file_name = format!("tmp/dream/{}{}.png", name, base_rgb.to_hex_string());
    if Path::new(&file_name).exists() {
        return  Ok(RString::new_utf8(&file_name));
    }
    let mut image: RgbaImage = ImageBuffer::new(result_width, result_height);

    let mut colors = Vec::new();

    for i in 0..10 {
        if i > 0 {
            rgb.lighten(2.)
        }
        let rgb_arr: [u8; 3] = (&rgb).into();
        colors.push(image::Rgba([rgb_arr[0], rgb_arr[1], rgb_arr[2], 255]));
    }

    let mut points = Vec::new();
    let num_points = ((result_width * result_height) as f64).sqrt() as usize;

    let poisson = Builder::<_, na::Vector2<f64>>::with_samples(num_points, 0.9, Type::Normal)
        .build(rng, algorithm::Bridson);

    for sample in poisson {
        points.push(Point {
            x: sample.x * max_width,
            y: sample.y * max_height,
        })
    }

    points.push(Point { x: 0.0, y: 0.0 });

    for part in 1..=10 {
        let factor = part as f64 * 0.1;
        points.push(Point {
            x: 0.0,
            y: max_height * factor,
        });
        points.push(Point {
            x: max_width,
            y: max_height * factor,
        });
        points.push(Point {
            x: max_width * factor,
            y: 0.0,
        });
        points.push(Point {
            x: max_width * factor,
            y: max_height,
        });
    }

    let result = triangulate(&points);
    let mut index: usize = 0;
    for triangle in result.triangles.chunks(3) {
        let mut draw_points = Vec::new();
        for index in triangle {
            let point: &Point = &points[*index];
            draw_points.push(DrawPoint {
                x: point.x as i32,
                y: point.y as i32,
            })
        }
        let color = colors[index % colors.len()];
        index += 1;
        draw_polygon_antialiased_mut(&mut image, &draw_points, color);
    }

    image.save(&file_name)?;
    Ok(RString::new_utf8(&file_name))
}

fn draw_polygon_antialiased_mut(
    canvas: &mut RgbaImage,
    poly: &[DrawPoint<i32>],
    color: image::Rgba<u8>,
) {
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
