//::///////////////////////////////////////////////
//:: Lesser Spell Breach
//:: NW_S0_LsSpBrch.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes 2 spell protection from an enemy mage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 10, 2002
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
    // Can't dispel Time Stopped creatures
    if( GetHasSpellEffect( SPELL_TIME_STOP, GetSpellTargetObject() ) ) {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_GLOBE_USE ), GetSpellTargetObject() );
        return;
    }

    object oTarget = GetSpellTargetObject();
    string oTargetSubrace = GetSubRace(oTarget);
    int nSR = 0;
    if(oTargetSubrace == "Drow" || oTargetSubrace == "Svirfneblin")
    {
        nSR = 0;
    }
    else
    {
        nSR = 3;
    }


    DoSpellBreach(oTarget, 2, nSR, GetSpellId());
}
