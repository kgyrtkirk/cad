package hu.rxd.kitchen;

import static hu.rxd.kitchen.F.cube;
import static hu.rxd.kitchen.F.*;
import static hu.rxd.kitchen.F.translate;

import java.util.ArrayList;
import java.util.List;

import org.w3c.dom.views.AbstractView;

import eu.printingin3d.javascad.models.Abstract3dModel;
import eu.printingin3d.javascad.tranzitions.Rotate;
import eu.printingin3d.javascad.tranzitions.Translate;
import eu.printingin3d.javascad.tranzitions.Union;

public class Wall extends Union {

  public interface XX {
    public String getName();
  };

  public static class LeftWall extends Union implements XX {

    private static final double HALF_WALL_H = 500;
    private static final double FULL_WALL_H = 1000;

    public LeftWall() {
      super(
          gen()
        );
    }

    private static List<Abstract3dModel> gen() {
      List<Abstract3dModel> ret = new ArrayList<>();
      int W1 = 600;
      int W2 = 1000;
      Wall e = new Wall(W1, FULL_WALL_H);
      Wall e2 = new Wall(W2, HALF_WALL_H);

      ret.add(translateX(e2, -W2 - W1));
      ret.add(translateX(e, -W1));
      //      new Rotate(model, angles)
      return ret;
    }

    private static Translate alignLeft(Wall e2, Wall e) {
      return translate(e2, d3(e.getBoundaries().getX().getMax(), 200, 0));

    }

    public String getName() {
      return "m";
    }
  }

  private static final double WALL_THICK = 70;
  public final double width;
  public final double height;

  public Wall(double width, double height) {
    super(
        bx(width, height));
    this.width = width;
    this.height = height;
  }

  private static Abstract3dModel bx(double width, double height) {
    Abstract3dModel res = cube(c3(width, WALL_THICK, height));
    res = translate(res, d3(width, WALL_THICK, height).mul(.5));
    return res;
    
  }



}
