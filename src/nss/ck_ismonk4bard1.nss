// Conversation conditional to check if PC has at least four levels of
// Paladin class or one level of Bard.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/30/2003 jpavelch         Initial Release.
//

int StartingConditional( )
{
    object oPC = GetPCSpeaker( );

    if ( GetIsDM(oPC) )
        return TRUE;

    return ( GetLevelByClass(CLASS_TYPE_MONK, oPC) >= 4
            || GetLevelByClass(CLASS_TYPE_BARD, oPC) >= 1 );
}
