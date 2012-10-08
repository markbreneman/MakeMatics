import linearclassifier.*;
import processing.data.*;

Table data;
LinearClassifier classifier;
String dayValue;
String dayValue2;
int scaleFactor;

PImage ITP;
PImage ChatID;
PFont font;


void setup() {
  size(800, 800);
  ITP=loadImage("ITPLogo.png");
  ChatID=loadImage("ChatIDLogo.png");
  imageMode(CENTER);

  // load the data and automatically parse the csv
  data = new Table(this, "ScrapedData.csv");

  classifier = new LinearClassifier(this);

  ArrayList<ArrayList<Float>> ITP = new ArrayList<ArrayList<Float>>();
  ArrayList<ArrayList<Float>> ChatID = new ArrayList<ArrayList<Float>>();

  data.removeTitleRow();

  // iterate through the data in the csv
  for (TableRow row : data) {
    // put the Day and Time data into an ArrayList
    ArrayList<Float> entry = new ArrayList<Float>(); 

    entry.add(row.getFloat(6));//Day as a number
    entry.add(row.getFloat(8));//Time as a function of minutes    

    // put the Pvector in the right ArrayList for ITP or ChatID
    if (row.getString(9).equals("ITP")) {
      ITP.add(entry);
    } 
    else if (row.getString(9).equals("ChatID")) {
      ChatID.add(entry);
    }
    
  }

  
  // pass the data to the classifier
  classifier.loadSet1(ITP);
  classifier.loadSet2(ChatID);


  scaleFactor=600; 
  ArrayList<PVector> scales = new ArrayList<PVector>();
  scales.add(new PVector(0, scaleFactor));
  scales.add(new PVector(scaleFactor, 0));
  classifier.setOutputScale(scales);
}

