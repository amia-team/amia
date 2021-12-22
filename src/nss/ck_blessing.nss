// Conversation conditional to check if the player should piss off.  This
// is basically used to prevent spamming after a failed skill check.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/18/2004 jpavelch         Initial Release.
// 05/02/2005 bbillington      Used the script to prevent stacked blessings on PCs.
// 20050502   jking            Refactored

#include "blessing"

int StartingConditional( )
{
    return IsBlessed(GetPCSpeaker(), STANDARD_BLESSING);
}
