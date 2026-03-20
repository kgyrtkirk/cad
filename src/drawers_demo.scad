use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>
use <syms.scad>

// ── Toggle flags ─────────────────────────────────────────────────────────────
OPEN_DRAWERS = true;    // false = closed state
SHOW_BOXES   = true;    // false = fronts only, no internal box
SHOW_FRONTS  = true;
SHOW_JOINTS  = true;

// ── Global special variables ─────────────────────────────────────────────────
$W             = 18;
$close         = "";
$front         = false;
$fronts        = SHOW_FRONTS;
$machines      = true;
$jointsVisible = SHOW_JOINTS;
$drawerBoxes   = SHOW_BOXES;
$drawerState   = OPEN_DRAWERS ? "OPEN" : "CLOSED";
$smartOverdrive = false;
$cornerProtect  = false;
$connect       = undef;
$handle        = "normal";
$closeWFront   = [.4, 2];
$closeWMain    = [.4, 2];

FOOT = 50;
GAP  = 80;

// ─────────────────────────────────────────────────────────────────────────────
// A: std slides, W=600, D=630
//    Full height variety: all six common drawer heights
// ─────────────────────────────────────────────────────────────────────────────
module demoA() {
    $defaultDrawer = "std";
    posNeg()
    cabinet(name="A_std600", w=600, h=1500, d=630, foot=FOOT) {
        cTop()
        drawer(h=400)
        drawer(h=300)
        drawer(h=250)
        drawer(h=200)
        drawer(h=150)
        drawer(h=100);
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// B: smart slides, W=600, D=630
//    Same heights as A — compare smart vs std side by side.
//    D=630 → smartSlideLen picks 600 mm slide.
// ─────────────────────────────────────────────────────────────────────────────
module demoB() {
    $defaultDrawer = "smart";
    posNeg()
    cabinet(name="B_smart600d630", w=600, h=1500, d=630, foot=FOOT) {
        cTop()
        drawer(h=400)
        drawer(h=300)
        drawer(h=250)
        drawer(h=200)
        drawer(h=150)
        drawer(h=100);
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// C: smart slides, W=600, D=320
//    Shallow cabinet → smartSlideLen picks 300 mm slide.
//    Contrast with B (same width, deeper, 600 mm slide).
// ─────────────────────────────────────────────────────────────────────────────
module demoC() {
    $defaultDrawer = "smart";
    posNeg()
    cabinet(name="C_smart600d320", w=600, h=1100, d=320, foot=FOOT) {
        cTop()
        drawer(h=300)
        drawer(h=250)
        drawer(h=250)
        drawer(h=300);
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// D: smart slides, W=400 (narrow), D=630
//    Tests ix = w - 2*qx with small width;
//    qx = W+5 for smart, so ix = 400-2*23 = 354 mm inner width.
// ─────────────────────────────────────────────────────────────────────────────
module demoD() {
    $defaultDrawer = "smart";
    posNeg()
    cabinet(name="D_smart400", w=400, h=1100, d=630, foot=FOOT) {
        cTop()
        drawer(h=300)
        drawer(h=250)
        drawer(h=250)
        drawer(h=300);
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// E: std slides, W=800 (wide), D=630
//    Tests nBeams logic (d>500 → 2 cross-beams in drawer box).
//    qx = W+12.7 for std, so ix = 800-2*30.7 = 738 mm inner width.
// ─────────────────────────────────────────────────────────────────────────────
module demoE() {
    $defaultDrawer = "std";
    posNeg()
    cabinet(name="E_std800", w=800, h=1100, d=630, foot=FOOT) {
        cTop()
        drawer(h=300)
        drawer(h=250)
        drawer(h=250)
        drawer(h=300);
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Layout — columns along X, all share Y=0 origin
// ─────────────────────────────────────────────────────────────────────────────

xA = 0;
xB = xA + 600 + GAP;           // 680
xC = xB + 600 + GAP;           // 1360
xD = xC + 600 + GAP;           // 2040
xE = xD + 400 + GAP;           // 2520
xF = xE + 800 + GAP;           // 3400

translate([xA, 0, 0]) demoA();
translate([xB, 0, 0]) demoB();
translate([xC, 0, 0]) demoC();
translate([xD, 0, 0]) demoD();
translate([xE, 0, 0]) demoE();