void draw() {
  background(255);
  noStroke();

  // display the data
  fill(151, 8, 255);
  classifier.drawSet1();//ITP blue
  fill(142, 194, 232);
  classifier.drawSet2();//ChatID RED

  // get the average of each set
  ArrayList<Float> set1Ave = classifier.getSet1Average();
  ArrayList<Float> set2Ave = classifier.getSet2Average();

  // draw them as black boxes
  fill(0);
  rectMode(CENTER);
  rect(set1Ave.get(0), set1Ave.get(1), 10, 10);
  text("ITP \n Average", set1Ave.get(0)+10, set1Ave.get(1)+10);
  rect(set2Ave.get(0), set2Ave.get(1), 10, 10);
  text("ChatID \n Average", set2Ave.get(0)+10, set2Ave.get(1)+10);

  // draw a line connecting the two averages
  // and a point at the center of that line
  fill(0, 255, 0);
  stroke(0, 255, 0);
  line(set1Ave.get(0), set1Ave.get(1), set2Ave.get(0), set2Ave.get(1));
  ellipse(classifier.getCenterPoint().x, classifier.getCenterPoint().y, 10, 10);

  // draw a line perpendicualr to the line
  // between the cetner points
  // this line should divide the two sets after classification
  stroke(0);
  drawPerpindicularLine(set1Ave.get(0), set1Ave.get(1), set2Ave.get(0), set2Ave.get(1));


  int currentTimeMinutes= minute()+hour()*60;
  float mappedTimeMinutes=map(currentTimeMinutes, 0, 24*60-120, height, 0); //1375 is the max minutes in the CSV; 10 is the ellipse size offset
  //Day of the Week as an number 0-6 starting with Sunday;
  Calendar c;
  int currentDayOfWeek;
  c = Calendar.getInstance();
  currentDayOfWeek = c.get(Calendar.DAY_OF_WEEK);
  float mappedDayofWeek=map(currentDayOfWeek, 0, 6, 0, width);
  //Put an ellipse on Now 
  stroke(255, 0, 0);
  ellipse(mappedDayofWeek-width/7, mappedTimeMinutes, 20, 20);//TODAY AND NOW

  //Time Label Calculations
  float minutesinHours=currentTimeMinutes*0.0166667;
  int roundedHours= int(minutesinHours);
  int minuteZerosDecide=int((minutesinHours-roundedHours)*60);
  String remainderMinutes= String.valueOf(int((minutesinHours-roundedHours)*60));
  String AMPM;
  if (minuteZerosDecide<10) { 
    remainderMinutes = nf(minuteZerosDecide, 2);
  }
  if (roundedHours>12) {
    roundedHours=roundedHours-12;
    AMPM="PM";
  }
  else {
    AMPM="AM";
  };  
  if (currentDayOfWeek>=0 && currentDayOfWeek<=1) {
    dayValue="Sunday";
  }
  else if (currentDayOfWeek>=1 && currentDayOfWeek<=2) {
    dayValue="Monday";
  }
  else if (currentDayOfWeek>=2 && currentDayOfWeek<=3) {
    dayValue="Tuesday";
  }
  else if (currentDayOfWeek>=3 && currentDayOfWeek<=4) {
    dayValue="Wednesday";
  }
  else if (currentDayOfWeek>=4 && currentDayOfWeek<=5) {
    dayValue="Thursday";
  }
  else if (currentDayOfWeek>=5 && currentDayOfWeek<=6) {
    dayValue="Friday";
  }
  else if (currentDayOfWeek>=6) {
    dayValue="Saturday";
  }
  text("Today is: \n" +  dayValue +"\n" + "The time is \n " + roundedHours + " :" + remainderMinutes + " " + AMPM, mappedDayofWeek-width/7-10, mappedTimeMinutes+33+20);

  ///DECIDING BEGINNING///
  ///COMMENT THIS DECIDING BOXED AREA OUT TO DEBUG DATA BEHING///
  
  PVector decidePVector = new PVector(mappedDayofWeek-width/7, mappedTimeMinutes+33);
//  PVector decidePVector = new PVector(700, 50); //ITP POINT
//  PVector decidePVector = new PVector(300, 600); //CHATID POINT
//  println(decidePVector.x);
//  println(decidePVector.y);

//  if (classifier.isInSet1(decidePVector)) {
//    fill(85,50,144);
//    rect(0, 0, width*2, height*2);
//    image(ITP, width/2, height/2);
//    fill(255, 255, 255);
//  } 
//  else {
//    fill(142, 194, 232);
//    rect(0, 0, width*2, height*2);
//    image(ChatID, width/2, height/2);
//    fill(255, 255, 255);
//  }
//  font = loadFont("Tungsten-Medium-48.vlw");
//  textAlign(CENTER);
//  textFont(font,72);
//  text("Ben's Probably Gonna Be at", width/2, height/4);

  ////DECIDING END////
  
  
  ///FOR DEBUGGING DATA WITH MOUSE START////
  noStroke();
  if (classifier.isInSet1( new PVector(mouseX, mouseY))) {
    fill(85,50,144);
  } 
  else {
    fill(142, 194, 232);
  }
  ellipse(mouseX, mouseY, 10, 10);  
  
  PVector p = classifier.getUnscaledPoint(new PVector(mouseX, mouseY));
  //time label Calculations
  float minutesinHours2=p.y*0.0166667;
  int roundedHours2= int(minutesinHours2);
  int minuteZerosDecide2=int((minutesinHours2-roundedHours2)*60);
  String remainderMinutes2= String.valueOf(int((minutesinHours2-roundedHours2)*60));
  String AMPM2;
  if (minuteZerosDecide2<10) { 
    remainderMinutes2 = nf(minuteZerosDecide2, 2);
  }
  if (roundedHours2>12) {
    roundedHours2=roundedHours2-12;
    AMPM2="PM";
  }
  else {
    AMPM2="AM";
  };  
  if (p.x>=0 && p.x<=1) {
    dayValue2="Sunday";
  }
  else if (p.x>=1 && p.x<=2) {
    dayValue2="Monday";
  }
  else if (p.x>=2 && p.x<=3) {
    dayValue2="Tuesday";
  }
  else if (p.x>=3 && p.x<=4) {
    dayValue2="Wednesday";
  }
  else if (p.x>=4 && p.x<=5) {
    dayValue2="Thursday";
  }
  else if (p.x>=5 && p.x<=6) {
    dayValue2="Friday";
  }
  else if (p.x>=6) {
    dayValue2="Saturday";
  }
  text( dayValue2 + "   " + roundedHours2 + " :" + remainderMinutes2 + " " + AMPM2, mouseX+7, mouseY+7);
   
   ///FOR DEBUGGING DATA WITH MOUSE////
  
}

void drawPerpindicularLine(float x1, float y1, float x2, float y2) {

  PVector axis = PVector.sub(new PVector(x1, y1), new PVector(x2, y2));
  PVector perp = axis.cross(new PVector(0, 0, 1));

  perp.setMag(500);

  PVector lineStart = PVector.sub(classifier.getCenterPoint(), perp);
  PVector lineEnd = PVector.add(classifier.getCenterPoint(), perp);

  line(lineStart.x, lineStart.y, lineEnd.x, lineEnd.y);
}

