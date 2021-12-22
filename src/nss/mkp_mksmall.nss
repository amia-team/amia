// Make placeables.  Conversation action to set size and create object.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/25/2004 jpavelch         Initial release.
//

void main( )
{
    object oWand = GetLocalObject( GetPCSpeaker(), "MKP_Wand" );
    SetLocalString( oWand, "MKP_Modifier", "small" );

    ExecuteScript( "mkp_main", GetPCSpeaker() );
}
