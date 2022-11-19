////////////////////////////////////////////////////////////////
// Circle of Balance     Druid Grove System (MagnumMan         )
// Copyright (C) 2004 by James E. King, III (jking@prospeed.net)
//                       Valdor Dormanigon  (Archdruid         )
//                                                             )
// 2022-11-09 - Added scale to default to fix bug (by frozen   )
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

    effect ePolymorph;

    int lastshape = GetLocalInt(oElvoriel, "elvoriel_poly" );
    if (++lastshape > 6)
        lastshape = 1;

    switch (lastshape) {
        case 1: ePolymorph = EffectPolymorph(POLYMORPH_TYPE_BADGER);       break;
        case 2: ePolymorph = EffectPolymorph(POLYMORPH_TYPE_BOAR);         break;
        case 3: ePolymorph = EffectPolymorph(POLYMORPH_TYPE_BROWN_BEAR);   break;
        case 4: ePolymorph = EffectPolymorph(POLYMORPH_TYPE_DIRE_PANTHER); break;
        case 5: ePolymorph = EffectPolymorph(POLYMORPH_TYPE_DIRETIGER);    break;
        case 6: ePolymorph = EffectPolymorph(POLYMORPH_TYPE_PIXIE);        break;
    }

    effect eSFX = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);

    ApplyEffectToObject(DURATION_TYPE_INSTANT  , eSFX      , oElvoriel,  3.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePolymorph, oElvoriel, 60.0f);
    SetLocalInt(oElvoriel, "elvoriel_poly", lastshape);
    SetObjectVisualTransform( oElvoriel, 10, 1.0);
}
