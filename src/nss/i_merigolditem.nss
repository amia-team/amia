//
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/15/2004 jpavelch         Initial Release
//

#include "x2_inc_switches"


// Toggles appearance between elf and fairie.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION ),
        GetLocation(oPC)
    );
    if ( GetAppearanceType(oPC) == APPEARANCE_TYPE_FAIRY )
        SetCreatureAppearanceType( oPC, APPEARANCE_TYPE_ELF );
    else
        SetCreatureAppearanceType( oPC, APPEARANCE_TYPE_FAIRY );

    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectPolymorph( POLYMORPH_TYPE_NULL_HUMAN ), oPC, 0.5 ) );
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
