PImage img;
String[] historyPoints;
ArrayList<PVector> vecPoints;

boolean first = true;

void setup() {
  img = loadImage("ConferenceRoomMapped01-edited800X500.png");
//  img = loadImage("ConferenceRoomMapped01-edited.png");
//  img.resize(1440,0);
  size(img.width, img.height, P3D);
//  size(img.width/30, img.height/30, P3D);
//  historyPoints = loadStrings("ConferenceRoomMapped01-edited800X500.txt");
  historyPoints = loadStrings("ConferenceRoomMapped01-editedtest.txt");
//  println(historyPoints.length);
//  println(split(historyPoints[1], ','));
  vecPoints=new ArrayList();
  vecPoints.add(new PVector(0,0));
  for (int i=1;i<historyPoints.length;i++){
  String[] parsedPoints =split(historyPoints[i], ',');
  PVector tmpPoint= new PVector(Float.valueOf(parsedPoints[0]).floatValue(),Float.valueOf(parsedPoints[1]).floatValue());
  vecPoints.add(tmpPoint);  
  }
//  println(vecPoints.get(3).x);
//  println(vecPoints.get(3).y);
//  println(vecPoints.size());
}


void draw() {
  //////////////retriving////////////////////////
  background(255);

  for (int i=0; i<img.height; i++) {
    for (int j=0; j<img.width; j++) {
      int loc = j + i*img.width;
      //color c = img.pixels[loc];
        
//////       img.resize(1440,0);

      
      float z = (vecPoints.get(loc).y);

      
       if (mouseX > z) {
       c = color(255,0,0);
       }
       
       pushMatrix();
       translate(j, i, 0);//(j+width/3, i+height/3, 0);
       fill(c);
       noStroke();
       rectMode(CENTER);
       rect(0, 0, 1, 1);
       popMatrix();     
    }
  }
}

void keyReleased() {
  
}

