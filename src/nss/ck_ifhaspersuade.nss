//::///////////////////////////////////////////////
//:: FileName ck_ifhaspersuade
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 5/5/2004 6:51:58 PM
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Make sure the player has the required skills
	if(!GetHasSkill(SKILL_PERSUADE, GetPCSpeaker()))
		return FALSE;

	return TRUE;
}
