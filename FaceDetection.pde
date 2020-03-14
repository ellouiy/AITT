void faceDetection() {

  for (int i = 0; i < faces.length; i++)
  {
    noFill();
    //face will show in a red box
    stroke(255, 0, 0);
    strokeWeight(3);
    int faceX = faces[i].x; 
    int faceY = faces[i].y;
    int faceWidth = faces[i].width;
    int faceHeight = faces[i].height;
    int noseZoneX = faceX + (faceWidth/3);
    int noseZoneY = faceY + (faceHeight/3);
    int noseZoneWidth = faceWidth/2; //3 sometimes works
    int noseZoneHeight = faceHeight/2;

    //rect(faceX, faceY, faces[i].width, faces[i].height);

    noseopencv.loadImage((PImage) cam);
    stroke(0, 0, 255);
    noseopencv.setROI(noseZoneX, noseZoneY, noseZoneWidth, noseZoneHeight);
    rect(noseZoneX, noseZoneY, noseZoneWidth, noseZoneHeight);
    noses = noseopencv.detect();

    for (int j = 0; j < noses.length; j++)
    {
      //orange coloured line
      stroke(255, 100, 0);
      strokeWeight(3);
      println(noses[j].x + " nose PLACE X ");
      println(noses[j].y + " nose PLACE Y");
      int noseX = noses[j].x + noseZoneX;
      int noseY = noses[j].y + noseZoneY;
      int noseWidth = noses[j].width;
      int noseHeight = noses[j].height;
      int mouthZoneX = faceX;
      int mouthZoneY = faceY + faceHeight/2;
      int mouthZoneWidth = faceWidth;
      int mouthZoneHeight = faceHeight/2;

      //draws where the nose is
      rect(noseX, noseY, noseWidth, noseHeight); // do NOT use ellipse, it measures x and y from the centre of the circle, not the top left point like a rect!

      mouthopencv.loadImage((PImage) cam);
      //draws the zone within a face where the mouth will be detected, aka the lower half of the face.
      //rect(mouthZoneX, mouthZoneY, mouthZoneWidth, mouthZoneHeight);
      mouthopencv.setROI(mouthZoneX, mouthZoneY, mouthZoneWidth, mouthZoneHeight);
      mouths = mouthopencv.detect();

      for (int m = 0; m < mouths.length; m++)
      {
        stroke(0, 255, 0);
        strokeWeight(3);
        int mouthX = mouths[m].x;
        int mouthY = mouths[m].y;

        image(yerder, faceX, faceY, faceWidth, faceHeight);

        //draws where the mouth is on the face
        rect((mouthZoneX + mouthX), (mouthZoneY + mouthY), mouths[m].width, mouths[m].height);
      }
      mouthopencv.releaseROI();
    }
    noseopencv.releaseROI();
  }
}
