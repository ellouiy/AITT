class Character
{
   Character(PImage mask, SoundFile music)
   {
     currentMask = mask;
     musicChoice = music;
   }
     
   
   SoundFile sound()
   {
      return musicChoice;
   }
   
   PImage maskChoice()
   {
    return currentMask; 
   }
  
}
