# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### OpenSCAD designs (`src/`)
```bash
cd src
gradle allScad    # compile all active designs → STL via openscad CLI
gradle allDxf     # generate DXF files (scad → SVG → DXF via svg2dxf)
gradle allPdf     # generate PDFs
```
Build targets are driven by `@OUTPUT:` markers inside `.scad` files; `build.gradle` discovers them automatically.

### svg2dxf tool (`tools/svg2dxf/`)
```bash
cd tools/svg2dxf
cargo build                        # debug build
cargo build --release              # optimised binary
cargo run -- input.svg             # output defaults to input.dxf
cargo run -- input.svg output.dxf  # explicit output path
cargo test
```

### DXF viewer (`docs/`)
```bash
cd docs
npm run build   # bundle dxf-viewer, copy fonts, zip DXF files
npm run dev     # build then serve locally
```

## Architecture

This is a **parametric furniture/cabinet CAD pipeline**: OpenSCAD designs are compiled to SVG panel layouts, which are then converted to DXF for CNC fabrication. The `galeria/` subdirectory holds compiled output files (logs, DXFs) from completed designs.

### Data flow

```
src/*.scad  (OpenSCAD parametric designs)
  │  openscad CLI  (-D mode=variant)
  ▼
SVG  (flat panel layouts)
  │  tools/svg2dxf  (Rust CLI)
  ▼
DXF  (CNC-ready, layer-semantics for drill/groove/panel/close)
  │  docs/  (esbuild bundle + dxf-viewer)
  ▼
Web viewer + downloadable zip
```

### Key source files (`src/`)

| File | Role |
|---|---|
| `furniture.scad` | Core cabinet library: joints, panels, drilling patterns |
| `kitchen.scad` / `kitchen_box.scad` | Kitchen cabinet modules and box primitives |
| `sarok.scad` | Corner cabinet system (main furniture design) |
| `syms.scad` | Symmetry helpers: `symX/Y/Z`, `magnetCut` |
| `hulls.scad` | Hull utilities |

### svg2dxf pipeline (`tools/svg2dxf/src/`)

See `tools/svg2dxf/CLAUDE.md` for full module-by-module documentation. Summary of processing stages:

1. **Parse** – SVG paths → polylines, Y-axis flipped (SVG Y-down → DXF Y-up)
2. **Tile dedup** – repeated tile layouts collapsed to largest bounding box
3. **Close extraction** – edge-banding strips pulled into `close_{B|L|R|T}_{width}` DXF layers
4. **Feature loop extraction** – holes/grooves/slots recovered by stripping panel-AABB boundaries
5. **Shape detection** – circles and 8×32 mm drill slots identified
6. **Layer assignment** – `classify::layer` maps geometry → DXF layer name
7. **DXF output** – AC1009-compatible POLYLINE/CIRCLE/TEXT entities

### OpenSCAD library path

External libraries live in `libraries/` (MCAD, gears, threadlib, etc.) and must also be symlinked or copied to `~/.local/share/OpenSCAD/libraries` for openscad to resolve them.
