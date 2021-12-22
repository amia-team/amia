int StartingConditional(){

    object oPC = GetPCSpeaker();

    int nClasses = GetLevelByClass( CLASS_TYPE_ARCANE_ARCHER, oPC );

    if ( nClasses > 1 ){

        return TRUE;
    }
    else{

        return FALSE;
    }
}
