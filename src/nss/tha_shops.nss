/*
tha_shops

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This script generates npc reactions based on race and reputation and opens a shop

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
2008-01-01      Disco      Updated
2011-11-08      Selmak     Allowed for random shops to periodically purge and
                           refresh their inventories.
------------------------------------------------
*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "nw_i0_plot"
#include "inc_ds_records"
#include "ds_inc_randstore"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
//makes npc speak a oneliner. The oneliner is stored on sWaypoint.
void tha_speak_phrase(object oPC, object oTarget, string sVariable, string sWaypoint);

//translates race/subrace into the right variable
string tha_get_race(object oPC);

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    object oPC      = GetPCSpeaker();
    string sRace    = tha_get_race( oPC );
    int nReputation = tha_reputation( oPC, 0 );
    string sStore   = GetTag( OBJECT_SELF );
    object oStore   = GetLocalObject( OBJECT_SELF, "MyStore" );

    if ( GetObjectType( oStore ) != OBJECT_TYPE_STORE ) {

        oStore = CreateObject( OBJECT_TYPE_STORE, sStore, GetLocation( OBJECT_SELF ) );
    }

    if( GetObjectType( oStore ) == OBJECT_TYPE_STORE ){

        //store store on object for future use
        SetLocalObject( OBJECT_SELF, "MyStore", oStore );

        //inject random items, if any are set
        InjectIntoStore( oStore );
    }
    else{

        //error
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
        return;
    }

    //reputation check
    if ( nReputation < 2 ){

        //no shop, but insults
        tha_speak_phrase( oPC, OBJECT_SELF, sRace, "tha_shops1" );
        return;
    }
    else if( nReputation < 3 ){

        //no shop, but milder insults
        tha_speak_phrase( oPC, OBJECT_SELF, sRace, "tha_shops2" );
        return;
    }
    else if( nReputation < 4 ){

        AssignCommand( OBJECT_SELF, SpeakString( "OK, OK, for YOU I make an exception!" ) );

        //the shop opens, but you get lousy prices and no appraise
        OpenStore( oStore, oPC, 0, 0 );
    }
    else{

        AssignCommand( OBJECT_SELF, SpeakString( "Of course! It's my pleasure, " + GetName( oPC ) + "!" ) );

        //only well known people can haggle
        gplotAppraiseOpenStore( oStore, oPC, 10, 10 );
    }

    //trace store use
    db_trace_shop( oPC, oStore, OBJECT_SELF );
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
void tha_speak_phrase( object oPC, object oTarget, string sVariable, string sWaypoint ){

    //variables
    object oWaypoint;   //I get a lot of info from waypoints
    string sMessage;    //The message that is send to or spoken by oTarget

    //get waypoint first and check if it's not recently used
    oWaypoint = GetNearestObjectByTag( sWaypoint, oPC, 1 );

    //get the right item and make the npc speak
    sMessage=GetLocalString(oWaypoint,sVariable);

    if ( sMessage != "" ){

        AssignCommand( oTarget, SpeakString( sMessage ) );
    }
}

string tha_get_race(object oPC){

    //variables
    int nRace;
    string sRace;
    string sSubRace;

    //basic races
    nRace=GetRacialType(oPC);
    if(nRace==RACIAL_TYPE_DWARF){sRace="dwarf";}
    if(nRace==RACIAL_TYPE_ELF){sRace="elf";}
    if(nRace==RACIAL_TYPE_GNOME){sRace="gnome";}
    if(nRace==RACIAL_TYPE_HALFELF){sRace="halfelf";}
    if(nRace==RACIAL_TYPE_HALFLING){sRace="halfling";}
    if(nRace==RACIAL_TYPE_HALFORC){sRace="halfork";}
    if(nRace==RACIAL_TYPE_HUMAN){sRace="human";}

    //relevant subrace overrules
    sSubRace=GetStringLowerCase(GetSubRace(oPC));
    if (sSubRace=="aquatic"){sRace="aquaticelf";}
    if (sSubRace=="svirfneblin"){sRace="svirfneblin";}
    if (sSubRace=="duergar"){sRace="duergar";}
    if (sSubRace=="drow"){sRace="drow";}
    if (sSubRace=="half-drow"){sRace="halfdrow";}
    if (sSubRace=="aasimar"){sRace="aasimar";}
    if (sSubRace=="tiefling"){sRace="tiefling";}
    if (sSubRace=="air genasi"){sRace="genasi";}
    if (sSubRace=="earth genasi"){sRace="genasi";}
    if (sSubRace=="fire genasi"){sRace="genasi";}
    if (sSubRace=="water genasi"){sRace="genasi";}
    if (sSubRace=="goblin"){sRace="goblin";}
    if (sSubRace=="faerie"){sRace="faerie";}
    if (sSubRace=="kobold"){sRace="kobold";}

    return GetStringLowerCase(sRace);
}
