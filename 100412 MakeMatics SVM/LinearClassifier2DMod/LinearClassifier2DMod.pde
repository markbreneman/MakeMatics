import linearclassifier.*;
import processing.data.*;

Table data;
LinearClassifier classifier;
String dayValue;

void setup() {
  size(800, 800);

  // load the data and automatically parse the csv
  data = new Table(this, "ScrapedData.csv");

  classifier = new LinearClassifier(this);

  ArrayList<ArrayList<Float>> ITP = new ArrayList<ArrayList<Float>>();
  ArrayList<ArrayList<Float>> ChatID = new ArrayList<ArrayList<Float>>();

  data.removeTitleRow();

  // iterate through the data in the csv
  for (TableRow row : data) {
    // put the height and weight data into an ArrayList
    ArrayList<Float> entry = new ArrayList<Float>(); 

    entry.add(row.getFloat(6));//Day as a number
    entry.add(row.getFloat(8));//Time as a function of minutes    

    // based on the f/m column
    // put the Pvector in the right ArrayList for itp or woitp
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

  ArrayList<PVector> scales = new ArrayList<PVector>();
  scales.add(new PVector(0, 24*60/2));
  scales.add(new PVector(24*60/2, 0));
  classifier.setOutputScale(scales);
}

void draw() {
  background(255);
  noStroke();

  // display the data
  fill(0, 0, 255);
  classifier.drawSet1();//ITP blue
  fill(255, 0, 0);
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

  noStroke();
  if (classifier.isInSet1( new PVector(mouseX, mouseY))) {
    fill(0, 0, 255);
  } 
  else {
    fill(255, 0, 0);
  }

  ellipse(mouseX, mouseY, 10, 10);  

  PVector p = classifier.getUnscaledPoint(new PVector(mouseX, mouseY));
  //time label Calculations
  float minutesinHours=p.y*0.0166667;
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
  if (p.x>=0 && p.x<=1) {
    dayValue="Monday";
  }
  else if (p.x>=1 && p.x<=2) {
    dayValue="Tuesday";
  }
  else if (p.x>=2 && p.x<=3) {
    dayValue="Wednesday";
  }
  else if (p.x>=3 && p.x<=4) {
    dayValue="Thursday";
  }
  else if (p.x>=4 && p.x<=5) {
    dayValue="Friday";
  }
  else if (p.x>=5 && p.x<=6) {
    dayValue="Saturday";
  }
  else if (p.x>=6) {
    dayValue="Sunday";
  }
  text( dayValue + "   " + roundedHours + " :" + remainderMinutes + " " + AMPM, mouseX+7, mouseY+7);
}

void drawPerpindicularLine(float x1, float y1, float x2, float y2) {

  PVector axis = PVector.sub(new PVector(x1, y1), new PVector(x2, y2));
  PVector perp = axis.cross(new PVector(0, 0, 1));

  perp.setMag(500);

  PVector lineStart = PVector.sub(classifier.getCenterPoint(), perp);
  PVector lineEnd = PVector.add(classifier.getCenterPoint(), perp);

  line(lineStart.x, lineStart.y, lineEnd.x, lineEnd.y);
}

