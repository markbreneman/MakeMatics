import dynamicprogramming.*;

SeamCarving carver;
ArrayList<PVector> seam;

PImage img, energyImage, scoreImage;
//////////////////////////////////////////////////// 
ArrayList<Pixel> pixelObjectArray;
Pixel pixel;

void setup() {
  img = loadImage("thecardplayers.jpg");
  size(img.width*2, img.height);  
  //  size(img.width*3, img.height); 
//  image(img, 0, 0);
  img.loadPixels();

  pixelObjectArray= new ArrayList<Pixel>();
  for (int i = 0; i<img.width; i++)
  {
    for (int j = 0; j < img.height; j++) {
      int loc = i + j*img.width;//GET THE PIXEL INDEX
      float redValue=red(img.pixels[loc]);
      float greenValue=green(img.pixels[loc]);
      float blueValue=blue(img.pixels[loc]);
      //  FROM THE CLASS Pixel(int _imageIndex, int _R, int _G, int _B) //
      pixel = new Pixel(loc, redValue, greenValue, blueValue);
      ///THIS ARRAY MAY NOT BE NEEDED
      pixelObjectArray.add(pixel);
    }
  } 
//  println("pixelObjectArray " + pixelObjectArray.size());
//  println("pixelObjectArray Red " + pixelObjectArray.get(0).R);///GET THE RED VALUE OF PIXEL OBJECT1
//  println("pixelObjectArray Green" + pixelObjectArray.get(0).G);///GET THE GREEN VALUE OF PIXEL OBJECT1
//  println("pixelObjectArray Blue" + pixelObjectArray.get(0).B);///GET THE BLUE VALUE OF PIXEL OBJECT1

  println("Image Width: " + img.width + " Image Height: " + img.height);

  carver = new SeamCarving(this, img);
  seam = carver.findMinSeam();

//  println("calculating energy image");
  energyImage = carver.getGradientImage();

//  println("calculating score image");
  scoreImage = carver.getScoreImage();

  //  image(scoreImage, img.width, 0);
}

boolean newSeam = false;

void draw() {
  
  //  // draw a white "background"
  //  // behind the final result (since it shrinks)
//  fill(255, 0, 0);
//  noStroke();
//  rect(energyImage.width*2, 0, energyImage.width, img.height);
  //
  //  //DRAW THE ENERGY IMAGE
  //  image(energyImage, 0, 0);
  //
  //  //DRAW THE FINAL IMAGE
//  image(img, 0, 0);
  //
  if (newSeam) {
     // draw a white "background"
     // behind the energy image (since it also shrinks)
    fill(255);
    noStroke();
//    rect(0, 0, energyImage.width, img.height);
//    translate(img.width,0);
    // REDRAW THE SCORE IMAGE
    image(scoreImage, 0, 0 );
  //
    // Draw the next seam to remove
    stroke(255, 0, 0);
    for (PVector p : seam) {
      point(p.x, p.y);
    }
    popMatrix();
    newSeam = false;
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
  //  newSeam = true;

  println("calculating score image");
  scoreImage = carver.getScoreImage();
  //  println(seam);
}

