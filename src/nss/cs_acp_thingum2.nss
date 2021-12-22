/*  Amia Control Panel [ACP] :: Thingum :: Transfer Thingum's Kit to the Player

    --------
    Verbatim
    --------
    This script will transfer the Thingum's kit over to the player.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082206  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "cs_inc_leto"
#include "logger"


/* Constants. */
const string THINGUM_GOLD   = "cs_thingum_gold";


void main( ){

    // Variables.
    object oVault           = OBJECT_SELF;
    object oDM              = GetPCSpeaker( );
    location lOrigin        = GetLocation( GetWaypointByTag( "wp_treasurevault" ) );
    object oPC              = GetNearestObjectToLocation( OBJECT_TYPE_CREATURE, lOrigin );
    object oThingum         = GetNearestObjectByTag( "cs_thingum", oDM );


    // Player target only.
    if( !GetIsPC( oPC ) ){
        SendMessageToPC( oDM, "- Error: The Thingum cannot operate on non-PCs. -" );
        return;
    }

    int nGold               = GetLocalInt( oThingum, THINGUM_GOLD );
    object oItem            = GetFirstItemInInventory( oThingum );
    int nItems              = 0;

    // Transfer all items from the Thingum's inventory over to the target player's.
    while( GetIsObjectValid( oItem ) ){

        // Transfer.
        CopyItem( oItem, oPC, TRUE );
        DestroyObject( oItem, 0.1 );

        // Tally number of items transfered.
        nItems++;

        // Get the next item.
        oItem = GetNextItemInInventory( oThingum );

    }

    // Transfer gold.
    SetLocalInt( oThingum, THINGUM_GOLD, 0 );   // Zerotize Thingum.
    GiveGoldToCreature( oPC, nGold );           // Issue Thingum's gold to the player.

    // Feedback.
    string szMessage = "- The Thingum gave " + IntToString( nGold ) + " pieces of gold and " + IntToString( nItems ) + " items to ";
    // Notify the DM and Player.
    SendMessageToPC( oDM, szMessage + GetName( oPC ) + "!-" );
    SendMessageToPC( oPC, szMessage + "you!-" );

    // Integrity.
    ExportSingleCharacter( oPC );

    return;

}
