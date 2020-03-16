import processing.sound.*;

float q0, q1, q2, q3, q4;

BandPass bp;
Reverb reverb;

void changeVolume()
{
  if (faceX > q0 && faceX < q1)
  {
    music1[count].amp(0.25);
  } else if (faceX > q1 && faceX < q2)
  {
    music1[count].amp(0.5);
  } else if (faceX > q2 && faceX < q3)
  {
    music1[count].amp(1);
  } else if (faceX > q3 && faceX < q4)
  {
    music1[count].amp(2);
  }
}

void changeSpeed()
{
  if (faceX > q0 && faceX < q1)
  {
    music1[count].rate(0.25);
  } else if (faceX > q1 && faceX < q2)
  {
    music1[count].rate(0.5);
  } else if (faceX > q2 && faceX < q3)
  {
    music1[count].rate(1);
  } else if (faceX > q3 && faceX < q4)
  {
    music1[count].rate(2);
  }
}

void applyBandPass()
{
  //https://www.youtube.com/watch?v=SGFJMwr-IqA

  if (faceX > q0 && faceX < q1)
  {
    bp.set(500, 40);
    bp.process(music1[count]);
  } else if (faceX > q1 && faceX < q2)
  {
    bp.set(600, 60);
    bp.process(music1[count]);
  } else if (faceX > q2 && faceX < q3)
  {
    bp.set(700, 80);
    bp.process(music1[count]);
  } else if (faceX > q3 && faceX < q4)
  {
    bp.set(800, 100);
    bp.process(music1[count]);
  }
}

void addReverb()
{
  if (faceX > q0 && faceX < q1)
  {
    reverb.process(music1[count]);
    reverb.wet(0);
  } else if (faceX > q1 && faceX < q2)
  {
    reverb.process(music1[count]);
    reverb.wet(0.25);
  } else if (faceX > q2 && faceX < q3)
  {
    reverb.process(music1[count]);
    reverb.wet(0.5);
  } else if (faceX > q3 && faceX < q4)
  {
    reverb.process(music1[count]);
    reverb.wet(0.75);
  }
}
