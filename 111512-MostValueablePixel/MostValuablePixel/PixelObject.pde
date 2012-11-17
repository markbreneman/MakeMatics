class Pixel {

  int imageIndex;
  float R;
  float G;
  float B;
  int seamIndex;

  PVector location;
  int rectSize;

  Pixel(int _imageIndex, float _R, float _G, float _B) {
    imageIndex = _imageIndex;
    R=_R;
    G=_G;
    B=_B;
  }

  void display(PVector _location, int _rectSize) {
    location=_location;
    rectSize=_rectSize;
    rect(location.x,location.y, rectSize, rectSize);
  }
}

