//::///////////////////////////////////////////////
//:: FileName ck_hasspideritem
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 17/03/2005 17:14:40
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_SHIFTER, GetPCSpeaker()) >= 5)
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "spiderseye"))
		return FALSE;

	return TRUE;
}
