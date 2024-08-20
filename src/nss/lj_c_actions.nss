///////////////////////////////////////////////////////
/*      Lord-Jyssev Convo Actions Taken Script

  This script will allow you to use Script Params in
  the dialogue window to take actions from the convo.

  To use it, add this to every instance of an "Actions
  taken" and be sure to set Script Params from the
  following list of options:

  - TakeGold       (Amount of gold to take from PC)
  - TakeItem       (Item tag to take from PC)
  - TakeDCs        (Amount of Dream Coins to take)
  - GiveXP         (XP to give to PC, can be negative)
  - GiveItem       (Item tag to give to PC)
  - GiveGold       (Amount of gold to give to PC)
  - GiveDCs        (Amount of Dream Coins to give)
  - Destination    (Teleports the player to this waypoint)
    -- DestinationParty (A trigger tagged "partytrigger" needs to be placed)
  - Hostile        (Setting to 1 makes the NPC hostile and attack)
  - Exit           (Setting to 1 makes the NPC destroy self after 1.5 seconds)
  - CustomToken    (Checks the NPC for this variable as a numbered custom token)
    -- TokenNumber (Needs to be set to the custom token number in the dialogue)
  - RunScript      (Runs the script name set in the Value field)
                                                     */
///////////////////////////////////////////////////////

#include "inc_dc_api"
#include "inc_ds_records"
#include "amia_include"

//Check if this param is set on the player or the NPC. If set on the player's last response, get the NPC as the last speaker
object CheckNPC( object oNPC );

void main()
{
    object oPC = GetPCSpeaker();
    object oNPC = OBJECT_SELF;

    int nTakeGold = StringToInt(GetScriptParam("TakeGold"));
    int nTakeDCs = StringToInt(GetScriptParam("TakeDCs"));
    string sTakeItem = GetScriptParam("TakeItem");
    string sDestination = GetScriptParam("Destination");
    string sDestinationParty = GetScriptParam("DestinationParty");

    int nGiveGold = StringToInt(GetScriptParam("GiveGold"));
    int nGiveDCs = StringToInt(GetScriptParam("GiveDCs"));
    string sGiveItem = GetScriptParam("GiveItem");
//    int nGiveFeat = StringToInt(GetScriptParam("GiveFeat"));            //Not yet implemented
    int nGiveXP = StringToInt(GetScriptParam("GiveXP"));
    int nHostile = StringToInt(GetScriptParam("Hostile"));
    int nExit = StringToInt(GetScriptParam("Exit"));
    string sCustomToken = GetScriptParam("CustomToken");
    string sRunScript = GetScriptParam("RunScript");

    if(nTakeGold != 0)
    {

        if(GetGold(oPC) < nTakeGold) //Failsafe for if the PC drops gold during the conversation
        {
            SendMessageToPC(oPC,"You don't have enough gold.");
            return;
        }
        else
        {
            TakeGoldFromCreature(nTakeGold, oPC, TRUE);
        }
    }
    if(sTakeItem != "")
    {
        if(GetIsObjectValid(GetItemPossessedBy(oPC, sTakeItem))) //Failsafe for if the PC drops the item during the conversation
        {
            SendMessageToPC(oPC,"You don't have the required item.");
            return;
        }
        else
        {
            ActionTakeItem(GetItemPossessedBy(oPC, sTakeItem), oPC);
        }
    }
    if(nTakeDCs != 0)
    {
        string sCDKey = GetPCPublicCDKey(oPC);
        SetDreamCoins(sCDKey, GetDreamCoins(sCDKey)-nTakeDCs);
        SendMessageToPC(oPC, "Dream Coins removed: <c§iÿ>" + IntToString(nTakeDCs) + "</c>");
    }
    if(nGiveGold != 0)
    {
        GiveGoldToCreature(oPC, nGiveGold);
    }
    if(sGiveItem != "")
    {
        object oGivenItem = CreateItemOnObject(sGiveItem, oPC, 1);
        SetIdentified(oGivenItem, 1);
    }
    if(nGiveXP != 0)
    {
        GiveXPToCreature(oPC, nGiveXP);
    }
    if(nGiveDCs != 0)
    {
        string sCDKey = GetPCPublicCDKey(oPC);
        SetDreamCoins(sCDKey, GetDreamCoins(sCDKey)+nGiveDCs);
        SendMessageToPC(oPC, "You gain <c§iÿ>" + IntToString(nGiveDCs) + "</c> Dream Coins.");
    }
    if(sDestination != "")
    {
        object oTarget  = GetWaypointByTag( sDestination );
        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oTarget, 0 ) ) );
    }
    else if(sDestinationParty != "")
    {
        ds_transport_party( oPC, sDestinationParty );
    }
    if(nHostile != 0)
    {
        CheckNPC(oNPC);
        ChangeToStandardFaction(oNPC, STANDARD_FACTION_HOSTILE);
        ExecuteScript(GetEventScript(oNPC, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND), oNPC);
    }
    if(nExit != 0)
    {
        CheckNPC(oNPC);
        DestroyObject(oNPC, 1.5);
    }
    if(sCustomToken != "")
    {
        CheckNPC(oNPC);
        sCustomToken = GetLocalString(oNPC, sCustomToken);
        int nCustomToken = StringToInt(GetScriptParam("TokenNumber"));

        if(sCustomToken != "")
        {
            SetCustomToken(nCustomToken, sCustomToken);
        }
        //If nothing's set, use the generic ones for shops
        else if(nCustomToken == 702001) { SetCustomToken(702001, "Greetings! Would you like to see what I have for sale?"); }
        else if(nCustomToken == 702002) { SetCustomToken(702002, "Yes, please."); }
        else if(nCustomToken == 702003) { SetCustomToken(702003, "No, thanks."); }
    }
    if(sRunScript != "")
    {
        ExecuteScript(sRunScript, oPC);
    }
    return;
}

object CheckNPC(object oNPC)
{
    if( GetIsPC(OBJECT_SELF) == 1){ oNPC = GetLastSpeaker(); }
    return oNPC;
}
