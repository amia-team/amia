void main()
{
    // This is the Object to apply the effect to.
    object oPC = GetPCSpeaker();

    // Create the effect to apply
    effect eGhost = EffectCutsceneGhost();

    // Apply the effect to the object
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oPC);
}
