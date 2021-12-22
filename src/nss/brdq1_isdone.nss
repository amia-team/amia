// Bard Quest #1.  Checks if quest #1 has already been completed.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/04/2004 jpavelch         Initial release.
// 2007/11/12  disco           using inc_ds_records

#include "inc_ds_records"

int StartingConditional( ){

    object oPC      = GetPCSpeaker( );

    return ( GetPCKEYValue( oPC, "AR_BardQuest1") );
}
