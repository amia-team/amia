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
                                                     */
///////////////////////////////////////////////////////



int StartingConditional()
{
    // Initialize variables from the conversation (if any)
    int nRequiredGold = StringToInt(GetScriptParam("RequiredGold"));
    int nRequiredLevel = StringToInt(GetScriptParam("RequiredLevel"));
    string sRequiredItem = GetScriptParam("RequiredItem");

    object oPC = GetPCSpeaker();

    // If gold amount isn't set we'll ignore it
    if(nRequiredGold != 0)
    {
        // Check if they have the required gold
        if(GetGold(oPC) >= 10)
        {
            return TRUE;
        }
    }
    else if(nRequiredLevel != 0)
    {
        int nClass1 = GetLevelByPosition(1, oPC);
        int nClass2 = GetLevelByPosition(2, oPC);
        int nClass3 = GetLevelByPosition(3, oPC);
        int nClassTotal = nClass1+nClass2+nClass3;

        if(nClassTotal >= nRequiredLevel)
        {
            return TRUE;
        }
    }
    else if(sRequiredItem != "")
    {
        // Check if they have one of the items tagged
        if(GetIsObjectValid(GetItemPossessedBy(oPC, sRequiredItem)))
        {
            return TRUE;
        }
    }
    // Don't show the node if none of the parameters were found
    return FALSE;
}
