/*  Amia Control Panel [ACP] :: Thingum :: Transfer Player's Kit to the Thingum

    --------
    Verbatim
    --------
    This script will transfer the player's kit over to the Thingum.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082206  kfw         Initial release.
    082306  kfw         Bugfix: Transfers equipped items.
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
    int nIndex              = 0;


    // Player target only.
    if( !GetIsPC( oPC ) ){
        SendMessageToPC( oDM, "- Error: The Thingum cannot operate on non-PCs. -" );
        return;
    }

    int nGold               = GetGold( oPC );
    object oItem            = GetFirstItemInInventory( oPC );
    int nItems              = 0;

    // Transfer all items from the target player's inventory over to the Thingum (And the DM).
    while( GetIsObjectValid( oItem ) ){

        // Transfer.
        CopyItem( oItem, oThingum, TRUE );
        CopyItem( oItem, oDM, TRUE );
        DestroyObject( oItem, 0.1 );

        // Tally number of items transfered.
        nItems++;

        // Get the next item.
        oItem = GetNextItemInInventory( oPC );

    }

    // Transfer equipped items.
    // Variables.
    oItem                   = GetItemInSlot( nIndex, oPC );

    // Cycle equipped items.
    for( nIndex = 0; nIndex < NUM_INVENTORY_SLOTS; nIndex++ ){

        // Trasnfer.
        CopyItem( oItem, oThingum, TRUE );
        CopyItem( oItem, oDM, TRUE );
        DestroyObject( oItem, 0.1 );

        // Tally number of items transfered.
        nItems++;

    }

    // Transfer gold.
    TakeGoldFromCreature( nGold, oPC, TRUE );
    SetLocalInt( oThingum, THINGUM_GOLD, nGold );

    // Feedback.
    string szMessage = "- The Thingum took " + IntToString( nGold ) + " pieces of gold and " + IntToString( nItems ) + " items from ";
    // Notify the DM and Player.
    SendMessageToPC( oDM, szMessage + GetName( oPC ) + "!-" );
    SendMessageToPC( oPC, szMessage + "you!-" );

    return;

}
