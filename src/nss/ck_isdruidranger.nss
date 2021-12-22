//::///////////////////////////////////////////////
//:: FileName ck_isdruidranger
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/01/2005 01:16:54
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) >= 3)
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 3))
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
