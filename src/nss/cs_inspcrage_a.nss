// Inspire Courage (OnEnter Aura)
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

void main(){

    // Variables.
    object oCreature    = GetEnteringObject( );
    object oPC          = GetItemActivator();
    int    nLevel       = GetHitDice( oPC );
    int    nDuration    = 10;
    int    nBonus       = 1;
    effect eGlow        = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);
    effect eSave;
    effect eAB;
    effect eDamage;
    effect eLink;
    int    bDebug       = FALSE;  // set to TRUE to see debug messages

    // Apply the bonuses to friendlies and the PC.
    if ( ( GetIsReactionTypeFriendly ( oCreature, oPC ) ) ||
         ( oCreature == oPC ) ) {

        // Determine the bonus level.
        if ( nLevel > 7 && nLevel < 14 ) {
            nBonus = 2;

        } else if ( nLevel > 13 && nLevel < 20 ) {
            nBonus = 3;

        } else {
            nBonus = 4;

        }

        // Define effects and link them
        eSave   = EffectSavingThrowIncrease( SAVING_THROW_WILL, nBonus );
        eAB     = EffectAttackIncrease( nBonus );
        eDamage = EffectDamageIncrease ( nBonus );

        eLink   = EffectLinkEffects( eSave, eAB );
        eLink   = EffectLinkEffects( eDamage, eLink );
        eLink   = EffectLinkEffects( eGlow, eLink );

        // Make the effects linger for 5 rounds after the aura fades.
        nDuration = nDuration + 5;

        // Apply the effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCreature, RoundsToSeconds( nDuration ) );

        // !!DEBUG!!
        if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oCreature) + " got bonuses of " + IntToString(nBonus) + " to AB/Will/Damage for " + IntToString(nDuration) + " rounds. -" ); }
    }
}
