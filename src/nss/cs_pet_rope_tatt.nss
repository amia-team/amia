/*  Item : Harper Scouts :: OnActivate : Pet Rope

    --------
    Verbatim
    --------
    This script entangles a foe, Harper stuff.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080406  kfw         Initial release.
    030211  PoS         Utterly rebalanced.
    ----------------------------------------------------------------------------

*/

#include "amia_include"

void main( ){

    // Variables.
    object oPC          = OBJECT_SELF;
    object oVictim      = GetLocalObject( oPC, "HARPER_TARGET" );

    int nDC             = 10 + GetAbilityModifier( ABILITY_DEXTERITY, oPC ) + ( GetLevelByClass( CLASS_TYPE_HARPER, oPC ) * 2 );

    // Make sure its a player.
    if( !GetIsPC( oVictim ) ){
        SendMessageToPC( oPC, "- Pet Rope failed to stick! -");
        return;
    }

    // Resolve ranged touch attack.
    if( TouchAttackRanged( oVictim ) ){
        if( ReflexSave( oVictim, nDC ) == 0 )
            // Failed save, root 'em!
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY,
                EffectLinkEffects( EffectEntangle( ), EffectVisualEffect( VFX_DUR_ENTANGLE ) ),
                oVictim,
                NewHoursToSeconds( 1 ) );
    }

    return;

}
