// Make placeables.  Conversation action to set color and create a shaft of
// light or magic sparks.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/25/2004 jpavelch         Initial release.
//

void main( )
{
    object oWand = GetLocalObject( GetPCSpeaker(), "MKP_Wand" );
    SetLocalString( oWand, "MKP_Modifier", "green" );

    ExecuteScript( "mkp_main", GetPCSpeaker() );
}
