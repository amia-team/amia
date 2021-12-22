#include "inc_nwnx_events"
#include "x2_inc_switches"
void main(){

    object oPC = OBJECT_SELF;
    SetUserDefinedItemEventNumber( X2_ITEM_EVENT_INSTANT );
    ExecuteScriptAndReturnInt( "i_" + GetTag( EVENTS_GetTarget( 0 ) ), oPC );

    effect eEffect = GetFirstEffect( oPC );
    while( GetIsEffectValid( eEffect ) ){

        if( GetEffectType( eEffect ) == EFFECT_TYPE_DAZED ){

            SendMessageToPC( oPC, "That action is not allowed in your current state." );
            EVENTS_Bypass();
            return;
        }

        eEffect = GetNextEffect( oPC );
    }
}
