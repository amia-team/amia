/*  Energon Merchant Script Check 1:

    o Spellcraft Check DC 23 to view the Energon's shop

*/

int StartingConditional( ){

    // Variables
    object oPC          =   GetPCSpeaker();

    // Once per reset - To prevent metaplaying
    if( !GetLocalInt( oPC, "cs_energon_merchant" ) )
    {
        // Do a Spellcraft Check DC 23
        if ( GetIsSkillSuccessful( oPC, SKILL_SPELLCRAFT, 23 ) )
        {
            return TRUE;
        }
        else
        {
            SetLocalInt( oPC, "cs_energon_merchant", 1 );
            return FALSE;
        }
    }
    else
    {
        return FALSE;
    }
}
