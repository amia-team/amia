//::///////////////////////////////////////////////
//:: FileName ck_hassd10insign
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 30/04/2005 20:48:55
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "masterinsignia"))
		return FALSE;

	return TRUE;
}
