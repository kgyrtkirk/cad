# DXF Format for CNC Woodworking Machines (MasterWork / Tecnos)

Source documents: `DXF Format_EN.doc` and `EN - Working with DXF.doc`

## Core Principle

All machining instructions are encoded by **layer name** + **entity thickness** (= depth):

- Layer name → operation type + optional speed overrides
- Entity "thickness" parameter → working depth (sign ignored; always treated as depth)

## Layer Name → Operation Mapping

| Layer Name Pattern | Operation | Entity Type |
|---|---|---|
| `PANEL` | Panel dimensions | Closed polyline (rectangle); thickness = board thickness |
| `TOP[$Fn]` | Vertical drillings (top face) | CIRCLE; thickness = drill depth |
| `LEFT[$Fn]` | Horizontal drilling, left side | Closed polyline (rectangle) |
| `FRONT[$Fn]` | Horizontal drilling, front side | Closed polyline (rectangle) |
| `RIGHT[$Fn]` | Horizontal drilling, right side | Closed polyline (rectangle) |
| `REAR[$Fn]` | Horizontal drilling, rear side | Closed polyline (rectangle) |
| `INDEX[$TOOL_NAME][$Fn]` | Indexed horizontal drilling | Closed polyline (rectangle) |
| `SAW[$Fn][$En]` | Saw blade cuts / grooving | LINE or closed polyline; thickness = cut depth |
| `TOOL$TOOL_NAME[$R\|$L][$Fn][$En][$Sn]` | Routing operations | LINE, ARC, CIRCLE, POLYLINE |

Optional speed parameters (appended to layer name):
- `$Fn` — feed rate in m/min
- `$En` — entry speed in m/min  
- `$Sn` — spindle speed in ×1000 RPM (routing only)

Since `.` is invalid in pre-AutoCAD-2000 layer names, use `P` as decimal point (e.g. `$F3P5`).

## SAW Layer Detail (Grooves)

Two modes depending on entity type:
- **LINE** → tool center path; pocket along the direction P1→P2
- **Closed POLYLINE (rectangle)** → area is pocketed; direction = major axis; pocket width = minor side

Thickness → cut depth.

## PANEL Layer Detail

- One closed polyline rectangle per drawing; defines panel X/Y dimensions
- Thickness = panel thickness (board height in Z)
- Reference point: bottom-left corner of this rectangle = origin for all operations
- Optional: TEXT/MTEXT entity in this layer = program comment

## Vertical Drilling (TOP Layer)

- CIRCLE entity; diameter = tool diameter; thickness = drill depth
- Center XY = drilling position

## Colours

Different colour per layer for visual debugging in CAD; not used during machining.

---

## Planned Layer Changes for svg2dxf

Current svg2dxf output → target DXF-standard names:

| Current layer | New layer | Notes |
|---|---|---|
| `groove_{width_mm}` | `SAW` | Rectangle entities; thickness = 8 mm |
| `drill_d{diam}` | `TOP` | Circle entities; thickness = 13 mm (drill depth) |
| `drill_slot_*` | keep or map to `TOP`/side layers | TBD |
| `panel` (inner AABB) | `RAW_PANEL` | Informational only; not a machine instruction |
| `extended_boundary` (outer AABB incl. closes) | `PANEL` | This is the actual panel outline; thickness = 18 mm |

Board parameters:
- Board thickness: **18 mm** → PANEL rectangle thickness
- Drill depth: **13 mm** → TOP circle thickness  
- Groove/saw depth: **8 mm** → SAW entity thickness
