/*
tha_npc_convo

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This script generates npc reactions based on race and reputation.

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
06-21-2006      disco      Check if the Priest is still in convo with a PC
19-11-2007      disco      Now using inc_ds_records
------------------------------------------------
*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"
#include "x0_i0_position"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
//makes npc speak a oneliner. The oneliner is stored on sWaypoint.
void tha_speak_phrase(object oPC, string sVariable, string sWaypoint);
//translates race/subrace into the right variable
string tha_get_race(object oPC);
//gets Sir?lady
string tha_get_title(object oPC);

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //variables
    object oPC=GetLastSpeaker();
    string sRace=tha_get_race(oPC);
    int nReputation=tha_reputation(oPC,0);

    //sometimes an NPC reacts to SpeakString from another NPC
    if(GetIsPC(oPC)==FALSE){
        return;
    }

    //face speaker
    TurnToFaceObject(oPC,OBJECT_SELF);

    //reputation check
    if(nReputation<2){
        tha_speak_phrase(oPC, sRace, "tha_insults1");
    }
    else if(nReputation<4){
        tha_speak_phrase(oPC, sRace, "tha_insults2");
    }
    else if(nReputation<5){
        AssignCommand(OBJECT_SELF, SpeakString("Hello, aren't you -urr- *snaps fingers* -urmm- ..."+tha_get_title(oPC)+" "+RandomName()+"?"));
    }
    else{
        AssignCommand(OBJECT_SELF, SpeakString("Hello, if it isn't "+tha_get_title(oPC)+" "+GetName(oPC)+"!"));
    }
}


//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
void tha_speak_phrase(object oPC, string sVariable, string sWaypoint){

    //variables
    object oWaypoint;   //The insults are stored on waypoints
    string sMessage;    //The message that is send to or spoken by oTarget

    //get waypoint first and check if it's not recently used
    oWaypoint=GetNearestObjectByTag(sWaypoint,oPC,1);

    //get the right item and make the npc speak
    sMessage=GetLocalString(oWaypoint,sVariable);
    if(sMessage!=""){
        SpeakString(sMessage);
    }
    else{
        //default outside Howness
        SpeakString("Hello, stranger!");
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

string tha_get_title(object oPC){
    int nGender=GetGender(oPC);
    string sTitle="Sir";

    if(nGender==1){
        sTitle="M'lady";
    }
    return sTitle;
}

