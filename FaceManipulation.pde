
//String maskNames[] ={"infant_yerder.png", "princess_buns.png", "nerf_herder.png", "big_dog.png"};
//PImage[] masks = new PImage[maskNames.length]; 
PImage currentMask;
int faceHeight, faceWidth;
int faceX, faceY, noseZoneX, noseZoneY, noseZoneWidth, noseZoneHeight, eyeZoneX, eyeZoneY, eyeZoneWidth, eyeZoneHeight;
void faceDetection() 
{
  for (int i = 0; i < faces.length; i++)
  {
    noFill();
    //face will show in a red box
    stroke(255, 0, 0);
    strokeWeight(3);
    faceX = faces[i].x; 
    faceY = faces[i].y;
    faceWidth = faces[i].width;
    faceHeight = faces[i].height;
    noseZoneX = faceX + (faceWidth/3);
    noseZoneY = faceY + (faceHeight/3);
    noseZoneWidth = faceWidth/2; //3 sometimes works
    noseZoneHeight = faceHeight/2;
    eyeZoneX = faceX;
    eyeZoneY = faceY;
    eyeZoneWidth = faceWidth;
    eyeZoneHeight = faceHeight/2;

    //rect(faceX, faceY, faces[i].width, faces[i].height);
    
    noseopencv.loadImage((PImage) cam);
    stroke(0, 0, 255);
    noseopencv.setROI(noseZoneX, noseZoneY, noseZoneWidth, noseZoneHeight);

    //rect(noseZoneX, noseZoneY, noseZoneWidth, noseZoneHeight);
    noses = noseopencv.detect();
    pairsOfEyes = eyeopencv.detect();

    for (int j = 0; j < noses.length; j++)
    {
      //orange coloured line
      stroke(255, 100, 0);
      strokeWeight(3);

      int noseX = noses[j].x + noseZoneX;
      int noseY = noses[j].y + noseZoneY;
      int noseWidth = noses[j].width;
      int noseHeight = noses[j].height;
      int mouthZoneX = faceX;
      int mouthZoneY = faceY + faceHeight/2;
      int mouthZoneWidth = faceWidth;
      int mouthZoneHeight = faceHeight/2;

      //draws where the nose is
      // rect(noseX, noseY, noseWidth, noseHeight); // do NOT use ellipse, it measures x and y from the centre of the circle, not the top left point like a rect!

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
        
        loadMask();
      }
    }
    mouthopencv.releaseROI();
    noseopencv.releaseROI();
  }
}



void timer(int totalTime)
{
  //println("passed time = " + passedTime);

  if (passedTime > totalTime)
  {
    println("YOU MAY NOW PROCEED");
   // waitPeriod = true;
    savedTime = millis(); //saves the current time and restarts the timer
  }
}

void loadMask()
{
  checkCounter();
  
    currentMask = characters[count].maskChoice();

  
    if(count == 0) //yoda
   {
      image(currentMask, faceX - cam.width/10, faceY - cam.height/7, faceWidth + faceWidth*1.2, faceHeight +  faceHeight*1.2);
   }
   if(count == 1) //mario
   {
     image(currentMask, faceX - cam.width/20, faceY - cam.height/10, faceWidth+faceWidth*0.5, faceHeight*0.8);
   }
   if(count == 2)
   {
     image(currentMask, faceX, faceY, faceWidth, faceHeight);
   }
   if(count ==3)
   {
     image(currentMask, faceX - faceWidth/2, faceY - faceHeight*0.75, faceWidth + faceWidth, faceHeight +  faceHeight);
   }
}

void checkCounter()
{
  if (count == characters.length) //hardcoded since we cannot return characters[count].length(), or sizeOf(ARRAY)
  {
    count = 0;
  }

  if (effectCounter == 4) //hardcoded 4 instead of putting number of music effects that are variable into an array
  {
    effectCounter = 0;
  }
}
