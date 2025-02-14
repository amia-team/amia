/*
   BG Check to see if they have the Epic Fiend Feat
   - Maverick0053, 2/13/25

*/

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if ( GetHasFeat( FEAT_EPIC_EPIC_FIEND, oPC ) == TRUE )
    {
       return TRUE;
    }
    else
    {
       return FALSE;
    }

}
