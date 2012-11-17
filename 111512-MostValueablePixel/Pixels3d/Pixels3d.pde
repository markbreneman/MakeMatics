import processing.video.*;

Capture video;       // The source image
int cellsize = 8; // Dimensions of each cell in the grid
int COLS, ROWS;   // Number of columns and rows in our system
void setup()
{
  size(400, 400, P3D); 
  COLS = width/cellsize;                                                       // Calculate # of columns
  ROWS = height/cellsize;                                                     // Calculate # of rows
  video = new Capture(this, width, height, 30);
  video.start();
  noStroke();
}
void draw() {
  rotateY(mouseY/100.0);                                        // rotate everything on the Y axis to see it from the side
  if (video.available()) {
    video.read();                                                                                                       
    video.loadPixels();    
    background(0);
    for ( int x = 0; x < width;x+=cellsize) {
      for ( int y = 0; y < height;y+=cellsize) {                                             
        color c = video.pixels[x + y*width];                                               // Grab the color
        float z = (mouseX / (float) width) * brightness(c) - 100.0f;                       // Calculate a z position as a function of mouseX and pixel brightness
        fill(c);                                                                            //set fill  and draw the rect
        pushMatrix();     
        translate(x, y, z);                                                                // Translate to the location, 
        rect(0, 0, cellsize, cellsize);                                                    // draw the rect at 0 0 but it is translated to the correct place, 
        popMatrix();
      }
    }
  }
}

