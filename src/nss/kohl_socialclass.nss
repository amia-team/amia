//::///////////////////////////////////////////////
//:: FileName kohl_socialclass
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 08.06.2010 15:54:30
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "dnm_defscloak"))
		return FALSE;

	return TRUE;
}
