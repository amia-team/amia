#include "inc_nwnx_events"

void main(){

    object oCaster = OBJECT_SELF;
    object oArea = GetArea( oCaster );

    if ( GetLocalInt( oArea, "NoCasting" ) == 1  &&
         GetIsDM( oCaster ) == FALSE &&
         GetIsDMPossessed( oCaster ) == FALSE &&
         GetLocalInt( GetModule(), "singleplayer" ) != 1 ){

        SendMessageToPC( oCaster, "- You cannot use feats in this area! -" );

        EVENTS_Bypass( );
        return;
    }
}
