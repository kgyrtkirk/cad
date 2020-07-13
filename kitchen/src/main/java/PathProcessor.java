import org.apache.batik.anim.dom.SVGOMPathElement;
import org.apache.batik.dom.svg.SVGItem;
import org.apache.batik.dom.svg.SVGPathSegItem;
import org.apache.batik.dom.svg.AbstractSVGPathSegList.SVGPathSegMovetoLinetoItem;
import org.apache.batik.ext.awt.geom.Polygon2D;
import org.w3c.dom.svg.SVGPathSegList;

class PathProcessor {

  Polygon2D poly = new Polygon2D();

  public void visit(SVGOMPathElement pathElement) {
    SVGPathSegList pathList = pathElement.getNormalizedPathSegList();
    int pathObjects = pathList.getNumberOfItems();

    for (int i = 0; i < pathObjects; i++) {
      SVGItem item = (SVGItem) pathList.getItem(i);
      process(item);
    }
  }

  private void addPoint(float x, float y) {
    poly.addPoint(x, y);
  }

  public void finishPoly() {
    switch (poly.npoints) {
    case 0:
    case 1:
    case 2:
    case 3:
      throw new RuntimeException("unexpected number of points");

    case 4:
      Rect1 r = new Rect1(poly);
      System.out.println(r);
      break;

    default:
      Circle1 c = new Circle1(poly);
      System.out.println(c);
      break;

    }

    poly = new Polygon2D();
  }

  void process1(SVGPathSegItem d) {
    switch (d.getPathSegTypeAsLetter()) {
    case "z":
      finishPoly();
      break;
    default:
      throw new RuntimeException(d.getPathSegTypeAsLetter());
    }
  }

  void process1(SVGPathSegMovetoLinetoItem d) {
    switch (d.getPathSegTypeAsLetter()) {
    case "M":
    case "L":
      addPoint(d.getX(), d.getY());
      break;
    default:
      throw new RuntimeException(d.getPathSegTypeAsLetter());
    }
  }

  void process(SVGItem i) {
    if (i instanceof SVGPathSegMovetoLinetoItem) {
      process1((SVGPathSegMovetoLinetoItem) i);
      return;
    }
    if (i instanceof SVGPathSegItem) {
      process1((SVGPathSegItem) i);
      return;
    }
    throw new RuntimeException("default for: " + i.getClass());
  }
}