/*  i_flight

    --------
    Verbatim
    --------
    Custom script for people with wings to fly short distances.

    ---------
    Changelog
    ---------

    Date    Name        Reason
    ------------------------------------------------------------------
    050106  Disco       Corrected OnActivate event & layout (*sniggers*)
    ------------------------------------------------------------------


*/
#include "x2_inc_switches"

void ActivateItem(){

    // vars
    object oPC;
    object oArea=GetArea(oPC);

    // resolve area flight status
    if(GetLocalInt(oArea,"CS_NO_FLY")==1){

        // warn the player
        FloatingTextStringOnCreature("- You are unable to fly in this area! -",oPC,FALSE);
        return;

    }

    // Check if item target is a valid target, otherwise end the script.
    if(GetIsObjectValid(GetItemActivatedTarget())){

        return;

    }

    // Now, to fly the PC using the superman animations. ;)
    effect eFly;
    location lTarget;
    oPC=GetItemActivator();

    /*  Here, we declare the varables. The location is the area targeted with the item,
        and the flying animation is the superman appearance and disappearance.          */

    lTarget=GetItemActivatedTargetLocation();
    eFly=EffectDisappearAppear(lTarget);

    // The duration of the superman effect is four seconds, for particularly mountainous areas.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFly,oPC,4.0);
}



void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}


