//::///////////////////////////////////////////////
//:: FileName ck_israngerdruid
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 23/01/2005 15:06:45
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) >= 1)
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 1))
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
