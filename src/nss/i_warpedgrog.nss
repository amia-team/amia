//Magically warped grog gives the PC a short boost of Regen and Damage Reduction, before
//damaging them for an equal amount and applying an AC Penalty

void main()
{
    //Define effects
    object oPC = GetItemActivator();
    effect eRed = EffectDamageReduction(10, 1, 0);
    effect eRegen = EffectRegenerate(3, 6.0);
    effect eAC = EffectACDecrease(2, AC_DODGE_BONUS);
    effect eDam = EffectDamage(30, DAMAGE_TYPE_ACID);
    effect eVis1 = EffectVisualEffect(VFX_FNF_HOWL_ODD);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEAD_ACID);
    effect eVis3 = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_ACID);

    //Take swig and Apply Beneficial effects to PC
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oPC, 60.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eRed, oPC, 60.0);

    //Fungal moonshine
    SendMessageToPC(oPC, "This stuff has got some kick! Oh, but the hangover...");
    DelayCommand(54.0, SendMessageToPC(oPC, "*Ominous gurgling...*"));
    DelayCommand(54.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oPC));

    //Apply Penalties after a minute
    DelayCommand(60.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oPC));
    DelayCommand(60.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC));
    DelayCommand(60.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 60.0));
}
