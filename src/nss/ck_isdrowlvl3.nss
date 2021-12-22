// Conversation conditional to check if PC is a Drow.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/12/2004 jpavelch         Initial release.
// 15/01/2005 kbillington      Adjusted level to 2
// 20050419   jking            Changed to use XP like the other scripts
// 20051210   kfw              disabled SEI, True Race compatibility

//#include "subraces"


int StartingConditional(){

    // vars
    object oPC=GetPCSpeaker();
    string szRace=GetStringLowerCase(GetSubRace(oPC));

    if( (szRace=="drow")            &&
        (GetXP(oPC)<=3000)          ){

        return(TRUE);

    }
    else{

        return(FALSE);

    }

}
