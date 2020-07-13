package eu.printingin3d.legobrick;

import java.io.File;
import java.io.IOException;

import eu.printingin3d.javascad.exceptions.IllegalValueException;
import eu.printingin3d.javascad.utils.SaveScadFiles;

public class Main {

  /**
   * @param args
   * @throws IOException 
   * @throws IllegalValueException 
   */
	public static void main(String[] args) throws IllegalValueException, IOException {
    new SaveScadFiles(new File("build")).
        addModel("lego_brick.scad", new LegoBrick(2, 6)).
				saveScadFiles();
	}
}
