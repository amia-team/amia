// Conversation action to set 'piss off' mode for on a PC.  This is basically
// used to prevent spamming after a failed skill check.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/18/2004 jpavelch         Initial Release.
// 05/02/2005 bbillington      Used the script to prevent multiple blessing off clerics.
// 20050502   jking            Refactored

#include "blessing"

void main()
{
    object oPC = GetPCSpeaker( );
    SetBlessing (oPC, STANDARD_BLESSING);
    DelayCommand( TurnsToSeconds(5), ClearBlessing(oPC, STANDARD_BLESSING) );
}
