// Item event script for the healer mark item. Spawns a healing knowledge item.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 22/01/2011 PaladinOfSune    Initial Release

#include "x2_inc_switches"

void ActivateItem()
{
    object oPC      = GetItemActivator();
    object oTarget  = GetItemActivatedTarget();
    object oItem    = GetItemPossessedBy( oTarget, "heal_knowledge" );

    // Return if the target already possesses a gem.
    if( GetIsObjectValid( oItem ) ) {
        FloatingTextStringOnCreature( "<cþ>- The target already possesses that item. -</c>", oPC, FALSE );
        return;
    }

    if ( !GetIsObjectValid( oTarget ) || ( GetObjectType( oTarget) != OBJECT_TYPE_CREATURE ) ) {
        FloatingTextStringOnCreature( "<cþ>- You must target someone! -</c>", oPC, FALSE );
        return;
    }

    CreateItemOnObject( "heal_knowledge", oTarget, 1 );
    FloatingTextStringOnCreature( "Item created successfully!", oPC, FALSE );
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
