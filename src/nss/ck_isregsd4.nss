//::///////////////////////////////////////////////
//:: FileName ck_isregsd4
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 5/29/2014 10:23:57 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_SHADOWDANCER, GetPCSpeaker()) >= 4)
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "sdtextbook"))
		return FALSE;

	return TRUE;
}
