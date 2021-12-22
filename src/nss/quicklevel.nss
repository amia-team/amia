/*
  Quick 2-3 level up script for NPC. Will also give 5k gold.
  - Maverick00053
*/


void main()
{

   object oPC = GetLastSpeaker();
   int iXP = GetXP(oPC);

   if ( oPC == OBJECT_INVALID ){

        oPC = GetLastUsedBy();
   }

   // Checks to see they are below level 3
   if(iXP < 3000)
   {
     SetXP(oPC,3000);
     GiveGoldToCreature(oPC,5000);
     FloatingTextStringOnCreature("Level 3 and 5k gold granted!", oPC, TRUE);
   }


}
