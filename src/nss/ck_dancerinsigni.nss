//::///////////////////////////////////////////////
//:: FileName ck_dancerinsigni
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 4/14/2005 6:19:56 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "DancerInsignia"))
		return FALSE;

	return TRUE;
}
