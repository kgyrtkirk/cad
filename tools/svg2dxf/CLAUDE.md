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
5. **Shape detection** – `geom::detect_circles` fits circles; `geom::detect_slots` expands 8×8 stubs to 8×32 mm edge slots; `geom::detect_saw_rects` converts 4-pt axis-aligned narrow rectangles to `Shape::Rect` (SAW layer); `geom::detect_arcs` fits arcs to open boundary-touching polylines with > 4 points.
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

See `DXF_FORMAT_SUMMARY.md` for the CNC machine's interpretation of layer names and entity thickness (depth).

| Pattern | Layer name |
|---|---|
| Circle, radius > 10 mm | `BACK` |
| Circle | `TOP` |
| `Shape::Rect`, AR > 8, short < 12 mm | `SAW` |
| Closed poly, ~138×33 mm | `HANDLE_CUT` |
| Closed poly, 8×32 mm abutting edge | `LEFT` / `RIGHT` / `FRONT` / `REAR` |
| Closed poly, 4.5 < short < 11 mm, long < 80 mm | `TOP` |
| Closed poly, AR > 8, short < 12 mm | `SAW` |
| Arc | `ARC_CUT` |
| Inner panel AABB | `raw_panel` |
| Outer AABB (includes close strips) | `PANEL` |
| Anything else | `unclassified` |

### Debugging

`cargo run` writes a diagnostic summary to stderr: close strips found, feature-loop count, layer shape counts. Check these first when output looks wrong:

```
  close FRONT: 2.00mm      ← if a close is missing, as_edge_close thin-dimension logic may be failing
  layer SAW: 1 shapes       ← if 0, grooves may have been eaten by detect_arcs
  layer ARC_CUT: N shapes   ← should be 0 on groove-only panels; > 0 only when true arc cuts exist
```

### Known FIXMEs in the code

- `geom.rs`: `Rect` should probably subsume `Aabb`; `Rect` could be a `Shape`.
- `xor.rs`: `Aabb` and `Line` are misplaced — they belong in `geom`.
- `xor.rs`: `poly_to_lines` could be an `Into`/`From` impl on `Polyline`.
