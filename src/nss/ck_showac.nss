// Conversation conditional to show AC in custom token.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/24/2004 jpavelch         Initial release.
//

int StartingConditional( )
{
    object oSelf = OBJECT_SELF;

    int nAC = GetAC( oSelf );
    SetCustomToken( 500, IntToString(nAC) );

    return TRUE;
}
