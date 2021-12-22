// Make Placeables.  Conversation action to create a summoning circle.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/25/2004 jpavelch         Initial release.
//

void main()
{
    object oPC = GetPCSpeaker( );
    object oWand = GetLocalObject( oPC, "MKP_Wand" );
    location lTarget = GetLocalLocation( oWand, "MKP_TargetLocation" );
    float fDuration = GetLocalFloat( oWand, "MKP_Duration" );

    object oObject = CreateObject(
                         OBJECT_TYPE_PLACEABLE,
                         "x2_plc_scircle",
                         lTarget
                     );
    AssignCommand( GetArea(oPC), DelayCommand(fDuration, DestroyObject(oObject)) );
    // For local vars cleanup.
    DeleteLocalInt( oWand, "MKP_State" );
    ExecuteScript( "mkp_main", oPC );
}
