// Gibbering Maw buy script
//
// based on Ostland Bird Helm Quest
//
// Checks the PC's inventory and rewards gold for each crystal or corpse they have.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/27/2012  Mathias          Initial Release.
// 12/10/2022  msheeler         modified to buy two items at diff prices
// 12/13/2012  xaviera          minor edit to check for both items ("or" condition)
//

#include "nw_i0_plot"

void main( ) {

    // Variables.
    string  sSuccess    = "Excellent. Here's your money, then."; // NPC says this line if the PC had items.
    string  sFail       = "I'll be happy to pay you when you bring me something.";    // NPC says this line if they had none.
    int     nPrice      = 30; // How much gold to pay per gibberslug corpse.
    int     nPrice2     = 45; // How much gold to pay per chaos crystal.
    object  oPC         =  GetPCSpeaker( );
    string  sItemTag    = "gbbr_slug_lt";
    string  sItemTag2   = "gbbr_crystl_lt";
    int     nItemCount  = GetNumItems( oPC, sItemTag );
    int     nItemCount2 = GetNumItems( oPC, sItemTag2);

// original line: if ( nItemCount ) {  // edit by xaviera
    if ( nItemCount || nItemCount2 ) {

        // Take the items.
        TakeNumItems( oPC, sItemTag, nItemCount );
        TakeNumItems( oPC, sItemTag2, nItemCount2 );

        // Award the gold.
        GiveGoldToCreature( oPC, ( nItemCount * nPrice ) );
        GiveGoldToCreature( oPC, ( nItemCount2 * nPrice2 ) );

        // Give the success message.
        ActionSpeakString( sSuccess );

    } else {

        // If PC had no helms, send them the fail message.
        ActionSpeakString( sFail );
    }
}


