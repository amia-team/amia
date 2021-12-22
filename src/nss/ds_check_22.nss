/*  ds_check_1

    --------
    Verbatim
    --------
    Returns true when corresponding LocalInt == 1

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    07-22-06  Disco       Start of header
    ------------------------------------------------------------------


*/

int StartingConditional(){

    //Get PC
    object oPC   = GetPCSpeaker();

    //change "ds_check_#" to the number of the script
    int nCheck   = GetLocalInt( oPC, "ds_check_22" );

    //test preset variable on PC
    if ( nCheck == 1 ){

        return TRUE;

    }

    return FALSE;
}
