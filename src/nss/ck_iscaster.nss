// Conversation conditional to see if the PC has any caster levels.
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
    if( GetLevelByClass( CLASS_TYPE_BARD, oPC ) ) return TRUE;
    else if( GetLevelByClass( CLASS_TYPE_CLERIC, oPC ) ) return TRUE;
    else if( GetLevelByClass( CLASS_TYPE_DRUID, oPC ) ) return TRUE;
    else if( GetLevelByClass( CLASS_TYPE_RANGER, oPC ) ) return TRUE;
    else if( GetLevelByClass( CLASS_TYPE_SORCERER, oPC ) ) return TRUE;
    else if( GetLevelByClass( CLASS_TYPE_WIZARD, oPC ) ) return TRUE;

    return FALSE;
}
