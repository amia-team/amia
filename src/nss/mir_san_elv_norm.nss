////////////////////////////////////////////////////////////////
// Circle of Balance     Druid Grove System (MagnumMan         )
// Copyright (C) 2004 by James E. King, III (jking@prospeed.net)
//                       Valdor Dormanigon  (Archdruid         )
////////////////////////////////////////////////////////////////
//
// Elvoriel likes to change shapes sometimes.
//
////////////////////////////////////////////////////////////////

#include "nw_i0_spells"
//#include "mir_grove_util"

void main()
{
    object oElvoriel = GetObjectByTag("mir_san_elvoriel");
    if (!GetIsObjectValid(oElvoriel))
        return;

    effect ePolymorph = GetFirstEffect(oElvoriel);
    while (GetIsEffectValid(ePolymorph)) {
        if (GetEffectType(ePolymorph) == EFFECT_TYPE_POLYMORPH) {
            effect eSFX = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSFX, oElvoriel, 3.0f);
            RemoveEffect(oElvoriel, ePolymorph);
            break;
        }
    }
}
