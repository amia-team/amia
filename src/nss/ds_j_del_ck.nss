/*  ds_j_del_ck

    --------
    Verbatim
    --------
    Returns true when DM-set LocalInt == 1
    This variable isn't set by any other script!

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    11-Feb-11 Selmak      Created check script
    ------------------------------------------------------------------


*/

int StartingConditional(){

    //Get PC
    object oPC   = GetPCSpeaker();

   //If "ds_trade_deletion" is set to 1 on the PC (by a DM) deleting
   //trade stuff is possible.

   if ( GetLocalInt( oPC, "ds_j_trade_deletion" ) ){
        return TRUE;
   }

    return FALSE;
}
