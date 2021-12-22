// Bard Quest #1.  Conversation conditional to check if the PC has not
// already completed quest #1, is at least a level four bard and has the
// Harp of Lengends in his inventory.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2004 jpavelch         Initial release.
// 2007-11-17 disco            using PCKEY now

#include "inc_ds_records"


int StartingConditional( )
{
    object oPC = GetPCSpeaker( );

    if ( GetLevelByClass(CLASS_TYPE_BARD, oPC) < 4 )
        return FALSE;


    if ( GetPCKEYValue( oPC, "AR_BardQuest1") ){

        return FALSE;
    }

    object oHarp = GetItemPossessedBy( oPC, "HarpofLegends" );

    if ( !GetIsObjectValid(oHarp) ){

        return FALSE;
    }

    DestroyObject( oHarp );
    CreateItemOnObject( "lichsong", oPC );

    SetPCKEYValue( oPC, "AR_BardQuest1", TRUE );

    return TRUE;
}
