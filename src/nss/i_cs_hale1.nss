// Twikle's Grog: Ale that does funny things to ya.

/* Includes */
#include "x2_inc_switches"

void main( ){

    // Variables
    int nEvent      = GetUserDefinedItemEventNumber( );
    int nResult     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC      = GetItemActivator( );

            effect eGrog    = EffectVisualEffect( VFX_DUR_GLOW_GREEN );
            effect eGrog2;

            // Generate a groggy effect
            switch( d4( ) ){

                case 1:     eGrog2 = EffectCharmed( );                                  break;
                case 2:     eGrog2 = EffectConfused( );                                 break;
                case 3:     eGrog2 = EffectStunned( );                                  break;
                default:    eGrog2 = EffectInvisibility( INVISIBILITY_TYPE_NORMAL );    break;

            }

            // Slap it on.
            eGrog = EffectLinkEffects( eGrog, eGrog2 );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eGrog, oPC, RoundsToSeconds( 1 ) );

            break;

        }

    }

    SetExecutedScriptReturnValue( nResult );

}
