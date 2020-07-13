package hu.rxd.kitchen;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.Test;

public class K2 {

  private static final int LEFT_FULL_WIDTH = 600;
  private static final int LEFT_HALF_WIDTH = 2000;
  private static final int BACK_WALL_WIDTH = 2000;

  @Test
  public void asd() throws Exception {

    SObj wall = new SObj("union()");
    int off = 0;//-LEFT_FULL_WIDTH;
    wall.add(translate(off, 0, 0, fullWall(LEFT_FULL_WIDTH)));
    off = LEFT_FULL_WIDTH;
    wall.add(translate(off, 0, 0, halfWall(LEFT_HALF_WIDTH)));

    wall.add(rotate(fullWall(BACK_WALL_WIDTH))

    );

    wall.print(new OutStram());
    

  }

  private SObj rotate(SObj... children) {
    return new SObj("rotate(90)", children);
  }

  private SObj fullWall(int i) {
    return wall(i, 2000);
  }

  private SObj halfWall(int i) {
    return wall(i, 1000);
  }

  private SObj wall(int i, int j) {
    int D = 70;
    return translate(0, -D, 0,
        cube(i, D, j));
  }

  private SObj translate(double i, double j, double k, SObj cube) {
    return new SObj(String.format("translate([%f,%f,%f])", i, j, k), cube);
  }

  private SObj cube(double i, double j, double j2) {
    return new SObj(String.format("cube([%f,%f,%f])", i, j, j2));
  }

  static class SObj {

    private String format;
    private List<SObj> children;

    public SObj(String format, SObj... children) {
      this.format = format;
      this.children = new ArrayList(Arrays.asList(children));

    }

    public void add(SObj translate) {
      children.add(translate);
    }

    public void print(OutStram os) {
      os.print(format);
      switch (children.size()) {
      case 0:
        os.println(";");
        break;
      case 1:
        os.indent(1);
        os.println("");
        children.get(0).print(os);
        os.indent(-1);
        break;
      default:
        os.indent(1);
        os.println("{");
        for (SObj sObj : children) {
          sObj.print(os);
        }
        os.indent(-1);
        os.println("}");

      }

    }

  }

  static class OutStram {

    private PrintStream fos;

    public OutStram() throws Exception {
      fos = new PrintStream(new File("build/m.scad"));
    }

    private int ii;
    private boolean newLine;

    public void print(String format) {
      if (newLine) {
        for (int i = 0; i < ii; i++) {
          Systemoutprint(" ");
        }
        newLine = false;
      }
      Systemoutprint(format);
    }

    public void println(String string) {
      Systemoutprintln(string);
      newLine = true;

    }

    private void Systemoutprint(String format) {
      fos.print(format);

    }

    private void Systemoutprintln(String string) {
      fos.println(string);

    }

    public void indent(int i) {
      ii += i;
    }
  }
}