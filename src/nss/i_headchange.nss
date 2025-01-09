/*
--------------------------------------------------------------------------------
NAME: i_headchange
Description: This is a simple script that can be used to change head model.
LOG:
    Jes 12/10/24 - Simplified for item activation.
--------------------------------------------------------------------------------
*/

void main()
{
    object oPC      = GetItemActivator();
    string sLast    = GetLocalString(oPC, "last_chat");

    string sHead = IntToString(GetCreatureBodyPart(CREATURE_PART_HEAD, oPC));

    SetCustomToken(6127, sHead);
    AssignCommand(oPC, ActionStartConversation(oPC, "c_headchange", TRUE, FALSE));
}
