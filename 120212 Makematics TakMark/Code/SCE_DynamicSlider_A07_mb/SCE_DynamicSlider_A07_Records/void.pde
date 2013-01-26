void makeArray(){
  img = loadImage("ConferenceRoomMapped01-edited.png");
//  size(img.width , img.height);
  size(img.width/30 , img.height/30);//For Logging
  carver = new SeamCarving(this, img);
  seam = carver.findMinSeam();
  energyImage = carver.getGradientImage();
  scoreImage = carver.getScoreImage();
  
  println(img.width+"<----------imgWidth");


}




