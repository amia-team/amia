// Conversation conditional for check admin status of player.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/21/2003 jpavelch         Initial Release.
//2007/09/29  disco            Caching system implemented
//

// Returns TRUE if player is part of the admin staff.
//

#include "inc_ds_records"


int StartingConditional( ){

    object oPC                  = GetPCSpeaker( );

    if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ){

        return TRUE;
    }

    return FALSE;
}
