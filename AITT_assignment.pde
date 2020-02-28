import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;
import com.corajr.loom.*;

OpenCV faceopencv, noseopencv;
Loom loom;
Pattern pat1;

Capture cam;

Rectangle[] faces;
Rectangle[] noses;
String s;

PImage yerder;
PFont font1;

void setup() 
{
  size(10, 10);

  initCamera();
  faceopencv = new OpenCV(this, cam.width, cam.height);
  noseopencv = new OpenCV(this, cam.width, cam.height);
  
  //yerder = loadImage("baby (2).png");
  yerder = loadImage("trump.png");

  surface.setResizable(true);
  surface.setSize(faceopencv.width, faceopencv.height);
  surface.setSize(noseopencv.width, noseopencv.height);

  faceopencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  noseopencv.loadCascade(OpenCV.CASCADE_NOSE);

  loom = new Loom(this, 160);
  pat1 = new Pattern(loom);
  
  s = "infant yerder";
  font1 = loadFont("starjout.ttf");
  
  cam.start();
}

void draw() 
{
  if (cam.available())
  {    
    cam.read();
    cam.loadPixels();
    faceopencv.loadImage((PImage)cam);
   
    image(cam, 0, 0);
    faces = faceopencv.detect();
   textFont(font1);
   text(s, 300, 70);
    
    for (int i = 0; i < faces.length; i++)
    {
      noFill();
      stroke(255, 0, 0);
      strokeWeight(3);
      println(faces.length + " face" );
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    
      
      noseopencv.loadImage((PImage) cam);
      noseopencv.setROI((faces[i].x), (faces[i].y), faces[i].width, faces[i].height);
      noses = noseopencv.detect();

      for (int j = 0; j < noses.length; j++)
      {
        stroke(0, 255, 0);
        strokeWeight(3);
        println(noses.length + " nose");
      
        image(yerder, faces[i].x-20, faces[i].y-30, faces[i].width+50, faces[i].height+50);
        //ellipse((faces[i].x + noses[j].x), (faces[i].y + noses[j].y), noses[j].width, noses[j].height);
       
      }
     noseopencv.releaseROI();
    }

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

    while (!cam.available()) print();

    cam.read();
    cam.loadPixels();
  } else
  {
    println("There are no cameras available for capture.");
    exit();
  }
}
