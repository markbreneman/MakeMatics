import dynamicprogramming.*;

SeamCarving carver;
ArrayList<PVector> seam;

PImage img, energyImage, scoreImage;
////////////////////////////////////////////////////
ArrayList<Pixel> pixelObjectArray;
ArrayList pixelObjectsByRow; 
Pixel pixel;
Pixel pixelOriginal;
int startingWidth;
int startingHeight;

ArrayList seamsOrig;
ArrayList seams;
boolean seamShow = false;
boolean automate = false;
PrintWriter output;

void setup() {
  output = createWriter("data/data.txt");  
//  img = loadImage("thecardplayers.jpg");
    img = loadImage("thecardplayers200_125.jpg");
//  img = loadImage("thecardplayers70_60.jpg");
  size(img.width*2, img.height);  
  img.loadPixels();


  pixelObjectArray= new ArrayList<Pixel>();

  for (int i = 0; i<img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      int index = i + j*img.width;//GET THE PIXEL INDEX and THEN UPDATE THE PIXELObjects
      float redValue=red(img.pixels[index]);
      float greenValue=green(img.pixels[index]);
      float blueValue=blue(img.pixels[index]);
      ///_________________________________CREATE PIXEL OBJECT_________________________________///
      //  FROM THE CLASS Pixel(int _imageIndex, int _R, int _G, int _B) //
      PVector startPos= new PVector(j, i);
      pixel = new Pixel(startPos, index, redValue, greenValue, blueValue);
      ///_________________________________ADD THE PIXEL OBJECT TO THIS ARRAY: MAY NOT BE NEEDED_________________________________///
      pixelObjectArray.add(pixel);
    }
  } 
  /////_______BREAK PIXEL OBJECT UP INTO ARRAY___________/////////// 
  ArrayList Row = new ArrayList();
  pixelObjectsByRow = new ArrayList();
  int j=1;
  for (int i=0; i<img.height*img.width; i+=img.width) {  
    Row = new ArrayList((List)pixelObjectArray.subList(i, j*img.width));
    pixelObjectsByRow.add(Row);
    j++;
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
  seams = new ArrayList();
  seamsOrig=new ArrayList();
}

boolean newSeam = false;
boolean fired = false;


void draw() {

  //  //DRAW THE ENERGY IMAGE
  //  image(energyImage, 0, 0);

  // draw a black rectangle "background"
  // behind the image (since it shrinks
  fill(0, 0, 0);
  noStroke();
  rect(0, 0, width/2, height);

  //DRAW THE FINAL IMAGE
  image(img, 0, 0);
  int testing=0;

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
    ArrayList seamCol = new ArrayList();
    ArrayList seamColOrig = new ArrayList();
    for (PVector p : seam) {
      point(p.x, p.y);
      ///_________________________________RELATIVE TO ORIGINAL________________________________///
      ///_________________________________GET THE INDEX VALUE OF THE SEAM LOCATION AND STORE IT TO AN SEAM INDEX ARRAY_________________________________///
      for (int j=0; j<pixelObjectArray.size(); j++) {
        Pixel tmpPixel = pixelObjectArray.get(j);
        if (tmpPixel.currentLocation.x==p.x && tmpPixel.currentLocation.y==p.y) {
          seamColOrig.add(tmpPixel);
          tmpPixel.seamIndex=seamColOrig.size();
//          output.println(pix.startLocation.x +","+pix.startLocation.y +","+ pix.currentLocation.x +","+ pix.currentLocation.y +","+ seamCol.size() +","+ pix.imageIndex +","+ pix.R +","+ pix.G +","+ pix.B);
        }
      }
      ///_________________________________RELATIVE TO CURRENT___________________________________________________///
      ///_________________________________GET THE INDEX VALUE OF THE SEAM LOCATION AND STORE IT TO AN SEAM INDEX ARRAY_________________________________//

      for (int k=0; k<pixelObjectsByRow.size();k++) {
        for (int l=0; l<img.width;l++) {  
          ArrayList tmpRow = (ArrayList)pixelObjectsByRow.get(k);///GET THE ROW 
          Pixel tmpPixel=((Pixel)((ArrayList)pixelObjectsByRow.get(k)).get(l));//GET THE IND. PIXEL  
          ///SHIFT PIXELS LOCATIONS
          if(tmpPixel.currentLocation.x>p.x && tmpPixel.currentLocation.y==p.y){
//          tmpPixel.currentLocation.x=tmpPixel.currentLocation.x-1;
          }
          
          ///REMOVE THE PIXEL AT THE SEAM
          if (tmpPixel.currentLocation.x==p.x && tmpPixel.currentLocation.y==p.y) {
              tmpPixel.seamIndex=seamCol.size();
              seamCol.add(tmpPixel);
            //((ArrayList)pixelObjectsByRow.get(k)).remove(((Pixel)((ArrayList)pixelObjectsByRow.get(k)).get(l)));
//            tmpRow.remove(tmpPixel);
          }
        }//end row for
      }//end array for
    }
    popMatrix();
    newSeam = false;
    fired = false;

///_________________________________ADD THE SEAMS ARRAYLISTS TO THEIR RESPECTIVE ARRAYS________________________________///
    seamsOrig.add(seamColOrig);
    seams.add(seamCol);
  }///END FOR LOOP FOR SEAMS FROM CARVER
  
///______________________AUTOMATE__________________////
if (automate==true) {
 newSeam(); 
}
if (img.width==1) {
 automate=false;
}  
  
  
///_________________________________DRAWING SEAMS_______________________________///  
  ///STROKE THE NORMAL IMAGE WITH THE SEAM
  stroke(0, 0, 255);
  for (PVector p : seam) {
    point(p.x, p.y);
  }

  if (seamShow==true) {
    for ( int i=0; i<seamsOrig.size(); i++) { 
      ArrayList<Pixel> tmpSeam =(ArrayList)seamsOrig.get(i); //GET THE SEAM FROM THE ARRRAY OF SEAMS
      for (int j=0; j<tmpSeam.size(); j++) {
        PVector pixLoc = tmpSeam.get(j).currentLocation;
        stroke(255, 0, 0);
        point(pixLoc.x, pixLoc.y);
      }
    }
  }
  
  
  
}
void keyPressed() {

  if (key == 'n' && img.width>1 && fired==false) {
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
  }

  if (key == 's') {
    seamShow=true;
  }

  if (key == 'h') {
    seamShow = false;
  }
  
  if (key == 'a') {
    automate = true;
  }


  if (key == 'i') {
    println("number of seams = " + seams.size());
    println("number of pixelObjects = " + pixelObjectArray.size());

  }
    
if (key =='q') {
      output.flush();  // Writes the remaining data to the file
      output.close();  // Finishes the file
      exit();  // Stops the program
    }
  }

  void newSeam() {
    if (img.width>1 && fired==false) {
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
    }
  }

