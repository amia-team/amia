// Dust Storm (OnExit Aura)
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
    object oCreature    = GetExitingObject( );
    object oPC          = GetAreaOfEffectCreator( );
    int    bDebug       = FALSE;  // set to TRUE to see debug messages

    // !!DEBUG!!
    if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oCreature) + " exited the aura." );  }

    // Cycle active effects to find those blinded by the caster
    effect eEffects = GetFirstEffect( oCreature );

    while( GetIsEffectValid( eEffects ) ){

        // Find blindness caused by the caster.
        if ( ( GetEffectType( eEffects ) == EFFECT_TYPE_BLINDNESS ) && ( GetEffectCreator( eEffects ) == oPC ) )
        {
            // And remove it.
            RemoveEffect( oCreature, eEffects );

            // !!DEBUG!!
            if (bDebug) { SendMessageToPC( oPC, GetName( oCreature ) + "'s blindness was removed, which was made by " + GetName( GetEffectCreator( eEffects ) ) + "."); }
        }
        eEffects = GetNextEffect( oCreature );
    }
}
