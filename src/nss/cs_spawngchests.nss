//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"



// Every hour a set of chests may be spawned in the Gauntlet of Terror
void main(){

    // vars
    object oCustomTrigger=OBJECT_SELF;
    object oPC=GetEnteringObject();

    // respawn chests only once per hour
    if(GetLocalInt(
        oCustomTrigger,
        "cs_gauntlet_chest_respawn_time")==1){

        //log_to_exploits( oPC, "gauntlet", "Blocked", 0 );

        SendMessageToPC(
            oPC,
            "- The gauntlet feels quiet and dismal, no magic lurks within... -");

        return;

    }

    SendMessageToPC(
        oPC,
        "- You feel a tingle ripple up your spine, magic lurks within! -");

        //log_to_exploits( oPC, "gauntlet", "Unblocked", 0 );

    string  szChestResRef="gauntletchest00";
    string  szChestWP="gchest_wp00";
    object  oChest1WP=GetWaypointByTag(szChestWP+"1"),oChest2WP=GetWaypointByTag(szChestWP+"2"),
            oChest3WP=GetWaypointByTag(szChestWP+"3");

    // debug
    if( (oChest1WP==OBJECT_INVALID) ||
        (oChest2WP==OBJECT_INVALID) ||
        (oChest3WP==OBJECT_INVALID) ){

        //log_to_exploits( oPC, "gauntlet", "Can't find WPs", 0 );

        return;

    }

    // create the three chests, at their designated wp's
    int nChestNumber=1;
    for(nChestNumber;nChestNumber<4;nChestNumber++){

        object oGauntletChest=CreateObject(
            OBJECT_TYPE_PLACEABLE,
            szChestResRef + IntToString(nChestNumber),
            GetLocation(GetWaypointByTag(szChestWP + IntToString(nChestNumber))),
            FALSE);

        if ( GetIsObjectValid( oGauntletChest ) ){

            //log_to_exploits( oPC, "gauntlet", "Spawned chest", nChestNumber );

        }

        // automatically despawn after 30 minutes
        DelayCommand(
            1800.0,
            DestroyObject(oGauntletChest));

    }

    // set respawn timer for 1 hour
    SetLocalInt(
        oCustomTrigger,
        "cs_gauntlet_chest_respawn_time",
        1);

    DelayCommand(
        3600.0,
        SetLocalInt(
            oCustomTrigger,
            "cs_gauntlet_chest_respawn_time",
            0));

}
