//::///////////////////////////////////////////////
//:: Divine Might
//:: x0_s2_divmight.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Up to (turn undead amount) per day the character may add his Charisma bonus to all
    weapon damage for a number of rounds equal to the Charisma bonus.

    MODIFIED JULY 3 2003
    + Won't stack
    + Set it up properly to give correct + to hit (to a max of +20)

    MODIFIED SEPT 30 2003
    + Made use of new Damage Constants

    MODIFIED DEC 20 2005
    + Added in visual candy, with thanks to Aleph. - PaladinOfSune

    2007-04-20 Disco Changed visual fx ADDPROP_POLICY
    2008-06-24 Terra VFX to secondary weapon +1 round to the VFX durination

    MODIFIED 18 SEPT 2012
    + Changed the visual candy - Glim

    MODIFIED 10 APRIl 2013
    + Changed so it properly refreshes duration on use
    */
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Sep 13 2002
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "x2_inc_itemprop"
void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        return;
   }

   if(GetHasFeat(413) == TRUE)
   {
        //Declare major variables
        object oTarget              = GetSpellTargetObject();
        object oMyWeapon            =  GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget);
         object oMySecondWeapon     =  GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oTarget);
        int nLevel = GetLevelByClass(CLASS_TYPE_PALADIN)+GetLevelByClass(CLASS_TYPE_CLERIC)+GetLevelByClass(CLASS_TYPE_BLACKGUARD)+GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION);

        effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        itemproperty ipGlow=ItemPropertyVisualEffect(ITEM_VISUAL_SONIC);

        int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);

        if (nCharismaBonus>0)
        {
            int nDamage1 = IPGetDamageBonusConstantFromNumber(nCharismaBonus > nLevel ? nLevel:  nCharismaBonus);

            effect eDamage1 = EffectDamageIncrease(nDamage1,DAMAGE_TYPE_DIVINE);

            effect eLink = EffectLinkEffects(eDamage1, eDur);

            //FALL HACK! Mwhahahaha
            if ( GetLocalInt( oTarget, "Fallen" ) == 1 ){
                FloatingTextStringOnCreature( "The plea to your deity is not heard...", oTarget, FALSE );
            }

            eLink = SupernaturalEffect(eLink);

            // * Do not allow this to stack
            RemoveEffectsFromSpell(oTarget, GetSpellId());

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DIVINE_MIGHT, FALSE));

            //Apply Link and VFX effects to the target
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            IPSafeAddItemProperty( oMyWeapon, ipGlow, RoundsToSeconds(nCharismaBonus+1));
            if(!GetIsObjectValid(oMySecondWeapon))
            IPSafeAddItemProperty( oMySecondWeapon, ipGlow, RoundsToSeconds(nCharismaBonus+1));
        }

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
    }
}



