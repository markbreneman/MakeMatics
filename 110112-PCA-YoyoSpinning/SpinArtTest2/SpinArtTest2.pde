Paint paint;
ArrayList paintArray;
int angle;


void setup() {
  size(640, 360);
  background(102);
  paintArray = new ArrayList();
  angle=0;
}

void draw() {
//  background(102);
  stroke(255);
  frameRate(5);
  pushMatrix();
  translate(width/2, height/2);
//  println(frameCount);
  rotate(angle);
  rectMode(CENTER);
  rect(0, 0, 10, 10);
  if (paintArray.size()>0) {
    for (int i=0; i<paintArray.size(); i++) {
      Paint P=(Paint) paintArray.get(i);
      P.update();
      P.display();
    }
  }
  popMatrix();
  println(angle);

  
  
//  println(paintArray.size());
}

void mousePressed() {
  PVector mousePos=new PVector( mouseX-width/2, mouseY-height/2);
  PVector origin = new PVector(0,0,0); 
  float mouseDistance = abs(mousePos.dist(origin));

//  println(mouseDistance);
  paintArray.add(
  new Paint( mouseX-width/2, mouseY-height/2)
//  new Paint(mouseDistance)
    );

}

void keyPressed() {
 if (key == 'r')
  {  
   angle+=1;
  }

}
