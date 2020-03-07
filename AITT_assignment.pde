import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;
import com.corajr.loom.*;
import themidibus.*;

OpenCV faceopencv, noseopencv, mouthopencv;
Loom loom;
Pattern pat1;
MidiBus myBus;

Capture cam;

Rectangle[] faces;
Rectangle[] noses;
Rectangle[] mouths;
String s;

PImage yerder;
PFont font1;

PVector averageFlow;

int flowScale = 50;
float flowLengthY;
float flowLengthX;

void setup() 
{
  //size(10, 10);

  initCamera();
  faceopencv = new OpenCV(this, cam.width, cam.height);
  noseopencv = new OpenCV(this, cam.width, cam.height);
  mouthopencv = new OpenCV(this, cam.width, cam.height);

  yerder = loadImage("big_dog.png");

  surface.setResizable(true);
  surface.setSize(faceopencv.width, faceopencv.height);
  surface.setSize(noseopencv.width, noseopencv.height);
  surface.setSize(mouthopencv.width, mouthopencv.height);

  faceopencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  noseopencv.loadCascade(OpenCV.CASCADE_NOSE);
  mouthopencv.loadCascade(OpenCV.CASCADE_MOUTH);

  /*loom = new Loom(this, 160);
   pat1 = new Pattern(loom);
   
   myBus = new MidiBus(this, -1, "No1 Baby");
   loom.setMidiBus(myBus);
   */

  //pat1.extend("0110111011");
  //pat1.add("clap");

  s = "infant yerder";

  font1 = createFont("Comic Sans MS Bold", 12);
  textFont(font1);

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

    faceDetection();


    //OPTICAL FLOW
    faceopencv.calculateOpticalFlow();
    //image(cam, 0, 0);
    //translate(cam.width, 0);
    //stroke(255, 0, 0);

    //faceopencv.drawOpticalFlow();

    averageFlow = faceopencv.getAverageFlow();


    stroke(255);
    strokeWeight(2);
    flowLengthY = noseopencv.height/2 + averageFlow.y*flowScale;
    flowLengthX = noseopencv.width/2 + averageFlow.x*flowScale;
    line(noseopencv.width/2, noseopencv.height/2, flowLengthX, flowLengthY);

    if (flowLengthY > 250 && flowLengthX > 200)
    {
      println("I'M HERE I'M HERE PLS NOTICE ME");
    }
  }
}

void faceDetection() {

  for (int i = 0; i < faces.length; i++)
  {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(3);
    //println(faces.length + " face" );
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);

    noseopencv.loadImage((PImage) cam);
    noseopencv.setROI((faces[i].x), (faces[i].y), faces[i].width, faces[i].height);
    noses = noseopencv.detect();

    for (int j = 0; j < noses.length; j++)
    {
      stroke(0, 255, 0);
      strokeWeight(3);
      //  println(noses.length + " nose");

      //ellipse((faces[i].x + noses[j].x), (faces[i].y + noses[j].y), noses[j].width, noses[j].height)

      mouthopencv.loadImage((PImage) cam);
      mouthopencv.setROI((faces[i].x), (faces[i].y), faces[i].width, faces[i].height);
      mouths = mouthopencv.detect();

      for (int m = 0; m < mouths.length; m++)
      {
        stroke(0, 255, 0);
        strokeWeight(3);
        //   println(mouths.length + " mouths");

        image(yerder, faces[i].x-40, faces[i].y-20, faces[i].width+100, faces[i].height+50);
      }
      mouthopencv.releaseROI();
    }
    noseopencv.releaseROI();
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
