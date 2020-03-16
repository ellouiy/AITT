import ddf.minim.*;
import processing.sound.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;


OpenCV faceopencv, noseopencv, mouthopencv, eyeopencv;
Capture cam;

Rectangle[] faces, noses, mouths, pairsOfEyes;

String s, maskName, musicName;
SoundFile starWars, mario, harryPotter, thomasTheTankEngine;
SoundFile[] music1 = new SoundFile[5];
PFont font1;
PVector averageFlow;

int count, flowScale;
float flowLengthY, flowLengthX;

boolean waitPeriod;

void setup() 
{  
  initCamera();
  faceopencv = new OpenCV(this, cam.width, cam.height);
  noseopencv = new OpenCV(this, cam.width, cam.height);
  mouthopencv = new OpenCV(this, cam.width, cam.height);
  eyeopencv = new OpenCV(this, cam.width, cam.height);

  surface.setResizable(true);
  surface.setSize(faceopencv.width, faceopencv.height);
  surface.setSize(eyeopencv.width, eyeopencv.height);

  faceopencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  noseopencv.loadCascade(OpenCV.CASCADE_NOSE);
  mouthopencv.loadCascade(OpenCV.CASCADE_MOUTH);
  eyeopencv.loadCascade(OpenCV.CASCADE_EYE);

  waitPeriod = false;
  count = 0;
  flowScale = 50;
 
  loadImage("infant_yerder.png");
  loadImage("princess_buns.png");
  loadImage("nerf_herder.png");
  loadImage("big_dog.png");
  
  q4 = cam.width;
  q3 = 0.75 * cam.width;
  q2 = 0.5 * cam.width;
  q1 = 0.25 * cam.width;
  q0 = 0;

  s = "infant yerder";
  font1 = createFont("Comic Sans MS Bold", 12);
  textFont(font1);
  
   
  starWars = new SoundFile(this, "Cantina_Rag.mp3"); //https://freemusicarchive.org/music/Jackson_F_Smith/Jackson_Frederick_Smith/Cantina_Rag
  mario = new SoundFile(this, "Super_Mario_remix.mp3"); //https://freemusicarchive.org/music/Bacalao/Cheat_Codes/05_Bacalao_-_Super_Mario_remix
  harryPotter = new SoundFile(this, "Mystery.wav");  //https://incompetech.com/music/royalty-free/index.html?isrc=USUAN1100812&fbclid=IwAR0JeKpKHL3D6Ycn777XkeKwbRrnPc-fAKVW8Ol1HzTTTkuHq5_1QJQcxkQ
  thomasTheTankEngine = new SoundFile(this, "Thomas the Tank Engine.mp3"); //https://www.youtube.com/watch?v=FCbqZjKUhMw
  
  music1[0]= starWars;
  music1[1] = mario;
  music1[2] = harryPotter;
  music1[3] = thomasTheTankEngine;
  
  cam.start();
  music1[count].play();
}

void draw() 
{
  if (cam.available())
  {    
    cam.read();
    cam.loadPixels();
    faceopencv.loadImage((PImage)cam);
    eyeopencv.loadImage((PImage)cam);

    image(cam, 0, 0);
    faces = faceopencv.detect();
    pairsOfEyes = eyeopencv.detect();
    
    textFont(font1);
    text(s, 300, 70);

    faceDetection();
    changeVolume();
    calculateOpticalFlow();
  }
}

void changeMusic()
{
      if(count > 0 && waitPeriod == true) //if the value is larger than 0
        {//make sure the previous song stops
          music1[count-1].stop();

          waitPeriod = false;
          //and the next song starts playing
          restartCounter();
          music1[count].play();
        }
}

void calculateOpticalFlow()
{
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
    //line(noseopencv.width/2, noseopencv.height/2, flowLengthX, flowLengthY);

    println(flowLengthX + " THIS IS X");
    println(flowLengthY + " THIS IS Y");
    if(flowLengthX > 400 && flowLengthY > 250 && waitPeriod == true)
    {
      count++;
      changeMusic();
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
