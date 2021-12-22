//::///////////////////////////////////////////////
//:: Blood Frenzy
//:: x0_s0_bldfrenzy.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Similar to Barbarian Rage.
    +2 Strength, Con. +1 morale bonus to Will
    -1 AC
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 19, 2002
//:: ------------------
//:: Date       Name                Description
//:: 2012/02/10 Naivatkal           Remade to follow new progression.
//:: 2012/02/19 PaladinOfSune       Bug fixes.
//:: 2012/05/21 Glim                Disable AB bonus on Clerics.
//:://////////////////////////////////////////////
//:: VFX Pass By:
#include "x2_inc_spellhook"
#include "inc_td_shifter"

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



    if(!GetHasSpellEffect(422))
    {
        //Declare major variables
        int nCasterLevel = GetNewCasterLevel( OBJECT_SELF );
        int nDuration;
        int nCastClass = GetLastSpellCastClass();
        object oTarget = OBJECT_SELF;

        if( GetIsPolymorphed( OBJECT_SELF ) )
        {
            nDuration = 10;
        }
        else
        {
             nDuration = nCasterLevel;
        }


        int nMetaMagic = GetMetaMagicFeat();
        if (nMetaMagic == METAMAGIC_EXTEND)
        {
            if( !GetIsPolymorphed( OBJECT_SELF ) )
            {
                nDuration = nDuration * 2;
            }
        }

        PlayVoiceChat(VOICE_CHAT_BATTLECRY1);

        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eABIncrease;
        effect eACDecrease;
        effect eRegen;
        effect eDamageIncrease;
        effect eSaveInc;
        effect eLink;

        // Begin Amia custom changes
        if ( nCastClass != CLASS_TYPE_DRUID ) {
            if ( nCasterLevel >= 1 && nCasterLevel <= 9 )
            {
                eABIncrease = EffectAttackIncrease(1, ATTACK_BONUS_MISC);
                eACDecrease = EffectACDecrease(1, AC_DODGE_BONUS);
                eLink = EffectLinkEffects(eABIncrease, eACDecrease);
            }
            else
            {
                eABIncrease = EffectAttackIncrease(2, ATTACK_BONUS_MISC);
                eACDecrease = EffectACDecrease(1, AC_DODGE_BONUS);
                eLink = EffectLinkEffects(eABIncrease, eACDecrease);
                eRegen = EffectRegenerate(1, 6.0);
                eLink = EffectLinkEffects(eLink, eRegen);
            }

        }
        else {

            if ( nCasterLevel >= 1 && nCasterLevel <= 9 )
            {
                eABIncrease = EffectAttackIncrease(1, ATTACK_BONUS_MISC);
                eACDecrease = EffectACDecrease(1, AC_DODGE_BONUS);
                eLink = EffectLinkEffects(eABIncrease, eACDecrease);
            }
            else if ((nCasterLevel >= 10) && (nCasterLevel <= 14))
            {
                eABIncrease = EffectAttackIncrease(2, ATTACK_BONUS_MISC);
                eACDecrease = EffectACDecrease(1, AC_DODGE_BONUS);
                eLink = EffectLinkEffects(eABIncrease, eACDecrease);
                eRegen = EffectRegenerate(1, 6.0);
                eLink = EffectLinkEffects(eLink, eRegen);
            }
            else if ((nCasterLevel >= 15) && (nCasterLevel <= 19))
            {
                eABIncrease = EffectAttackIncrease(3, ATTACK_BONUS_MISC);
                eRegen = EffectRegenerate(1, 6.0);
                eLink = EffectLinkEffects(eABIncrease, eRegen);
            }
            else if ((nCasterLevel >= 20) && (nCasterLevel <= 24))
            {
                eABIncrease = EffectAttackIncrease(4, ATTACK_BONUS_MISC);
                eRegen = EffectRegenerate(1, 6.0);
                eLink = EffectLinkEffects(eABIncrease, eRegen);
                eDamageIncrease = EffectDamageIncrease(1, DAMAGE_TYPE_BASE_WEAPON);
                eLink = EffectLinkEffects(eLink, eDamageIncrease);
            }
            else if ((nCasterLevel >= 25) && (nCasterLevel <= 29))
            {
                eABIncrease = EffectAttackIncrease(5, ATTACK_BONUS_MISC);
                eRegen = EffectRegenerate(2, 6.0);
                eLink = EffectLinkEffects(eABIncrease, eRegen);
                eDamageIncrease = EffectDamageIncrease(2, DAMAGE_TYPE_BASE_WEAPON);
                eLink = EffectLinkEffects(eLink, eDamageIncrease);
            }
            else //30
            {
                eABIncrease = EffectAttackIncrease(6, ATTACK_BONUS_MISC);
                eRegen = EffectRegenerate(2, 6.0);
                eLink = EffectLinkEffects(eABIncrease, eRegen);
                eDamageIncrease = EffectDamageIncrease(3, DAMAGE_TYPE_BASE_WEAPON);
                eLink = EffectLinkEffects(eLink, eDamageIncrease);
                eSaveInc = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL);
                eLink = EffectLinkEffects(eLink, eSaveInc);
            }
       }

        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, 422, FALSE));

        //Make effect extraordinary
        eLink = MagicalEffect(eLink);
        effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE); //Change to the Rage VFX

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) ;
    }
}
