//::///////////////////////////////////////////////
//:: FileName ck_issd7insignia
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 30/04/2005 20:24:20
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_SHADOWDANCER, GetPCSpeaker()) >= 7)
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "DancerInsignia"))
		return FALSE;

	return TRUE;
}
