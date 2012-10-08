import org.json.*;
import linearclassifier.*;
import processing.data.*;

Table data;
LinearClassifier classifier;

int scaleFactor;

PImage ITP;
PImage ChatID;
PFont font;
int count;
int createdAt;

ArrayList<String> months = new ArrayList<String>();//Months of the checkin
ArrayList<String> dates = new ArrayList<String>();//Months of the checkin
ArrayList days; //Days of the checkin
ArrayList hours;//Hours of the checkin
ArrayList years;//Years of the checkin
ArrayList minutes;//Minutes of the checkin
int dayValue;//A 0-6 value for the day Sunday is 0
int timeMinutes;//Cumulatie time of checkin in Minutes 

void setup() {
  size(200, 200);

  ITP=loadImage("ITPLogo.png");
  ChatID=loadImage("ChatIDLogo.png");
  imageMode(CENTER);

  font = loadFont("Tungsten-Medium-48.vlw");

  ///PULL IN DATA FROM FOURSQUARE///

  //This the URL to the users checkin data
  String BASE_URL = "https://api.foursquare.com/v2/users/self/checkins?oauth_token=D3VT4ZRYPV2PCBTS0CBBKPP1DBMUGJ2XXX2BE3EDIUX20LAJ&limit=250";
  // Get the JSON formatted response
  String fourSquareresponse = loadStrings( BASE_URL)[0];
  // Make sure we got a response.
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
      if (items.optJSONObject(i).getJSONObject("venue").getString("name").equals("ITP")|| items.optJSONObject(i).getJSONObject("venue").getString("name").equals("ChatID")) {
        
        count++; 
        
        createdAt = items.optJSONObject(i).getInt("createdAt");
        //DEBUG
        String date = new java.text.SimpleDateFormat("MM/dd/yyyy/k/mm/a").format(new java.util.Date (createdAt*1000L));
        dates.add(date);// Add Month to Months ArrayList

         String yearCheckin = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String
        int intyearCheckin = Integer.parseInt(yearCheckin);
        years.add(intyearCheckin);// Add year to year ArrayList
        
        String monthCheckin = new java.text.SimpleDateFormat("MMMMM").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Month as String
        months.add(monthCheckin);// Add Month to Months ArrayList
        
        String dayCheckin = new java.text.SimpleDateFormat("EEEEEE").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String        
        ///Convert Days to 0-6 value ///
          if (dayCheckin.equals("Sunday")){ 
          dayValue=0;
          }
          else if (dayCheckin.equals("Monday")){
          dayValue=1;
          }
          else if (dayCheckin.equals("Tuesday")){
          dayValue=2;
          }
          else if (dayCheckin.equals("Wednesday")){
          dayValue=3;
          }
          else if (dayCheckin.equals("Thursday")){
          dayValue=4;
          }
          else if (dayCheckin.equals("Friday")){
          dayValue=5;
          }
          else if (dayCheckin.equals("Saturday")){
          dayValue=6;
          } 
        days.add(dayValue);// Add days to days ArrayList 
        
        String hourCheckin = new java.text.SimpleDateFormat("k").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String
        int inthourCheckin = Integer.parseInt(hourCheckin);
        hours.add(inthourCheckin);// Add hours to year ArrayList
        
        String minuteCheckin = new java.text.SimpleDateFormat("mm").format(new java.util.Date (createdAt*1000L));//From the Epoch Time Stamp Return the Day as String
        int intminuteCheckin = Integer.parseInt(minuteCheckin);
        minutes.add(intminuteCheckin);// Add minutes to year ArrayList
        
      }}
      
//      println(dates.get(0));
//      println(months.get(0));
//      println(days.get(0));
//      println(years.get(0));
//      println(hours.get(0));
//      println(minutes.get(0));
//      println("the Count is" + count);

    }



    classifier = new LinearClassifier(this);

    ArrayList<ArrayList<Float>> ITP = new ArrayList<ArrayList<Float>>();
    ArrayList<ArrayList<Float>> ChatID = new ArrayList<ArrayList<Float>>();
  }

  void draw() {
  }

