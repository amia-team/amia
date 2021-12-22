/*
   Demon Invasion Boss Script

   07/25/19 - Maverick00053

   Used with i_invasiongen


*/

void main()
{
   object oPC = GetItemActivator();
   object oItem = GetItemActivated();
   object oArea = GetArea(oPC);
   object oTarget = GetItemActivatedTarget();
   object oModule = GetModule();
   int nLieutenants = GetLocalInt(oArea,"InvasionLieutenants");
   int nCheckItem = GetLocalInt(oItem,"doublerun");
   string sLieutenants;
   string sItemResRef = GetResRef(oItem);
   string sTargetResRef = GetResRef(oTarget);



   if(sTargetResRef == "invasioncreat004")
   {

   // Extra check to make sure it doesnt delete the wrong item or double run the script.
   // Server is grumpy sometimes.
   if((sItemResRef == "invasionboss") && (nCheckItem == 0))
   {

   // Making sure it doesnt double run the script
   SetLocalInt(oItem,"doublerun",1);

   if((nLieutenants > 1) && (nLieutenants != 100))
   {
     nLieutenants = nLieutenants - 1;
     sLieutenants = IntToString(nLieutenants);
     SetLocalInt(oArea,"InvasionLieutenants", nLieutenants);
     AssignCommand(oPC,ActionSpeakString("The demonic creature leading this horde trembles as some of its magical protection shatters. Its body trembles and it lets out a violent roar as it renews its assault. The creatures defenses still hold, there are " + sLieutenants + " more barrier(s) remaining."));

   // Extra Checks to account for Amia server lag, and make sure it functions
   if(GetLocalInt(oArea,"InvasionLieutenants") != nLieutenants)
   {
     SetLocalInt(oArea,"InvasionLieutenants", nLieutenants);
   }

     DestroyObject(oItem);

   }
   else if((nLieutenants == 1) && (nLieutenants != 100))
   {
     SetLocalInt(oArea,"InvasionLieutenants", 100);
     AssignCommand(oPC,ActionSpeakString("The last barrier shatters and the demonic leader spews forth a slew of curses in abyssal. Its flesh is now vulnerable!"));
     SetPlotFlag(oTarget, 0);

   // Extra Checks to account for Amia server lag, and make sure it functions
   if(GetLocalInt(oArea,"InvasionLieutenants") != 100)
   {
     SetLocalInt(oArea,"InvasionLieutenants", 100);
   }

     DestroyObject(oItem);



   }

}
}
}
