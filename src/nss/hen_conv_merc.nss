//:://////////////////////////////////////////////////
//:: X0_CH_HEN_CONV
/*

  OnDialogue event handler for henchmen/associates.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/05/2003
//:://////////////////////////////////////////////////


#include "inc_henai_pm"
#include "x0_i0_henchman"

int GetPartyMemberWithPCInArea(object oPC);

//* GeorgZ - Put in a fix for henchmen talking even if they are petrified
int AbleToTalk(object oSelf)
{
   if (GetHasEffect(EFFECT_TYPE_CONFUSED, oSelf) || GetHasEffect(EFFECT_TYPE_DOMINATED, oSelf) ||
        GetHasEffect(EFFECT_TYPE_PETRIFY, oSelf) || GetHasEffect(EFFECT_TYPE_PARALYZE, oSelf)   ||
        GetHasEffect(EFFECT_TYPE_STUNNED, oSelf) || GetHasEffect(EFFECT_TYPE_FRIGHTENED, oSelf)
    )
    {
        return FALSE;
    }

   return TRUE;
}


#include "x0_i0_henchman"


void main()
{
  // * XP2, special handling code for interjections
  // * This script only fires if someone inits with me.
  // * with that in mind, I am now clearing any interjections
  // * that the character might have on themselves.
  // //
  if (GetLocalInt(GetModule(), "X2_L_XP2") == TRUE)
  {
    SetLocalInt(OBJECT_SELF, "X2_BANTER_TRY", 0);
    SetHasInterjection(GetMaster(OBJECT_SELF), FALSE);
    SetLocalInt(OBJECT_SELF, "X0_L_BUSY_SPEAKING_ONE_LINER", 0);
    SetOneLiner(FALSE, 0);
  }

    object oShouter = GetLastSpeaker();

    DeleteLocalInt(oShouter,"ds_check_1");
    DeleteLocalInt(oShouter,"ds_check_2");

    if (GetTag(OBJECT_SELF) == "x0_hen_dee")
    {
        string sCall = GetCampaignString("Deekin", "q6_Deekin_Call"+ GetName(oShouter), oShouter);

        if (sCall == "")
        {
            SetCustomToken(1001, GetStringByStrRef(40570));
        }
        else SetCustomToken(1001, sCall);
    }

//    int i = GetLocalInt(OBJECT_SELF, sAssociateMasterConditionVarname);
//    SendMessageToPC(GetFirstPC(), IntToHexString(i));
    if (GetIsHenchmanDying() == TRUE)
    {
        return;
    }

    object oMaster = GetMaster();
    int nMatch = GetListenPatternNumber();

    object oIntruder;

     // listening pattern matched
     if (GetIsObjectValid(oMaster))
     {
            // we have a master, only listen to them
            // * Nov 2003 - Added an AbleToTalk, so that henchmen
            // * do not respond to orders when 'frozen'
        if (GetIsObjectValid(oShouter) && oMaster == oShouter && AbleToTalk(OBJECT_SELF)) {
                SetCommandable(TRUE);
                bkRespondToHenchmenShout(oShouter, nMatch, oIntruder);
         }
     }  // we don't have a master, behave in default way
     else
     {
       if(GetPartyMemberWithPCInArea(oShouter)==0)
       {
        SetCustomToken(69696969,GetLocalString(OBJECT_SELF,"nopartydialogue"));
        SetLocalInt(oShouter,"ds_check_1",1);
       }
       else
       {
        SetCustomToken(69696969,GetLocalString(OBJECT_SELF,"partydialogue"));
        SetLocalInt(oShouter,"ds_check_2",1);
       }
       BeginConversation("hen_merc_convo",oShouter);
     }


    // Signal user-defined event
    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT)) {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE));
    }
}


int GetPartyMemberWithPCInArea( object oPC){

    object oPartyMember = GetFirstFactionMember(oPC,FALSE);
    object oArea = GetArea( oPC );
    int nPartyCount = 0;

    while( GetIsObjectValid( oPartyMember ) == TRUE )
    {

        if(((GetArea(oPartyMember) == oArea) && GetIsPC(oPartyMember) && (oPC != oPartyMember)) || (GetLocalInt(oPartyMember,"IsMerc")==1))
        {
          nPartyCount++;
        }


        oPartyMember = GetNextFactionMember(oPC,FALSE);
    }

    return nPartyCount;
}
