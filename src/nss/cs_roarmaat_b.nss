// Roar of the Ma'at (OnExit Aura)
//
// Uses one Bard Song per use, lasts Round/Bard level. Creates a 10
// meter aura, and enemies which enter the aura must roll
// Concentration vs Taunt or suffer -4 AB.  Allies which enter the
// aura gain +20% physical damage immunity.  The caster gains
// +20% physical damage immunity, but suffers -4 AC and -50% str
// modified damage.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/14/2012 Mathias          Initial Release.
//

void main( ){

    // Variables.
    object oCreature    = GetExitingObject( );
    object oPC          = GetItemActivator( );
    int    bDebug       = FALSE;  // set to TRUE to see debug messages

    // Prevent aura being deactivated due to lag
    if( oCreature == oPC )
        return;

    // Cycle active effects to find supernatural AB changes
    effect eEffects = GetFirstEffect( oCreature );

    while( GetIsEffectValid( eEffects ) ){

        // Find supernatural effects
        if ( GetEffectSubType( eEffects ) == SUBTYPE_SUPERNATURAL )
        {

            // Find AB loss or damage immunity
            if ( GetEffectType( eEffects ) == EFFECT_TYPE_ATTACK_DECREASE ||
                 GetEffectType( eEffects ) == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE )
            {

                // And remove them
                RemoveEffect( oCreature, eEffects );

                // !!DEBUG!!
                if (bDebug) { FloatingTextStringOnCreature( "- " + GetName(oCreature) + "'s effect #" + IntToString( GetEffectType( eEffects ) ) + " was removed.", oPC, FALSE ); }
            }
        }
        eEffects = GetNextEffect( oCreature );
    }
}
