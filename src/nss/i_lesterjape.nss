// Lester's Irresistible Jape
//
// The caster tells a joke.  For the duration, the caster is silenced and in
// defensive casting mode with VFXs, allies laugh, get the VFXs and take -2 AC
// and -5 reflex, and others must make a will save.  If they fail, they laugh
// and are prone for the duration, and if they pass they laugh and take -2 AC
// and -5 reflex for the duration.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/25/2012 Mathias          Initial release.
//

#include "x2_inc_switches"
#include "inc_ds_records"
#include "amia_include"

void ActivateItem( )
{
    // Variables.
    object      oPC         = GetItemActivator();
    int         nLevel      = GetHitDice( oPC );
    location    lTarget     = GetLocation( oPC );
    int         nCha        = GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int         nSave       = 10 + ( nLevel / 2 ) + nCha;
    int         nDuration   = nLevel / 5;
    string      sProneLine  = "*Laughs hysterically!*";
    string      sJokeStart  = "*starts a good joke!*";
    int         nCooldown   = 3;  // Cooldown time in turns.
    int         nTargetInt;
    float       fLaughDur;
    int         nWillResult;
    object      oTarget     = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    effect      eHowl       = EffectVisualEffect( VFX_FNF_HOWL_MIND );
    effect      eBubbles    = EffectVisualEffect( VFX_DUR_BUBBLES );
    effect      ePunchline  = EffectVisualEffect( VFX_IMP_HEAD_ODD );
    effect      eKnockdown  = EffectKnockdown( );
    effect      eACLoss     = EffectACDecrease( 2 );
    effect      eReflexLoss = EffectSavingThrowDecrease( SAVING_THROW_REFLEX, 5 );
    effect      eSilence    = EffectSilence( );
    effect      eCasterLink = EffectLinkEffects( eBubbles, eSilence );
    effect      eTargetLink = EffectLinkEffects( eACLoss, eReflexLoss );
    int         bDebug      = FALSE;  // Set to TRUE to see debug information.

    // Prevent stacking.
    if ( GetIsBlocked( oPC, "jape_on" ) > 0 ) {
          FloatingTextStringOnCreature( "- " + IntToString( GetIsBlocked( oPC, "jape_on" ) ) + " seconds left on the cooldown.  -", oPC, FALSE );
          return;
    }

    // Exit if PC has no more bard song uses.
    if ( !GetHasFeat( FEAT_BARD_SONGS, oPC ) ) {
        FloatingTextStringOnCreature( "- You do not have any remaining uses for this ability! -", oPC, FALSE );
        return;
    }

    // Make sure the duration is at least one round.
    if( nDuration < 1 ) {
        nDuration = 1;
    }
    fLaughDur = RoundsToSeconds( nDuration );

    // Debug
    if( bDebug ) { SendMessageToPC( oPC, "Spell activated for " + IntToString( nDuration ) + " rounds at DC " + IntToString( nSave ) + " (10 + " + IntToString( nLevel / 2 ) + " + " + IntToString( nCha ) + ")." ); }

    // Apply caster effects.
    AssignCommand( oPC, SpeakString( sJokeStart ) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHowl, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eCasterLink, oPC, RoundsToSeconds( nDuration ) );
    DelayCommand( RoundsToSeconds( nDuration ), ApplyEffectToObject( DURATION_TYPE_INSTANT, ePunchline, oPC ) );

    // Set defensive casting mode, and turn it off at the end.
    DelayCommand( 6.0, SetActionMode( oPC, ACTION_MODE_DEFENSIVE_CAST, TRUE ) );
    DelayCommand( RoundsToSeconds( nDuration ), SetActionMode( oPC, ACTION_MODE_DEFENSIVE_CAST, FALSE ) );

    // Cycle through targets in the shape.
    while( GetIsObjectValid( oTarget ) ) {

        // Check target's INT
        nTargetInt = GetAbilityScore( oTarget, ABILITY_INTELLIGENCE );

        // Don't affect the caster.
        if ( oTarget == oPC ) {

            // Debug
            if( bDebug ) { SendMessageToPC( oPC, GetName( oTarget ) + " is the caster and was not affected." ); }

        // Make sure they have more than 3 int.
        } else if ( nTargetInt > 3 ) {

            // Affect allies.
            if( GetIsReactionTypeFriendly( oTarget, oPC ) ) {

                // If allies are mind immune, don't affect them.
                if( GetIsImmune( oTarget, IMMUNITY_TYPE_MIND_SPELLS ) ) {

                    // Debug
                    if( bDebug ) { SendMessageToPC( oPC, GetName( oTarget ) + " is an ally but is mind spell immune and wasn't affected." ); }

                } else {

                    // Debug
                    if( bDebug ) { SendMessageToPC( oPC, GetName( oTarget ) + " was affected as an ally." ); }

                    // Make the target laugh, hit them with the ac and reflex penalties and apply the bubbles VFX.
                    AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_LOOPING_TALK_LAUGHING, 1.0, fLaughDur ) );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTargetLink, oTarget, RoundsToSeconds( nDuration ) );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBubbles, oTarget, RoundsToSeconds( nDuration ) - 6.0 );
                }

            // Affect others.
            } else {

                // Roll will save.
                nWillResult = WillSave( oTarget, nSave, SAVING_THROW_TYPE_MIND_SPELLS, oPC );

                // If they are immune...
                if ( nWillResult == 2 ) {

                    // Debug
                    if( bDebug ) { SendMessageToPC( oPC, GetName( oTarget ) + " is immune to mind spells and isn't affected." ); }

                // If they fail...
                } else if ( nWillResult == 0 ) {

                    // Debug
                    if( bDebug ) { SendMessageToPC( oPC, GetName( oTarget ) + " failed their will save and gets the full effects." ); }

                    // Make the target laugh and prone for the duration.
                    AssignCommand( oTarget, SpeakString( sProneLine ) );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBubbles, oTarget, RoundsToSeconds( nDuration ) - 6.0 );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds( nDuration ) );

                // If they succeed...
                } else {

                    // Debug
                    if( bDebug ) { SendMessageToPC( oPC, GetName( oTarget ) + " passed their will save and gets reduced effects." ); }

                    // Make the target laugh and apply the bubbles, AC loss, and reflex loss.
                    AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_LOOPING_TALK_LAUGHING, 1.0, fLaughDur ) );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTargetLink, oTarget, RoundsToSeconds( nDuration ) );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBubbles, oTarget, RoundsToSeconds( nDuration ) - 6.0 );

                }
            }
        } else {

            // Debug
            if( bDebug ) { SendMessageToPC( oPC, GetName( oTarget ) + " has only " + IntToString( nTargetInt ) + " INT and was not affected." ); }
        }

        //Get next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    }

    // Decrement a feat usage.
    DecrementRemainingFeatUses( oPC, FEAT_BARD_SONGS );

    // Start the cooldown.
    SetBlockTime( oPC, 0, FloatToInt( TurnsToSeconds( nCooldown ) ), "jape_on" );
}

void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;

        case X2_ITEM_EVENT_EQUIP:

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
    }
}
