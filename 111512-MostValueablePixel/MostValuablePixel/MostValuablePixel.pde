import dynamicprogramming.*;

SeamCarving carver;
ArrayList<PVector> seam;

PImage img, energyImage, scoreImage;

void setup() {
  img = loadImage("thecardplayers.jpg");
  
  size(img.width*3,img.height);
  
  println(img.width + " " + img.height);
  
    carver = new SeamCarving(this, img);
    seam = carver.findMinSeam();
    
    println("calculating energy image");
    energyImage = carver.getGradientImage();
    
    println("calculating score image");
    scoreImage = carver.getScoreImage();

   image(scoreImage,img.width,0);

}

boolean newSeam = false;

void draw() {
  // draw a white "background"
  // behind the final result (since it shrinks)
  fill(255,0,0);
  noStroke();
  rect(energyImage.width*2, 0, energyImage.width, img.height);
  
  //DRAW THE ENERGY IMAGE
  image(energyImage, 0, 0);
  
  //DRAW THE FINAL IMAGE
  image(img, energyImage.width*2, 0);

  if(newSeam){
    pushMatrix();
    translate(energyImage.width,0);
    
    // draw a white "background"
    // behind the energy image (since it also shrinks)
    fill(255);
    noStroke();
    rect(0, 0, energyImage.width, img.height);
    
    // REDRAW THE SCORE IMAGE
    image(scoreImage, 0,0 );
    
    // Draw the next seam to remove
    stroke(255,0,0);
    for(PVector p : seam){
      point(p.x, p.y);
    }
    popMatrix();
    newSeam = false;
  }
}

void keyPressed(){
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
