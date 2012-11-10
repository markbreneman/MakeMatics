import Jama.Matrix;
import pca_transform.*;
import hypermedia.video.*;

PCA pca;

PVector axis1;
PVector axis2;
PVector mean;

OpenCV opencv;
PImage img;
//int imgWidth = 640/4;
//int imgHeight = 480/4;
int windowWidth = 640;
int windowHeight = 480;
int debugWindowWidth = 640;
int debugWindowHeight = 480;

int imgWidth = 640/4;
int imgHeight = 480/3;

/////640/480=1.33333333
float aspectRatio=1.33333333;

int brightnessK=30;
int thresholdK=40;
int contrastK=120;
PVector centroid;
float scaleX;
float scaleY;

///____PAINT VARIABLES______///
Paint paint;
float angle = 0;
ArrayList paintArray;
ArrayList vertexes;
boolean showArt;
PVector mousePos;
int axis1Angle;
int oldaxis1Angle;
int axis2Angle;
int oldaxis2Angle;

///____SECOND WINDOW______///
secondApplet debugScreen;
PFrame Frame1;


void setup() {
  size(windowWidth, windowHeight);
  opencv = new OpenCV(this);
  opencv.capture(imgWidth, imgHeight);
  centroid = new PVector();  

  //Paint Details
  paintArray = new ArrayList();
  showArt = false;

  //Second Window
  Frame1 = new PFrame();
  debugScreen.size(debugWindowWidth, debugWindowHeight);
  debugScreen.background(80);
}

Matrix toMatrix(PImage img) {
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      int i = y*img.width + x;
      if (brightness(img.pixels[i]) > 0) {
        points.add(new PVector(x, y));
      }
    }
  }

  Matrix result = new Matrix(points.size(), 2);

  float centerX = 0;
  float centerY = 0;

  for (int i = 0; i < points.size(); i++) {
    result.set(i, 0, points.get(i).x);
    result.set(i, 1, points.get(i).y);

    centerX += points.get(i).x;
    centerY += points.get(i).y;
  }
  centerX /= points.size();
  centerY /= points.size();
  centroid.x = centerX;
  centroid.y = centerY;
  return result;
}

void imageInGrid(PImage img, String message, int row, int col) {
  int currX = col*img.width;
  int currY = row*img.height;
  image(img, currX, currY);
  fill(255, 0, 0);
  text(message, currX + 5, currY + imgHeight - 5);
}

