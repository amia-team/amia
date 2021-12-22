// Conversation conditional to get the name of the startpoint this PC is
// affiliated with.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2007/11/12 disco         Initial release.

#include "inc_ds_records"

int StartingConditional( ){

    object oPC   = GetPCSpeaker( );
    string sName = "Start Location";

    if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ){

        object oHome = GetWaypointByTag( GetStartWaypoint( oPC ) );

        if ( !GetIsObjectValid( oHome ) ){

            return FALSE;
        }

        sName = GetName( GetArea( oHome ) );
    }

    SetCustomToken( 202, sName );

    return TRUE;
}
