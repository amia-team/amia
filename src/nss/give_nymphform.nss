//::///////////////////////////////////////////////
//:: FileName give_nymphform
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 05/03/2005 20:59:06
//:://////////////////////////////////////////////
void main()
{
    // Give the speaker the items
    CreateItemOnObject("nymphform", GetPCSpeaker(), 1);

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION), GetPCSpeaker() );
}
