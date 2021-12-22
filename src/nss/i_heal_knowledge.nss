// Item event script for the healing knowledge item. Gives +10 Heal for Turn/Level.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 22/01/2011 PaladinOfSune    Initial Release

#include "x2_inc_switches"
#include "amia_include"

void ActivateItem()
{
    // Major variables.
    object oPC  = GetItemActivator();
    int nLevel  = GetHitDice( oPC );
    effect eBonus = EffectSkillIncrease( SKILL_HEAL, 10 );
    effect eVFX = EffectVisualEffect( VFX_IMP_MAGICAL_VISION );
    float fDuration = TurnsToSeconds( nLevel );

    // Prevent stacking.
    if ( GetIsBlocked( oPC, "heal_widget_active" ) > 0 ) {
        FloatingTextStringOnCreature( "<cþ>- You cannot stack this effect! -</c>", oPC, FALSE );
        return;
    }

    // Apply the Heal bonus for Turns/Level.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBonus, oPC, fDuration );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oPC );

    // Block time to prevent stacking.
    SetBlockTime( oPC, 1, FloatToInt( fDuration ), "heal_widget_active" );
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
