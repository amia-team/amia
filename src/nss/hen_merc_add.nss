/*
     Henchmen Merc Add To Party
     - Maverick00053, 12/5/24
*/

void main()
{
  object oPC = GetLastSpeaker();
  object oMerc = OBJECT_SELF;
  AddHenchman(oPC,oMerc);
}
