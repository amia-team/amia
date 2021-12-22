/*  i_shadowport

    --------
    Verbatim
    --------
    Custom item for shadowdancers, to teleport short distances.

    ---------
    Changelog
    ---------

    Date    Name        Reason
    ------------------------------------------------------------------
    050106  Disco       Corrected OnActivate event
    ------------------------------------------------------------------


*/

#include "x2_inc_switches"

void ActivateItem(){

    // vars
    object oPC=GetItemActivator();
    object oArea=GetArea(oPC);

    // resolve shadowjump use status
    if(GetLocalInt(
        oArea,
        "CS_NO_SHADOWJUMP")==1){

        // warn the player
        FloatingTextStringOnCreature(
            "- You are unable to Shadow Jump in this area! -",
            oPC,
            FALSE);

        return;

    }

    if (GetIsObjectValid(GetItemActivatedTarget())){

        return;

    }

    object oTarget=GetItemActivator();

    // Visual effects to be applied to the item user.
    int nInt;
    nInt = GetObjectType(oTarget);

    if (nInt != OBJECT_TYPE_WAYPOINT)
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_DEATH_WARD),
            oTarget);

    else
        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_DEATH_WARD),
            GetLocation(oPC));

    oTarget=GetItemActivatedTarget();

    // The location to be ported to is the item's target. ;)

    location lTarget;
    lTarget=GetItemActivatedTargetLocation();

    // The PC will only jump if the location is valid. Otherwise, the script ends.

    if(GetAreaFromLocation(lTarget)==OBJECT_INVALID)
        return;

    // Clear all actions and teleport PC, and end the script!
    AssignCommand(
        oPC,
        ClearAllActions());

    AssignCommand(
        oPC,
        ActionJumpToLocation(lTarget));

}



void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}



