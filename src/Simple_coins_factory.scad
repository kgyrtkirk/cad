// Download Write.scad and DXF-file (Letters.dxf by default) from
// http://www.thingiverse.com/thing:16193
use <write/Write.scad>;

// What coin do you want?
value="25"; // [1, 5, 10, 25, 50]
coin(value);

// You can set these values to non-zero value to override defaults,
// or even define your own coin without modifying this file
Radius = undef;
Thickness = undef;
FontHeight = undef;

// Constants
EDGE_R = 0.9; // Radius of the edge relative to the coin radius (0.9 = 90%)
EDGE_H = 1; // Height of the edge in mm (along Z axis)
EXTRA_EDGE = false; // If 'true', allows easy coins stacking with extra sharp edge on top

coins =
[ // Nominal, Radius, Thickness, FontHeight
  [  "1",     9.5,    3,         12.5 ]
, [  "5",     10.5,   3,         12.5 ]
, [  "10",    8.5,    2.5,       8.5 ]
, [  "25",    12,     3,         12 ]
, [  "50",    15,     3,         15 ]
];

// [Hidden]
$fn=120;

module coin(value)
{
  found = search([value], coins, 1);
  //echo(found);
  coin = coins[found[0]];
  Radius     = (Radius == undef)     ? coin[1] : Radius;
  Thickness  = (Thickness == undef)  ? coin[2] : Thickness;
  FontHeight = (FontHeight == undef) ? coin[3] : FontHeight;
  echo(str("Radius=", Radius, ", Thickness=", Thickness, ", FontHeight=", FontHeight));
  if (Radius != undef && Thickness != undef && FontHeight != undef)
  {
    union()
    {
      difference()
      {
        union()
        {
          translate([0, 0, EDGE_H])
            cylinder(r = Radius, h = Thickness - EDGE_H);
          cylinder(r1 = Radius * EDGE_R, r2 = Radius, h = EDGE_H);
        }
        translate([0, 0, Thickness - EDGE_H])
          cylinder(r = Radius * EDGE_R, h = Thickness);
        // Bottom text
        translate([0, 0, EDGE_H / 2 - 0.1])
          rotate([180, 0, 180])
            write(value, h = FontHeight, center = true, bold = 0.5);
      } // difference
      // Top text
      translate([0, 0, Thickness - EDGE_H / 2])
        write(value, h = FontHeight, center = true, bold = 0.5);
      if (EXTRA_EDGE)
      {
        translate([0, 0, Thickness])
        difference()
        {
          cylinder(r = Radius, h = EDGE_H);
          translate([0, 0, -0.1])
          cylinder(r1 = Radius * EDGE_R, r2 = Radius, h = EDGE_H + 0.2);
        }
      }
    } // union
  }
  else
    echo(str("ERROR: Coin for ", value, " can't be created!"));
} // module