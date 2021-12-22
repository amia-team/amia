// Conversation conditional to check if PC speaker is evil.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/22/2004 jpavelch         Initial Release.
//

int StartingConditional( )
{
    return ( GetAlignmentGoodEvil(GetPCSpeaker()) == ALIGNMENT_EVIL );
}
