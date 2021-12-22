// OnUsed event of Guantlet of Terror floor lever.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/14/2003 jpavelch         Initial Release.
//


// Returns TRUE if PC has all three items required to open the door.  Also
// will move those items back to their respective chests if the PC does
// possess them.
//
int GetPCHasItems( object oPC )
{
    object oItem1 = GetItemPossessedBy( oPC, "GauntletPass1" );
    if ( !GetIsObjectValid(oItem1) ) return FALSE;

    object oItem2 = GetItemPossessedBy( oPC, "GauntletPass2" );
    if ( !GetIsObjectValid(oItem2) ) return FALSE;

    object oItem3 = GetItemPossessedBy( oPC, "GauntletPass3" );
    if ( !GetIsObjectValid(oItem3) ) return FALSE;

    AssignCommand( GetObjectByTag("GauntletChest_1"), ActionTakeItem(oItem1, oPC) );
    AssignCommand( GetObjectByTag("GauntletChest_2"), ActionTakeItem(oItem2, oPC) );
    AssignCommand( GetObjectByTag("GauntletChest_3"), ActionTakeItem(oItem3, oPC) );

    return TRUE;
}


// If PC has all three pass items opens door and moves items back to their
// respective chests.
//
void main()
{
    object oPC = GetLastUsedBy( );
    if ( !GetIsPC(oPC) ) return;

    PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );
    DelayCommand( 0.5, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE) );

    if ( GetPCHasItems(oPC) ) {
        FloatingTextStringOnCreature(
            "You feel an unknown force all about your body.",
            oPC
        );
        object oDoor = GetObjectByTag( "GauntletExit" );
        AssignCommand( oDoor, ActionOpenDoor(oDoor) );
    } else {
        FloatingTextStringOnCreature(
            "You feel an unknown force all about your body.  Perhaps it is searching for something?",
            oPC
        );
    }
}
