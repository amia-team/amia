// Conversation conditional to see if the PC has nature levels or Animal Domain.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 08/03/2013 PoS              Initial release.
//


int StartingConditional()
{
    object oPC   = GetPCSpeaker();
    // Restrict based on the player's class
    if( GetLevelByClass( CLASS_TYPE_DRUID, oPC ) ) return TRUE;
    else if( GetLevelByClass( CLASS_TYPE_RANGER, oPC ) >= 4 ) return TRUE;
    else if( GetHasFeat( FEAT_ANIMAL_DOMAIN_POWER, oPC ) ) return TRUE;
    return FALSE;
}
