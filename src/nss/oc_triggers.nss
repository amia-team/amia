//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  oc_triggers
//group:   triggers
//used as: this script acts as an universal trigger handler
//date:    may 19 2007
//author:  disco


//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------

void ds_set_ocean_triggers();

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //variables
    object oPC       = GetEnteringObject();     //who triggers the trigger?
    object oArea     = GetArea(oPC);            //I can't imagine I won't need this soon
    object oTarget;                             //Most of the time the target of the script
    string sEnterTag = GetTag(OBJECT_SELF);     //The name of the trigger, to be used in the if/then
    string sMessage;                            //The message that is send to or spoken by oTarget
    location lTarget;                           //location of oTarget

    //Quit if the entering object isn't a PC
    if ( GetIsPC( oPC ) == FALSE ){

        return;
    }

    if ( sEnterTag == "oc_oceanwrecks" ){

        ds_set_ocean_triggers();

    }
}


//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------

void ds_set_ocean_triggers(){

    int i;
    int nDie = Random( 7 );
    object oTrigger;
    object oWaypoint;

    //block self
    if ( GetLocalInt( OBJECT_SELF, "blocked" ) != 1 ){

        SetLocalInt( OBJECT_SELF, "blocked", 1 );
    }
    else{

        return;
    }

    //remove self
    DestroyObject( OBJECT_SELF, 3.0 );

    for ( i=0; i<7; ++i ){

        oTrigger = GetObjectByTag( "oc_bottom_to_wreck", i );

        if ( oTrigger != OBJECT_INVALID && nDie != i ){

            //get return waypoint
            oWaypoint = GetNearestObjectByTag( "oc_from_wreck", oTrigger );

            //destroy trigger
            DestroyObject( oTrigger, 1.0 );

            //destroy associated waypoint
            DestroyObject( oWaypoint, 2.0 );
        }
        else{

            //get return waypoint
            oWaypoint = GetNearestObjectByTag( "oc_from_wreck", oTrigger );

            CreateObject( OBJECT_TYPE_PLACEABLE, "nw_plc_bubbleslg", GetLocation( oWaypoint ) );
        }
    }
}


