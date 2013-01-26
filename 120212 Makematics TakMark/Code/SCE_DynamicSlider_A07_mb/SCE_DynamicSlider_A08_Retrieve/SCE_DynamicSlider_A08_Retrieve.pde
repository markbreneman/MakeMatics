PImage img;
String[] historyPoints;
ArrayList<PVector> vecPoints;
color c;
boolean drawSeams = false;
boolean drawImg = true;
int zoom=1;

float dim;

void setup() {
  //  img = loadImage("ConferenceRoomMapped01-edited800X500.png");
  img = loadImage("ConferenceRoomMapped01-edited.png");
  size(img.width, img.height, P3D);
  //  size(img.width/30, img.height/30, P3D);
  //  historyPoints = loadStrings("ConferenceRoomMapped01-edited800X500.txt");
  historyPoints = loadStrings("ConferenceRoomMapped01-edited.txt");
  vecPoints=new ArrayList();
  vecPoints.add(new PVector(0, 0));
  for (int i=1;i<historyPoints.length;i++) {
    String[] parsedPoints =split(historyPoints[i], ',');
    PVector tmpPoint= new PVector(Float.valueOf(parsedPoints[0]).floatValue(), Float.valueOf(parsedPoints[1]).floatValue());
    vecPoints.add(tmpPoint);
  }
}


void draw() {
  //////////////retriving////////////////////////
  background(255);
//  background(0);


  ////////////////////////DRAW THE SEAMS IF TRUE///////////////////////////
  if (drawSeams) {
    
    float newMouseX = map(mouseX, 0, img.width, 408, img.width);
    for (int i=0; i<img.height; i++) {
      for (int j=0; j<img.width; j++) {
        int loc = j + i*img.width;
        //color c = img.pixels[loc];
        float z = (vecPoints.get(loc).y);
        

        if (z<408) {
          c = color(0);
          zoom=1;

        }
        else if (z>408 && z>newMouseX) {
          c = color(0);
          zoom=1;
          
        }
        else if (z>408 && z<newMouseX) {
          dim = map(z, 408, newMouseX, 0, 255);
          c = color(dim);
          zoom=1;
        }
      if(floor(z) == floor(newMouseX)){
          c = color(255-random(1,100),0,0);
          zoom=5;
        }

/////////////////NEXT SEAM HIGHLIGHT////////////////////
//        if(floor(z) == floor(newMouseX)){
//          c = color(255,255,255);
////          c = color(0);
//          zoom=5;
//        }else{
//          c = color(0);
//          zoom=1;
//        }

        pushMatrix();
        translate(j, i-20, 0);//(j+width/3, i+height/3, 0);
        fill(c);
        noStroke();
        rectMode(CENTER);
        rect(0, 0, zoom, zoom);
        popMatrix();
      }
    }
  }

  ////////////////////////DRAW THE IMAGE IF TRUE///////////////////////////
  if (drawImg) {
    image(img, 0, -20);
  }
}

void keyReleased() {

  if (key=='s') {
    drawSeams=false;
    drawImg=true;
  }

  if (key=='i') {
    drawSeams=true;
    drawImg=false;
  }
}

