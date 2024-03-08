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
  - RequiredQuest  (Tag of relevant Quest)
  - RequiredDCs    (Number of Dream Coins required)
                                                     */
///////////////////////////////////////////////////////

#include "inc_dc_api"
#include "inc_ds_records"

int StartingConditional()
{
    // Initialize variables from the conversation (if any)
    int nRequiredGold = StringToInt(GetScriptParam("RequiredGold"));
    int nRequiredLevel = StringToInt(GetScriptParam("RequiredLevel"));
    int nRequiredDCs   =StringToInt(GetScriptParam("RequiredDCs"));
    string sRequiredItem = GetScriptParam("RequiredItem");
    string sRequiredQuest = GetScriptParam("RequiredQuest");

    object oPC = GetPCSpeaker();
    string sCDKey = GetPCPublicCDKey(oPC);
    object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");

    // Count the number of requirements that aren't blank
    int nRequirementsFound;

    if(nRequiredGold != 0){ nRequirementsFound++; }
    if(nRequiredLevel != 0){ nRequirementsFound++; }
    if(sRequiredItem != ""){ nRequirementsFound++; }
    if(sRequiredQuest != ""){ nRequirementsFound++; }
    if(nRequiredDCs != 0){ nRequirementsFound++; }

    // Initialize variable for number of requirements met
    int nRequirementsMet;

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
    if(nRequirementsFound == nRequirementsMet)
    {
        return TRUE;
    }
    else // Don't show the node if none of the parameters were found
    {
        return FALSE;
    }

}
