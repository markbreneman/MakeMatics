import isolines.*;
import channels.*;

Isolines finder;
PImage img;
int threshold = 120;

void setup() {
  // load the image and scale
  // the sketch to the image size
  img = loadImage("IMG_0023-900.png");
  size(img.width, img.height);
  // initialize an isolines finder based on img dimensions
  finder = new Isolines(this, img.width, img.height);
}

void draw() {
  image(img, 0,0);
  // update the threshold
  finder.setThreshold(threshold);
  // Use the Channels library to extract
  // the hue channel as an int array
  int[] pix = Channels.brightness(img.pixels);
  // find the isolines in the hue pixels
  finder.find(pix);

  // draw the contours
  stroke(0);
  fill(32);
  for (int k = 0; k < finder.getNumContours(); k++) {
    finder.drawContour(k);
  }
  text("threshold: " + threshold, width-150, 20);
  
  
  //my start
  fill(255,0,0);
  println(finder.getNumContours());
  for (int k = 0; k < finder.getNumContours(); k++) {
    // get each contour as an array of PVectors
    // so we can work with the individual points
    PVector[] points = finder.getContourPoints(k);
//    println(finder.measureArea(k));
    // draw a shape for each contour
    if(finder.measureArea(k)<0){
    beginShape();
    for (int i = 0; i < points.length; i++) {
      PVector p = points[i];
      vertex(p.x, p.y);
    }
    // close the shape
    endShape(CLOSE);
  }}
  
  
}

void keyPressed() {
  if (key == '-') {
    threshold-=5;
    if (threshold < 0) {
      threshold = 0;
    }
  }
  if (key == '=') {
    threshold+=5;
  }
}
