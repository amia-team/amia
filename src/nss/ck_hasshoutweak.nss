//::///////////////////////////////////////////////
//:: FileName ck_hasshoutweak
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 12/02/2006 17:28:27
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "ki_shout"))
		return FALSE;
	if(!HasItem(GetPCSpeaker(), "ki_weaktouch"))
		return FALSE;

	return TRUE;
}
