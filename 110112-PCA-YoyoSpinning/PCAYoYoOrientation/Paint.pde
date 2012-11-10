class Paint {
  float x;
  float y;
  color c1;
  int numVertices;
  float vertexDegree;
  float startRadius;
  float radius;
  float lineWeight;
  ArrayList vertexes;
  PVector paintOrigin;
  int startAngle;
  int deltaAngle;

  Paint(float _radius, PVector _paintOrigin, int _startAngle, int _deltaAngle) {
    
     
    c1 = color (random(255), random(255), random(255), random(255));
    numVertices = 360;
    vertexDegree = 360 / numVertices;
    startRadius = _radius;
    radius=startRadius;
    lineWeight=(10);
    paintOrigin=_paintOrigin;
    startAngle=_startAngle;
    deltaAngle=_deltaAngle;
    
    vertexes=new ArrayList();

    ///____CREATE THE OBJECTS POINTS____///
    
    //____OuterRing___// 
    for (float i = 360; i > 0; i--)
    { 
      float x = cos(radians(i * vertexDegree)) * (radius+lineWeight*noise(i)*random(.5, 3));
      float y = sin(radians(i * vertexDegree)) * (radius+lineWeight*noise(i)*random(.5, 3));
      PVector pVertex = new PVector(x+paintOrigin.x, y+paintOrigin.y);
      vertexes.add(pVertex);
    }
    int numberofVertexes = vertexes.size();
    //____InnerRing___//
    for (float k = 360; k > 0; k--)
    { 
      float a = cos(radians(k * vertexDegree)) * (radius-lineWeight*.25);
      float b = sin(radians(k * vertexDegree)) * (radius-lineWeight*.25);
      PVector pVertex = new PVector(a+paintOrigin.x, b+paintOrigin.y);
      vertexes.add(pVertex);
    }
  }

  void update() {
    
    
    if (radius-startRadius<startRadius*.1 && startRadius>0) {
      radius=radius+noise(frameCount)*5;

      for (int j = 0; j < vertexes.size()/2; j++)
      { 
        float x = cos(radians(j * vertexDegree)) * (radius+lineWeight*noise(j)*random(.5, 3));
        float y = sin(radians(j * vertexDegree)) * (radius+lineWeight*noise(j)*random(.5, 3));
      PVector pVertex = new PVector(x+paintOrigin.x, y+paintOrigin.y);
        vertexes.set(j, pVertex);
      }

      for (int k = vertexes.size()/2; k < vertexes.size(); k++)
      { 
        float a = cos(radians(k * vertexDegree)) * (radius);
        float b = sin(radians(k * vertexDegree)) * (radius);
      PVector pVertex = new PVector(a+paintOrigin.x, b+paintOrigin.y);
        vertexes.set(k, pVertex);
      }
    }
  }


  void display() {
    println(axis1Angle);
//    rotate(radians(angle));
//    rotate(radians(axis1Angle));
    ///____OUTERRING____////
    noFill();
    strokeWeight(lineWeight);
    stroke(c1);
    strokeCap(SQUARE);
    beginShape();
    for (int j=0; j<vertexes.size()/2; j++) {
      PVector vertexPoint = (PVector) vertexes.get(j);
      vertex(vertexPoint.x, vertexPoint.y);
    }
    endShape();
    //    stroke(0,0,255);
    strokeWeight(lineWeight*1.75);
    ///____INNER RING____////
    beginShape();
    for (int k=vertexes.size()/2; k<vertexes.size(); k++) {
      PVector vertexPoint = (PVector) vertexes.get(k);
      vertex(vertexPoint.x, vertexPoint.y);
    }
    endShape();
  }
}

