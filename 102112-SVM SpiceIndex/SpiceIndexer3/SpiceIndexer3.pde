/*

This sketch uses image color and Support Vector Machines
to distinguish pictures of clovess from pictures of chilis.
It calculates a color histogram for each picture and uses
that as the feature vector for training an SVM.

The SVM is trained using the images in the folders named
"clovess" and "chilis" and then tested on the images
in the folder named "test" to establish a success percentage.

The test images are then displayed with their histograms
and their classification result.

*/

import psvm.*;

SVM model;

// declare Histogram object
Histogram histogram;
// "bin" the histogram into 32 separate
// color groups
int numBins =25;

PImage testImage;
double testResult;

int[] labels;
float[][] trainingData;
String[] testFilenames;

void setup() {
  size(600, 600);
  textSize(32);
  
  // get the names of all of the image files in the "cardamom" folder
  java.io.File cardamomFolder = new java.io.File(dataPath("Cardamom"));
  String[] cardamomFilenames = cardamomFolder.list();
  
  // get the names of all of the image files in the "chili" folder
  java.io.File chiliFolder = new java.io.File(dataPath("ChiliPowder"));
  String[] chiliFilenames = chiliFolder.list();

  // get the names of all of the image files in the "nutmeg" folder
  java.io.File nutmegFolder = new java.io.File(dataPath("Nutmeg"));
  String[] nutmegFilenames = nutmegFolder.list();
  
  // get the names of all of the image files in the "nutmeg" folder
  java.io.File thymeLeavesFolder = new java.io.File(dataPath("ThymeLeaves"));
  String[] thymeLeavesFilenames = thymeLeavesFolder.list();
  
  // get the names of all of the image files in the "nutmeg" folder
  java.io.File turmericFolder = new java.io.File(dataPath("Turmeric"));
  String[] turmericFilenames = turmericFolder.list();

  // initialize labels and trainingData arrays
  // one label for each training image
//  println(nutmegFilenames.length);
  labels = new int[cardamomFilenames.length + chiliFilenames.length + nutmegFilenames.length + thymeLeavesFilenames.length + turmericFilenames.length];
  // one vector for each training image
  // each vector has 3 entries for each bin
  // one each for R, G, and B
  trainingData = new float[labels.length][numBins*3];
  
  // create the histogram object and tell it how many
  // bins we want
  histogram  = new Histogram();
  histogram.setNumBins(numBins);

  // build vectors for each chili image
  // and add the appropriate label
  for (int i = 0; i < cardamomFilenames.length; i++) {
    println("loading cardamom " + i);
    trainingData[i] = buildVector(loadImage("Cardamom/" + cardamomFilenames[i]));
    labels[i] = 1;
  }

  // build vectors for each cloves image
  // and add the appropriate label
  for (int i = 0; i < chiliFilenames.length; i++) {
    println("loading chilipowder " + i);
    trainingData[i + chiliFilenames.length] = buildVector(loadImage("ChiliPowder/" + chiliFilenames[i]));
    labels[i+ chiliFilenames.length] = 2;
  } 

for (int i = 0; i < nutmegFilenames.length; i++) {
    println("loading nutmeg " + i);
    trainingData[i + chiliFilenames.length + nutmegFilenames.length] = buildVector(loadImage("Nutmeg/" + nutmegFilenames[i]));
    labels[i+ chiliFilenames.length + nutmegFilenames.length] = 3;
  } 

for (int i = 0; i < thymeLeavesFilenames.length; i++) {
    println("loading ThymeLeaves " + i);
    trainingData[i + chiliFilenames.length + nutmegFilenames.length + thymeLeavesFilenames.length] = buildVector(loadImage("ThymeLeaves/" + thymeLeavesFilenames[i]));
    labels[i+ chiliFilenames.length + nutmegFilenames.length + thymeLeavesFilenames.length] = 4;
  } 

for (int i = 0; i < turmericFilenames.length; i++) {
    println("loading Turmeric " + i);
    trainingData[i + chiliFilenames.length + nutmegFilenames.length + thymeLeavesFilenames.length + turmericFilenames.length] = buildVector(loadImage("Turmeric/" + turmericFilenames[i]));
    labels[i+ chiliFilenames.length + nutmegFilenames.length + thymeLeavesFilenames.length+ turmericFilenames.length-2] = 5;
  } 

  // setup our SVM model
  model = new SVM(this);
  SVMProblem problem = new SVMProblem();
  // each vector will have three features for each bin
  // in our histogram: one each for red, green, and blue
  // components
  problem.setNumFeatures(numBins*3);
  // set the data and train the SVM
  problem.setSampleData(labels, trainingData);
  model.train(problem);
  
  // load in the test images
  java.io.File testFolder = new java.io.File(dataPath("Test"));
  testFilenames = testFolder.list();
  
  // run the evaluation (see function for more)
  evaluateResults();
  // loads and tests a new image from the test folder
  loadNewTestImage();
}

// This function calculates the histogram for a PImage
// and scales it so that the sum of each RGB entry is 1
// the results are used as the feature vector for SVM
float[] buildVector(PImage img) {
  histogram.setImage(img);
  histogram.calculateHistogram();
  histogram.scale(0, 0.33);
  return histogram.getHSV();
}

void draw() {
  background(0);
  
  pushMatrix();
  scale(0.5);
  image(testImage, 0, 60);
  popMatrix();
  
  // testResult is set in loadNewTestImage()
  String message = "";
  if((int)testResult == 1){
    message = "Cardamom";
  } 
  else if((int)testResult == 2){
    message = "ChiliPowder";
  }
  else if((int)testResult == 3){
    message = "Nutmeg";
  }
  else if((int)testResult == 4){
    message = "ThymeLeaves";
  }
  else if((int)testResult == 5){
    message = "Turmeric";
  }
  
  fill(255);
  text(message, 10, 25);
  text("Percent classified correctly: " + nf(correctPercentage * 100,2,2), 20, height -40);
  stroke(255);
  histogram.drawRGB(0, height/2, width, height/2);
}

// Loads up a new random image.
// Runs in through the SVM for classification.
// Stores the results in the testResult variable.
void loadNewTestImage(){
  int imgNum = (int)random(0, testFilenames.length-1);
  testImage = loadImage("Test/" + testFilenames[imgNum]); 
  testResult = model.test(buildVector(testImage));
}

void keyPressed(){
  if(key == 'n'){
  loadNewTestImage();
}
    if(key == 's'){
      model.saveModel("model.txt");
  }
}

float correctPercentage = 0.0;

void evaluateResults(){
  int numCorrect = 0;
  PImage img;
  
  for (int i = 0; i < testFilenames.length; i++) {
    img = loadImage("Test/" + testFilenames[i]); 
    double r = model.test(buildVector(img));
    if(r == 1.0 && split(testFilenames[i], "-")[0].equals("Cardamom")){
      numCorrect++;
    }
    
    if(r == 2.0 && split(testFilenames[i], "-")[0].equals("ChiliPowder")){
      numCorrect++;
    }

    if(r == 3.0 && split(testFilenames[i], "-")[0].equals("Nutmeg")){
      numCorrect++;
    }
    
    if(r == 4.0 && split(testFilenames[i], "-")[0].equals("ThymeLeaves")){
      numCorrect++;
    }

    if(r == 5.0 && split(testFilenames[i], "-")[0].equals("Turmeric")){
      numCorrect++;
    }
  }
  
  correctPercentage = (float)numCorrect/testFilenames.length;
  
  println("Num Bins: " + numBins + " Percent Correct: " + correctPercentage);
}


