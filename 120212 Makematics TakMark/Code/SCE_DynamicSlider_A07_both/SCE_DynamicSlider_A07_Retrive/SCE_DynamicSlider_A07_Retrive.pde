PImage img,img2;
String[] historyPoints;
float moveX;
int[] placeOrder;

boolean first = true;

void setup() {
//  img = loadImage("ConferenceRoomMapped01-edited800X500.png");
  img = loadImage("ConferenceRoomMapped01-edited.png");
//  img.resize(1440,0);
  size(img.width, img.height, P3D);
//  historyPoints = loadStrings("ConferenceRoomMapped01-edited800X500.txt");
  historyPoints = loadStrings("ConferenceRoomMapped01-edited.txt");
  placeOrder = new int[img.width];
  
}


void draw() {
  //////////////retriving////////////////////////
  background(255);



  for (int i=0; i<img.height; i++) {
    for (int j=0; j<img.width; j++) {
      int loc = j + i*img.width;
      color c = img.pixels[loc];

      String[] printPoint = split(historyPoints[loc], ',');
      String[] refinePoint = split(printPoint[2], ' ');


      //////////////VISUALIZATION 1////////////////////////////
      
      float z = (float(refinePoint[1]));
       if (mouseX > z) {
       c = color(255,0,0);
       }
       
//       img.resize(1440,0);
       
       pushMatrix();
       translate(j, i, 0);//(j+width/3, i+height/3, 0);
       fill(c);
       noStroke();
       rectMode(CENTER);
       rect(0, 0, 1, 1);
       popMatrix();
       

      //////////////VISUALIZATION 2//////////////////////////
      /*
      
       float z = (float(refinePoint[1]));
       
       float tempA = map(z, mouseX, img.width, 0, 255);
       float a = constrain(tempA, 0, 255);
       
       pushMatrix();
       translate(j, i, 0);
       fill(c,a);
       noStroke();
       rectMode(CENTER);
       rect(0, 0, 1, 1);
       popMatrix();
       */

      //////////////VISUALIZATION 3//////////////////////////
      /*
      float z = (float(refinePoint[1]));
      
      if(mouseX > z){
        moveX = abs(mouseX-z);
      } 

      pushMatrix();
      translate(j-moveX + img.width, i, 0-(z/100));
      fill(c);
      noStroke();
      rectMode(CENTER);
      rect(0, 0, 1, 1);
      popMatrix();
      */
        //////////////VISUALIZATION 4//////////////////////////
      /*
      float z = (float(refinePoint[1]));

      if (mouseX > z) {
        moveX = (mouseX-z)/2;
      } 
      else { 
        moveX = 0;
      }

      pushMatrix();
      translate(j-moveX + img.width, i, 0+(z/100));
      fill(c);
      noStroke();
      rectMode(CENTER);
      rect(0, 0, 1, 1);
      popMatrix();
      */
      
    }
  }
}

void keyReleased() {
  switch(key) {
  case 'p':
    println(placeOrder);
    break;
  }
}

