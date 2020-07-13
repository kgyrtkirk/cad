import java.awt.geom.Point2D;
import java.util.LinkedList;
import java.util.List;

import org.apache.batik.parser.DefaultPathHandler;
import org.apache.batik.parser.DefaultPointsHandler;
import org.apache.batik.parser.ParseException;
import org.apache.batik.parser.PathHandler;
import org.apache.batik.parser.PathParser;
import org.apache.batik.parser.PointsHandler;
import org.apache.batik.parser.PointsParser;

public class S1 {

  public List extractPoints(String s) throws ParseException {
    final LinkedList points = new LinkedList();
    PathParser pp = new PathParser();
    PathHandler ph = new DefaultPathHandler() {
      //      public void point(float x, float y) throws ParseException {
      //        Point2D p = new Point2D.Float(x, y);
      //        points.add(p);
      //      }
    };
    pp.setPathHandler(ph);
    pp.parse(s);
    return points;
  }
}