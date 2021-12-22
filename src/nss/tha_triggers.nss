/*
tha_triggers

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This script is as a universal trigger handler

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
19-11-2007      disco      Now using inc_ds_records
------------------------------------------------
*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"


//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void tha_trigger_message(object oPC, string sTrigger, string sMessage);
void tha_speak_phrase(object oPC, string sTrigger, string sTarget, int nDie);

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //variables
    object oPC=GetEnteringObject();             //who triggers the trigger?
    object oArea= GetArea(oPC);                 //I can't imagine I won't need this soon
    object oTarget;                             //Most of the time the target of the script
    string sEnterTag=GetTag(OBJECT_SELF);       //The name of the trigger, to be used in the if/then
    string sMessage;                            //The message that is send to or spoken by oTarget
    location lTarget;                           //location of oTarget

    //Quit if the entering object isn't a PC
    if (GetIsPC(oPC)==FALSE){return;}

    //area Mt Firth Caverns
    if(sEnterTag=="tha_dragonlair"){
        int nDC = 40;    // difficulty of thing to avoid
        int nQuiet = GetSkillRank( SKILL_MOVE_SILENTLY, oPC );
        if ((nQuiet >= 0) && (d20() + nQuiet >= nDC) && GetStealthMode(oPC)==STEALTH_MODE_ACTIVATED) {
            SendMessageToPC(oPC,"You managed to sneak past the dragon!");
        }
        else{
            SendMessageToPC(oPC,"The dragon notices you moving towards it's treasures!");
            oTarget=GetObjectByTag("tha_dragon");
            AssignCommand(oTarget, SpeakString("I shall kick thine arse from mine lair!"));
            DelayCommand(0.0,ActionStartConversation(oPC,"tha_dragonlair"));
        }
    }
    //Mt Firth Caverns
    else if(sEnterTag=="tha_dragoncave"){
        tha_trigger_message(oPC,"tha_dragoncave", "This is a sight to behold! You enter a gigantic cave, inhabited by a fancy coloured dragon. The dragon ignores you, as she is busy studying a series of books and maps spread out in front of her. The cave is crawling with kobolds: some are making mushroom stew, others groom the dragon and you even see one or two cleaning the numerous artifacts displayed around the cave.");
    }
    //Glacier
    else if(sEnterTag=="tha_skullpole"){
        tha_trigger_message(oPC,"tha_skullpole", "Somebody placed the skulls of large humanoid monsters on a pole.");
    }
    //Howness West Bay
    else if(sEnterTag=="tha_menhirs"){
        tha_trigger_message(oPC,"tha_menhirs", "You see a group of menhirs standing in the snow. Somebody placed the head of a large humanoid monster on a pole between the stones.");
    }
    //Gray Forest Coast Road
    else if(sEnterTag=="tha_forgotten"){
        tha_trigger_message(oPC,"tha_menhirs", "You enter an area with derelict buildings and ruined defensive structures. The snow and the everlasting darkness make it hard to determine how long the place has been in this sorry state.");
    }
    //indoor areas in Howness
    else if(sEnterTag=="tha_tale"){
        tha_speak_phrase(oPC,sEnterTag,"tha_npc",20);
    }
    else if(sEnterTag=="tha_gnometalk"){
        tha_speak_phrase(oPC,sEnterTag,"tha_npc",5);
    }
    //Mt Firth Caverns
    else if(sEnterTag=="tha_kobolt_chat"){
        tha_speak_phrase(oPC,sEnterTag,"tha_kobolt",8);
    }
    //temple and monastery
    else if(sEnterTag=="tha_prayer"){
        tha_speak_phrase(oPC,sEnterTag,"tha_priest",8);
    }
    //Ljot caverns
    else if( sEnterTag == "tha_trigger_ljot" ){

        int nQuest = ds_quest( oPC, "tha_quest5", 0 );

        if ( GetNearestObjectByTag( "tha_werewolf", oPC ) == OBJECT_INVALID && ( nQuest == 1 || nQuest == 2 ) ){

            ds_quest( oPC, "tha_quest5", 2 );

            oTarget = GetNearestObjectByTag( "tha_spawn_ljot", oPC, d4() );

            CreateObject( OBJECT_TYPE_CREATURE, "tha_werewolf", GetLocation( oTarget ), FALSE );
        }
    }
    //Ljot caverns
    else if( sEnterTag == "tha_put_back" ){

        if ( GetNearestObjectByTag( "tha_werewolf", oPC ) != OBJECT_INVALID && ds_quest( oPC, "tha_quest5", 0 ) == 0 ){

            SendMessageToPC( oPC, "OOC: Don't interfere in this fight or your companion's quest will be disabled." );
            AssignCommand( oPC, JumpToObject( GetObjectByTag( "tha_get_out" ) ) );
        }
    }
    //Below the forgotten ruins
    else if(sEnterTag=="tha_children"){
        if(GetNearestObjectByTag("tha_child",oPC)==OBJECT_INVALID && ds_quest( oPC,"tha_quest7",0)==1){
            oTarget=GetNearestObjectByTag("tha_spawn_child",oPC,d4());
            CreateObject(OBJECT_TYPE_CREATURE, "tha_child", GetLocation(oTarget), FALSE);
        }
    }
    //Gnomish Testing Grounds
    else if(sEnterTag=="tha_gnomish_bomb"){
        oTarget=GetNearestObjectByTag("tha_npc",oPC);
        AssignCommand(oTarget, SpeakString("NO! FOOL! DUCK!"));
        lTarget = GetLocation(GetNearestObjectByTag("tha_gnomish_bomb"));
        AssignCommand(oTarget, ActionCastSpellAtLocation(SPELL_GREAT_THUNDERCLAP,lTarget,METAMAGIC_ANY,TRUE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
        //the trigger destroys the bomb, so I destroy the trigger too. This one fires once a reboot.
        DestroyObject(OBJECT_SELF);
    }
}


//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------

//This function sends a message and makes sure the same trigger isn't saying this until another message has been received
void tha_trigger_message(object oPC, string sTrigger, string sMessage){
    if(GetLocalString(oPC,"tha_last_message")!=sTrigger){
        SendMessageToPC(oPC,sMessage);
        SetLocalString(oPC,"tha_last_message",sTrigger);
    }
}

//makes each waypoint deliver a story/prayer once a minute, if triggered.
void tha_speak_phrase(object oPC, string sTrigger, string sTarget, int nDie){

    //variables
    object oWaypoint;   //I get a lot of info from waypoints
    object oTarget;     //Most of the time the target of the script
    string sTag;        //Sometimes I need a tag for something
    string sMessage;    //The message that is send to or spoken by oTarget

    //get waypoint first and check if it's not recently used
    oWaypoint=GetNearestObjectByTag(sTrigger+"s",oPC,1);

    if (GetLocalInt(oWaypoint,"used")==0){

        //get the right item and make the closest npc speak
        oTarget=GetNearestObjectByTag(sTarget,oPC);
        sTag="item_"+IntToString(1+Random(nDie));
        sMessage=GetLocalString(oWaypoint,sTag);
        if(sMessage!=""){
            AssignCommand(oTarget, SpeakString(sMessage));
        }

        //makes sure this waypoint isn't delivering a message every enter
        SetLocalInt(oWaypoint,"used",1);
        DelayCommand(120.0, SetLocalInt(oWaypoint,"used",0));
    }
}
