// Conversation conditional for Billy the Paper Boy shouting his headlines.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 08/17/2003 jpavelch         Initial Release.
//


#include "NW_I0_GENERIC"


int StartingConditional()
{
    if ( GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION)
        && !GetIsObjectValid(GetPCSpeaker()) ) {

        object oBilly = GetObjectByTag( "Billy" );
        int nOneLiner = GetLocalInt( oBilly, "jp_oneliner" );

        if ( nOneLiner == 1 ) {
            SetLocalInt( oBilly, "jp_oneliner", nOneLiner+1 );
            return TRUE;
        }
    }

    return FALSE;
}
