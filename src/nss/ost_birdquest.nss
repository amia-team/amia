// Ostland Bird Helm Quest - Action script
//
// Checks the PC's inventory and rewards them 25 gold for each helm they have.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/27/2012  Mathias          Initial Release.
//
#include "nw_i0_plot"

void main( ) {

    // Variables.
    string  sSuccess    = "Good work. Here are the coins I promised.";                    // NPC says this line if the PC had helms.
    string  sFail       = "What are you trying to pull here? You dont have any proof!";    // NPC says this line if they had none.
    int     nPrice      = 25;                           // How much gold to pay per helm.
    object  oPC         = GetPCSpeaker( );
    string  sItemTag    = "rua_birdhelm";
    int     nItemCount  = GetNumItems( oPC, sItemTag );

    if ( nItemCount ) {

        // Take the items.
        TakeNumItems( oPC, sItemTag, nItemCount );

        // Award the gold.
        GiveGoldToCreature( oPC, ( nItemCount * nPrice ) );

        // Give the success message.
        ActionSpeakString( sSuccess );

    } else {

        // If PC had no helms, send them the fail message.
        ActionSpeakString( sFail );
    }
}


