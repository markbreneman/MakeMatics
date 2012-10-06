import org.json.*;

void setup() {
  String BASE_URL = "https://api.foursquare.com/v2/users/self/checkins?oauth_token=D3VT4ZRYPV2PCBTS0CBBKPP1DBMUGJ2XXX2BE3EDIUX20LAJ&limit=250";

  // Get the JSON formatted response
  String fourSquareresponse = loadStrings( BASE_URL)[0];

  // Make sure we got a response.
  if ( fourSquareresponse != null ) {
    // Initialize the JSONObject for the response
    JSONObject root = new JSONObject( fourSquareresponse );
    //    println(root);
    JSONObject checkins = root.getJSONObject("response").getJSONObject("checkins");
    //    println(checkins);
    JSONArray items = checkins.getJSONArray("items");
//    println(items);
//    println(items.length());
//    println(items.optJSONObject(0));
    println(items.optJSONObject(249).getInt("createdAt"));
    
  }
}

void draw() {
}

