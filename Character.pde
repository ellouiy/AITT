class Character
{
   SoundFile chosenMusic;
   PImage maskNow;
   
   Character(PImage mask, SoundFile music, float x, float y, float xOffset, float yOffset)
   {
     maskNow = mask;
     chosenMusic = music;
   }
   
   SoundFile sound()
   {
      return chosenMusic;
   }
   
   PImage maskChoice()
   {
    return maskNow; 
   }
}
