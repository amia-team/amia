#include "nw_i0_tool"

void main()
{
   object oPC = GetClickingObject();
   int iHas1;
   if (HasItem(oPC, "jj_elvishwriting_1"))
        iHas1 = 1;
   int iHas2;
   if (HasItem(oPC, "jj_elvishwriting_2"))
        iHas2 =  1;
   int iHas3;
   if (HasItem(oPC, "jj_elvishwriting_3"))
        iHas3 = 1;
   int iHas4;
   if (HasItem(oPC, "jj_elvishwriting_4"))
        iHas4 = 1;
   int iHas5;
   if (HasItem(oPC, "jj_elvishwriting_5"))
        iHas5 = 1;
   int iHas = iHas1 + iHas2 + iHas3 + iHas4 + iHas5;
   if (iHas1 && iHas2 && iHas3 && iHas4 && iHas5)
   {
     ActionSpeakString("*The door opens as speak the elvish phrase*");
     ActionDoCommand(SetLocked(OBJECT_SELF, FALSE));
     ActionOpenDoor(OBJECT_SELF);
     DelayCommand(10.0, SetLocked(OBJECT_SELF, TRUE));
   }
}
