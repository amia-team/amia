/*  ds_check_quest_1

    --------
    Verbatim
    --------
    Generic quest tester.
    Selects on NPC tag.
    Returns TRUE if condition is met.

    ---------
    Changelog
    ---------

    Date    Name        Reason
    ------------------------------------------------------------------
    062406  Disco       Script header started
  20071103  Disco       Now uses databased PCKEY functions
    ------------------------------------------------------------------


*/
//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"

//-------------------------------------------------------------------------------
//starting conditional
//-------------------------------------------------------------------------------

int StartingConditional(){

    //variables
    object oPC           = GetPCSpeaker();
    string sConvoNPCTag  = GetTag(OBJECT_SELF);

    //sometimes an NPC reacts to SpeakString from another NPC
    if( !GetIsPC(oPC) ){

        return FALSE;
    }

    if( sConvoNPCTag == "ds_fisherman" ){

        // don't show option if quest is set
        if( GetPCKEYValue( oPC, "ds_quest_1" ) > 0 ){ return FALSE; }

    }
    else if( sConvoNPCTag == "Zeek" ){

        // don't show option if total quest is not set
        if( GetPCKEYValue( oPC, "ds_quest_1" ) < 1 ){ return FALSE; }

        // don't show option if subquest is set
        if( GetPCKEYValue( oPC, "ds_quest_2" ) > 0 ){ return FALSE; }

    }
    else if( sConvoNPCTag == "ds_pitcher" ){

        // don't show option if total quest is not set
        if( GetPCKEYValue( oPC, "ds_quest_1" ) < 1 ){ return FALSE; }

        // don't show option if subquest is set
        if( GetPCKEYValue( oPC, "ds_quest_3" ) > 0 ){ return FALSE; }

    }
    else if( sConvoNPCTag == "ds_uhm_mayor" ){

        // don't show option if total quest is not set
        if( GetPCKEYValue( oPC, "ds_quest_4" ) != 1 ){ return FALSE; }

        int    nDeadFishermen = GetLocalInt( OBJECT_SELF, "ds_dfm" ) + 1;
        string sDeadFishermen;

        SetLocalInt( OBJECT_SELF, "ds_dfm", nDeadFishermen );

        switch ( nDeadFishermen ) {
            case 1:     sDeadFishermen = "first";     break;
            case 2:     sDeadFishermen = "second";    break;
            case 3:     sDeadFishermen = "third";     break;
            case 4:     sDeadFishermen = "fourth";    break;
            case 5:     sDeadFishermen = "fifth";     break;
            case 6:     sDeadFishermen = "sixth";     break;
            case 7:     sDeadFishermen = "seventh";   break;
            case 8:     sDeadFishermen = "eighth";    break;
            case 9:     sDeadFishermen = "ninth";     break;

            default:    sDeadFishermen = "*counts on his fingers* -urrr- too maniest";    break;

        }

        SetCustomToken( 3101, sDeadFishermen );
    }

    return TRUE;
}

