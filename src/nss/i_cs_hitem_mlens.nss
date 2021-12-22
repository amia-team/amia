/*  Item : Harper Scouts :: Lens of Myopic Scrying

    --------
    Verbatim
    --------
    This script reveals the number of foes in 30-foot radius about the player, Harper stuff.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080406  kfw         Initial release.
    080406  disco       adapted it to show hostile NPCs only
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"


void main( ){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables.
            object oPC          = GetItemActivator( );
            location lPC        = GetLocation( oPC );

            int nNumberOfNPCs    = 0;

            // Cycle objects in a 30-foot radius about the Harper.
            object oObject      = GetFirstObjectInShape( SHAPE_SPHERE, 30.0, lPC );

            while( GetIsObjectValid( oObject ) && GetObjectType( oObject ) == OBJECT_TYPE_CREATURE ){

                // hostile NPC detected
                if( GetIsReactionTypeHostile( oObject, oPC ) && !GetIsPC( oObject ) )
                    nNumberOfNPCs++;

                oObject         = GetNextObjectInShape( SHAPE_SPHERE, 30.0, lPC );
            }

            // Notify the Harper.
            SendMessageToPC( oPC, "- You see " + IntToString( nNumberOfNPCs ) + " bright patches around you! - " );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
