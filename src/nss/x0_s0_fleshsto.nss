//::///////////////////////////////////////////////
//:: Flesh to Stone
//:: x0_s0_fleshsto
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: The target freezes in place, standing helpless.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: October 16, 2002
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

// @@@ AmiaAddition leave this overridden to prevent permanent petrification

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
    object oTarget = GetSpellTargetObject();
    int nDuration1 = 5;
    int nDuration2 = GetCasterLevel(OBJECT_SELF);
    effect eConDecrease = EffectAbilityDecrease(ABILITY_CONSTITUTION, 2);
    effect eStrDecrease = EffectAbilityDecrease(ABILITY_STRENGTH, 2);


    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, OBJECT_SELF))
    {
        nDuration1 = 6;
    }

    if (MyResistSpell(OBJECT_SELF,oTarget) <1)
    {
        if ( GetHasEffect( EFFECT_TYPE_PETRIFY, oTarget ))
        {
            return;
        }
        else
        {
            if ( GetHasSpellEffect( GetSpellId(), oTarget ))
                {
                    DoPetrification(nDuration1, OBJECT_SELF, oTarget, GetSpellId(), GetSpellSaveDC());
                }
            else
            {
                DoPetrification(nDuration1, OBJECT_SELF, oTarget, GetSpellId(), GetSpellSaveDC());
                ApplyEffectToObject (DURATION_TYPE_TEMPORARY, eConDecrease, oTarget, RoundsToSeconds(nDuration2));
                ApplyEffectToObject (DURATION_TYPE_TEMPORARY, eStrDecrease, oTarget, RoundsToSeconds(nDuration2));
            }
        }
    }
}
