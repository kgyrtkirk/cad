import java.awt.geom.Rectangle2D;

import org.apache.batik.ext.awt.geom.Polygon2D;

class Rect1 {
  double x, y, w, h;

  public Rect1(Polygon2D poly) {
    Rectangle2D b = poly.getBounds2D();
    if (!poly.contains(b)) {
      throw new RuntimeException("non AA rect");
    }
    x = b.getX();
    y = b.getY();
    w = b.getWidth();
    h = b.getHeight();
  }

  @Override
  public String toString() {
    return String.format("rect %.3f %.3f %.3f %.3f", x, y, w, h);
  }

  public void translate(double d, double e) {
    x += d;
    y += e;
  }

}