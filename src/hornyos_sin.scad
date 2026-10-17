// Fogólap: a halmazrendező kártyái koncentrikus íveken, egymás mögött,
// hátradőlve. Egy lap = egy kategória. A középpont a néző felől van,
// a hátsó ívek hosszabbak; a kártyát az ív görbülete szorítja a résben.
// Laposan nyomtatódik, támasz nélkül.

//@OUTPUT:def

szog    = 50;    // a körcikk nyílásszöge (fok)
r_elso  = 140;   // az első ív sugara; a csúcs felőli rész kimarad
sorok   = 6;
sorkoz  = 22;    // az ívek távolsága; a hátsó ív 218 mm: a 210 mm-es címke elfér
kullok  = 6;     // sugárirányú összekötők száma, a két szélső is
rud     = 2;     // a küllők szélessége
alap    = 1.2;   // a küllők vastagsága
talp    = 4;     // a tartó háromszög alapja
magas   = 8;     // a tartó háromszög magassága
doles   = 8;     // a középvonal (és a kártya) hátradőlése a függőlegestől (fok)
res     = 0.8;   // a papír helye: téglalap a középvonal mentén
res_alj = 1.3;   // a rés alja ennyivel a tartó alja fölött
rud_fent = 0.5;  // a küllő felső átmérője

$fa = 1;
$fs = 0.5;
//$fn = 63;

r_utso = r_elso + (sorok - 1) * sorkoz;
// A küllő oldalának dőlése a függőlegestől; a tartók vége ezen a síkon áll.
vag = atan((rud - rud_fent) / 2 / alap);
tulnyul = rud / 2 / r_elso * 180 / PI + 1;  // fok: a kihúzás ráhagyása a levágáshoz

// Keresztmetszet az r–z síkban: háromszög, csúcsa hátrahúzva; a középvonal
// mentén, alulról kicsit feljebb kezdődő téglalap a rés.
module tarto_profil(r)
  difference() {
    polygon([
      [r - talp / 2, 0],
      [r + talp / 2, 0],
      [r + magas * tan(doles), magas],
    ]);
    translate([r + res_alj * tan(doles), res_alj])
      rotate(-doles) translate([-res / 2, 0]) square([res, 2 * magas]);
  }

module kullo(a)
  hull() {
  $fn =32;
    rotate(a) translate([r_elso - talp/2, 0]) cylinder(d1 = rud, d2 = rud_fent, h = alap);
    rotate(a) translate([r_utso + talp / 2, 0]) cylinder(d1 = rud, d2 = rud_fent, h = alap);
  }

// A tartók mindkét végükön túlnyúlnak a körcikken; a szélső küllők síkja vágja le őket.
module tartok_hosszan()
  for (i = [0 : sorok - 1])
    rotate(-tulnyul) rotate_extrude(angle = szog + 2 * tulnyul)
      tarto_profil(r_elso + i * sorkoz);

// Az x tengelyen álló szélső küllő külső oldalának síkja: alul rud/2-vel
// kívül, felfelé vag szöggel befelé dől. A küllő felőli félteret adja.
module felter()
  translate([0, -rud / 2, 0]) rotate([-vag, 0, 0])
    translate([-r_utso, 0, -r_utso]) cube([3 * r_utso, 2 * r_utso, 2 * r_utso]);

// A körcikk az +y tengelyre szimmetrikus. A render() nélkül az előnézet (F5)
// nem mutatja a metszetet.
rotate(90 - szog / 2) {
  intersection() {
    render() tartok_hosszan();
    felter();
    rotate(szog) mirror([0, 1, 0]) felter();
  }
  for (j = [0 : kullok - 1]) kullo(j * szog / (kullok - 1));
}
