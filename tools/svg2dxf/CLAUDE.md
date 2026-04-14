# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
cargo build                          # debug build
cargo build --release                # optimised build
cargo run -- input.svg               # convert (output defaults to input.dxf)
cargo run -- input.svg output.dxf    # explicit output path
cargo test                           # run tests (none yet)
```

## Architecture

`svg2dxf` is a Rust CLI that converts panel-layout SVGs (produced by OpenSCAD) into DXF files suitable for CNC/CAD workflows. Coordinates are in **mm** throughout (`usvg` is initialised at 96 dpi → 25.4 mm/inch so 1 SVG user unit = 1 mm). The SVG Y-axis is flipped on ingestion because SVG is Y-down and DXF is Y-up.

### Processing pipeline (`main.rs`)

1. **Parse** – `svg::parse_svg` flattens all SVG paths into `Shape::Poly` polylines with Y already flipped.
2. **Tile dedup** – `keep_one_tile` detects repeated tile layouts by comparing bounding boxes; retains only shapes inside the largest bounding box (+ 3 mm margin).
3. **Close extraction** – `close::extract_closes` pulls thin rectangles that abut the outer AABB edges; these are edge-banding (close) strips rendered by OpenSCAD. They get their own `close_{edge}_{width}` DXF layers.
4. **Feature loop extraction** – `xor::feature_loops` strips segments that lie on the inner panel AABB, then splits each shape at those boundaries to recover individual feature loops (holes, grooves, slots).
5. **Shape detection** – `geom::detect_circles` fits circles to polygon approximations; `geom::detect_slots` expands 8 mm-wide edge slots to 32 mm-depth rectangles anchored on the panel edge.
6. **Origin translation** – shifts everything so the panel's bottom-left is at (0, 0).
7. **Layer assignment** – `classify::layer` maps each shape to a DXF layer name based on geometry rules (see below).
8. **DXF output** – `dxf::build_drawing` + `dxf::add_close_layers` write AC1009-compatible POLYLINE/CIRCLE/TEXT entities.

### Module responsibilities

| Module | Responsibility |
|---|---|
| `geom.rs` | Primitives (`Point`, `Rect`, `Circle`, `Polyline`, `Shape` enum); circle-fit and slot-expansion logic |
| `svg.rs` | SVG ingestion via `usvg`; Y-flip; splits paths at `MoveTo`/`Close` into `Polyline` shapes |
| `xor.rs` | `Aabb` type; `feature_loops` boundary-stripping algorithm |
| `close.rs` | Edge-close strip detection and `EdgeClose`/`Edge` types |
| `classify.rs` | Layer-name rules (see below) |
| `dxf.rs` | DXF entity construction; layer colour assignment (`layer_color`) |

### Layer naming rules (`classify.rs`)

| Pattern | Layer name |
|---|---|
| Circle | `drill_d{diameter_mm_rounded}` |
| Closed poly, 4.5 < short side < 11 mm, long side < 80 mm | `drill_slot_{short}x{long}` |
| Closed poly, aspect ratio > 8, short side < 12 mm | `groove_{short_mm}` |
| Expanded 8×32 mm drill slot | `drill_slot_8x32` |
| Panel inner AABB | `panel` |
| Outer AABB (includes close strips) | `extended_boundary` |
| Edge-close strip | `close_{B\|L\|R\|T}_{width:.2}` |
| Anything else | `unclassified` |

### Known FIXMEs in the code

- `geom.rs`: `Rect` should probably subsume `Aabb`; `Rect` could be a `Shape`.
- `xor.rs`: `Aabb` and `Line` are misplaced — they belong in `geom`.
- `xor.rs`: `poly_to_lines` could be an `Into`/`From` impl on `Polyline`.
