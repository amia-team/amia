// Dart repeater trap, trigger it and it fires a single dart, which hurts!
void main(){

    // vars
    object oTrap=OBJECT_SELF;
    object oPC=GetEnteringObject();
    object oDartRepeater=GetNearestObjectByTag("cs_plc_drep1");

    // resolve PC status
    if(GetIsPC(oPC)==FALSE){

        return;

    }

    // sound anims
    DelayCommand(
        0.1,
        AssignCommand(
            oPC,
            PlaySound("gui_trapsetoff")));

    DelayCommand(
        0.9,
        AssignCommand(
            oPC,
            PlaySound("cb_ht_arrow1")));

    // warn the player
    FloatingTextStringOnCreature(
        "- A dart shoots out of the wall~! -",
        oPC,
        FALSE);

    // damage, reflex for 1/2
    int nDartDamage=GetReflexAdjustedDamage(
        d8(5),
        oPC,
        GetHitDice(oPC)+5,
        SAVING_THROW_TYPE_TRAP,
        oDartRepeater);

    // dart vfx
    AssignCommand(
        oDartRepeater,
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(359),
            oPC,
            0.0));

    // slap em
    DelayCommand(
        1.0,
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectLinkEffects(
                EffectDamage(
                    nDartDamage,
                    DAMAGE_TYPE_PIERCING),
                EffectVisualEffect(491)),
            oPC,
            0.0));

    return;

}
