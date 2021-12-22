/*  Supernatural Ability :: Palemaster :: Undead Graft: Deathless Mastery Touch

    --------
    Verbatim
    --------
    This script will allow the Palemaster to instantly slay her foes if they fail a Fortitude save:
        DC 10 + Palemaster Level + INT modifier.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082906  kfw         Initial release.
    090406  kfw         Bugfix: No Special Abilities Zone support added.
    011307  disco       Bugfix: Break from GS and other invis effects
    100209  Terra       Bugfix: Spellscript is now a spellscript, give back the change on missed touchattack
    ----------------------------------------------------------------------------

*/


/* Constants. */
const string NO_SPEC_AB = "NoSpecialAbilities";

// includes
#include "nw_i0_spells"


void main( ){

    // Variables.
    object oPC          = OBJECT_SELF;
    object oArea        = GetArea( oPC );
    int nNoSpecAbil     = GetLocalInt( oArea, NO_SPEC_AB );
    int nPM_rank        = GetLevelByClass( CLASS_TYPE_PALE_MASTER );
    int nINT_mod        = GetAbilityModifier( ABILITY_INTELLIGENCE );
    int nDC             = 10 + nPM_rank + nINT_mod;
    object oVictim      = GetSpellTargetObject( );
    int nPlot           = GetPlotFlag( oVictim );
    int nCreatureSize   = GetCreatureSize( oVictim );
    int nRacialType     = GetRacialType( oVictim );
    int nHP             = GetCurrentHitPoints( oVictim ) + 10;  // +10 ensures death.
    effect eSlay        = EffectLinkEffects(
                            EffectVisualEffect( VFX_IMP_DEATH ),
                            EffectDamage( nHP, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY ) );


    // Zone status.
    if( nNoSpecAbil ){

        SendMessageToPC( oPC, "- You may not use this Special Ability in this area! -" );
        return;
    }

    if ( !GetIsReactionTypeHostile( oPC, oVictim ) ){

        SendMessageToPC( oPC, "- You can only use this ability on hostile creatures! -" );
        return;
    }

    if ( GetIsBlocked( oVictim, "Deathtouch_Immune" ) ) {

        SendMessageToPC( oPC, "- Target is immune! -" );
        return;
    }

    //if target == PC
    if ( oVictim == oPC ){

        SendMessageToPC( oPC, "- Palemasters don't suicide! -" );
        return;
    }

    //Signal the spell events
    SignalEvent( oVictim, EventSpellCastAt( oPC, GetSpellId( ), TRUE ) );

    // Filter: Plot, Creature Size greater than Large, Non-living.
    if( nPlot                                       ||
        nCreatureSize > CREATURE_SIZE_LARGE         ||
        nRacialType == RACIAL_TYPE_CONSTRUCT        ||
        nRacialType == RACIAL_TYPE_OOZE             ||
        nRacialType == RACIAL_TYPE_UNDEAD           ){
        // Notify.
        SendMessageToPC( oPC, "<c€þ>- Undead Graft: Deathless Mastery Touch won't affect this creature. -" );
        return;
    }


    if( TouchAttackMelee( oVictim ) > 0 ){
    // Unsuccessful Will Save, paralyze the Victim.
        if( FortitudeSave( oVictim, nDC, SAVING_THROW_TYPE_DEATH, oPC ) == 0 ){

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eSlay, oVictim );
        }
    }
    else
        IncrementRemainingFeatUses( oPC, FEAT_DEATHLESS_MASTER_TOUCH );
    return;

}
