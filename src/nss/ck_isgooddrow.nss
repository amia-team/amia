// Conversation conditional to check if PC is a Drow and of good alignment.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/12/2004 jpavelch         Initial release.
// 12/10/2005 kfw              disabled SEI, True Race compatibility

//#include "subraces"


int StartingConditional(){

    // vars
    object oPC=GetPCSpeaker();
    string szRace=GetStringLowerCase(GetSubRace(oPC));

    if( (szRace=="drow")                                &&
        (GetAlignmentGoodEvil(oPC)==ALIGNMENT_GOOD)     ){

        return(TRUE);

    }
    else{

        return(FALSE);

    }

}
