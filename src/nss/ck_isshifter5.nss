//::///////////////////////////////////////////////
//:: FileName ck_isshifter5
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 17/03/2005 17:13:45
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_SHIFTER, GetPCSpeaker()) >= 5)
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
