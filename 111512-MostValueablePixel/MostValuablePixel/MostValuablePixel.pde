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
      pixel = new Pixel(loc, redValue, greenValue, blueValue,i,j);
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
  fill(0,0,0);
  noStroke();
  rect(0, 0, width/2,height);
  
  //DRAW THE FINAL IMAGE
  image(img, 0, 0);
  //
  if (newSeam) {
    pushMatrix();
    translate(startingWidth,0);
     // draw a black rectangle "background"
     // behind the image (since it shrinks
     rect(0, 0, width/2,height);
    // REDRAW THE SCORE IMAGE
    image(scoreImage, 0, 0 );
  //
    // Draw the next seam to remove
    stroke(255, 0, 0);
    ArrayList seamImageIndex = new ArrayList();
    for (PVector p : seam) {
      point(p.x, p.y);
///_________________________________GET THE INDEX VALUE OF THE SEAM LOCATION AND STORE IT TO AN SEAM INDEX ARRAY_________________________________///
      int originalIndex =int(p.x+p.y*startingWidth);
      seamImageIndex.add(pixelObjectArray.get(originalIndex).imageIndex);
    }
    popMatrix();
    newSeam = false;
///_________________________________ADD THE SEAM INDEX ARRAY TO THE OVERALL SEAM ARRAY_________________________________///
    seamIndexes.add(seamImageIndex);
    println(seamIndexes.size());
  }
  ///STROKE THE NORMAL IMAGE WITH THE SEAM
  stroke(255, 0, 0);
    for (PVector p : seam) {
      point(p.x, p.y);
    }
}

void keyPressed() {
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

  println("calculating score image");
  scoreImage = carver.getScoreImage();
  //  println(seam);
}

