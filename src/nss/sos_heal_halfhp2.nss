//
// This script is used for Leidende's "heal" conversations -
// in this case the script tests to see if the user has more than 50%
// of their total hitpoints.  If they do, this script returns TRUE,
// which tells Leidende to say "oh you poor thing" and then she harms them
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2005/01/12 jking            Initial Release.
//

int StartingConditional()
{
    int cutoff = GetMaxHitPoints(GetPCSpeaker()) / 2;
    return (GetCurrentHitPoints(GetPCSpeaker()) >= cutoff) ? TRUE : FALSE;
}

