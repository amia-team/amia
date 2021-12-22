// Conversation conditional to see if PC can port to his leader.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// ?          jpavelch         Initial release.
// 02/14/2004 jpavelch         Added local integers to all areas that cannot
//                             be ported to and removed the hard-coding of
//                             area tags.


int GetAllMembersDead( object oLeader, object oArea )
{
    object oMember = GetFirstFactionMember( oLeader );
    while ( GetIsPC(oMember) ) {
        if ( GetArea(oMember) == oArea && !GetIsDead(oMember) )
            return FALSE;

        oMember = GetNextFactionMember( oLeader );
    }

    return TRUE;
}


int StartingConditional()
{
    object oPC = GetPCSpeaker( );
    object oLeader = GetFactionLeader( oPC );

    // PC cannot already be party leader
    if ( oLeader == oPC )
        return FALSE;

    object oArea = GetArea( oLeader );

    int nRezOnly = GetLocalInt( oArea, "PortOnlyToRez" );
    if ( nRezOnly )
        return ( GetAllMembersDead(oLeader, oArea) );

    int nPrevent = GetLocalInt( oArea, "PreventPortToLeader" );
    if ( nPrevent == TRUE )
        return FALSE;

    return TRUE;
}
