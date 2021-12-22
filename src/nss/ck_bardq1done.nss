// Bard Quest #1.  Checks if quest #1 has already been completed.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/04/2004 jpavelch         Initial release.
//   20071118  Disco       Using inc_ds_records now
// ------------------------------------------------------------------


//includes
#include "inc_ds_records"



int StartingConditional( ){

    object oPC = GetPCSpeaker( );

    return ( GetPCKEYValue(oPC, "AR_BardQuest1") );
}
