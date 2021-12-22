/*  Mythal Crafting :: Conversation Initialize

    --------
    Verbatim
    --------
    Initializes the mythal crafting conversation

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    20050606  kfw       Initial Release.
    20080901  Terra     Epic clean up
    20111028  Selmak    Recompile for containers
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "x2_inc_itemprop"

#include "inc_td_mythal"
#include "inc_ds_porting"

void main( ){

    // Variables
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            object oMythal      = GetNearestObjectByTag( MYTHAL_FORGE, oPC );
            object oReagent     = GetItemActivated( );
            object oItem        = GetItemActivatedTarget( );

            //Recharge wand
            if ( GetTag( oItem ) == "ds_porting" ){

                port_mythal_init( oPC, oItem, oReagent, oMythal );
                return;
            }

            // Strip temporary item effects
            if( GetObjectType( oItem ) == OBJECT_TYPE_ITEM )
            {
            itemproperty IP = GetFirstItemProperty( oItem );

                while( GetIsItemPropertyValid( IP ) )
                {
                    if( GetItemPropertyDurationType( IP ) == DURATION_TYPE_TEMPORARY ){
                    RemoveItemProperty( oItem , IP );
                    }
                IP = GetNextItemProperty( oItem );
                }

            SendMessageToPC( oPC, "<cÌ&Ì>- The mythal seems to strip your item of its temporary enchantments-</c>" );
            }

            // Player must be within 5 feet of a mythal forge (and the forget itself must exist).
            if( !GetIsObjectValid( oMythal ) || GetDistanceBetween( oPC, oMythal ) > 5.0 ){

                // Notify the player.
                SendMessageToPC(
                    oPC,
                    "<cÌ&Ì>- Mythal Crafting - <cþ  >Error</c> - <cþþþ>You aren't near a Mythal Forge to craft.</c> -" );

                // Candy.
                AssignCommand( oPC, PlaySound( "sff_spellfail" ) );

                break;

            }

            // Player must own the item they want to craft.
            if( GetItemPossessor( oItem ) != oPC ){

                // Notify the player.
                SendMessageToPC(
                    oPC,
                    "<cÌ&Ì>- Mythal Forge - <cþ  >Error</c> - <cþþþ>You cannot craft items that you don't own.</c> -" );

                // Candy.
                AssignCommand( oPC, PlaySound( "sff_spellfail" ) );

                break;

            }

            // Plot or Stolen Items aren't permitted. Checks separate variable to block mythals.
            if( GetPlotFlag( oItem ) || ( GetLocalInt( oItem, "mythalblock" ) == 1 )) {

                // Notify the player.
                SendMessageToPC(
                    oPC,
                    "<cÌ&Ì>- Mythal Forge - <cþ  >Error</c> - <cþþþ>Item is too powerful to be crafted.</c> -" );

                break;

            }

            /* Store variables on player object. */
            /* Setup temporary custom tokens for strings in Conversation. */
            /* Initialize conversation. */
            SetMythalChecks( oPC , oItem , oReagent , oMythal , "mythal" );




            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
