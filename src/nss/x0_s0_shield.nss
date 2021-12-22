//::///////////////////////////////////////////////
//:: Shield
//:: x0_s0_shield.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Immune to magic Missile
    +4 general AC
    DIFFERENCES: should be +7 against one opponent
    but this cannot be done.
    Duration: 1 turn/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003

// Updated 17/02/2012 by PaladinOfSune; Abjuration focus buffs.

#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    int nMetaMagic = GetMetaMagicFeat();
    int nShieldBonus;
    effect eShieldBonus;

    effect eArmor = EffectACIncrease(4, AC_DEFLECTION_BONUS);
    effect eSpell = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
    effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);

    // Uses from item doesn't receive spell focus bonus
    if( !GetIsObjectValid( GetSpellCastItem( ) ) )
    {
        // Seek out Spell Foci
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
        {
            nShieldBonus = 50;
        }
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
        {
            nShieldBonus = 25;
        }
        else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
        {
            nShieldBonus = 5;
        }
    }

    effect eLink = EffectLinkEffects(eArmor, eDur);
    eLink = EffectLinkEffects(eLink, eSpell);

    if( nShieldBonus > 0 )
    {
        eShieldBonus = EffectDamageImmunityIncrease( DAMAGE_TYPE_MAGICAL, nShieldBonus );
        eLink = EffectLinkEffects( eLink, eShieldBonus );
    }

    int nDuration = GetCasterLevel(OBJECT_SELF); // * Duration 1 turn
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }
    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 417, FALSE));

    RemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());

    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}



