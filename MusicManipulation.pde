import processing.sound.*;

float q0, q1, q2, q3, q4;

BandPass bp;
Reverb reverb;

void changeVolume()
{
  if (faceX > q0 && faceX < q1)
  {
    music1[count].amp(0);
  } else if (faceX > q1 && faceX < q2)
  {
    music1[count].amp(0.6);
  } else if (faceX > q2 && faceX < q3)
  {
    music1[count].amp(0.8);
  } else if (faceX > q3 && faceX < q4)
  {
    music1[count].amp(1);
  }
}

void changeSpeed()
{
  if (faceX > q0 && faceX < q1)
  {
    music1[count].rate(0.5);
  } else if (faceX > q1 && faceX < q2)
  {
    music1[count].rate(0.75);
  } else if (faceX > q2 && faceX < q3)
  {
    music1[count].rate(1);
  } else if (faceX > q3 && faceX < q4)
  {
    music1[count].rate(1.25);
  }
}

void applyBandPass()
{
  //https://www.youtube.com/watch?v=SGFJMwr-IqA

  if (faceX > q0 && faceX < q1)
  {
    bp.set(750, 150);
    bp.process(music1[count]);
  } else if (faceX > q1 && faceX < q2)
  {
    bp.set(1000, 200);
    bp.process(music1[count]);
  } else if (faceX > q2 && faceX < q3)
  {
    bp.set(1500, 250);
    bp.process(music1[count]);
  } else if (faceX > q3 && faceX < q4)
  {
    bp.set(2000, 300);
    bp.process(music1[count]);
  }
}

void addReverb()
{
  if (faceX > q0 && faceX < q1)
  {
    reverb.process(music1[count]);
    reverb.wet(0.5);
  } else if (faceX > q1 && faceX < q2)
  {
    reverb.process(music1[count]);
    reverb.wet(1);
  } else if (faceX > q2 && faceX < q3)
  {
    // NullPointerException here??? presumably because count has incremented too quickly and the music that is meant to play shown by count is not the same as the count that has incremented due to faceX being above the line. 
    reverb.process(music1[count]);
    reverb.wet(1.5);
  } else if (faceX > q3 && faceX < q4)
  {
    reverb.process(music1[count]);
    reverb.wet(2);
  }
}
