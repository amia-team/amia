// Item script to transform into a black dragon.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/28/2005 bbillington         Initial release.
//

#include "x2_inc_switches"


// Changes appearance of PC between standard and black dragon.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_PWKILL),
        oPC
    );

    int nAppearType = GetAppearanceType( oPC );
    if ( nAppearType == APPEARANCE_TYPE_DRAGON_BLACK ) {
        nAppearType = GetLocalInt( oItem, "PHE_AppearType" );
        DeleteLocalInt( oItem, "PHE_AppearType" );
        DelayCommand( 0.1, SetCreatureAppearanceType(oPC, nAppearType) );
    } else {
        SetLocalInt( oItem, "PHE_AppearType", nAppearType );
        DelayCommand( 0.1, SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_DRAGON_BLACK) );
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
