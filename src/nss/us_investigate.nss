// 6/26/2016    msheeler    added epic result check

void main(){

    object oPC      = GetLastUsedBy();
    string sSkill   = GetLocalString( OBJECT_SELF, "SkillCheck" );
    int nLore;
    int nSkill;
    int nLore1      = GetLocalInt( OBJECT_SELF, "nMediumLore" );
    int nLore2      = GetLocalInt( OBJECT_SELF, "nHighLore" );
    int nLore3      = GetLocalInt( OBJECT_SELF, "nEpicLore" );
    string sMessage1 = GetLocalString( OBJECT_SELF, "sLowLore" );
    string sMessage2 = GetLocalString( OBJECT_SELF, "sMediumLore" );
    string sMessage3 = GetLocalString( OBJECT_SELF, "sHighLore" );
    string sMessage4 = GetLocalString( OBJECT_SELF, "sEpicLore" );

    if( sSkill == "" )
    {
        nLore = GetSkillRank( SKILL_LORE, oPC, TRUE );
    }
    else
    {
        nSkill = StringToInt( sSkill );
        nLore = GetSkillRank( nSkill, oPC, TRUE );
    }

//    SendMessageToPC ( oPC, "DEBUG: Lore result is: " + IntToString ( nLore ));

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
    else if ( sMessage4 == "") {

        if ( sMessage3 != "" ){

            FloatingTextStringOnCreature( sMessage3, oPC, FALSE );
        }
    }
     else if ( sMessage4 != "" && nLore < nLore3 ) {

        if ( sMessage3 != "") {

            FloatingTextStringOnCreature( sMessage3, oPC, FALSE );
        }
    }
    else {
        if ( sMessage4 != "" ) {

            FloatingTextStringOnCreature( sMessage4, oPC, FALSE );
        }
    }
}
