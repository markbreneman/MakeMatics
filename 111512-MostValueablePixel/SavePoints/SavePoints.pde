// Learning Processing
// http://www.learningprocessing.com
// Daniel Shiffman

PrintWriter output;

void setup() {
  size(200,200);
  background(255);
  smooth();
  // Load everything from the file
  String[] positions = loadStrings("data.txt");
  // Create a print writer (will clear the file)
  output = createWriter("data/data.txt"); 

  // It might be null the first time we run the program if there is no data.txt file!
  if (positions != null) {
    // Read all the lines from the file and convert to two integers (xy coordinate)
    for (int i = 0; i < positions.length; i++) {
      int[] xy = int(split(positions[i],","));
      fill(0);
      rectMode(CENTER);
      rect(xy[0],xy[1],16,16);
      // We have to write the data out to the file again
      output.println(xy[0] + "," + xy[1]);
    }
  }
}

void draw() {
}

void mousePressed() {
  // Draw a new rectangle and write it out
  fill(0);
  rectMode(CENTER);
  rect(mouseX,mouseY,16,16);
  output.println(mouseX + "," + mouseY); // Write the coordinate to the file
}

void keyPressed() {
  // Create a print writer (will clear the file)
//  output = createWriter("data/data.txt"); 
//  background(255);
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file
  exit();  // Stops the program

}

// This will get called when the sketch quits
//void stop() {
//  output.flush();  // Flush all the data to the file
//  output.close();  // Close the file
//}






