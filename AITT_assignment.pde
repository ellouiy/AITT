import gab.opencv.*;
import processing.video.*;
import processing.sound.*;
import java.awt.Rectangle;
import themidibus.*;

OpenCV faceopencv, noseopencv, mouthopencv, eyeopencv;


Capture cam;

Rectangle[] faces, noses, mouths, eyes;

String s, maskName, musicName;



String[] music = {"Cantina.mp3", "scifi.mp3", "jazz.mp3"};
SoundFile[] musicFiles = new SoundFile[music.length];
SoundFile currentFile;

PFont font1;

PVector averageFlow;

int flowScale = 50, faceX, faceY, faceWidth, faceHeight;
int count;
float flowLengthY, flowLengthX;

void setup() 
{
  //size(10, 10);

  initCamera();
  faceopencv = new OpenCV(this, cam.width, cam.height);
  noseopencv = new OpenCV(this, cam.width, cam.height);
  mouthopencv = new OpenCV(this, cam.width, cam.height);
  eyeopencv = new OpenCV(this, cam.width, cam.height);

  surface.setResizable(true);
  surface.setSize(faceopencv.width, faceopencv.height);

  faceopencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  noseopencv.loadCascade(OpenCV.CASCADE_NOSE);
  mouthopencv.loadCascade(OpenCV.CASCADE_MOUTH);
  eyeopencv.loadCascade(OpenCV.CASCADE_EYE);

  count = 0;

 
  loadImage("infant_yerder.png");
  loadImage("princess_buns.png");
  loadImage("nerf_herder.png");
  loadImage("big_dog.png");
  
  currentFile = new SoundFile(this, "Cantina.mp3");
  //MidiBus.list();
  s = "infant yerder";
  font1 = createFont("Comic Sans MS Bold", 12);
  textFont(font1);

  cam.start();
  currentFile.play();
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
      println("I'M SPEEDING UP...\n");
      //file.rate(1.2);
    }

    if (flowLengthY < 250)
    {
      //file.rate(1);
      //println("I'M SLOWING DOWN...");
    }
    
    println(flowLengthX + " THIS IS X");
    println(flowLengthY + " THIS IS Y");
    if(flowLengthX > 400 && flowLengthY > 260)
    {
      count++;
    }
  }
}

void mousePressed() 
{
  count++;
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
