// Conversation conditional to check if OBJECT_SELF is a cusion.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/14/2004 jpavelch         Initial Release.
//

int StartingConditional( )
{
    object oPC = GetPCSpeaker( );
    object oTarget = GetLocalObject( oPC, "AR_Target" );

    if ( !GetIsObjectValid(oTarget) )
        return FALSE;

    string sResRef = GetResRef( oTarget );
    return ( sResRef == "ar_cusion" );
}
