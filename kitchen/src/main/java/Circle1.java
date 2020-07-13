import org.apache.batik.ext.awt.geom.Polygon2D;

class Circle1 {

  float x;
  float y;
  double r;

  public Circle1(Polygon2D poly) {
    float sumX = 0.0f;
    float sumY = 0.0f;
    int n = poly.npoints;
    for (int i = 0; i < n; i++) {
      sumX += poly.xpoints[i];
      sumY += poly.ypoints[i];
    }
    x = (sumX / n);
    y = (sumY / n);

    for (int i = 0; i < n; i++) {
      float dx = x - poly.xpoints[i];
      float dy = y - poly.ypoints[i];
      double d = Math.sqrt(dx * dx + dy * dy);
      if (i == 0) {
        r = d;
      } else {
        if (!isSame(d, r)) {
          throw new RuntimeException(d + " ~ " + r);
        }
      }
    }
    if (isSame(x, 0.0))
      x = 0;
    if (isSame(y, 0.0))
      y = 0;
  }

  @Override
  public String toString() {
    return String.format("Circle  %.3f  %.3f %.3f", x, y, r);
  }

  private boolean isSame(double d, double r2) {
    double delta = Math.abs(d - r2);

    return (delta < .0005);
  }

}