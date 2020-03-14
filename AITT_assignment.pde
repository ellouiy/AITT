import gab.opencv.*;
import processing.video.*;
import processing.sound.*;
import java.awt.Rectangle;
import themidibus.*;

OpenCV faceopencv, noseopencv, mouthopencv, eyeopencv;

SoundFile file;
Capture cam;

Rectangle[] faces;
Rectangle[] noses;
Rectangle[] mouths;
Rectangle[] eyes;
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
  eyeopencv = new OpenCV(this, cam.width, cam.height);

  yerder = loadImage("infant_yerder.png");

  surface.setResizable(true);
  surface.setSize(faceopencv.width, faceopencv.height);

  faceopencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  noseopencv.loadCascade(OpenCV.CASCADE_NOSE);
  mouthopencv.loadCascade(OpenCV.CASCADE_MOUTH);
  eyeopencv.loadCascade(OpenCV.CASCADE_EYE);


  file = new SoundFile(this, "Cantina.mp3");
  //MidiBus.list();


  s = "infant yerder";

  font1 = createFont("Comic Sans MS Bold", 12);
  textFont(font1);

  cam.start();
  file.play();
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

    //println(flowLengthY);

    if (flowLengthY > 260 && flowLengthX > 200)
    {
      // println("I'M SPEEDING UP...\n");
      file.rate(1.2);
    }

    if (flowLengthY < 250)
    {
      file.rate(1);
      //println("I'M SLOWING DOWN...");
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
