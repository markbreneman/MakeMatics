import dynamicprogramming.*;

SeamCarving carver;
ArrayList<PVector> seam;

PImage img, energyImage, scoreImage;
//////////////////////////////////////////////////// 
ArrayList<Pixel> pixelObjectArray;
ArrayList<Pixel> pixelObjectArrayOrig;
Pixel pixel;
Pixel pixelOriginal;
int startingWidth;
int startingHeight;

ArrayList seamIndexes; 
boolean seamFO = false;

void setup() {
  img = loadImage("thecardplayers.jpg");
  size(img.width*2, img.height);  
  img.loadPixels();

  pixelObjectArray= new ArrayList<Pixel>();
  pixelObjectArrayOrig= new ArrayList<Pixel>();
   for (int i = 0; i<img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        int index = i + j*img.width;//GET THE PIXEL INDEX and THEN UPDATE THE PIXELObjects
      float redValue=red(img.pixels[index]);
      float greenValue=green(img.pixels[index]);
      float blueValue=blue(img.pixels[index]);
      ///_________________________________CREATE PIXEL OBJECT_________________________________///
      //  FROM THE CLASS Pixel(int _imageIndex, int _R, int _G, int _B) //
      PVector startPos= new PVector(i, j);
      pixel = new Pixel(startPos, index, redValue, greenValue, blueValue);
      pixelOriginal = new Pixel(startPos, index, redValue, greenValue, blueValue);
      ///_________________________________ADD THE PIXEL OBJECT TO THIS ARRAY: MAY NOT BE NEEDED_________________________________///
      pixelObjectArray.add(pixel);
      pixelObjectArrayOrig.add(pixelOriginal);
    }
  } 
  println(pixelObjectArray.size());
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
boolean fired = false;


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
      for (int j=0; j<pixelObjectArrayOrig.size(); j++) {
        Pixel pix = pixelObjectArrayOrig.get(j);
        if (pix.currentLocation.x==p.x && pix.currentLocation.y==p.y) {
          seamImageIndex.add(pix);
          //          println(j);//Should Print 313 numbers and does!
        }
      }
      for (int k=0; k<pixelObjectArray.size(); k++) {
        Pixel pix = pixelObjectArray.get(k);
        if (pix.currentLocation.x==p.x && pix.currentLocation.y==p.y) {
          pixelObjectArray.remove(k);
        }
      }
    }
    popMatrix();
    newSeam = false;
    fired = false;
    
    ///_________________________________ADD THE SEAM INDEX ARRAY TO THE OVERALL SEAM ARRAY_________________________________///
    seamIndexes.add(seamImageIndex);
    //////________________UPDATE THE PIXEL OBJECTS ARRAY LIST TO REFLECT OBJECT REMOVED_______________________//////
    if(fired==false){
    ArrayList<Integer> updatingIndexes=new ArrayList();
    ArrayList<PVector> updatingLocations=new ArrayList();
    for (int i = 0; i<img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        //CREATE THE PIXEL'S new temp INDEX and add it to the updating Indexes Array
        int updatedIndex = i + j*img.width;
        PVector updatedLocations = new PVector(i,j);
        updatingIndexes.add(updatedIndex);
        updatingLocations.add(updatedLocations);
        }
      }
    //update the pixel Objects  
    for(int k=0; k<pixelObjectArray.size(); k++){  
          Pixel pixeltoUpdate = pixelObjectArray.get(k);
          pixeltoUpdate.update(updatingLocations.get(k),updatingIndexes.get(k));
          
    }
  println("updating indexes Size" + updatingIndexes.size());
  println("updating Locations Size " + updatingLocations.size());
  println("updated pixelObjectArray " + pixelObjectArray.size());
  }}
  ///STROKE THE NORMAL IMAGE WITH THE SEAM
  stroke(0, 0, 255);
  for (PVector p : seam) {
    point(p.x, p.y);
  }

  if (seamFO==true) {
    for ( int i=0; i<seamIndexes.size(); i++) { 
      ArrayList<Pixel> tmpSeam =(ArrayList)seamIndexes.get(i); //GET THE SEAM FROM THE ARRRAY OF SEAMS
      for (int j=0; j<tmpSeam.size(); j++) {
        PVector pixLoc = tmpSeam.get(j).startLocation;
        stroke(255, 0, 0);
        point(pixLoc.x, pixLoc.y);
      }
    }
  }
}
void keyPressed() {

  if (key == 'n' && img.width>3 && fired==false) {
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
    fired = true;

    //    println("calculating score image");
    scoreImage = carver.getScoreImage();
    //  println(seam);
  }

  if (key == 's') {
    seamFO=true;
  }
  
  if (key == 'h') {
    seamFO = false;
  }
  
   
  if (key == 'i') {
    println("number of seams = " + seamIndexes.size());
    println("number of pixelObjects = " + pixelObjectArray.size());
    println("number of pixelObjects Orig = " + pixelObjectArrayOrig.size());
  }
}

