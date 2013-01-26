import isolines.*;
import channels.*;

Isolines finder;
PImage img;
int threshold = 200;

void setup() {
  // load the image and scale
  // the sketch to the image size
  img = loadImage("ConferenceRoomMapped01-edited.png");
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
  int[] pix = Channels.hue(img.pixels);
  // find the isolines in the hue pixels
  finder.find(pix);

  // draw the contours
  stroke(4);
  
  for (int k = 0; k < finder.getNumContours(); k++) {
//    finder.drawContour(k);
    if(finder.measureArea(k)>300){
    PVector[] points=finder.getContourPoints(k);

    
    int yCenter=(int)finder.getBBCenterY(k);
    int xCenter=(int)finder.getBBCenterX(k);

    
    text("red",xCenter,yCenter);
    
    fill(255-k*10,255-k*10,255-k*10);
    beginShape();
    for(int l=0; l<points.length; l++){
    PVector p =points[l];
    vertex(p.x,p.y);
    }
    endShape(CLOSE);
    }
  }
  
  text("threshold: " + threshold, width-150, 20);
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
