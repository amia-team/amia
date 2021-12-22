//::///////////////////////////////////////////////
//:: FileName ck_masterinsign
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 4/14/2005 11:52:18 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "masterinsignia"))
		return FALSE;

	return TRUE;
}
