// Conversation action to rotate a placeable object 45 degrees clockwise.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/22/2004 jpavelch         Initial release.
//

void main( )
{
    object oPC = GetPCSpeaker( );
    object oTarget = GetLocalObject( oPC, "AR_Target" );

    if ( !GetIsObjectValid(oTarget) ) {
        if ( oPC != OBJECT_SELF )
            oTarget = OBJECT_SELF;
    }

    float fDirection = GetFacing( oTarget );
    fDirection -= 45.0;
    if ( fDirection < 0.0 ) fDirection += 360.0;

    AssignCommand( oTarget, SetFacing(fDirection) );
}
