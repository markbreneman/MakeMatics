class Pixel {

  int imageIndex;
  int tmpIndex;
  float R;
  float G;
  float B;
  PVector startLocation;
  PVector currentLocation;///this will be the value that gets recalculated.
  int seamIndex; ///this is the "step" at which the pixel object will be remove

  Pixel(PVector _startLocation, int _imageIndex, float _R, float _G, float _B ) {
    imageIndex = _imageIndex;
    R=_R;
    G=_G;
    B=_B;
    startLocation=_startLocation;
    /////To Start this off. 
    currentLocation=new PVector();
    currentLocation.x=startLocation.x;
    currentLocation.y=startLocation.y; 
}
  void update(PVector _location,int _tmpIndex) {
    currentLocation=_location;
    tmpIndex=_tmpIndex;
  }
}

