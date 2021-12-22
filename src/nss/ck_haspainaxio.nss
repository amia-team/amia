//::///////////////////////////////////////////////
//:: FileName ck_haspainaxio
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 12/02/2006 17:05:36
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "ki_axiomatic"))
		return FALSE;
	if(!HasItem(GetPCSpeaker(), "ki_paintouch"))
		return FALSE;

	return TRUE;
}
