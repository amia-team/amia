// Script for a shell to spawn a black pearl once per reset;
// one in four chance.

#include "NW_O2_CONINCLUDE"

void main()
{

   // Variables.
   int nRandom = Random(4) + 1 ;

   // If shell already searched, return.
   if (GetLocalInt(OBJECT_SELF,"PearlShell") != 0)
      {
      return;
      }

   // If a one is rolled, spawn the pearl.
   if((nRandom) == 1) {

      object oLastOpener = GetLastOpener();
      CreateItemOnObject("blackpearl", OBJECT_SELF, 1);
      SetLocalInt(OBJECT_SELF, "PearlShell",1);

   }

   // Otherwise, don't spawn it.
   else if((nRandom) =! 1) {

      SetLocalInt(OBJECT_SELF, "PearlShell", 1);

   }

}


