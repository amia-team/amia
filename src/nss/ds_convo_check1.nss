/*  ds_convo_check

--------
Verbatim
--------
Generic convo checker

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
11-07-06  Disco       Start of header
  20071119  disco       Removed CS_ tags
------------------------------------------------------------------

*/

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int check_pirates();

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

int StartingConditional(){

    object oPC      = GetPCSpeaker();
    string sNPC     = GetName(OBJECT_SELF);
    string sNPCtag  = GetTag(OBJECT_SELF);


    if( sNPC == "Lemonade Lady" ){

        return TRUE;
    }
    else if( sNPC == "Ferry to Moribund" ){

        return TRUE;
    }
    else if ( sNPCtag == "ds_captain" ){

        if ( check_pirates() != 1 ){

            return TRUE;
        }
        else{

            return FALSE;

        }
    }
    else {
        return FALSE;
    }
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int check_pirates(){

    if ( GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY ) != OBJECT_INVALID ){

        return 1;

    }
    else{

        return 0;

    }
}
