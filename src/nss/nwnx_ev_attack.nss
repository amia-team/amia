#include "inc_nwnx_events"

void main(){

    object oPC = OBJECT_SELF;
    object oTarget = EVENTS_GetTarget( 0 );
    object oArea = GetArea( oPC );

    if ( GetLocalInt( oArea, "NoCasting" ) == 1  &&
         GetIsDM( oPC ) == FALSE &&
         GetIsDMPossessed( oPC ) == FALSE &&
         GetLocalInt( GetModule(), "singleplayer" ) != 1 ){

        SendMessageToPC( oPC, "- You cannot attack stuff in this area! -" );

        EVENTS_Bypass( );
        return;
    }

    if( GetIsPC( oTarget ) && GetIsPC( oPC ) && GetIsReactionTypeNeutral( oTarget, oPC ) ){
        SetPCDislike( oPC, oTarget );
    }
}
