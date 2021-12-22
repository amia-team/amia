// OnUsed event when user steps into shrine trigger to climb down
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050212   jking            Initial Release.
//

void main( )
{
    object oPC = GetEnteringObject( );
    if ( !GetIsPC(oPC) ) return;

    string sConversation = GetLocalString(OBJECT_SELF, "convo");

    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, ActionStartConversation(oPC, sConversation, TRUE, FALSE) );
}
