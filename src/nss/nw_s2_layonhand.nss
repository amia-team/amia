//::///////////////////////////////////////////////
//:: Lay_On_Hands
//:: NW_S2_LayOnHand.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Paladin is able to heal his Chr Bonus times
    his level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:: Updated On: Oct 20, 2003
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "amx_fallcheck"
void main()
{

    if ( (IsSpecificFallen(OBJECT_SELF)) ||
         (!DeityCheck(OBJECT_SELF)) ){
        FloatingTextStringOnCreature( "The plea to your deity is not heard...", OBJECT_SELF, FALSE );
        return;
    }
    object oTarget = GetSpellTargetObject();

    int nChr = GetAbilityModifier(ABILITY_CHARISMA);
    if (nChr < 0)
    {
        nChr = 0;
    }
    int nLevel = GetLevelByClass(CLASS_TYPE_PALADIN);

    //--------------------------------------------------------------------------
    // July 2003: Add Divine Champion levels to lay on hands ability
    //--------------------------------------------------------------------------
    nLevel = nLevel + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION);

    //--------------------------------------------------------------------------
    // Caluclate the amount to heal, min is 1 hp
    //--------------------------------------------------------------------------
    int nHeal = nLevel * nChr;
    if(nHeal <= 0)
    {
        nHeal = 1;
    }
    effect eHeal = EffectHeal(nHeal);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eDam;
    int nTouch;

    //--------------------------------------------------------------------------
    // A paladin can use his lay on hands ability to damage undead creatures
    // having undead class levels qualifies as undead as well
    //--------------------------------------------------------------------------
    if( GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD ||
       GetLevelByClass(CLASS_TYPE_UNDEAD,oTarget)>0 )
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
        //Make a ranged touch attack
        nTouch = TouchAttackMelee(oTarget,TRUE);

        //----------------------------------------------------------------------
        // GZ: The PhB classifies Lay on Hands as spell like ability, so it is
        //     subject to SR. No more cheesy demi lich kills on touch, sorry.
        //----------------------------------------------------------------------
        int nResist = MyResistSpell(OBJECT_SELF,oTarget);
        if (nResist == 0 )
        {
            if(nTouch > 0)
            {
                if(nTouch == 2)
                {
                    nHeal *= 2;
                }

                if ( MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()) )
                    nHeal /= 2;

                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
                eDam = EffectDamage(nHeal, DAMAGE_TYPE_DIVINE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            }
        }
    }
    else
    {
//==============================================================================
//This is a new part as of Dec. 2007.  If the Paladin has the "Fall" item in the
//inventory, they will take the same damage as if they used it on undead, that is,
// CHA mod * Pally/DivineChamp Level.
        if( GetLocalInt( OBJECT_SELF, "Fallen" ) == 1 ){
                    FloatingTextStringOnCreature( "The plea to your deity is not heard...", OBJECT_SELF, FALSE );
        }
//==============================================================================

        else{
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS, FALSE));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}