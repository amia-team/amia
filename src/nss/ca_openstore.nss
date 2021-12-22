// Conversation action to open a store.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2004 jpavelch         Initial Release.
// 04/01/2004 jpavelch         NPC will now attempt to create their
//                             associated store if it does not exist in the
//                             area.
// 12/29/2006 disco            Disabled logger
// 12/31/2006 disco            Implemented database tracking
// 05/01/2007 disco            Shop Injection
// 2007/07/30 disco            Now works for PLCs too, use in OnUsed. Removed GetNearestObhect calls.
// 20071118   Disco            Now using inc_ds_records
// 2008-01-30 Disco            Rewritten and libbed.

#include "inc_ds_shops"

void main( ){

    //check if there's a valid PC

    object oPC      = GetLastSpeaker();

    if ( oPC == OBJECT_INVALID ){

        oPC = GetLastUsedBy();
    }

    if ( oPC == OBJECT_INVALID ){

        return;
    }

    string sStore   = GetLocalString( OBJECT_SELF, "MyStore" );

    OpenRacialStore( oPC, OBJECT_SELF, sStore );

}
