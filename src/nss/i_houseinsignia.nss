// House Insignia generic item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/04/2004 jpavelch         Initial Release
//

#include "x2_inc_switches"


// Destroys object thereby removing house affiliation.
//
void ActivateItem( ){

    object oPC   = GetItemActivator( );
    object oItem = GetItemActivated( );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oPC );

    DestroyObject( oItem, 1.0 );
}


void main( ){

    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE: ActivateItem( ); break;
    }
}
