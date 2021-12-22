//Kamina 28/07/18
//:://////////////////////////////////////////////
void main()
{
    // Give the speaker the items
    CreateItemOnObject("polysdragshad", GetPCSpeaker(), 1);

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION), GetPCSpeaker() );
}
