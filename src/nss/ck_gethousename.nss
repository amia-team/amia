// Conversation conditional to get the name of the house this PC is
// affiliated with.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/04/2004 jpavelch         Initial release.
// 12/29/2006 disco            Clean and allow for full names
// 2007/07/12  disco           style and fix to locally stored journal object
// 2007/11/12  disco           using inc_ds_records

#include "inc_ds_records"

int StartingConditional( ){

    object oPC        = GetPCSpeaker( );
    string sHouseName = "Home Location";

    if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ){

        object oHome      = GetInsigniaWaypointB( oPC );

        if ( !GetIsObjectValid( oHome ) ){

            return FALSE;
        }

        sHouseName = GetName( GetArea( oHome ) );
    }

    SetCustomToken( 200, sHouseName );

    return TRUE;
}
