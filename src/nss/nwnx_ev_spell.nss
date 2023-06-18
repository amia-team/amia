#include "inc_nwnx_events"
#include "nwnx_creature"

// Opustus 6/18/23 added cantrip restoration for wiz and sorc.

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

    // Restore cantrips for wizard and sorcerer.
    if(GetLevelByClass(CLASS_TYPE_WIZARD, oCaster) > 0)
    {
       NWNX_Creature_RestoreSpells(oCaster, 0);
    }
    if (GetLevelByClass(CLASS_TYPE_SORCERER, oCaster) > 0)
    {
       NWNX_Creature_RestoreSpells(oCaster, 0);
    }
}