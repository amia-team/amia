//::///////////////////////////////////////////////
//:: FileName ck_isbard7
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 27/09/2005 20:09:47
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) >= 7)
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
