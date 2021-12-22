//::///////////////////////////////////////////////
//:: FileName ck_shadowrootext
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 4/16/2005 10:26:55 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "Shadowrootextract"))
		return FALSE;

	return TRUE;
}
