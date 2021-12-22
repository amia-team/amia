// Kierenis Head Change Widget
//
// The widget toggles between heads 143 and 154.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/14/2012 Mathias          Initial release.
//
//
#include "x2_inc_switches"
#include "inc_ds_records"

void ActivateItem( ) {

    // Variables.
    object      oPC         = GetItemActivator();
    int         nCurrent    = GetCreatureBodyPart( CREATURE_PART_HEAD, oPC );
    int         nFirstHead  = 143;
    int         nSecondHead = 154;
    int         bDebug      = TRUE;

    // Debug
    if ( bDebug ) { SendMessageToPC( oPC, "Head number: " + IntToString( nCurrent ) ); }

    // Warning: Seriously complex code follows.
    if ( nCurrent == 143 ) {

        SetCreatureBodyPart( CREATURE_PART_HEAD, nSecondHead, oPC );
    } else {

        SetCreatureBodyPart( CREATURE_PART_HEAD, nFirstHead, oPC );
    }

}

void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;

        case X2_ITEM_EVENT_EQUIP:

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
    }
}
