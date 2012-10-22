import psvm.*;
import processing.video.*;
Histogram histogram;
boolean Switch=false;
// Capture object for accessing video feed
Capture video;
// size of the box we'll be looking in for hand gestures
int rectW = 150;
int rectH = 150;
double testResult;
int numBins =25;
int count = 0;
String message = "";

SVM model;
PImage testImage;

void setup() {
  
  size(640, 480); 
  // capture video at half size for speed
  video = new Capture(this, 640, 480);
  video.start();   
  // declare our SVM object
  model = new SVM(this);
//  model.loadModel("SpicerIndexer3model.txt",5);
model.loadModel("SpicerIndexer3model.txt",5);
  // initialize our PImage at 50x50
  // we'll use this to display the part
  // of the video feed we're searching
  testImage = createImage(200, 200, RGB);
  
}

// video event, necessary for getting live camera
void captureEvent(Capture c) {
  c.read();
}

void draw() {
  background(0);



  // display the video, the test image, and the red box
  image(video, 0, 0);
  image(testImage, width - testImage.width, 0);
  noFill();
  stroke(255, 0, 0);
  strokeWeight(5);
  rect(video.width - rectW - (video.width - rectW)/2, video.height - rectH - (video.height - rectH)/2, rectW, rectH);
  
  
//  print(testResult);
  if((int)testResult == 1){
    message = "Cardamom";
  } 
  else if((int)testResult == 2){
    message = "ChiliPowder";
  }
  else if((int)testResult == 3){
    message = "Nutmeg ";
  }
  else if((int)testResult == 4){
    message = "ThymeLeaves";
  }
  else if((int)testResult == 5){
    message = "Turmeric";
  }
  fill(255);
  text(message, 10, 25);
}

float[] buildVector(PImage img) {
  
  histogram.setImage(img);
  histogram.calculateHistogram();
  histogram.scale(0, 0.33);
  return histogram.getHSV();
}

void keyPressed() {
  if(key == 's'){
  testImage.copy(video, video.width - rectW - (video.width - rectW)/2, video.height - rectH - (video.height - rectH)/2, rectW, rectH, 0, 0, 300, 300);
//  testImage.updatePixels();
  testImage.save("Sample"+count+".jpg");
  count++;
  histogram  = new Histogram();
  histogram.setNumBins(numBins);  
  PImage sampledImage = loadImage("Sample"+(count-1)+".jpg"); 
  testResult = model.test(buildVector(sampledImage));
  }
}
