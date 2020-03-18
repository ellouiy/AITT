import ddf.minim.*;
import processing.sound.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;


OpenCV faceopencv, noseopencv, mouthopencv, eyeopencv, handopencv;
Capture cam;

Rectangle[] faces, noses, mouths, pairsOfEyes;

String s, maskName, musicName;
SoundFile starWars, mario, harryPotter, thomasTheTankEngine, musicChoice;
SoundFile[] music1 = new SoundFile[5]; //I'm aware this is bad practice, but I need music1[] to be a global variable so I can use it elsewhere at runtime. If I instantiate it in setup() then music1[] is not recognised elsewhere.
PFont font1;
PVector averageFlowFace, averageFlowHand;

int count, flowScaleFace, flowScaleHand, effectCounter, totalTime, savedTime;
int passedTime;
float faceFlowLengthY, faceFlowLengthX, handFlowLengthX, handFlowLengthY;

boolean canChangeEffect, canChangeMask;

void setup() 
{  
  initCamera();
  faceopencv = new OpenCV(this, cam.width, cam.height);
  noseopencv = new OpenCV(this, cam.width, cam.height);
  mouthopencv = new OpenCV(this, cam.width, cam.height);
  eyeopencv = new OpenCV(this, cam.width, cam.height);
  handopencv = new OpenCV(this, cam.width/5, cam.height); //for some reason the camera opens to this size

  surface.setResizable(true);
  surface.setSize(faceopencv.width, faceopencv.height);
  surface.setSize(eyeopencv.width, eyeopencv.height);
  surface.setSize(handopencv.width, handopencv.height);

  faceopencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  noseopencv.loadCascade(OpenCV.CASCADE_NOSE);
  mouthopencv.loadCascade(OpenCV.CASCADE_MOUTH);
  eyeopencv.loadCascade(OpenCV.CASCADE_EYE);
 // handopencv.loadCascade("haarcascade_smile.xml"); //this xml I downloaded from github does not load...license information in folder 

  //handopencv.setROI(cam.width / 9, cam.width/6, cam.width / 5, cam.height / 4);

  //waitPeriod = false;
  canChangeEffect = false;
  canChangeMask = false;
  count = 0;
  effectCounter = 0;
  flowScaleFace = 50;
  flowScaleHand = 30;

  bp = new BandPass(this);
  reverb = new Reverb(this);

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
  //totalTime = 5000;
  savedTime = millis();

  starWars = new SoundFile(this, "Music/Cantina_Rag.mp3"); //https://freemusicarchive.org/music/Jackson_F_Smith/Jackson_Frederick_Smith/Cantina_Rag
  mario = new SoundFile(this, "Music/Super_Mario_remix.mp3"); //https://freemusicarchive.org/music/Bacalao/Cheat_Codes/05_Bacalao_-_Super_Mario_remix
  harryPotter = new SoundFile(this, "Music/Mystery.wav");  //https://incompetech.com/music/royalty-free/index.html?isrc=USUAN1100812&fbclid=IwAR0JeKpKHL3D6Ycn777XkeKwbRrnPc-fAKVW8Ol1HzTTTkuHq5_1QJQcxkQ
  thomasTheTankEngine = new SoundFile(this, "Music/Thomas the Tank Engine.mp3"); //https://www.youtube.com/watch?v=FCbqZjKUhMw

  music1[0]= starWars;
  music1[1] = mario;
  music1[2] = harryPotter;
  music1[3] = thomasTheTankEngine;

  cam.start();
  timer(5000);
  music1[count].amp(0.8);
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
    handopencv.loadImage((PImage)cam);

    passedTime = millis() - savedTime;
    stroke(255);
    strokeWeight(2);

    image(cam, 0, 0);
    faces = faceopencv.detect();
    pairsOfEyes = eyeopencv.detect();

    textFont(font1);
    text(s, 300, 70);
    
    //change effect line. 
    line(0, cam.height/5, cam.width, cam.height/5);
    
    println("I'm cam.height / 5 " + cam.height/5);
    println("I'm cam.width / 6 " + cam.width/6);
    //CHANGE MASK LINE
    line(cam.width/6, 0, cam.width/6, cam.height);
    
    faceDetection();
    calculateOpticalFlow();
    changeMasks();
   triggerMusicEffectChange();
   changeMusicEffect();
   
  }
}



void triggerMusicEffectChange()
{
  
  //line(0,0, cam.height, cam.height/5);
   if (faceY < cam.height/5 && canChangeEffect == false)
  {
    canChangeEffect = true;
    
    //timer(1000);
  }
  if(faceY > cam.height/5 && canChangeEffect == true)
  {
    effectCounter++;
    canChangeEffect = false;
  }
}

void changeMusicEffect()
{
  timer(1000);
  if (effectCounter == 1)
  {
    reverb.stop();

    changeVolume();
   println("I'm now changing VOLUME");
  } else if (effectCounter == 2)
  {
    music1[count].amp(0.8);

    changeSpeed(); 
    println("I'm now changing SPEED");
  } else if (effectCounter == 3)
  {
    music1[count].rate(1);
    applyBandPass();

  } else if (effectCounter == 0)
  {
    bp.stop();
    addReverb();
    println("REVERB");
  }
  checkCounter();
}

void changeMusic()
{

  if (count > 0 ) //if the value is larger than 0
  {//make sure the previous song stops
    music1[count-1].stop();

    //and the next song starts playing
    checkCounter();
    music1[count].play();
  }
}

void calculateOpticalFlow()
{
  faceopencv.calculateOpticalFlow();

  averageFlowFace = faceopencv.getAverageFlow();

  faceFlowLengthY = noseopencv.height/2 + averageFlowFace.y*flowScaleFace;
  faceFlowLengthX = noseopencv.width/2 + averageFlowFace.x*flowScaleFace;

  // println(faceFlowLengthX + " THIS IS FACE X");
  // println(faceFlowLengthY + " THIS IS FACE Y");
}

void changeMasks()
{
  if(faceX < cam.width/6 && canChangeMask == false)
  {
    canChangeMask = true;
   }
  if(faceX > cam.width/6 && canChangeMask == true)
  {
     count++;
     canChangeMask = false;
     
     loadMask();
     timer(2000);
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
