Paint paint;
float angle = 0;
ArrayList paintArray;
ArrayList vertexes;

void setup() {
  size(640, 640);
  background(102);
  paintArray = new ArrayList();
}

void draw() {
  background(255);
  smooth();
  stroke(255);
//  frameRate(5);

  pushMatrix();
  translate(width/2, height/2);
  //  println(frameCount);
//  angle=degrees(frameCount);
  rotate(radians(angle));
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
}

void mousePressed() {
  PVector mousePos=new PVector( mouseX-width/2, mouseY-height/2);
  PVector origin = new PVector(0, 0, 0); 
  float mouseDistance = abs(mousePos.dist(origin));
  paintArray.add(
  new Paint(mouseDistance)
    );
}

void keyPressed() {
  int keyIncrement=1;
  if (key == 'a') {
    angle+=keyIncrement;
    println(angle);
  }
  //  ////____PRINT____///

  if (key == 'p') {
    
    for (int i=0; i<paintArray.size(); i++) {  
      Paint p=(Paint) paintArray.get(i);
      for (int j=0; j<p.vertexes.size();j++) {      
        println("Vertexes " + j +" "+ p.vertexes.get(j));
      }
    }
  }
}

