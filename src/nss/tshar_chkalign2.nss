//::///////////////////////////////////////////////
//:: FileName tshar_chkalign2
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 6/12/2006 1:29:25 PM
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Restrict based on the player's alignment
	if(GetAlignmentGoodEvil(GetPCSpeaker()) != ALIGNMENT_EVIL)
		return FALSE;

	return TRUE;
}
