/*  ds_menu_set_#

    --------
    Verbatim
    --------
    Sets menu section from the Okappa restaurant

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    22-07-06  Disco       Start of header
    ------------------------------------------------------------------


*/

void main(){

    //Get PC
    object oPC       = GetPCSpeaker();

    SetLocalString( oPC, "ds_action", "ds_menu_2" );

}
