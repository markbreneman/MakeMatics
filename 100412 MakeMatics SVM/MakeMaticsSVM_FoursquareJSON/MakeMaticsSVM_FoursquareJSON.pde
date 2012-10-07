import org.json.*;
import linearclassifier.*;
import processing.data.*;

Table data;
LinearClassifier classifier;

void setup() {
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
    
    for(int i=0; i<items.length(); i++){
      //The request below get data about item[i] or in other words the checkin at that point in the items array
//    println(items.optJSONObject(i).getString("id")); //This gets the ID of the checkin
//    println(items.optJSONObject(i).getInt("createdAt")); //This gets the Time
//    println(items.optJSONObject(i).getJSONObject("venue").getString("name")); //This gets the Venue Name 
//    println(items.optJSONObject(i).getJSONObject("venue").getJSONObject("location").get("lat")); //This gets the Latitude of the Venue
//    println(items.optJSONObject(i).getJSONObject("venue").getJSONObject("location").get("city"));//This gets the Longitude of the Venue
    }
  
  
  
    
  }
}

void draw() {
}

