// werecat item script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/04/2004 bbillington         Initial release.
//

#include "x2_inc_switches"


// Changes appearance of PC between standard and werecat form.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_POLYMORPH),
        oPC
    );

    int nAppearType = GetAppearanceType( oPC );
    if ( nAppearType == APPEARANCE_TYPE_WERECAT ) {
        nAppearType = GetLocalInt( oItem, "PHE_AppearType" );
        DeleteLocalInt( oItem, "PHE_AppearType" );
        DelayCommand( 0.1, SetCreatureAppearanceType(oPC, nAppearType) );
    } else {
        SetLocalInt( oItem, "PHE_AppearType", nAppearType );
        DelayCommand( 0.1, SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_WERECAT ) );
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
