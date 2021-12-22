// Conversation conditional to check if PC is a Drow.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/12/2004 jpavelch         Initial release.
// 11/20/2005 kfw              modified to allow only xE and xN drow into Udos
// 12/10/2005 kfw              disabled SEI, True Races compatibility
// 12/31/2006 kfw              Added DMs

//#include "subraces"
#include "cs_inc_xp"

int StartingConditional( )
{
    // vars
    object oPC = GetPCSpeaker();

    if ( GetIsDM( oPC ) ){

        SendMessageToPC( oPC, "[Drow test passed because you are a DM]" );
        return(TRUE);
    }

    int szRace=GetRacialType(oPC);
    int nAlignment=GetAlignmentGoodEvil(oPC);

    if( (szRace==33)   &&

        (   (nAlignment==ALIGNMENT_EVIL)       ||
            (nAlignment==ALIGNMENT_NEUTRAL)     )   ){

        return(TRUE);

    }
    else{

        return(FALSE);

    }
}
