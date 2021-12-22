//::///////////////////////////////////////////////
//:: FileName ck_isshadyclass
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 06/02/2005 20:54:44
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_ASSASSIN, GetPCSpeaker()) >= 1)
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) >= 1))
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_HARPER, GetPCSpeaker()) >= 1))
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_ROGUE, GetPCSpeaker()) >= 1))
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_SHADOWDANCER, GetPCSpeaker()) >= 1))
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
