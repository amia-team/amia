// Conversation conditional to check if PC is not a Drow.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/12/2004 jpavelch         Initial release.
// 11/20/2005   kfw            modified to allow xG drow into Cordor
// 12/10/2005   kfw            disabled SEI, True Race compatibility
// 2007/10/02   disco          No more Drow in Cordor

//#include "subraces"


int StartingConditional( )
{

    // vars
    object oPC=GetPCSpeaker();
    string szRace=GetStringLowerCase(GetSubRace(oPC));
    int nAlignment=GetAlignmentGoodEvil(oPC);

    if( szRace == "drow" ){

        return(FALSE);

    }
    else{

        return(TRUE);

    }

}
