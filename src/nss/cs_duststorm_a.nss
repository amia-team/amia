// Dust Storm (OnEnter Aura)
//
// Creates an area of effect that blinds hostiles and the caster when inside.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/09/2012 Mathias          Initial Release.
//


void main()
{
    // Variables.
    object oCreature        = GetEnteringObject( );
    object oPC              = GetAreaOfEffectCreator( );
    effect eBlind           = EffectBlindness( );
    effect eVFX             = EffectVisualEffect( VFX_IMP_BLIND_DEAF_M );
    int    bDebug           = FALSE;  // set to TRUE to see debug messages

    // !!DEBUG!!
    if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oCreature) + " entered the aura." );  }

    // Apply effects to the currently selected target.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oCreature );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBlind, oCreature );

}
