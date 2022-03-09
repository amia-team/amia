//::///////////////////////////////////////////////
//:: Divine Shield
//:: x0_s2_divshield.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Up to [turn undead] times per day the character may add his Charisma bonus to his armor
    class for a number of rounds equal to the Charisma bonus.

    MODIFIED 20 DEC 2005
    + Added visual candy, with thanks to Aleph. - PaladinOfSune
    MODIFIED 18 SEPT 2012
    + Changed the visual candy - Glim
    MODIFIED 10 APRIl 2013
    + Changed so it properly refreshes duration on use
	MODIFIED 9 MARCH 2022
	+ Changed to no longer include divine champion in level calculation
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Sep 13, 2002
//:://////////////////////////////////////////////
#include "x0_i0_spells"

void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        return;
   }

   if(GetHasFeat(414) == TRUE)
   {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        int nLevel = GetLevelByClass(CLASS_TYPE_PALADIN)+GetLevelByClass(CLASS_TYPE_CLERIC)+GetLevelByClass(CLASS_TYPE_BLACKGUARD);

        effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        effect eGlow = EffectVisualEffect(VFX_DUR_GLOW_WHITE);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
        effect eAC = EffectACIncrease( nCharismaBonus > nLevel ? nLevel : nCharismaBonus );
        effect eLink = EffectLinkEffects(eAC, eDur);

         // * Do not allow this to stack
        RemoveEffectsFromSpell(oTarget, GetSpellId());

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 474, FALSE));

        //FALL HACK! Mwhahahaha
        if ( GetLocalInt( oTarget, "Fallen" ) == 1 ){
                FloatingTextStringOnCreature( "The plea to your deity is not heard...", oTarget, FALSE );
                return;
        }

        eLink = SupernaturalEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGlow, oTarget, RoundsToSeconds(nCharismaBonus));
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);

    }
}



