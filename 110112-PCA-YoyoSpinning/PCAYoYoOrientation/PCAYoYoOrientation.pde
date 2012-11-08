import Jama.Matrix;
import pca_transform.*;
import hypermedia.video.*;

PCA pca;

PVector axis1;
PVector axis2;
PVector mean;

OpenCV opencv;

PImage img;

int imgWidth = 640/4;
int imgHeight = 480/4;
int brightnessK=30;
//int brightnessK=60;
int thresholdK=40;
int contrastK=120;

PVector centroid;

Paint paint;
float angle = 0;
ArrayList paintArray;
ArrayList vertexes;
boolean showArt;
PVector mousePos;

void setup() {
  size(640, 480);
  opencv = new OpenCV(this);
  opencv.capture(imgWidth, imgHeight);
  centroid = new PVector();  

  //Paint Details
  paintArray = new ArrayList();
  showArt = false;
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
  println("centroid x" + centroid.x);
  println("centroid y" + centroid.y);

  opencv.read();

  imageInGrid(opencv.image(), "CAMERA", 0, 0);

  opencv.convert(GRAY);
  imageInGrid(opencv.image(), "GRAY", 0, 1);

  opencv.absDiff();
  imageInGrid(opencv.image(), "DIFF", 0, 2);

  opencv.brightness(brightnessK);
  imageInGrid(opencv.image(), "BRIGHTNESS"+ brightnessK, 0, 3);

  opencv.threshold(thresholdK);
  imageInGrid(opencv.image(), "THRESHOLD"+ thresholdK, 1, 3);

  opencv.contrast(contrastK);
  imageInGrid(opencv.image(), "CONTRAST"+contrastK, 2, 3);

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

    image(opencv.image(), 0, opencv.image().height, opencv.image().width*3, opencv.image().height*3);
    stroke(200);
    pushMatrix();
    translate(0, imgHeight);
    scale(3, 3);
    translate(centroid.x, centroid.y);
    strokeWeight(1);
    stroke(0, 255, 0);
    line(0, 0, axis1.x, axis1.y);
    stroke(255, 0, 0);
    line(0, 0, axis2.x, axis2.y);
    popMatrix();

    ///____ADD A COORDINATE AREA_____///
    pushMatrix();
    PVector centerDisplay = new PVector(opencv.image().width*3/2, opencv.image().height*5/2);
    translate(centerDisplay.x,centerDisplay.y); 
    ellipse(0, 0, 10, 10);
    stroke(0, 0, 255);
    strokeWeight(6);
    PVector coordVector= new PVector(30, 30);
    line(-coordVector.x, 0, coordVector.x, 0);
    line(0, coordVector.y, 0, -coordVector.y);
    popMatrix();

    //___CALC ANGLES____//
    float a = degrees(PVector.angleBetween(coordVector, axis1));
    //    println(int(a));
    float b = degrees(PVector.angleBetween(coordVector, axis2));

    fill(255, 255, 255);
    text("PCA Object Axes:\nFirst two principle components centered at blob centroid", 10, height - 40);
    text("Axis 1 Green, Axis 2 Red", 10, height - 5);


    ///___________SPIN ART___________///////
    if (showArt==true) {
      smooth();
      stroke(255);
      //      frameRate(5);

      pushMatrix();
      translate(0, imgHeight);
      scale(3, 3);
      translate(centroid.x, centroid.y);
      scale(.3, .3);
      if (paintArray.size()>0) {
        for (int i=0; i<paintArray.size(); i++) {
          Paint P=(Paint) paintArray.get(i);
          P.update();
          P.display();
        }
      }

      rotate(radians(angle));
      rectMode(CENTER);
      rect(0, 0, 10, 10);
      popMatrix();
      
//      PVector Debug = new PVector( (centroid.x+(opencv.image().width*3)/2)*.3,(centroid.y+(opencv.image().height*5)/2)*.3);
//      println("debug X " + Debug.x);
//      println("debug Y " + Debug.y);
    }
  }
}


void mousePressed() {
      mousePos=new PVector( mouseX, mouseY);

//      println("mouse x " + mousePos.x);
//      println("mouse y " + mousePos.y);

  PVector origin = new PVector(centroid.x, centroid.y, 0); 
  PVector trueOrigin = new PVector(0, 0, 0); 

  float mouseDistance = abs(mousePos.dist(trueOrigin));
  println("Radius Distance" + mouseDistance);
  paintArray.add(
  new Paint(mouseDistance)
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

