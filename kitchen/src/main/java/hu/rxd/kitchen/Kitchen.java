package hu.rxd.kitchen;

import java.io.File;

import eu.printingin3d.javascad.models.IModel;
import eu.printingin3d.javascad.utils.SaveScadFiles;
import eu.printingin3d.legobrick.LegoBrick;

public class Kitchen {

  public static void main(String[] args) throws Exception {
    SaveScadFiles exporter = new SaveScadFiles(new File("build"));

    IModel myModel = new Wall.LeftWall();
    exporter.addModel("m.scad", myModel);

    exporter.saveScadFiles();

  }
}
