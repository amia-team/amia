//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:
//group:
//used as:
//date: yyyy-mm-dd
//author:
// 20090513   disco            added Job System support
// 20090802   disco            moved job sytem stuff to ds_j lib, added player function
// 20110212   PoS              Added tattoo functions.
// 20130924   Terrah           Moved all commands to its own script (mod_pla_cmd)

#include "inc_language"

void main(){

    object oPC          = GetPCChatSpeaker();
    string sMessage     = GetPCChatMessage();
    int nVolume         = GetPCChatVolume();

    SetLocalString( oPC, "last_chat", sMessage );

    //we'll only use the shout channel for this
    if( nVolume == TALKVOLUME_SILENT_SHOUT ){

        if( FindSubString(sMessage,"[=[") > -1 || FindSubString(sMessage,"[=[") > -1 ){
            SendMessageToPC(oPC,"[=[ and ]=] are reserved");
            return;
        }

        ExecuteLuaString(oPC,"function ChatSend(pc) nwn.SendChatMessage(pc,OBJECT_SELF,[=["+sMessage+"]=],5); end");

        object o = GetFirstPC();
        while( GetIsObjectValid( o ) ){

            if( !GetIsDM( o ) && !GetIsDMPossessed( o ) && ( GetLocalInt( o, "dev_shout_next" ) || oPC==o ) ){

                ExecuteLuaFunction(oPC,"ChatSend",ObjectToString(o));
            }

            o = GetNextPC();
        }
    }
    else if( nVolume == TALKVOLUME_SHOUT ){

        ExecuteScript( "mod_pla_cmd", OBJECT_SELF );
    }
    else if( nVolume == TALKVOLUME_TALK || nVolume == TALKVOLUME_WHISPER ){

    }
    if (sMessage == "f_fetch"){
        SetPCChatMessage(""); // Clear chat message.
        // GET ASSOCIATES.
        object oAssociate1 = GetAssociate(3, oPC, 1); // Familiar
        object oAssociate2 = GetAssociate(4, oPC, 1); // Summon
        object oAssociate3 = GetAssociate(0, oPC, 1); // Unknown
        object oAssociate4 = GetAssociate(2, oPC, 1); // Animal Companion
        object oAssociate5 = GetAssociate(5, oPC, 1); // Dominated
        // CLEAR ACTIONS.
        AssignCommand(oAssociate1, ClearAllActions());
        AssignCommand(oAssociate2, ClearAllActions());
        AssignCommand(oAssociate3, ClearAllActions());
        AssignCommand(oAssociate4, ClearAllActions());
        AssignCommand(oAssociate5, ClearAllActions());
        // JUMP TO MASTER.
        location masterLocation = GetLocation(oPC);
        AssignCommand(oAssociate1, ActionJumpToLocation(masterLocation));
        AssignCommand(oAssociate2, ActionJumpToLocation(masterLocation));
        AssignCommand(oAssociate3, ActionJumpToLocation(masterLocation));
        AssignCommand(oAssociate4, ActionJumpToLocation(masterLocation));
        AssignCommand(oAssociate5, ActionJumpToLocation(masterLocation));
    }
    else if (sMessage == "f_stuck") {
        SetPCChatMessage(""); // Clear chat message.
        // Get nearest spawn waypoint.
        object oWaypoint = GetNearestObjectByTag("ds_spwn", oPC, 1);
        // If the target is not in combat, jump to the nearest spawn waypoint.
        if (!GetIsInCombat(oPC)) {
            AssignCommand(oPC, ActionJumpToObject(oWaypoint));
        }
    }
}

