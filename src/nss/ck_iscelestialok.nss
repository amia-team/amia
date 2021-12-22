// Conversation conditional to see if the PC can select Celestialsummons.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 08/03/2013 PoS              Initial release.
//

#include "inc_ds_records"

int StartingConditional()
{
    object oPC   = GetPCSpeaker();
    int nChosen  = GetPCKEYValue( oPC, "AlignChoice" );
    // Restrict based on the player's class & alignment
    if( GetLevelByClass( CLASS_TYPE_DRUID, oPC ) ) return FALSE;
    else if( GetLevelByClass( CLASS_TYPE_RANGER, oPC ) >= 4 ) return FALSE;
    else if( GetAlignmentGoodEvil( oPC ) == ALIGNMENT_GOOD ) return TRUE;
    else if( GetAlignmentGoodEvil( oPC ) == ALIGNMENT_NEUTRAL && nChosen == 3) return TRUE;
    else if( GetAlignmentGoodEvil( oPC ) == ALIGNMENT_NEUTRAL && nChosen == 0) return TRUE;
    return FALSE;
}
