import java.awt.geom.Point2D;

import javax.management.RuntimeErrorException;

import org.apache.batik.anim.dom.SVGOMPathElement;
import org.apache.batik.dom.svg.SVGItem;
import org.w3c.dom.Node;
import org.w3c.dom.svg.SVGPathSegList;

import eu.printingin3d.javascad.models.Sphere;
import eu.printingin3d.javascad.models2d.Circle;
import eu.printingin3d.javascad.models2d.Polygon;

/**
 * Responsible for converting an SVG path element to MetaPost. This
 * will convert just the bezier curve portion of the path element, not
 * its style. Typically the SVG path data is provided from the "d" attribute
 * of an SVG path node.
 */
public class MetaPostPath {
  private SVGOMPathElement pathElement;

  /**
   * Use to create an instance of a class that can parse an SVG path
   * element to produce MetaPost code.
   *
   * @param pathNode The path node containing a "d" attribute (output as MetaPost code).
   */
  public MetaPostPath( Node pathNode ) {
    setPathNode( pathNode );
  }

  /**
   * Converts this object's SVG path to a MetaPost draw statement.
   * 
   * @return A string that represents the MetaPost code for a path element.
   */
  public String toCode() {
    //    {
    //    PX px = new PX();
    //    px.visit(pathElement);
    //      if (true)
    //        return "";
    //    }

    StringBuilder sb = new StringBuilder(16384);
    SVGOMPathElement pathElement = getPathElement();
    SVGPathSegList pathList = pathElement.getNormalizedPathSegList();

    int pathObjects = pathList.getNumberOfItems();

    //    sb.append( ( new MetaPostComment( getId() ) ).toString() );
    //    sb.append("??" + getId());

    PX px = new PX();

    for (int i = 0; i < pathObjects; i++) {

      SVGItem item = (SVGItem) pathList.getItem(i);

      String format = String.format("%s%n", item.getValueAsString());
      //      System.out.println(format);
      sb.append(format);

      px.process(item);

    }

    return sb.toString();

  }

  /**
   * Returns the value for the id attribute of the path element. If the
   * id isn't present, this will probably throw a NullPointerException.
   * hahaha--- very classy! ^^^^
   * 
   * 
   * @return A non-null, but possibly empty String.
   */
  private String getId() {
    return getPathElement().getAttributes().getNamedItem( "id" ).getNodeValue();
  }


  /**
   * Typecasts the given pathNode to an SVGOMPathElement for later analysis.
   * 
   * @param pathNode The path element that contains curves, lines, and other
   * SVG instructions.
   */
  private void setPathNode( Node pathNode ) {
    this.pathElement = (SVGOMPathElement)pathNode;
  }

  /**
   * Returns an SVG document element that contains path instructions (usually
   * for drawing on a canvas).
   * 
   * @return An object that contains a list of items representing pen
   * movements.
   */
  private SVGOMPathElement getPathElement() {
    return this.pathElement;
  }
}