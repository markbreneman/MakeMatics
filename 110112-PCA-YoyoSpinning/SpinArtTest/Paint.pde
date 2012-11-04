class Paint {
  float x;
  float y;
  color c1;
  float numVertices;
  float vertexDegree;
  ArrayList vertexes;
  float startRadius;
  float radius;
  float lineWeight;

  Paint(float _radius) {

    c1 = color (random(255), random(255), random(255),random(255));
    numVertices = 360;
    vertexDegree = 360 / numVertices;
    startRadius = _radius;
    radius=startRadius;
    lineWeight=(10);
    vertexes=new ArrayList();
    
    fill(c1);
    noStroke();
    noFill();
    stroke(c1);
    strokeWeight(lineWeight); 
  }
  
  void update() {
    if (radius-startRadius<startRadius*.25 && startRadius>0) {
      radius=radius+noise(frameCount)*5;
     }
  }


  void display() {
//  fill(c1);
//  noStroke();
  noFill();
  stroke(c1);

  strokeWeight(lineWeight); 
  beginShape();
    for (float i = numVertices; i > 0; i--)
//    for (int i = 0; i < numVertices; i++)
    { 
      float x = cos(radians(i * vertexDegree)) * (radius+random(-2,2));
      float y = sin(radians(i * vertexDegree)) * (radius+random(-2,2));
      vertex(x,y);
    }
    endShape(CLOSE);
//
  noFill();
  stroke(c1);
  beginShape();
    for (int i = 0; i < numVertices; i++)
//  for (float i = numVertices; i > 0; i--)
  { 
    float a = cos(radians(i * vertexDegree)) * (radius-lineWeight+1);
    float b = sin(radians(i * vertexDegree)) * (radius-lineWeight+1);
    vertex(a,b);
  }
  endShape(CLOSE);
  }
}

