// Conversation conditional to check if PC is a Drow or Half-Drow.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 9/19/2005   bbillington       Initial release.
// 12/10/2005  kfw               disabled SEI, True Race compatibility

//#include "subraces"


int StartingConditional(){

    // vars
    object oPC=GetPCSpeaker();
    string szRace=GetStringLowerCase(GetSubRace(oPC));

    if( (szRace=="drow")        ||
        (szRace=="half-drow")   ){

        return(TRUE);

    }
    else{

        return(FALSE);

    }

}
