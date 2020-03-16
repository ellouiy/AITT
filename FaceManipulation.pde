
String maskNames[] ={"infant_yerder.png", "princess_buns.png", "nerf_herder.png", "big_dog.png"};
PImage[] masks = new PImage[maskNames.length]; 
PImage currentMask;

int faceX, faceY, faceWidth, faceHeight, noseZoneX, noseZoneY, noseZoneWidth, noseZoneHeight, eyeZoneX, eyeZoneY, eyeZoneWidth, eyeZoneHeight;
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
    eyeopencv.setROI(eyeZoneX, eyeZoneY, eyeZoneWidth, eyeZoneHeight);
    rect(eyeZoneX, eyeZoneY, eyeZoneWidth, eyeZoneHeight);
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

        restartCounter();

        //FOR SOME REASON the below block of code won't work if I put it into the changeMasks method? Therefore keepingi t out here.   
        maskName = maskNames[count];
        masks[count] = loadImage(maskName);
        currentMask = masks[count];
        println("THIS IS THE CURRENT MASK: " + maskName);
        //currentFile.stop();
        image(currentMask, faceX, faceY, faceWidth, faceHeight);
        
        if(waitPeriod == false)
        {
           waitPeriod = true; 
        }
        
   
        
       
        // println("I'M THE NEXT MUSIC: " + music1[count]);

        //draws where the mouth is on the face
        rect((mouthZoneX + mouthX), (mouthZoneY + mouthY), mouths[m].width, mouths[m].height);
      }
      mouthopencv.releaseROI();
    }


    for (int e = 0; e < pairsOfEyes.length; e++)
    {
      int eyeX = pairsOfEyes[e].x + eyeZoneX;
      int eyeY = pairsOfEyes[e].y + eyeZoneY;

      noFill();
      //eyes will show in a purple box
      stroke(127, 0, 255);
      strokeWeight(3);

      rect((eyeX), (eyeY), pairsOfEyes[e].width, pairsOfEyes[e].height);
    }
    eyeopencv.releaseROI();
    noseopencv.releaseROI();
  }
}

void restartCounter()
{
  if (count == maskNames.length)
  {
    count = 0;
  }
}
