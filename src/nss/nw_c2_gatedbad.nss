//::///////////////////////////////////////////////
//:: Custom On Spawn In
//:: nw_c2_gatedbad
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Balor will destroy self after 1 minute
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "NW_O2_CONINCLUDE"
#include "NW_I0_GENERIC"

void main(){

    DestroyObject(OBJECT_SELF, 60.0);
    effect e = EffectVisualEffect(VFX_IMP_UNSUMMON);
    location lLoc = GetLocation(OBJECT_SELF);
    DelayCommand(59.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, e, lLoc));

}

