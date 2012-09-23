import isolines.*;
import channels.*;
import processing.pdf.*;


Isolines finder;
PImage img;
int threshold = 120;

boolean exporting = false;
int layerResolution = 5;


void setup() {
  // load the image and scale
  // the sketch to the image size
  img = loadImage("IMG_0023-900.png");
  size(img.width, img.height);

  // initialize an isolines finder based on img dimensions
  finder = new Isolines(this, img.width, img.height);
}

void draw() {
  image(img, 0, 0);
  // update the threshold
  finder.setThreshold(threshold);
  // Use the Channels library to extract
  // the hue channel as an int array
  int[] pix = Channels.brightness(img.pixels);
  // find the isolines in the hue pixels
  finder.find(pix);
  
  if (exporting) {
    // start a new pdf file named after
    // the current threshold
    beginRecord(PDF, "layer_"+threshold+".pdf");
    println("exporting layer at: " + threshold);
  }

  // draw the contours  
  //my start
  fill(255, 0, 0);
  loadPixels();
  
  int noContours=0;

  for (int k = 0; k < finder.getNumContours(); k++) {
    // get each contour as an array of PVectors
    // so we can work with the individual points
    PVector[] points = finder.getContourPoints(k);

    // draw a shape for each contour

    //I want don't want the contours to overlap which is why i used the K<0
    //I also want the the contours to be tied to the center using the contains

    if (abs((float)finder.measureArea(k)) > 300 && finder.contains(k, width/2, height/2)) {
//      println("There are " + finder.getNumContours());
      //      println("Contour "+ k +"has an area of "+finder.measureArea(k));
      noContours++;
      println("this is contour " + k + " and there are " + noContours + " contours displayed");
      beginShape();
      for (int i = 0; i < points.length; i++) {
        PVector p = points[i];
        vertex(p.x, p.y);
      }
      // close the shape
      endShape(CLOSE);
    }

  }
  
   if(exporting){
    // stop drawing to the PDF file
    endRecord();
    // if we're under  255, we still
    // have more layers to go,
    // so increase the threshold and go again
    // otherwise stop exporting
    if(threshold < 255){
      threshold += layerResolution;
    } else {
      exporting = false;
      println("exporting complete");
    }
  }

  text("threshold: " + threshold, width-150, 20); 

  // Loop through every pixel row and check to see if it is contained in the coutours
  // if it is set in the contour add it to the average and set fill based off that.

//  for (int i = 0; i < width; i++ ) {
//    for (int j = 0; j < height; j++ ) {  
//      for (int k=0; k< finder.getNumContours(); k++) {
//        if (abs((float)finder.measureArea(k)) > 300 && finder.contains(k, width/2, height/2) && finder.contains(k, i, j)) {   
//          location_count++;
//          int loc = i + j*img.width;
//
//          float r = red(img.pixels[loc]);
//          float g = green(img.pixels[loc]);
//          float b = blue(img.pixels[loc]);
//        }
//      }
//    }
//  }


}

void keyPressed() {
  if (key == '-') {
    threshold-=1;
    if (threshold < 0) {
      threshold = 0;
    }
  }
  if (key == '=') {
    threshold+=1;
  }
    if(key == ' '){
    println("exporting layers");
    threshold = 0;
    exporting = true;
  }
}

