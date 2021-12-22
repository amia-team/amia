
int StartingConditional(){



    if ( GetLevelByClass( CLASS_TYPE_PALEMASTER, GetPCSpeaker() ) > 0 ){

        return TRUE;
    }

    return FALSE;
}
