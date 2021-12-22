// Winya Ravana: Elves, Half-Elves and Fey check

int StartingConditional(){

    // vars
    object oPC=GetPCSpeaker();
    int nRace=GetRacialType(oPC);

    // resolve Race status and report
    if( (nRace==RACIAL_TYPE_ELF)        ||
        (nRace==RACIAL_TYPE_FEY)        ||
        (nRace==RACIAL_TYPE_HALFELF)    ){

        return(TRUE);

    }
    else{

        return(FALSE);

    }

}
