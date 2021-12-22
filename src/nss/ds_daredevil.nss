/*  ds_daredevil

14 oct 2008 Terra: using ds_drown() from amia_include instead

*/



//-------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    //make a variable on the object called target
    //

    object oPC      = GetLastUsedBy();
    object oTarget;
    int nDC         = GetLocalInt( OBJECT_SELF, "dc" );
    int nDexMod     = GetAbilityModifier( ABILITY_DEXTERITY, oPC );
    int nResult     = 10 + nDexMod + d20();

    if ( ( nResult ) >= nDC ) {

        oTarget  = GetWaypointByTag( GetLocalString( OBJECT_SELF, "target" ) + "_pass" );
        SendMessageToPC( oPC, "You manage to swing onto the opposite boat in a piratey fashion!" );
        SendMessageToPC( oPC, "Succes: "+IntToString( nResult )+" vs DC "+IntToString( nDC ) );
    }
    else{

        oTarget  = GetWaypointByTag( GetLocalString( OBJECT_SELF, "target" ) + "_miss" );
        SendMessageToPC( oPC, "You try to swing onto the deck of the closest boat but fall into the water instead." );
        SendMessageToPC( oPC, "Equip underwater gear or you will drown in 30 seconds!" );
        SendMessageToPC( oPC, "Failed: "+IntToString( nResult )+" vs DC "+IntToString( nDC ) );
        DelayCommand( 30.0, ds_drown( oPC ) );
    }

    DelayCommand( 0.0, AssignCommand( oPC, JumpToObject( oTarget, 0 ) ) );
}
