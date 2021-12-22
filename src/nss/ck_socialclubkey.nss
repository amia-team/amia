//::///////////////////////////////////////////////
//:: FileName ck_socialclubkey
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 8/27/2004 9:11:30 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "socialclubkey"))
		return FALSE;

	return TRUE;
}
