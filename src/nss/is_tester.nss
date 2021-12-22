//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  is_tester
//group:   tools
//used as: check script
//date:    may 27 2007
//author:  disco


int StartingConditional(){

    object oPC = GetPCSpeaker();

    if ( GetLocalInt( oPC, "tester" ) == 1 ) {

        return TRUE;
    }

    return FALSE;

}