void draw() {
  background(125);

  opencv.read();
  //  opencv.flip( OpenCV.FLIP_BOTH );

  debugScreen.image(opencv.image(), (debugWindowWidth-(imgHeight*aspectRatio))/2, 0, imgHeight*aspectRatio, imgHeight);
  debugScreen.text("CAMERA INPUT", (debugWindowWidth-(imgHeight*aspectRatio))/2+10, imgHeight-10);

  opencv.convert(GRAY);
  debugScreen.imageInGrid(opencv.image(), "GRAY", 1, 0);

  opencv.absDiff();
  debugScreen.imageInGrid(opencv.image(), "DIFF", 1, 1);

  opencv.brightness(brightnessK);
  debugScreen.imageInGrid(opencv.image(), "BRIGHTNESS "+ brightnessK, 1, 2);

  opencv.threshold(thresholdK);
  debugScreen.imageInGrid(opencv.image(), "THRESHOLD "+ thresholdK, 1, 3);

  opencv.contrast(contrastK);
  debugScreen.image(opencv.image(), (debugWindowWidth-(imgHeight*aspectRatio))/2, debugWindowHeight-imgHeight, imgHeight*aspectRatio, imgHeight);
  debugScreen.text("CONTRAST", (debugWindowWidth-(imgHeight*aspectRatio))/2+10, debugWindowHeight-10);

  Matrix m = toMatrix(opencv.image());


  if (m.getRowDimension() > 0) {
    pca = new PCA(m);
    Matrix eigenVectors = pca.getEigenvectorsMatrix();

    axis1 = new PVector();
    axis2 = new PVector();
    if (eigenVectors.getColumnDimension() > 1) {

      axis1.x = (float)eigenVectors.get(0, 0);
      axis1.y = (float)eigenVectors.get(1, 0);

      axis2.x = (float)eigenVectors.get(0, 1);
      axis2.y = (float)eigenVectors.get(1, 1);  

      axis1.mult((float)pca.getEigenvalue(0));
      axis2.mult((float)pca.getEigenvalue(1));
    }


    //DRAW THE LARGER FINAL TRACKED IMAGE
    image(opencv.image(), 0, 0, width, height);
    scaleX=width/opencv.image().width;
    scaleY=height/opencv.image().height;
    //DRAW THE AXIS OF ORIENTATION 
    stroke(200);
    pushMatrix();
    scale(scaleX, scaleY);
    translate(centroid.x, centroid.y);
    strokeWeight(1);
    stroke(0, 255, 0);
    line(0, 0, axis1.x, axis1.y);
    stroke(255, 0, 0);
    line(0, 0, axis2.x, axis2.y);
    popMatrix();

    ///____ADD A COORDINATE AREA_____///
    pushMatrix();
    PVector centerDisplay = new PVector(width/2, height/2);
    translate(centerDisplay.x, centerDisplay.y); 
    ellipse(0, 0, 10, 10);
    stroke(0, 0, 255);
    strokeWeight(2);
    PVector coordVector= new PVector(0, 30);
    ellipse(coordVector.x, coordVector.y, 10, 10);
    line(-coordVector.y, 0, coordVector.y, 0);
    line(0, coordVector.y, 0, -coordVector.y);
    popMatrix();

    //___CALC ANGLES____//
    axis1Angle = int(90+degrees(PVector.angleBetween(coordVector, axis1)));
    axis2Angle = int(90+degrees(PVector.angleBetween(coordVector, axis2)));

    //    if(centroid.x*scaleX<width/2){
    //      a=a+180;
    //    }
    fill(255, 0, 0);
    text("PCA Object Axes:\nFirst two principle components centered at blob centroid", 10, height - 60);
    text("Axis 1 is Green and at an Angle of: "+axis1Angle+ "\nand Axis 2 is Red and at an Angle of: "+ axis2Angle, 10, height - 20);
  }

  if (frameCount%3==0) {
    oldaxis1Angle=axis1Angle;
    oldaxis2Angle=axis2Angle;
  }

  if (oldaxis1Angle != axis1Angle) {
    int deltaAngle =abs(oldaxis1Angle-axis1Angle);
  }


  ///___________SPIN ART___________///////
  if (showArt==true) {
//    fill(90, 90, 90, 230);
    fill(255);
    rect(0, 0, width*2, height*2);
    smooth();
    stroke(255);
    if (paintArray.size()>0) {
      for (int i=0; i<paintArray.size(); i++) {
        Paint P=(Paint) paintArray.get(i);
         P.update();
        P.display();
      }
    }
  }
  rotate(radians(angle));
}


void mousePressed() {
  mousePos=new PVector( mouseX, mouseY);

  PVector origintoCentroid = new PVector(centroid.x*scaleX, centroid.y*scaleY); 
  PVector origin = new PVector(0, 0, 0); 

  float mouseDistance = abs(mousePos.dist(origintoCentroid));
  //  //  println("Radius Distance: " + mouseDistance);

  paintArray.add(
  new Paint(mouseDistance, origintoCentroid, axis1Angle, oldaxis1Angle)
    );
}

void keyPressed() {
  int keyIncrement=3;
  if (key == 's') {
    opencv.remember();
  }
  if (key == '1') {
    brightnessK-=keyIncrement;
  }
  if (key == '2') {
    brightnessK+=keyIncrement;
  }
  if (key == '3') {
    thresholdK-=keyIncrement;
  }
  if (key == '4') {
    thresholdK+=keyIncrement;
  }
  if (key == '5') {
    contrastK-=keyIncrement;
  }
  if (key == '6') {
    contrastK+=keyIncrement;
  }

  if (key == 'p') {
    showArt=!showArt;
  }

  if (key == 'a') {
    angle+=keyIncrement;
    println(angle);
  }
}


///____SECOND WINDOW____////
public class PFrame extends Frame {
  public PFrame() {
    setBounds(100, 100, debugWindowWidth, debugWindowHeight+20);
    debugScreen = new secondApplet();
    add(debugScreen);
    debugScreen.init();
    show();
  }
}

public class secondApplet extends PApplet {
  public void setup() {
    size(debugWindowWidth, debugWindowHeight);
  }
  public void draw() {
    smooth();
  }

  public void imageInGrid(PImage img, String message, int row, int col) {
    int currX = col*img.width;
    int currY = row*img.height;
    image(img, currX, currY);
    fill(255, 0, 0);
    text(message, currX + 5, currY + imgHeight - 5);
  }
}

