Paint paint;
Float angle;
ArrayList paintArray;

void setup() {
  size(640, 360);
  background(102);
  paintArray = new ArrayList();
}

void draw() {
  background(102);
  stroke(255);
  frameRate(5);
  pushMatrix();
  translate(width/2, height/2);
  println(frameCount);
  angle=degrees(frameCount);
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
  

  
  
//  println(paintArray.size());
}

void mousePressed() {
  PVector mousePos=new PVector( mouseX-width/2, mouseY-height/2);
  PVector origin = new PVector(0,0,0); 
  float mouseDistance = abs(mousePos.dist(origin));

//  println(mouseDistance);
  paintArray.add(
  new Paint(mouseDistance)
    );

}

