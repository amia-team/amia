// Conversation action to set 'piss off' mode for on a PC.  This is basically
// used to prevent spamming after a failed skill check.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/18/2004 jpavelch         Initial Release.
// 4/30/2005  bbillington      Used JP's charming script for the SD academy.
// 20050502   jking            Refactored

#include "blessing"

void main( )
{
    object oPC = GetPCSpeaker( );
    SetBlessing(oPC, ACADEMY_TEACH_0);
    DelayCommand( TurnsToSeconds(15), ClearBlessing(oPC, ACADEMY_TEACH_0) );
}
