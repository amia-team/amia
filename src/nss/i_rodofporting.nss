// Rod of Porting item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 12/08/2003 jpavelch         Initial Release
// 07/18/2004 jpavelch         Removed database call.
// 20050214   jking            Refactored constants.
// 20070103   disco            DM avatars can use the rod on PCs
// 20070113   disco            DM avatars can use the rod everywhere

#include "inc_userdefconst"
#include "x2_inc_switches"
#include "amia_include"
#include "inc_ds_records"

// Creates a portal that PC can use to teleport around the realms.  The
// rod will not function in areas if it has a local integer named
// PreventRodOfPorting with a value of 1.
//
void ActivateRodOfPorting( ){

    object oPC          = GetItemActivator( );
    object oItem        = GetItemActivated();


    SendMessageToPC( oPC, "The Porting Rod is obsolete, it has been replaced by the Portal Wands." );
    DestroyObject( oItem );
    return;

}


void main( ){

    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateRodOfPorting( );
            break;
    }
}
