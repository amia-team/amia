#include "inc_nwnx_events"

void main(){

    object oCaster = OBJECT_SELF;
    object oTarget = EVENTS_GetTarget( 0 );
    object oArea = GetArea( oCaster );

    if ( GetLocalInt( oArea, "NoCasting" ) == 1  &&
         GetIsDM( oCaster ) == FALSE &&
         GetIsDMPossessed( oCaster ) == FALSE &&
         GetLocalInt( GetModule(), "singleplayer" ) != 1 ){

        if( GetIsObjectValid( oTarget ) && GetIsDead( oTarget ) && GetIsPC( oTarget ) ){
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectResurrection( ), oTarget );
            SendMessageToPC( oCaster, "- Fixed that for you! -" );
        }
        else
            SendMessageToPC( oCaster, "- You cannot cast magic in this area! -" );

        EVENTS_Bypass( );
        return;
    }
}
