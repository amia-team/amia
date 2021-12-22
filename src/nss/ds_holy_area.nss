//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_holy_area
//group:   utility
//used as: OnEnter script
//date:    aug 05 2007
//author:  disco

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC          = GetEnteringObject();
    int nRace           = GetRacialType( oPC );
    string sMessage     = "";

    if ( nRace == RACIAL_TYPE_UNDEAD ){

        object oWaypoint = GetWaypointByTag( GetLocalString( OBJECT_SELF, "ds_target" ) );

        sMessage         = "Undead cannot enter this area." ;

        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWaypoint ) ) );

    }
    else{

        int nAlign          = GetAlignmentGoodEvil( oPC );

        sMessage            = "You are entering an area that has been Blessed. You are not allowed to raise or summon Undead";

        if ( nAlign == ALIGNMENT_EVIL ){

            sMessage = sMessage + ", and you feel very uncomfortable here.";
        }
        else {

            sMessage = sMessage + " here.";
        }
    }

    SendMessageToPC( oPC, sMessage );
}

