//::///////////////////////////////////////////////
//:: FileName ph_kellytemplegr
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10.09.2009 14:00:06
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "EternalOrderTemplarHelmet"))
		return FALSE;

	return TRUE;
}
