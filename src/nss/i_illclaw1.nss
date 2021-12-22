/*  Illithid :: Claw On Hit

    --------
    Verbatim
    --------
    This script will do a touch attack on the illithid's foe DC 20 or suck its brains out!

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062306  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"


void main( ){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ONHITCAST:{

            // Variables.
            object oIllithid    = OBJECT_SELF;
            object oVictim      = GetSpellTargetObject( );
            int nPC             = GetIsPC( oVictim );

            // Notify if its a player.
            if( nPC )   SendMessageToPC( oVictim, "- An illithid is attempting to suck your brains out! -" );

            // Make the illithid perform a touch attack.
            if( TouchAttackMelee( oVictim ) ){
                // Successful touch attack, allow the player a will save to resist getting her brains sucked out.
                if( WillSave( oVictim, 20, SAVING_THROW_TYPE_EVIL ) == 1 ){
                    // Failure.
                    if( nPC )   SendMessageToPC( oVictim, "- The illithid sucked your brains out! -" );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath( TRUE ), oVictim );
                }
                // Success.
                else
                    if( nPC )   SendMessageToPC( oVictim, "- You escaped getting your brains sucked out by an illithid! -" );
            }

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
