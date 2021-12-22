void main(){

    // Variables
    object oSelf = OBJECT_SELF;

    AssignCommand( oSelf, ClearAllActions( TRUE ) );

    object oPC      = GetLastSpeaker();
    int nLore       = GetSkillRank( SKILL_LORE, oPC, TRUE );
    int nLore1      = GetLocalInt( OBJECT_SELF, "nMediumLore" );
    int nLore2      = GetLocalInt( OBJECT_SELF, "nHighLore" );
    string sMessage1 = GetLocalString( OBJECT_SELF, "sLowLore" );
    string sMessage2 = GetLocalString( OBJECT_SELF, "sMediumLore" );
    string sMessage3 = GetLocalString( OBJECT_SELF, "sHighLore" );

    if ( nLore < nLore1 ){

        if ( sMessage1 != "" ){

            FloatingTextStringOnCreature( sMessage1, oPC, FALSE );
        }
    }
    else if ( nLore < nLore2 ){

        if ( sMessage2 != "" ){

            FloatingTextStringOnCreature( sMessage2, oPC, FALSE );
        }
    }
    else{

        if ( sMessage3 != "" ){

            FloatingTextStringOnCreature( sMessage3, oPC, FALSE );
        }
    }
}
