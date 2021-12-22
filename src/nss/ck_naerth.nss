int StartingConditional(){

    object oPC = GetPCSpeaker();

    int nClasses = GetLevelByClass( CLASS_TYPE_DRUID, oPC ) + GetLevelByClass( CLASS_TYPE_RANGER, oPC );

    if ( nClasses > 3 ){

        return TRUE;
    }
    else{

        return FALSE;
    }
}
