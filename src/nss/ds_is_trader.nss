//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:ds_is_trader
//group: travel
//used as: check
//date: 2008-10-26
//author: disco




int StartingConditional(){

    object oPC = GetPCSpeaker();

    if ( GetIsObjectValid( GetItemPossessedBy( oPC, "tha_trader_papers" ) ) ){

        return TRUE;
    }

    return FALSE;
}
