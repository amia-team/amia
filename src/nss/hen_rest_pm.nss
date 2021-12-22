//:://////////////////////////////////////////////////
//:: X0_CH_HEN_REST
/*
  OnRest event handler for henchmen/associates.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/06/2003
//:://////////////////////////////////////////////////

void main()
{

    effect eVFX = EffectVisualEffect(VFX_IMP_UNSUMMON);
    object oHench = OBJECT_SELF;
    location lLocation = GetLocation(oHench);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lLocation);
    SetLocalInt(oHench,"respawnoff",1);
    DestroyObject(oHench,0.1);

}
