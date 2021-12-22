// Script to dismiss companion.

void main()
{

// Declare variables.

object oPC = GetPCSpeaker();

object oTarget;
oTarget = GetObjectByTag("koloth");

int nInt;
nInt = GetObjectType(oTarget);

// Apply a fancy visual before destroying companion.

if (nInt != OBJECT_TYPE_WAYPOINT) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oTarget);
else ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oTarget));

oTarget = GetObjectByTag("koloth");

DestroyObject(oTarget, 3.0);

}

