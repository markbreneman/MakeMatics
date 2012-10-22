import org.json.*;
import linearclassifier.*;
import processing.data.*;

Table data;
LinearClassifier classifier;

int scaleFactor;

PImage ITPLogo;
PImage ChatIDLogo;
PFont font;
int count;
int createdAt;

ArrayList<String> months = new ArrayList<String>();//Months of the checkin
//ArrayList<String> dates = new ArrayList<String>();//Months of the checkin
ArrayList days; //Days of the checkin
ArrayList hours;//Hours of the checkin
ArrayList years;//Years of the checkin
ArrayList minutes;//Minutes of the checkin
float dayValue; //Day of the Week 0-6 Starting with Sunday
String dayLabel;//Labeling Data
String dayLabel2;//Labeling Data
int timeMinutes;//Cumulative time of checkin in Minutes 

void setup() {
  size(800, 800);

  ITPLogo=loadImage("ITPLogo.png");
  ChatIDLogo=loadImage("ChatIDLogo.png");
  imageMode(CENTER);

  font = loadFont("Tungsten-Medium-48.vlw");

  ///PULL IN DATA FROM FOURSQUARE///

  //This the URL to the users checkin data
  String BASE_URL = "https://api.foursquare.com/v2/users/self/checkins?oauth_token=D3VT4ZRYPV2PCBTS0CBBKPP1DBMUGJ2XXX2BE3EDIUX20LAJ&limit=250";
  // Get the JSON formatted response
  String fourSquareresponse = loadStrings( BASE_URL)[0];
  // Make sure we got a response.
  
  ArrayList<ArrayList<Float>> ITP = new ArrayList<ArrayList<Float>>();
  ArrayList<ArrayList<Float>> ChatID = new ArrayList<ArrayList<Float>>();
  
  if ( fourSquareresponse != null ) {
    // Initialize the JSONObject for the response
    JSONObject root = new JSONObject( fourSquareresponse ); //This is the Top Level JSON Object
    JSONObject checkins = root.getJSONObject("response").getJSONObject("checkins");//This is the Checkins Object
    JSONArray items = checkins.getJSONArray("items");//This is the Array Object with Checkins, each Item is a checkin with properties associated with it

    data = new Table();///This May not be needed
    days=new ArrayList();
    hours=new ArrayList();
    minutes=new ArrayList();
    years=new ArrayList();
    
    for (int i=0; i<items.length(); i++) {
      if (items.optJSONObject(i).getJSONObject("venue").getString("name").equals("ITP")) {

        count++; 

        createdAt = items.optJSONObject(i).getInt("createdAt");
        //DEBUG
//        String date = new java.text.SimpleDateFormat("MM/dd/yyyy/k/mm/a").format(new java.util.Date (createdAt*1000L));
//        dates.add(date);// Add Month to Months ArrayList

//        String yearCheckin = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String
//        int intyearCheckin = Integer.parseInt(yearCheckin);
//        years.add(intyearCheckin);// Add year to year ArrayList

//        String monthCheckin = new java.text.SimpleDateFormat("MMMMM").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Month as String
//        months.add(monthCheckin);// Add Month to Months ArrayList

        String dayCheckin = new java.text.SimpleDateFormat("EEEEEE").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String        

        ///Convert Days to 0-6 value ///
        
        if (dayCheckin.equals("Sunday")) { 
          dayValue=0;
        }
        else if (dayCheckin.equals("Monday")) {
          dayValue=1;
        }
        else if (dayCheckin.equals("Tuesday")) {
          dayValue=2;
        }
        else if (dayCheckin.equals("Wednesday")) {
          dayValue=3;
        }
        else if (dayCheckin.equals("Thursday")) {
          dayValue=4;
        }
        else if (dayCheckin.equals("Friday")) {
          dayValue=5;
        }
        else if (dayCheckin.equals("Saturday")) {
          dayValue=6;
        } 
        
        days.add(dayValue);// Add days to days ArrayList 

        String hourCheckin = new java.text.SimpleDateFormat("k").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String
        int inthourCheckin = Integer.parseInt(hourCheckin)*60;
//        hours.add(inthourCheckin);// Add hours to year ArrayList

        String minuteCheckin = new java.text.SimpleDateFormat("mm").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String
        int intminuteCheckin = Integer.parseInt(minuteCheckin)+inthourCheckin;
        float floatminuteCheckin=float(intminuteCheckin);
        minutes.add(floatminuteCheckin);// Add minutes to year ArrayList
        
        ArrayList<Float> entry = new ArrayList<Float>(); 
        entry.add(dayValue);//Day as a number
        entry.add(floatminuteCheckin);//Time as a function of minutes 
        ITP.add(entry);
        }//end if ITP
        
        if (items.optJSONObject(i).getJSONObject("venue").getString("name").equals("ChatID")) {
 
        createdAt = items.optJSONObject(i).getInt("createdAt");
        //DEBUG
//        String date = new java.text.SimpleDateFormat("MM/dd/yyyy/k/mm/a").format(new java.util.Date (createdAt*1000L));
//        dates.add(date);// Add Month to Months ArrayList

//        String yearCheckin = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String
//        int intyearCheckin = Integer.parseInt(yearCheckin);
//        years.add(intyearCheckin);// Add year to year ArrayList

//        String monthCheckin = new java.text.SimpleDateFormat("MMMMM").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Month as String
//        months.add(monthCheckin);// Add Month to Months ArrayList

        String dayCheckin = new java.text.SimpleDateFormat("EEEEEE").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String        

        ///Convert Days to 0-6 value ///
        
        if (dayCheckin.equals("Sunday")) { 
          dayValue=0;
        }
        else if (dayCheckin.equals("Monday")) {
          dayValue=1;
        }
        else if (dayCheckin.equals("Tuesday")) {
          dayValue=2;
        }
        else if (dayCheckin.equals("Wednesday")) {
          dayValue=3;
        }
        else if (dayCheckin.equals("Thursday")) {
          dayValue=4;
        }
        else if (dayCheckin.equals("Friday")) {
          dayValue=5;
        }
        else if (dayCheckin.equals("Saturday")) {
          dayValue=6;
        } 
        
        days.add(dayValue);// Add days to days ArrayList 

        String hourCheckin = new java.text.SimpleDateFormat("k").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String
        int inthourCheckin = Integer.parseInt(hourCheckin)*60;

        String minuteCheckin = new java.text.SimpleDateFormat("mm").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String
        int intminuteCheckin = Integer.parseInt(minuteCheckin)+inthourCheckin;
        float floatminuteCheckin=float(intminuteCheckin);
        minutes.add(floatminuteCheckin);// Add minutes to year ArrayList
        
        ArrayList<Float> entry = new ArrayList<Float>(); 
        entry.add(dayValue);//Day as a number
        entry.add(floatminuteCheckin);//Time as a function of minutes 
        ChatID.add(entry);
        }//end if ChatID
        
        
    }//end forLoop    
  }//end if response from server
  
//  println("ITP = " + ITP);
//  println("ChatID = " + ChatID);

  //Start the classifier
   classifier = new LinearClassifier(this);
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
  float mappedTimeMinutes=map(currentTimeMinutes, 0, 24*60-120, height, 0); //Collections.max is max minutes ; 10 is the ellipse size offset
  
  //Day of the Week as an number 0-6 starting with Sunday;
  Calendar c;
  int currentDayOfWeek;
  c = Calendar.getInstance();
  currentDayOfWeek = c.get(Calendar.DAY_OF_WEEK);
  float mappedDayofWeek=map(currentDayOfWeek, 0, 6, 0, width);
  //Put an ellipse on Now 
  stroke(255, 0, 0);
  ellipse(mappedDayofWeek-width/7, mappedTimeMinutes, 20, 20);

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
    dayLabel="Sunday";
  }
  else if (currentDayOfWeek>=1 && currentDayOfWeek<=2) {
    dayLabel="Monday";
  }
  else if (currentDayOfWeek>=2 && currentDayOfWeek<=3) {
    dayLabel="Tuesday";
  }
  else if (currentDayOfWeek>=3 && currentDayOfWeek<=4) {
    dayLabel="Wednesday";
  }
  else if (currentDayOfWeek>=4 && currentDayOfWeek<=5) {
    dayLabel="Thursday";
  }
  else if (currentDayOfWeek>=5 && currentDayOfWeek<=6) {
    dayLabel="Friday";
  }
  else if (currentDayOfWeek>=6) {
    dayLabel="Saturday";
  }
  text("Today is: \n" +  dayLabel +"\n" + "The time is \n " + roundedHours + " :" + remainderMinutes + " " + AMPM, mappedDayofWeek-width/7-10, mappedTimeMinutes+33+20);

  ///DECIDING BEGINNING///
  ///COMMENT THIS DECIDING BOXED AREA OUT TO DEBUG DATA BEHING///
  
  PVector decidePVector = new PVector(mappedDayofWeek-width/7, mappedTimeMinutes+33);
