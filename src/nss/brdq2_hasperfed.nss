// Bard Quest #2.  Conversation conditional that checks if PC has flag
// from performing in front of talent scout and has not already completed
// this quest.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/04/2004 jpavelch         Initial release.
//  20071118  Disco       Using inc_ds_records now
// ------------------------------------------------------------------


//includes
#include "inc_ds_records"


int StartingConditional( )
{
    object oPC = GetPCSpeaker( );

    if ( GetPCKEYValue(oPC, "AR_BardQuest2") ){

        return FALSE;
    }

    if ( !GetLocalInt(oPC, "AR_BardQuest2") ){

        return FALSE;
    }

    CreateItemOnObject( "stonesong", oPC );
    SetPCKEYValue( oPC, "AR_BardQuest2", TRUE );
    DeleteLocalInt( oPC, "AR_BardQuest2" );

    return TRUE;
}
