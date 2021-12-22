//::///////////////////////////////////////////////
//:: FileName ck_isnaturey
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 05/03/2005 20:56:09
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 12)
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_SHIFTER, GetPCSpeaker()) >= 5))
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
