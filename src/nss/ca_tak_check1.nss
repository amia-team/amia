// Bendir Dale: Tak NPC: Residency check 1: Dwarf, Gnome, Hin or special token (big folk) only
int StartingConditional(){

    // vars
    object oPC=GetPCSpeaker();
    int nRace=GetRacialType(oPC);
    int nSpecialInvite=GetLocalInt(
        oPC,
        "special_hin_invite");

    // resolve residency check 1
    if( (nRace==RACIAL_TYPE_DWARF)      ||
        (nRace==RACIAL_TYPE_GNOME)      ||
        (nRace==RACIAL_TYPE_HALFLING)   ||
        (nSpecialInvite==1)             ){

        return(FALSE);

    }
    else{

        return(TRUE);

    }

}
