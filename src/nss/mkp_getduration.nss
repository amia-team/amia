// Make placeables.  Conversation conditional to show the current duration.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/25/2004 jpavelch         Initial release.
//

int StartingConditional( )
{
    object oWand = GetLocalObject( GetPCSpeaker(), "MKP_Wand" );
    float fDuration = GetLocalFloat( oWand, "MKP_Duration" );

    // Defaults to 3 minutes.
    if ( fDuration == 0.0 ) {
        fDuration = 180.0;
        SetLocalFloat( oWand, "MKP_Duration", fDuration );
    }

    int nMinutes = FloatToInt( fDuration/60 );
    SetCustomToken( 500, IntToString(nMinutes) );
    return TRUE;
}
