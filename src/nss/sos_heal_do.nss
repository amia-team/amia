// Executed with the altar as OBJECT_SELF so conversation does not end
// when talking to Leidende and she (or the altar) harms you.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2005/01/12 jking            Initial Release.
//

void main()
{
    object oPC     = GetLocalObject(OBJECT_SELF, "object_to_harm");
    int    iDamage = GetLocalInt   (OBJECT_SELF, "amount_to_harm");

    effect eZap    = EffectVisualEffect(VFX_BEAM_LIGHTNING);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eZap, oPC, 1.0f);

    effect eVisual = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    effect eDamage = EffectDamage      (iDamage, DAMAGE_TYPE_ELECTRICAL);
    effect eLink   = EffectLinkEffects (eVisual, eDamage);

    DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oPC));
}

