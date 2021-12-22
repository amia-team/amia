// Conversation action to sit on the selected object.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/14/2004 jpavelch         Initial Release.
//

void main( )
{
    object oPC = GetPCSpeaker( );
    object oTarget = GetLocalObject( oPC, "AR_Target" );

    if ( !GetIsObjectValid(oTarget) ) {
        if ( oPC != OBJECT_SELF )
            oTarget = OBJECT_SELF;
    }

    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, ActionSit(oTarget) );
}
