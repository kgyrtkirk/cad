package hu.rxd.kitchen;

import eu.printingin3d.javascad.coords.Coords3d;
import eu.printingin3d.javascad.coords.Dims3d;
import eu.printingin3d.javascad.models.Abstract3dModel;
import eu.printingin3d.javascad.models.Cube;
import eu.printingin3d.javascad.tranzitions.Translate;

public class F {

  // FIXME dims3d and coords3d are crap 
  public static Coords3d d3(double x, double y, double z) {
    return c3(x, y, z);
  }
  public static Coords3d c3(double x, double y, double z) {
    return new Coords3d(x, y, z);
  }

  public static Cube cube(Coords3d size) {
    return new Cube(toDims(size));
  }


  public static Translate translate(Abstract3dModel m, Coords3d t) {
    return new Translate(m, (t));
  }

  public static Translate translateX(Abstract3dModel m, double x) {
    return new Translate(m, (d3(x, 0, 0)));
  }

  // FIXME getX is just crap when x is finalized
  private static Coords3d toCoords(Dims3d t) {
    return new Coords3d(t.getX(), t.getY(), t.getZ());
  }

  // FIXME getX is just crap when x is finalized
  private static Dims3d toDims(Coords3d t) {
    return new Dims3d(t.getX(), t.getY(), t.getZ());
  }
}