//  PVector decidePVector = new PVector(700, 50); //ITP POINT
//  PVector decidePVector = new PVector(300, 600); //CHATID POINT
//  println(decidePVector.x);
//  println(decidePVector.y);

  if (classifier.isInSet1(decidePVector)) {
    fill(85,50,144);
    rect(0, 0, width*2, height*2);
    image(ITPLogo, width/2, height/2);
    fill(255, 255, 255);
  } 
  else {
    fill(142, 194, 232);
    rect(0, 0, width*2, height*2);
    image(ChatIDLogo, width/2, height/2);
    fill(255, 255, 255);
  }
  font = loadFont("Tungsten-Medium-48.vlw");
  textAlign(CENTER);
  textFont(font,72);
  text("Ben's Probably Gonna Be at", width/2, height/4);

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
    dayLabel2="Sunday";
  }
  else if (p.x>=1 && p.x<=2) {
    dayLabel2="Monday";
  }
  else if (p.x>=2 && p.x<=3) {
    dayLabel2="Tuesday";
  }
  else if (p.x>=3 && p.x<=4) {
    dayLabel2="Wednesday";
  }
  else if (p.x>=4 && p.x<=5) {
    dayLabel2="Thursday";
  }
  else if (p.x>=5 && p.x<=6) {
    dayLabel2="Friday";
  }
  else if (p.x>=6) {
    dayLabel2="Saturday";
  }
  text( dayLabel2 + "   " + roundedHours2 + " :" + remainderMinutes2 + " " + AMPM2, mouseX+7, mouseY+7);
   
   ///FOR DEBUGGING DATA WITH MOUSE END////
  
}

void drawPerpindicularLine(float x1, float y1, float x2, float y2) {

  PVector axis = PVector.sub(new PVector(x1, y1), new PVector(x2, y2));
  PVector perp = axis.cross(new PVector(0, 0, 1));

  perp.setMag(500);

  PVector lineStart = PVector.sub(classifier.getCenterPoint(), perp);
  PVector lineEnd = PVector.add(classifier.getCenterPoint(), perp);

  line(lineStart.x, lineStart.y, lineEnd.x, lineEnd.y);
}
