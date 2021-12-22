// Platinum Coin Widget: Glowing Eyes

// includes
#include "x2_inc_switches"

void main(){

    // vars

    if(GetUserDefinedItemEventNumber()!=X2_ITEM_EVENT_ACTIVATE){

        return;

    }

    object oWidget=GetItemActivated();
    object oPC=GetItemActivatedTarget();
    object oDM=GetItemActivator();

    // resolve DM status (security purposes!)
    if(GetIsDM(oDM)==FALSE){

        string szMessage=
            "<cþ  >|Platinum Coin Widget|Player="                               +
            GetPCPlayerName(oDM)                                                +
            "|Character Name="                                                  +
            GetName(oDM)                                                        +
            "|Reason=Non-DM used a Platinum Coin Widget.|</c>";

        // notify all dms
        SendMessageToAllDMs(szMessage);

        // log
        WriteTimestampedLogEntry(szMessage);

        // remove the illegally-used tool
        DestroyObject(oDM);

        return;

    }
    else{

        string szMessage=
            "<cþ  >|Platinum Coin Widget|Dungeon Master="                       +
            GetPCPlayerName(oDM)                                                +
            "|PC="                                                              +
            GetName(oPC)                                                        +
            "|Reason=Player has been awarded a Platinum Coin: Glowing Eyes.|</c>";

        // notify all dms
        SendMessageToAllDMs(szMessage);

        // log
        WriteTimestampedLogEntry(szMessage);

    }

    // resolve Target status
    if(GetIsPC(oPC)==FALSE){

        FloatingTextStringOnCreature(
            "- Platinum Coins may only be given to PCs -",
            oDM,
            FALSE);

        return;

    }

    // spawn 'n sign the Platinum Coin (used for tracking purposes)

    // platinum Coin
    object oPlatinumCoin=CreateItemOnObject(
        "sdc_eyes1",
        oPC,
        1);

    // sign it
    DelayCommand(
        1.0,
        SetLocalString(
            oPlatinumCoin,
            "CS_DM",
            GetPCPlayerName(oDM)));

    // notify the player that she has been awarded the Platinum Coin: Glowing Eyes
    SendMessageToPC(
        oPC,
        "<cÌwþ>Well done, you've just been awarded a Platinum Coin: Glowing Eyes!</c>");

    return;

}
