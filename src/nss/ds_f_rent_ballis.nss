// Reworked the faction ballista
// Author: Maverick00053

void main()
{
    string sDeny;
    object oPC = GetLastUsedBy();
    location lWaypoint = GetLocalLocation(oPC, "ballista_loc");

    if (!GetIsPC(oPC)) return;



     if(GetLocalInt(oPC,"ballista_delay") == 1)
     {


     AssignCommand(oPC, ActionSpeakString("*Must wait 60 seconds to fully reload the ballista!*"));


     }
     else
     {





    if (GetItemPossessedBy(oPC, "ballista_bolt")== OBJECT_INVALID)
    {

     CreateItemOnObject("ballista_bolt", oPC);
     AssignCommand(oPC, ActionSpeakString("*Bolt obtained, use it to lock in the location and load it and then click the ballista again to fire it at the target location!*"));


    }
    else if((GetIsObjectValid(GetItemPossessedBy(oPC, "ballista_bolt"))) && GetIsObjectValid(GetAreaFromLocation(lWaypoint)))
    {

     AssignCommand(oPC, ActionSpeakString("*The magical ballista fires off an magical bolts at the targeted area!*"));
     AssignCommand(oPC, ActionCastSpellAtLocation(SPELL_EPIC_HELLBALL, lWaypoint, METAMAGIC_MAXIMIZE, TRUE, PROJECTILE_PATH_TYPE_DEFAULT,TRUE));

     SetLocalInt(oPC,"ballista_delay", 1);
     DelayCommand(60.0,DeleteLocalInt(oPC,"ballista_delay"));
     DeleteLocalLocation(oPC, "ballista_loc");

    }
    else if((GetIsObjectValid(GetItemPossessedBy(oPC, "ballista_bolt"))) && !GetIsObjectValid(GetAreaFromLocation(lWaypoint)))
    {

      AssignCommand(oPC, ActionSpeakString("*You already have a bolt, use it to lock in the location and load it and then click the ballista again to fire it at the target location!*"));


    }

    }

}
