import processing.sound.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

OpenCV faceopencv, noseopencv, mouthopencv, eyeopencv;
Capture cam;

Rectangle[] faces, noses, mouths, pairsOfEyes;
Character[] characters = new Character[4];
String[] names = new String[4];

String maskName, musicName, nameOne, nameTwo, nameThree, nameFour;
SoundFile starWars, mario, harryPotter, thomasTheTankEngine;
PFont font1;
PVector averageFlowFace, averageFlowHand;
PImage starWarsMask, harryPotterMask, trainMask, marioMask;

int count, flowScaleFace, flowScaleHand, effectCounter, totalTime, savedTime, passedTime;

float faceFlowLengthY, faceFlowLengthX, handFlowLengthX, handFlowLengthY;
boolean canChangeEffect, canChangeMask, noCrossing;

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

  canChangeEffect = false;
  canChangeMask = false;
  noCrossing = false;
  count = 0;
  effectCounter = 0;
  flowScaleFace = 50;
  flowScaleHand = 30;

  bp = new BandPass(this);
  reverb = new Reverb(this);

  nameOne = "Infant Yerder";
  nameTwo = "Game Man";
  nameThree = "Wizard Boy";
  nameFour = "T R A I N";

  font1 = createFont("Comic Sans MS Bold", 12);
  textFont(font1);

  names[0] = nameOne;
  names[1] = nameTwo;
  names[2] = nameThree;
  names[3] = nameFour;

  savedTime = millis();

  starWarsMask = loadImage("infant_yerder.png");
  marioMask = loadImage("game man.png");
  harryPotterMask = loadImage("magic boy.png");
  trainMask = loadImage("train.png");

  starWars = new SoundFile(this, "Music/Cantina_Rag.mp3"); //https://freemusicarchive.org/music/Jackson_F_Smith/Jackson_Frederick_Smith/Cantina_Rag
  mario = new SoundFile(this, "Music/Super_Mario_remix.mp3"); //https://freemusicarchive.org/music/Bacalao/Cheat_Codes/05_Bacalao_-_Super_Mario_remix
  harryPotter = new SoundFile(this, "Music/Mystery.wav");  //https://incompetech.com/music/royalty-free/index.html?isrc=USUAN1100812&fbclid=IwAR0JeKpKHL3D6Ycn777XkeKwbRrnPc-fAKVW8Ol1HzTTTkuHq5_1QJQcxkQ
  thomasTheTankEngine = new SoundFile(this, "Music/Thomas the Tank Engine.mp3"); //https://www.youtube.com/watch?v=FCbqZjKUhMw

  Character space = new Character(starWarsMask, starWars, faceX - cam.width/10, faceY - cam.height/7, faceWidth + faceWidth*1.2, faceHeight +  faceHeight*1.2);
  Character gameMan = new Character(marioMask, mario, faceX - cam.width/10, faceY - cam.height/7, faceWidth + faceWidth*1.2, faceHeight +  faceHeight*1.2);
  Character wizardBoy = new Character(harryPotterMask, harryPotter, faceX, faceY, faceWidth, faceHeight);
  Character train = new Character(trainMask, thomasTheTankEngine, faceX - faceWidth/2, faceY - faceHeight*0.8, faceWidth + faceWidth, faceHeight +  faceHeight);

  characters[0] = space;
  characters[1] = gameMan;
  characters[2] = wizardBoy;
  characters[3] = train;

  characters[count].sound().amp(0.4); 
  characters[count].sound().play();

  cam.start();
  timer(5000);
}

void draw() 
{
  if (cam.available())
  {    
    cam.read();
    cam.loadPixels();
    faceopencv.loadImage((PImage)cam);
    eyeopencv.loadImage((PImage)cam);

    passedTime = millis() - savedTime;
    stroke(255);
    strokeWeight(2);

    image(cam, 0, 0);
    faces = faceopencv.detect();
    pairsOfEyes = eyeopencv.detect();

    textFont(font1);
    textSize(32);
    stroke(92, 109, 196);
    fill(255, 300);
    text(names[count], (cam.width /6)*2, (cam.height/6)*5);
    
    //change effect line. 
    line(0, cam.height/6, cam.width, cam.height/6);

    //CHANGE MASK LINE
    line(cam.width/6, 0, cam.width/6, cam.height);
    
    //setCoordinates();
    faceDetection();
    calculateOpticalFlow();
    changeMasks();
    
    int warning = #FF6666;
    int legal = #5EFF00;
    
    println("passed time = " + passedTime);
    
    if(passedTime > 5000 )//&& noCrossing == false)
    {
      fill(legal, 80);
      noStroke();
      rect(0,0, cam.width/5, cam.height);
      rect(0, 0, cam.width, cam.height/5);
      
    }
    if(passedTime <= 5000 )//&& noCrossing == true)
    {
      //noCrossing = false;
      fill(warning, 80);
      rect(0,0, cam.width/5, cam.height);
      rect(0, 0, cam.width, cam.height/5);
    }
    
    triggerMusicEffectChange();
    changeMusicEffect();
  }
}

void triggerMusicEffectChange()
{
  if (faceY < cam.height/5 && canChangeEffect == false)
  {
    canChangeEffect = true;
  }
  if (faceY > cam.height/5 && canChangeEffect == true)
  {
    effectCounter++;
    canChangeEffect = false;
  }
}

void changeMusicEffect()
{
 // timer(1000);
  if (effectCounter == 1)
  {
    reverb.stop();
    changeVolume();
    println("I'm now changing VOLUME");
  } else if (effectCounter == 2)
  {
    characters[count].sound().amp(0.8);
    //music1[count].amp(0.8);
    changeSpeed(); 
    println("I'm now changing SPEED");
  } else if (effectCounter == 3)
  {
    characters[count].sound().rate(1);
    //music1[count].rate(1);
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
    //music1[count-1].stop();
    characters[count-1].sound().stop();
    //and the next song starts playing
    checkCounter();

    characters[count].sound().play();
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
  if (faceX < cam.width/6 && canChangeMask == false)
  {
    canChangeMask = true;
  }
  if (faceX > cam.width/6 && canChangeMask == true)
  {
    count++;
    canChangeMask = false;

    loadMask();
    //timer(2000);
    changeMusic();
    timer(5000); //show a sign to the user that they should not touch the line during this time
    
    noCrossing = true;
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
