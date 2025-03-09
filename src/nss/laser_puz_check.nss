/*  Djinni Laser Puzzle check

   - Mav

   Will check to see if the puzzle is locked out or not.
*/

int StartingConditional(){

    //Get PC
    object oPC   = GetPCSpeaker();

    object oArea = GetArea(oPC);
    string sID = GetLocalString(OBJECT_SELF,"puzzleid");
    int nActive = GetLocalInt(oArea,sID+"locked");

    //test preset variable on PC
    if ( nActive == 1 ){

        return FALSE;

    }

    return TRUE;
}
