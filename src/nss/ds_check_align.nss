/*
1               Neutral
2               Lawful
3               Chaotic
4               Good
5               Evil
*/


int StartingConditional(){

    object oPC = GetPCSpeaker();

    int nLawChaos = GetAlignmentLawChaos( oPC );
    int nGoodEvil = GetAlignmentGoodEvil( oPC );

    if ( GetLocalInt( OBJECT_SELF, "NoNeutral" ) == 1 && nLawChaos == 1 ){

        return TRUE;
    }
    if ( GetLocalInt( OBJECT_SELF, "NoNeutral" ) == 1 && nGoodEvil == 1 ){

        return TRUE;
    }
    if ( GetLocalInt( OBJECT_SELF, "NoLaw" ) == 1 && nLawChaos == 2 ){

        return TRUE;
    }
    if ( GetLocalInt( OBJECT_SELF, "NoChaos" ) == 1 && nLawChaos == 3 ){

        return TRUE;
    }
    if ( GetLocalInt( OBJECT_SELF, "NoEvil" ) == 1 && nGoodEvil == 5 ){

        return TRUE;
    }
    if ( GetLocalInt( OBJECT_SELF, "NoGood" ) == 1 && nGoodEvil == 4 ){

        return TRUE;
    }

    return FALSE;
}
