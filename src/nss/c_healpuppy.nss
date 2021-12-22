// Script to heal companion upon selection.

void main()
   {

// Declare variables.

    object oPC = GetPCSpeaker();
    object oTarget;

    oTarget = OBJECT_SELF;

    effect eEffect;
    eEffect = EffectHeal(750);

// Apply effect.

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 1.0f);

}

