/*  DC Item :: Bailéad dar Bænsidhe :: OnUse: Unique Power: Target

    --------
    Verbatim
    --------
    Bardsong that does a fortitude save vs. death DC 30, and a will vs. fear DC 35
    to all foes within a 30-ft sphere about the singer.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062307  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "x2_inc_switches"
#include "amia_include"
#include "x2_inc_itemprop"
#include "x2_i0_spells"

// Prototypes.

// Ballad of the Banshee effect.
void BansheeBallad( object oPC, object oVictim );


void main(){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch(nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            vector vPos         = GetPosition( oPC );
            location lTarget    = GetItemActivatedTargetLocation( );
            object oVictim      = GetFirstObjectInShape( SHAPE_SPHERE, 30.0, lTarget, FALSE, OBJECT_TYPE_CREATURE, vPos );


            // Cycle through 20-ft cone's worth of victims.
            while( GetIsObjectValid( oVictim ) ){

                // Foe of the singer.
                if( GetIsEnemy( oVictim, oPC ) )
                    DelayCommand( 3.0, BansheeBallad( oPC, oVictim ) );

                oVictim = GetNextObjectInShape( SHAPE_SPHERE, 30.0, lTarget, FALSE, OBJECT_TYPE_CREATURE, vPos );

            }

            // Candy.
            AssignCommand( oPC, PlaySound( "vs_nx2matrf_dead" ) );
            DelayCommand( 2.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_WAIL_O_BANSHEES ), lTarget ) );

            break;

        }

        default:
            break;

    }

    SetExecutedScriptReturnValue( nResult );
    return;

}

// Ballad of the Banshee effect.
void BansheeBallad( object oPC, object oVictim ){

    // Variables.
    float fDuration         = RoundsToSeconds( GetLevelByClass( CLASS_TYPE_BARD, oPC ) );

    // Fortitude save vs. death, DC 30.
    if( FortitudeSave( oVictim, 30, SAVING_THROW_TYPE_DEATH, oPC ) == 0 ){
        // Failed: Apply death effects.
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH ), oVictim );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath( ), oVictim );
    }
    // Will save vs.
    else if( WillSave( oVictim, 35, SAVING_THROW_TYPE_FEAR, oPC ) == 0 ){
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectFrightened( ), oVictim, fDuration );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR ), oVictim, fDuration );
    }

    return;

}
