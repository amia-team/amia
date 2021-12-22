/* OnUse Event for Labyrinth: Massacre flames and keys

Combines all four essences together with the empty box given by the quest.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
04/19/12 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"
#include "inc_ds_qst"

void ActivateItem()
{
    object oPC = GetItemActivator();

    if( GetIsObjectValid( GetItemPossessedBy( oPC, "sec_1to2_fire" ) ) &&
        GetIsObjectValid( GetItemPossessedBy( oPC, "sec_1to2_cold" ) ) &&
        GetIsObjectValid( GetItemPossessedBy( oPC, "sec_1to2_acid" ) ) &&
        GetIsObjectValid( GetItemPossessedBy( oPC, "sec_1to2_elec" ) ) )
    {
        effect eCombine = EffectVisualEffect( VFX_IMP_KNOCK );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eCombine, oPC );
        object oEmpty = GetItemPossessedBy( oPC, "sec_1to2_key" );
        DestroyObject( GetItemPossessedBy( oPC, "sec_1to2_fire" ) );
        DestroyObject( GetItemPossessedBy( oPC, "sec_1to2_cold" ) );
        DestroyObject( GetItemPossessedBy( oPC, "sec_1to2_acid" ) );
        DestroyObject( GetItemPossessedBy( oPC, "sec_1to2_elec" ) );
        SendMessageToPC( oPC, "You fill the empty box with the four essences. The full box is now ready to be given to Lorvo back in Cordor." );
        CreateItemOnObject( "sec_1to2_box_f", oPC, 1, "" );

        //update quest status if needed
        if ( ds_quest( oPC, "ds_quest_98" ) == 1 )
        {
            ds_quest( oPC, "ds_quest_98", 2 );
        }

        if( GetIsObjectValid( oEmpty ) )
        {
            DestroyObject( oEmpty );
        }
    }
    else
    {
        SendMessageToPC( oPC, "*something seems to be missing...*" );
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
