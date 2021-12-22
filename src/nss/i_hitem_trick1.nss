/*  Item : Harper Scouts :: Bag of Tricks : Witchstone

    --------
    Verbatim
    --------
    This script creates a Wail of the Banshee & Smoke VFX effect, and confuses all foes within a 20-foot radius if they fail a Will save.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080406  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"

void KillInvis( object oPC ){

    effect eEff = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEff ) ){
        nType=GetEffectType( eEff );

        if( nType == EFFECT_TYPE_INVISIBILITY || nType == EFFECT_TYPE_ETHEREAL || nType == EFFECT_TYPE_SANCTUARY )
            RemoveEffect( oPC, eEff );

        eEff = GetNextEffect( oPC );
    }
}

void main( ){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables.
            object oPC          = GetItemActivator( );
            location lPC        = GetLocation( oPC );

            KillInvis( oPC );

            // Candy: Wail and smoke.
            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                EffectLinkEffects(
                    EffectVisualEffect( VFX_FNF_WAIL_O_BANSHEES ),
                    EffectVisualEffect( VFX_FNF_SMOKE_PUFF ) ),
                oPC );

            // Cycle PC foes within a 20-foot radius of the Harper.
            object oObject      = GetFirstObjectInShape( SHAPE_SPHERE, 20.0, lPC );

            while( GetIsObjectValid( oObject ) ){

                // Enemy of the Harper.
                if( GetIsEnemy( oObject, oPC ) ){
                    // Resolve Will Save.
                    if( WillSave( oObject, 30, SAVING_THROW_TYPE_NONE, oPC ) == 0 )
                        ApplyEffectToObject(
                            DURATION_TYPE_TEMPORARY,
                            EffectLinkEffects(
                                EffectConfused( ),
                                EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED ) ),
                            oObject,
                            RoundsToSeconds( 2 ) );
                }

                oObject         = GetNextObjectInShape( SHAPE_SPHERE, 20.0, lPC );

            }

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
