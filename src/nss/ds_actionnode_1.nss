/*  ds_actionnode_#

    --------
    Verbatim
    --------
    Used as to assign a node variable for large convo files. So we can reuse the
    ds_action 1 - 99 without generating more.

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    4-07-20  Maverick00053       Start of header
    ------------------------------------------------------------------


*/


void main(){

    //Convo node number (same as script number)
    int nNode        = 1;

    //Get PC
    object oPC       = GetPCSpeaker();

    //change number to the number of the script
    SetLocalInt( oPC, "ds_actionnode", nNode );


}
