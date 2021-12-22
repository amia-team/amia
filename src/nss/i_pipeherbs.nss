// Mathias' Illegal Pipe Herbs item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 12/08/2003 jpavelch         Initial Release
//

#include "x2_inc_switches"


// Generates a silly effect on the PC after using (smoking) some of Mathias'
// pipeweed.  The effect lasts 20 seconds.
//
void ActivatePipeHerbs( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    effect ePipeweed =  EffectLinkEffects(
                            EffectStunned(),
                            EffectVisualEffect(VFX_DUR_PARALYZE_HOLD)
                        );
    effect eCessate = EffectVisualEffect( VFX_DUR_CESSATE_NEUTRAL );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePipeweed, oPC, 20.0 );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eCessate, oPC, 20.0 );

    DelayCommand( 20.0, PlayVoiceChat(VOICE_CHAT_LAUGH, oPC) );
}


void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivatePipeHerbs( );
            break;
    }
}
