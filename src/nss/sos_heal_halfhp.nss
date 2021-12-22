//
// This script is used for Leidende's "heal" conversations -
// in this case the script tests to see if the user has less than 50%
// of their total hitpoints.  If they do, this script returns TRUE,
// which tells Leidende to say "why you're in perfect health!"
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2005/01/12 jking            Initial Release.
//

int StartingConditional()
{
    int cutoff = GetMaxHitPoints(GetPCSpeaker()) / 2;
    return (GetCurrentHitPoints(GetPCSpeaker()) < cutoff) ? TRUE : FALSE;
}

