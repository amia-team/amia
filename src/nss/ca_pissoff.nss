// Conversation action to set 'piss off' mode for on a PC.  This is basically
// used to prevent spamming after a failed skill check.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/18/2004 jpavelch         Initial Release.
// 20050502   jking            Refactored

#include "blessing"

void main( )
{
    object oPC = GetPCSpeaker( );
    SetBlessing(oPC, HAMAR_PISSOFF);
    DelayCommand( TurnsToSeconds(5), ClearBlessing(oPC, HAMAR_PISSOFF) );
}
