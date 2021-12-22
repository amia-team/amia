// Conversation conditional to check if PC has food in inventory.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/08/2004 Artos            Initial release.
//
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "FoodBundle"))
		return FALSE;

	return TRUE;
}
