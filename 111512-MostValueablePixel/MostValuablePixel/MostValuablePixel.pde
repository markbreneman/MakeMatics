import dynamicprogramming.*;

SeamCarving carver;
ArrayList<PVector> seam;

PImage img, energyImage, scoreImage;
//////////////////////////////////////////////////// 
ArrayList<Pixel> pixelObjectArray;
Pixel pixel;
int startingWidth;
int startingHeight;
ArrayList seamIndexes; 
boolean seamFO = false;

void setup() {
  img = loadImage("thecardplayers.jpg");
  size(img.width*2, img.height);  
  img.loadPixels();

  pixelObjectArray= new ArrayList<Pixel>();
  for (int i = 0; i<img.width; i++)
  {
    for (int j = 0; j < img.height; j++) {
      int loc = i + j*img.width;//GET THE PIXEL INDEX
      float redValue=red(img.pixels[loc]);
      float greenValue=green(img.pixels[loc]);
      float blueValue=blue(img.pixels[loc]);
      ///_________________________________CREATE PIXEL OBJECT_________________________________///
      //  FROM THE CLASS Pixel(int _imageIndex, int _R, int _G, int _B) //
      pixel = new Pixel(loc, redValue, greenValue, blueValue, i, j);
      ///_________________________________ADD THE PIXEL OBJECT TO THIS ARRAY: MAY NOT BE NEEDED_________________________________///
      pixelObjectArray.add(pixel);
    }
  } 
  println("Image Width: " + img.width + " Image Height: " + img.height);
  startingWidth=img.width;
  startingHeight=img.height;

  carver = new SeamCarving(this, img);
  seam = carver.findMinSeam();

  //  println("calculating energy image");
  energyImage = carver.getGradientImage();

  //  println("calculating score image");
  scoreImage = carver.getScoreImage();
  image(scoreImage, startingWidth, 0);
  ///_________________________________CREATE AN ARRAY LIST TO HOLD SEAM INDEXES_________________________________///
  seamIndexes = new ArrayList();
}

boolean newSeam = false;


void draw() {

  //DRAW THE ENERGY IMAGE
  //  image(energyImage, 0, 0);

  // draw a black rectangle "background"
  // behind the image (since it shrinks
  fill(0, 0, 0);
  noStroke();
  rect(0, 0, width/2, height);

  //DRAW THE FINAL IMAGE
  image(img, 0, 0);
  //
  if (newSeam) {
    pushMatrix();
    translate(startingWidth, 0);
    // draw a black rectangle "background"
    // behind the image (since it shrinks
    rect(0, 0, width/2, height);
    // REDRAW THE SCORE IMAGE
    image(scoreImage, 0, 0 );

    // Draw the next seam to remove
    stroke(0, 0, 255);
    ArrayList seamImageIndex = new ArrayList();
    for (PVector p : seam) {
      point(p.x, p.y);
      ///_________________________________GET THE INDEX VALUE OF THE SEAM LOCATION AND STORE IT TO AN SEAM INDEX ARRAY_________________________________///
      //      int originalIndex =int(p.x+p.y*startingWidth);
      //      println(originalIndex);
      //      int indexAtSeam= pixelObjectArray.get(originalIndex).imageIndex;
      for (int j=0; j<pixelObjectArray.size(); j++) {
        Pixel pix = pixelObjectArray.get(j);
        if (pix.startX==p.x && pix.startY==p.y) {
          seamImageIndex.add(pix.imageIndex);
//          println("pixel " + pix.startX+" "+ pix.startY);
//          println("pixel image Index " + pix.imageIndex);
        }
      }
    }
    popMatrix();
    newSeam = false;
    ///_________________________________ADD THE SEAM INDEX ARRAY TO THE OVERALL SEAM ARRAY_________________________________///
    seamIndexes.add(seamImageIndex);
//    println("number of seams = " + seamIndexes.size());
  }
  ///STROKE THE NORMAL IMAGE WITH THE SEAM
  stroke(0, 0, 255);
  for (PVector p : seam) {
    point(p.x, p.y);
  }

  if (seamFO==true) {
    for ( int i=0; i<seamIndexes.size(); i++) {
      println("Seam "+i); 
      ArrayList<Integer> tmpSeam =(ArrayList)seamIndexes.get(i);
      //        println(tmpSeam.get(i));
      for (int j=0; j<tmpSeam.size(); j++) {
        int tmpIndexSeam = tmpSeam.get(j); /// This prints out the index of the PixelObject
        for(int k=0; k<pixelObjectArray.size(); k++){
         Pixel sample = pixelObjectArray.get(k);
        stroke(255, 0, 0);
        strokeWeight(2);
//         beginShape();
         if (sample.imageIndex == tmpIndexSeam){
//         ellipse(sample.startX,sample.startY,10,10);
          point(sample.startX,sample.startY);
         }      
//         endShape();
        }
      }
    }
//      seamFO = false;
  }
}
void keyPressed() {

  if (key == 'n') {
    //Load all the pixels in the Image Array
    img.loadPixels();
    //Pass the Image to the Carver to remove the column
    img = carver.removeColumn();
    //Update the Pixels Array
    img.updatePixels();

    //Pass the updated image pixels array back to the carver
    carver.setImage(img);
    //Get the Seam for the next one to be removed.
    seam = carver.findMinSeam();
    newSeam = true;

//    println("calculating score image");
    scoreImage = carver.getScoreImage();
    //  println(seam);
  }

  if (key == 's') {
    seamFO=true;
  }
}

