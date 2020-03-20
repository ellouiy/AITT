import processing.sound.*;

float q0, q1, q2, q3, q4;

BandPass bp;
Reverb reverb;

void changeVolume()
{

  if (faceFlowLengthX > 320 && faceFlowLengthX < 340)
  {
    characters[count].sound().amp(0.4);
    
    println("QUIET QUIET");

  } else if (faceFlowLengthX > 340 && faceFlowLengthX < 350)
  {
    characters[count].sound().amp(0.6);
    
    println("KINDA QUIET");
    // music1[count].amp(0.6);
  } else if (faceFlowLengthX > 350 && faceFlowLengthX < 365)
  {
    characters[count].sound().amp(0.8);
    
    println("LOUDER");
    
    // music1[count].amp(0.8);
  } else if (faceFlowLengthX > 365)// && faceFlowLengthY < 200)
  {
    characters[count].sound().amp(1);
    
    println("LOUDEST");
    //music1[count].amp(1);
  }
}

void changeSpeed()
{
  if (faceFlowLengthX > 320 && faceFlowLengthX < 340)
  {
    characters[count].sound().rate(0.5);
    //music1[count].rate(0.5);
  } else if (faceFlowLengthX > 340 && faceFlowLengthX < 350)
  {
    characters[count].sound().rate(0.75);
    //music1[count].rate(0.75);
  } else if (faceFlowLengthX > 350 && faceFlowLengthX < 365)
  {
    characters[count].sound().rate(1);
    // music1[count].rate(1);
  } else if (faceFlowLengthX > 365)
  {
    characters[count].sound().rate(1.2);
    //music1[count].rate(1.25);
  }
}

void applyBandPass()
{
  //https://www.youtube.com/watch?v=SGFJMwr-IqA

  if (faceFlowLengthX > 320 && faceFlowLengthX < 340)
  {
    bp.set(750, 150);
    bp.process(characters[count].sound());
    //bp.process(music1[count]);
  } else if (faceFlowLengthX > 340 && faceFlowLengthX < 350)
  {
    bp.set(1000, 200);
    bp.process(characters[count].sound());
    // bp.process(music1[count]);
  } else if (faceFlowLengthX > 350 && faceFlowLengthX < 365)
  {
    bp.set(1500, 250);
    bp.process(characters[count].sound());
    //bp.process(music1[count]);
  } else if (faceFlowLengthX > 365)
  {
    bp.set(2000, 300);
    bp.process(characters[count].sound());
    //bp.process(music1[count]);
  }
}

void addReverb()
{
  if (faceFlowLengthX > 320 && faceFlowLengthX < 340)
  {
    //reverb.process(music1[count]);
    reverb.wet(0.5);
    reverb.process(characters[count].sound());
  } else if (faceFlowLengthX > 340 && faceFlowLengthX < 350)
  {
    //reverb.process(music1[count]);
    reverb.wet(1);
    reverb.process(characters[count].sound());
  } else if (faceFlowLengthX > 350 && faceFlowLengthX < 365)
  {
    // NullPointerException here??? presumably because count has incremented too quickly and the music that is meant to play shown by count is not the same as the count that has incremented due to faceX being above the line. 
    // reverb.process(music1[count]);
    reverb.wet(1.5);
    reverb.process(characters[count].sound());
  } else if (faceFlowLengthX > 365)
  {
    // reverb.process(music1[count]);
    reverb.wet(2);
    reverb.process(characters[count].sound());
  }
}
