// Conversation conditional to check if PC can cast arcane spells.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/12/2004 Artos            Initial release.
//

int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, GetPCSpeaker()) >= 1)
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker()) >= 4))
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) >= 4))
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker()) >= 4))
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
