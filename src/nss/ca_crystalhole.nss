// Conversation action of crystal hole.  Ports PC and associates to other
// side of the river.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/01/2004 jpavelch         Initial release.
//

void main()
{
    object oPC = GetPCSpeaker( );

    object oSelf = OBJECT_SELF;
    string sTag = GetTag( oSelf );

    string sDestTag = GetStringLeft( sTag, (GetStringLength(sTag)-1) );
    if ( GetStringRight(sTag, 1) == "1" )
        sDestTag += "2";
    else
        sDestTag += "1";

    object oDest = GetNearestObjectByTag( sDestTag );

    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, JumpToObject(oDest, FALSE) );

    // Port the associates.
    int i;
    object oAssociate;
    for ( i=ASSOCIATE_TYPE_HENCHMAN; i <= ASSOCIATE_TYPE_DOMINATED; ++i ) {
        oAssociate = GetAssociate( i, oPC );
        if ( GetIsObjectValid(oAssociate) ) {
            AssignCommand( oAssociate, ClearAllActions() );
            AssignCommand( oAssociate, JumpToObject(oDest, FALSE) );
        }
    }
}
