//::///////////////////////////////////////////////
//:: FileName kohl_malecheck
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 29.12.2012 18:47:28
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Add the gender restrictions
	if(GetGender(GetPCSpeaker()) != GENDER_MALE)
		return FALSE;

	return TRUE;
}
