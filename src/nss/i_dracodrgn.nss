// Item script to transform into a bone dragon.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/28/2005 bbillington         Initial release.
//

#include "x2_inc_switches"


// Changes appearance of PC between standard and bone dragon.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_HARM),
        oPC
    );

    int nAppearType = GetAppearanceType( oPC );
    if ( nAppearType == APPEARANCE_TYPE_DRACOLICH ) {
        nAppearType = GetLocalInt( oItem, "PHE_AppearType" );
        DeleteLocalInt( oItem, "PHE_AppearType" );
        DelayCommand( 0.1, SetCreatureAppearanceType(oPC, nAppearType) );
    } else {
        SetLocalInt( oItem, "PHE_AppearType", nAppearType );
        DelayCommand( 0.1, SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_DRACOLICH) );
    }
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
