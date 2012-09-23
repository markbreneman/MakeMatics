import isolines.*;
import channels.*;
import processing.pdf.*;


Isolines finder;
PImage img;
int threshold = 120;

boolean exporting = false;
int layerResolution = 5;

int contourR;
int contourG;
int contourB;

int noPixels;


void setup() {
  // load the image and scale
  // the sketch to the image size
  img = loadImage("IMG_0023-900.png");
  size(img.width, img.height);

  // initialize an isolines finder based on img dimensions
  finder = new Isolines(this, img.width, img.height);
}

void draw() {
  ////BASIC SETUP FOR ISOLINES/////

  image(img, 0, 0);
  // update the threshold
  finder.setThreshold(threshold);
  // Use the Channels library to extract
  // the hue channel as an int array
  int[] pix = Channels.brightness(img.pixels);
  // find the isolines in the hue pixels
  finder.find(pix);

  ////IF PRINTING/////
  if (exporting) {
    // start a new pdf file named after
    // the current threshold
    beginRecord(PDF, "layer_"+threshold+".pdf");
    println("exporting layer at: " + threshold);
  }

  ///EYE SPECIFIC///
//  fill(255, 0, 0);
  loadPixels();
  int noContours=0;

  for (int k = 0; k < finder.getNumContours(); k++) {
    //      println("There are " + finder.getNumContours());
    //      println("Contour "+ k +"has an area of "+finder.measureArea(k));

    // get each contour as an array of PVectors
    // so we can work with the individual points
    if (abs((float)finder.measureArea(k)) > 300 && finder.contains(k, width/2, height/2)) {
      int contourID=k;
//      println(contourID);
//      finder.getBBMinX(contourID);
//      finder.getBBMinY(contourID);
//      finder.getBBMaxX(contourID);
//      finder.getBBMaxY(contourID);
      
      
      PVector[] points = finder.getContourPoints(contourID);
      noContours++; //this is the number of contours which meet criteria actually drawn to the screen.

      for (int i =  (int)finder.getBBMinX(contourID); i < (int)finder.getBBMaxX(contourID); i++ ) {
        for (int j = (int)finder.getBBMinY(contourID); j < (int)finder.getBBMaxY(contourID); j++ ) {  
          if (finder.contains(contourID, i, j)) {
            noPixels++;            
            int loc = i + j*img.width;

            float r = red(img.pixels[loc]);
            float g = green(img.pixels[loc]);
            float b = blue(img.pixels[loc]);

            contourR +=r;
            contourG +=g;
            contourB +=b;
          }
        }
      }
      
      fill(contourR/noPixels,contourG/noPixels,contourB/noPixels);
      

      println("this is contour " + contourID + " and there are " + noContours + " contours displayed");

      //Start drawing the Contour
      beginShape();
      for (int l = 0; l < points.length; l++) {
        PVector p = points[l];
        vertex(p.x, p.y);
      }
      // close the shape
      endShape(CLOSE);
    }
  }


  if (exporting) {
    // stop drawing to the PDF file
    endRecord();
    // if we're under  255, we still
    // have more layers to go,
    // so increase the threshold and go again
    // otherwise stop exporting
    if (threshold < 255) {
      threshold += layerResolution;
    } 
    else {
      exporting = false;
      println("exporting complete");
    }
  }
  text("threshold: " + threshold, width-150, 20); 
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
  if (key == ' ') {
    println("exporting layers");
    threshold = 0;
    exporting = true;
  }
}

