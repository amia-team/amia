//::///////////////////////////////////////////////
//:: Wounding Whispers
//:: x0_s0_WoundWhis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Magical whispers cause 1d8 sonic damage to attackers who hit you.
    Made the damage slightly more than the book says because we cannot
    do the +1 per level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Modified for wounding whispers, July 30 2002, Brent
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003
//  7/15/2106   msheeler    moved damage from declarations to inside spell cast event so it rolls damage each hit
//                          added code for handling maximize and empower

#include "x2_inc_spellhook"
#include "x0_i0_spells"
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
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = OBJECT_SELF;
    effect eShield = EffectDamageShield (nDuration, DAMAGE_BONUS_1d6, DAMAGE_TYPE_SONIC);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);



    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 441, FALSE));

    if (GetHasSpellEffect(GetSpellId()))
    {
        RemoveSpellEffects(GetSpellId(),OBJECT_SELF,OBJECT_SELF);
    }

    if ( GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD) ) {
        RemoveSpellEffects(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, oTarget );
    }
    if ( GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH) ) {
        RemoveSpellEffects(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, oTarget );
    }
    if ( GetHasSpellEffect(SPELL_DEATH_ARMOR) ) {
        RemoveSpellEffects(SPELL_DEATH_ARMOR, OBJECT_SELF, oTarget );
    }


    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        eShield = EffectDamageShield (nDuration + 6, 0, DAMAGE_TYPE_SONIC);
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        eShield = EffectDamageShield (nDuration, DAMAGE_BONUS_2d6, DAMAGE_TYPE_SONIC);
    }

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}
