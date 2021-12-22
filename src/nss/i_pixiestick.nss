// Pixie Stick item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/19/2004 jpavelch         Initial Release
//

#include "x2_inc_switches"


void CastHaste( object oPC )
{
    effect eHaste = EffectHaste( );
    effect eDur = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );
    effect eLink = EffectLinkEffects( eHaste, eDur );

    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        eLink,
        oPC,
        20.0
    );
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_HASTE),
        oPC
    );
}


// Plays twitch animation and gives haste for 20 seconds.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    AssignCommand( oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM) );
    DelayCommand( 1.0, CastHaste(oPC) );

    DestroyObject( oItem );
}


void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
