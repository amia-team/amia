/*  Item :: Cordor Guard: Lodestone: OnUse [Target]

    --------
    Verbatim
    --------
    This script will sic/nix a lodestone from a player.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082906  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "amia_include"


/* Constants. */
const string LODESTONE_REF      = "cs_it_lodesone1";
const string LODESTONE_DEST     = "wp_lodestone_dest1";


void main( ){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            object oVictim      = GetItemActivatedTarget( );
            object oLodestone   = OBJECT_INVALID;


            // Filter: PC's only.
            if( !GetIsPC( oVictim ) ){
                // Notify the PC.
                SendMessageToPC( oPC, "- You may only use the Lode wand on PC's! -" );
                break;
            }


            // No lodestone, issue one, and teleport them out.
            if( !GetIsObjectValid( oLodestone = GetItemPossessedBy( oVictim, LODESTONE_REF ) ) ){

                // Notify the Server.
                SendMessageToAllPCs( "- " + GetName( oVictim ) + " has been LODED by " + GetName( oPC ) + " for breaking the CORDORIAN LAW! -" );

                // Issue lodestone.
                CreateItemOnObject( LODESTONE_REF, oVictim );

                // Teleport them out of the City of Cordor.
                AssignCommand(
                    oVictim,
                    JumpToLocation( GetLocation( GetWaypointByTag( LODESTONE_DEST ) ) ) );

            }
            // Lodestone, nix it.
            else{
                // Notify the Server.
                SendMessageToAllPCs( "- " + GetName( oVictim ) + " has been UNLODED by " + GetName( oPC ) + ". -" );
                // Nix the lodestone.
                DestroyObject( oLodestone );
            }


            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}


