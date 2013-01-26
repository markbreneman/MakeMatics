import dynamicprogramming.*;

SeamCarving carver;
//ArrayObject[] points;
ArrayList<PVector> seam;
ArrayList<PVector> points;
ArrayList<PVector> tempPoints;

PImage img, energyImage, scoreImage;

boolean newSeam = false;

int value = 1;
int step = 0;

PrintWriter history;

void setup() {

  //historyOutput = createWriter("historyOutput.txt");
  makeArray();

  points = new ArrayList<PVector>();//<--this arraylist is the master history.
  tempPoints = new ArrayList<PVector>();//<--this arraylist strinks 

  ////////////Initializes both arraylist with (original location, 0, 0)////////////////
  for (int i=0; i<img.height; i++) {
    for (int j=0; j<img.width; j++) {
      int loc = int(j+ (i*img.width));
      PVector tempPV = new PVector(loc, 0, 0);
      points.add(loc, tempPV);
      tempPoints.add(loc, tempPV);
    }
  }
  history = createWriter("ConferenceRoomMapped01-editedtest.txt");
}

void draw() {
  // draw a white "background"
  // behind the final result (since it shrinks)
  //  fill(255);
  //  noStroke();
  //  rect(energyImage.width, 0, energyImage.width, img.height);
  //
  //  image(img, 0, 0);
  //
  //  if (newSeam) {
  //    // draw a white "background"
  //    // behind the energy image (since it also shrinks)
  //    fill(255);
  //    noStroke();
  //    rect(0, 0, energyImage.width, img.height);
  //
  //    // draw the score image
  ////    image(scoreImage, 0, 0 );
  //
  //    // draw the next seam to remove
  //    stroke(255, 0, 0);
  //    for (PVector p : seam) {
  //      point(p.x, p.y);
  //    }
  //    
  //    newSeam = false;
  //  }
}


void keyReleased() {  
  if ( key=='n' && img.width>= 4  ) {
    seam = carver.findMinSeam();
    energyImage = carver.getGradientImage();
    carver.setImage(img);
    scoreImage = carver.getScoreImage();

    value += 1;//<------------------------------------------------------------keeping track of value(seam) count outside of forLoop
    for (int i=1; i<seam.size(); i++) {
      int loc = int(seam.get(i).x+ (seam.get(i).y*img.width));
      PVector oPosition = tempPoints.get(loc);
      PVector tempPV = new PVector(oPosition.x, value);
      points.set(int(oPosition.x), tempPV);
      tempPoints.remove(loc);
    }

    img.loadPixels();
    img = carver.removeColumn();
    println(img.width+"<----------imgWidth");
    img.updatePixels();
    newSeam = true;
  }

////AUTOMATION---SAME CODE AS ABOVE BUT WITH A FOR LOOP

if ( key=='a' && img.width>= 4  ) {
    for (int j=0; j<img.width; j++) {////NOTE THIS FOR LOOP
      seam = carver.findMinSeam();
      energyImage = carver.getGradientImage();
      carver.setImage(img);
      scoreImage = carver.getScoreImage();
      value += 1;
      for (int i=1; i<seam.size(); i++) {
        int loc = int(seam.get(i).x+ (seam.get(i).y*img.width));
        PVector oPosition = tempPoints.get(loc);
        PVector tempPV = new PVector(oPosition.x, value);
        points.set(int(oPosition.x), tempPV);
        tempPoints.remove(loc);
      }

      img.loadPixels();
      img = carver.removeColumn();
      println(img.width+"<----------imgWidth");
      img.updatePixels();
      newSeam = true;
    }
  }
  
/////SAVE OUT THE HISTORY OF THE SEAMS.

    if ( key=='s') { 
    for (int i=0; i<points.size(); i++) {
      history.println(points.get(i));
    }
    history.flush();
    history.close();
    exit();
  }

  
}

