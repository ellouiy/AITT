import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

OpenCV opencv;

Capture cam;

Rectangle[] faces;
Rectangle[] noses;

void setup() 
{
  size(10, 10);
  
  initCamera();
  opencv = new OpenCV(this, cam.width, cam.height);
  
  surface.setResizable(true);
  surface.setSize(opencv.width, opencv.height);
  
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  opencv.loadCascade(OpenCV.CASCADE_NOSE);

  cam.start();
}

void draw() 
{
  if(cam.available())
  {    
  
    cam.read();
    cam.loadPixels();
    opencv.loadImage((PImage)cam);
    
    image(cam, 0, 0);
 
    // CODE
  
     
     faces = opencv.detect();
     println(faces.length + " face" );

     
     for(int i = 0; i < faces.length; i++)
     {
       noFill();
       stroke(255, 0, 0);
       strokeWeight(3);
       
       rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
       
       
       noses = opencv.detect();
       println(noses.length + " nose");
       
         for(int j = 0; j < noses.length; j++)
         {
           stroke(0, 255, 0);
           strokeWeight(3);
           ellipse(noses[j].x, noses[j].y, noses[j].width, noses[j].height);
         }
     }
    
    // end code
    
  //image(opencv.getInput(), 0, 0);
  }
}

void initCamera()
{
  String[] cameras = Capture.list();
  if (cameras.length != 0) 
  {
    println("Using camera: " + cameras[0]); 
    cam = new Capture(this, cameras[0]);
    cam.start();    
    
    while(!cam.available()) print();
    
    cam.read();
    cam.loadPixels();
  }
  else
  {
    println("There are no cameras available for capture.");
    exit();
  }
}
