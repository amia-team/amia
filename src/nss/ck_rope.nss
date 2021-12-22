// Conversation conditional to check if PC has some rope in inventory.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/21/2003 Artos            Initial release.
//
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "rope"))
		return FALSE;

	return TRUE;
}
