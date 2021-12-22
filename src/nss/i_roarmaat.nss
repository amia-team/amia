// Roar of the Ma'at
//
// Uses one Bard Song per use, lasts Round/Bard level. Creates a 10
// meter aura, and enemies which enter the aura must roll
// Concentration vs Taunt or suffer -4 AB.  Allies which enter the
// aura gain +20% physical damage immunity.  The caster gains
// +20% physical damage immunity, but suffers -4 AC and -50% str
// modified damage.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/14/2012 Mathias          Initial Release.
//

#include "amia_include"
#include "x2_inc_switches"

void ActivateItem( ) {

    // Variables
    object oPC          = GetItemActivator();
    object oWidget      = GetItemActivated();
    int    nBardLevel   = GetLevelByClass( CLASS_TYPE_BARD, oPC );
    int    nStrMod      = GetAbilityModifier( ABILITY_STRENGTH, oPC );
    int    nDMGLoss     = nStrMod / 2;
    effect eAOE         = EffectAreaOfEffect(AOE_MOB_DRAGON_FEAR, "cs_roarmaat_a", "****", "cs_roarmaat_b");
    effect eACLoss      = EffectACDecrease(4);
    effect eRedGlow     = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);
    effect eSResist     = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 20);
    effect ePResist     = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 20);
    effect eBResist     = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 20);
    effect eHowl        = EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR_2);
    effect eHowl2       = EffectVisualEffect(VFX_FNF_HOWL_ODD);
    effect eAOEVFX      = EffectVisualEffect( VFX_DUR_AURA_DRAGON_FEAR );
    effect eLink;
    effect eDMGLoss;
    int    bDebug       = FALSE;  // set to TRUE to see debug messages

    // Exit if PC has no more bard song uses.
    if ( !GetHasFeat( FEAT_BARD_SONGS, oPC ) ) {
        FloatingTextStringOnCreature( "- You do not have any remaining uses for this ability! -", oPC, FALSE );
        return;
    }

    // Prevent stacking.
    if ( GetIsBlocked( oPC, "roar_on" ) > 0 ) {
        FloatingTextStringOnCreature( "- This ability is already active! -", oPC, FALSE );
        return;
    }

    // STR damage loss.
    if ( nDMGLoss < 1 ) nDMGLoss = 0;
    eDMGLoss = EffectDamageDecrease( nDMGLoss );

    // !!DEBUG!!
    if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oPC) + " takes -4 AC, -" + IntToString(nDMGLoss) + " to damage, and receives 20% resistance to physical damage. -" ); }


    // Link effects
    eLink   = EffectLinkEffects(eAOE, eACLoss);
    eLink   = EffectLinkEffects(eRedGlow, eLink);
    eLink   = EffectLinkEffects(eDMGLoss, eLink);
    eLink   = EffectLinkEffects(eSResist, eLink);
    eLink   = EffectLinkEffects(ePResist, eLink);
    eLink   = EffectLinkEffects(eBResist, eLink);
    eLink   = EffectLinkEffects(eAOEVFX, eLink);

    // Apply effects to caster.
    DelayCommand( 0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds( nBardLevel ) ) );

    // Instant howl VFX.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHowl, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHowl2, oPC);

    // Decrement a feat usage.
    DecrementRemainingFeatUses( oPC, FEAT_BARD_SONGS );

    // Set stackage prevention time.
    SetBlockTime( oPC, 0, FloatToInt( RoundsToSeconds( nBardLevel ) ), "roar_on" );
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
