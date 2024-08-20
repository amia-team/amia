///////////////////////////////////////////////////////
/*       Lord-Jyssev Convo Conditions Script

  This script will allow you to use Script Params in
  the dialogue window to check starting conditions.

  To use it, add this to every instance of a "Text
  appears when" and be sure to set Script Params from
  the following list of options:

  - RequiredGold   (Amount of gold needed)
  - RequiredLevel  (Level of the PC in convo)
  - RequiredItem   (Tag of the item requirement)
  - RequiredQuest  (Tag of relevant Quest completed)
  - RequiredDCs    (Number of Dream Coins required)
  - Persuade       (Base ranks of Persuade required)
  - Bluff          (Base ranks of Bluff required)
  - Intimidate     (Base ranks of Intimidate required)
  - CustomToken    (Checks the NPC for this variable as a numbered custom token)
    -- TokenNumber (Needs to be set to the custom token number in the dialogue)
                                                     */
///////////////////////////////////////////////////////

#include "inc_dc_api"
#include "inc_ds_records"
#include "nw_i0_tool"

//Check if this param is set on the player or the NPC. If set on the player's last response, get the NPC as the last speaker
object CheckNPC( object oNPC );

int StartingConditional()
{
    // Initialize variables from the conversation (if any)
    int nRequiredGold = StringToInt(GetScriptParam("RequiredGold"));
    int nRequiredLevel = StringToInt(GetScriptParam("RequiredLevel"));
    int nRequiredDCs   =StringToInt(GetScriptParam("RequiredDCs"));
    int nPersuade   =StringToInt(GetScriptParam("Persuade"));
    int nBluff   =StringToInt(GetScriptParam("Bluff"));
    int nIntimidate   =StringToInt(GetScriptParam("Intimidate"));
    string sRequiredItem = GetScriptParam("RequiredItem");
    string sRequiredQuest = GetScriptParam("RequiredQuest");
    string sCustomToken = GetScriptParam("CustomToken");

    object oPC = GetPCSpeaker();
    object oNPC = OBJECT_SELF;
    string sCDKey = GetPCPublicCDKey(oPC);
    object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");

    // Count the number of requirements that aren't blank
    int nRequirementsFound;

    if(nRequiredGold != 0){ nRequirementsFound++; }
    if(nRequiredLevel != 0){ nRequirementsFound++; }
    if(sRequiredItem != ""){ nRequirementsFound++; }
    if(sRequiredQuest != ""){ nRequirementsFound++; }
    if(nRequiredDCs != 0){ nRequirementsFound++; }
    if(nPersuade != 0){ nRequirementsFound++; }
    if(nBluff != 0){ nRequirementsFound++; }
    if(nIntimidate != 0){ nRequirementsFound++; }

    // Initialize variable for number of requirements met
    int nRequirementsMet;

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

    // If gold amount isn't set we'll ignore it
    if(nRequiredGold != 0)
    {
        // Check if they have the required gold
        if(GetGold(oPC) >= nRequiredGold)
        {
            nRequirementsMet++;
        }
    }
    if(nRequiredLevel != 0)
    {
        int nClass1 = GetLevelByPosition(1, oPC);
        int nClass2 = GetLevelByPosition(2, oPC);
        int nClass3 = GetLevelByPosition(3, oPC);
        int nClassTotal = nClass1+nClass2+nClass3;

        if(nClassTotal >= nRequiredLevel)
        {
            nRequirementsMet++;
        }
    }
    if(sRequiredItem != "")
    {
        // Check if they have one of the items tagged
        if(GetIsObjectValid(GetItemPossessedBy(oPC, sRequiredItem)))
        {
            nRequirementsMet++;
        }
    }
    if(sRequiredQuest != "")
    {
        if(GetLocalInt(oPCKey, sRequiredQuest) == 2)
        {
            nRequirementsMet++;
        }
    }
    if(nRequiredDCs != 0)
    {
        if(GetDreamCoins(sCDKey) >= nRequiredDCs)
        {
            nRequirementsMet++;
        }
    }
    if(nPersuade != 0)
    {
        if(GetSkillRank(SKILL_PERSUADE, oPC, TRUE) >= nPersuade)
        {
            nRequirementsMet++;
        }
    }
    if(nBluff != 0)
    {
        if(GetSkillRank(SKILL_BLUFF, oPC, TRUE) >= nBluff)
        {
            nRequirementsMet++;
        }
    }
    if(nIntimidate != 0)
    {
        if(GetSkillRank(SKILL_INTIMIDATE, oPC, TRUE) >= nIntimidate)
        {
            nRequirementsMet++;
        }
    }
    if(nRequirementsFound == nRequirementsMet)
    {
        return TRUE;
    }
    else // Don't show the node if none of the parameters were found
    {
        return FALSE;
    }

}

object CheckNPC(object oNPC)
{
    if( GetIsPC(OBJECT_SELF) == 1){ oNPC = GetLastSpeaker(); }
    return oNPC;
}
