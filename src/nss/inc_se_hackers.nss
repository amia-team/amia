//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: inc_se_hackers
//group:  core
//used as: library
//date: 2011-03-11
//author:  Selmak

//2011-03-20    Disco     Added some changes for Barbarians


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

int GetBuyPoints( int nHAS );

int GetAbilitiesAreCorrect( object oPC );

int GetHasWrongExclusiveSkills( object oPC, int nClass );

int GetSkillPointsAreCorrect( object oPC );

//Removes ALL items from oPC.  Only for use on new characters.
void DoItemStrip( object oPC );

//Re-create starting gear for oPC.  Only for use on new characters.
void CreateNewbGear( object oPC );

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int GetBuyPoints( int nHAS ){

    // We're finding the number of buy points for one ability.
    // Should be 0 when initialised anyway, but can't hurt.
    int nBuyPoints = 0;

    // So long as this Human Ability Score is above 8...
    while ( nHAS > 8 ) {
        // If it is indeed more than 16, knock one point off the score and
        // give us 3 Buy Points, please!
        if ( nHAS > 16 ) {
            nHAS--;
            nBuyPoints = nBuyPoints + 3;
        }
        // If it is not bigger than 16 but it is bigger than 14, we
        // want 2 Buy Points, please!
        else if ( nHAS > 14 ) {
            nHAS--;
            nBuyPoints = nBuyPoints + 2;
        }
        // Otherwise, we want one Buy Point for one ability point off.
        else {
            nHAS--;
            nBuyPoints++;
        }
    }

    // This tells the calling function how many buy points were given back.
    return nBuyPoints;
}

int GetAbilitiesAreCorrect( object oPC ){

    // Going to need to store some things.
    int nStr, nDex, nCon, nWis, nInt, nCha;
    int nRace, nBonus, nTotalBuyPoints;

    // Is this PC not level 1?
    if ( GetHitDice( oPC ) != 1 )
        // We don't need to examine this PC any further.
        return TRUE;

    nStr = GetAbilityScore( oPC, ABILITY_STRENGTH, TRUE );
    nDex = GetAbilityScore( oPC, ABILITY_DEXTERITY, TRUE );
    nCon = GetAbilityScore( oPC, ABILITY_CONSTITUTION, TRUE );
    nWis = GetAbilityScore( oPC, ABILITY_WISDOM, TRUE );
    nInt = GetAbilityScore( oPC, ABILITY_INTELLIGENCE, TRUE );
    nCha = GetAbilityScore( oPC, ABILITY_CHARISMA, TRUE );

    // What race is this PC?
    nRace = GetRacialType( oPC );

    // Is that race valid i.e. does it exist?
    if ( nRace == RACIAL_TYPE_INVALID )
        SendMessageToPC( oPC, "Your race is invalid!" );

    // Now we subtract the bonuses or penalties from the ability scores.
    // This leaves us with the ability scores a human character would have.
    // N.B. If the character has a subrace then we need to lookup the values
    // for that subrace, this only covers base races.

    nBonus = StringToInt( Get2DAString("racialtypes", "StrAdjust", nRace) );
    nStr = nStr - nBonus;

    nBonus = StringToInt( Get2DAString("racialtypes", "DexAdjust", nRace) );
    nDex = nDex - nBonus;

    nBonus = StringToInt( Get2DAString("racialtypes", "ConAdjust", nRace) );
    nCon = nCon - nBonus;

    nBonus = StringToInt( Get2DAString("racialtypes", "WisAdjust", nRace) );
    nWis = nWis - nBonus;

    nBonus = StringToInt( Get2DAString("racialtypes", "IntAdjust", nRace) );
    nInt = nInt - nBonus;

    nBonus = StringToInt( Get2DAString("racialtypes", "ChaAdjust", nRace) );
    nCha = nCha - nBonus;

    // We set our Total Buy Points to 0.
    nTotalBuyPoints = 0;
    // We call the function above using the human ability scores as parameters,
    // and get the total.
    nTotalBuyPoints = GetBuyPoints( nStr ) + GetBuyPoints( nDex ) + GetBuyPoints( nCon );
    nTotalBuyPoints = nTotalBuyPoints + GetBuyPoints( nWis ) + GetBuyPoints( nInt ) + GetBuyPoints( nCha );

    // The total should be 30 for a level 1 character.
    if ( nTotalBuyPoints != 30 )
        return FALSE;
    else
        return TRUE;

}

int GetHasWrongExclusiveSkills( object oPC, int nClass ){

    int nSkillRanks;

    nSkillRanks = GetSkillRank( SKILL_PERFORM, oPC, TRUE );
    //If Class is not bard AND skill ranks are greater than 0
    if ( nClass != CLASS_TYPE_BARD && nSkillRanks > 0 )
        return TRUE;

    nSkillRanks = GetSkillRank( SKILL_ANIMAL_EMPATHY, oPC, TRUE );
    //If Class is not druid AND is not ranger, AND skill ranks are greater than 0
    if ( ( nClass != CLASS_TYPE_DRUID && nClass != CLASS_TYPE_RANGER ) && nSkillRanks > 0 )
        return TRUE;

    nSkillRanks = GetSkillRank( SKILL_USE_MAGIC_DEVICE, oPC, TRUE );
    //If Class is not bard AND is not rogue, AND skill ranks are greater than 0
    if ( ( nClass != CLASS_TYPE_BARD && nClass != CLASS_TYPE_ROGUE ) && nSkillRanks > 0 )
        return TRUE;

    return FALSE;

}

int GetSkillPointsAreCorrect( object oPC ){
    int nIntMod = ( GetAbilityScore( oPC, ABILITY_INTELLIGENCE, TRUE ) - 10 )/2;
    int nSpentSkillRanks = 0;
    int nAvailableRanks = 0;
    int nClass = GetClassByPosition( 1, oPC );

    // We check first to see if the PC has skills that are exclusive to another
    // class, if they do their skills are invalid so no need to check each one.
    if ( GetHasWrongExclusiveSkills( oPC, nClass ) )
        return FALSE;


    string sSkill2DA = Get2DAString( "classes", "SkillsTable", nClass );
    string sValue;

    int nSkill, nSkillRanks;
    int nClassSkill = 0;
    int nIsClassSkill = 0;

    // We check the skill 2DA table for this particular class, checking each skill
    // available to this class.
    sValue = Get2DAString( sSkill2DA, "SkillIndex", nClassSkill );
    while ( sValue != ""){
        nSkill = StringToInt( sValue );

        nSkillRanks = GetSkillRank( nSkill, oPC, TRUE );
        // Check in case this returns -1 for a skill, probably won't.
        if ( nSkillRanks > -1 ){
            sValue = Get2DAString( sSkill2DA, "ClassSkill", nClassSkill );
            nIsClassSkill = StringToInt( sValue );
            //sValue = Get2DAString( sSkill2DA, "SkillLabel", nClassSkill );

            if ( nIsClassSkill ){

                nSpentSkillRanks += nSkillRanks;
                //SendMessageToPC( oPC, "Your skill points in "+ sValue + ": " + IntToString(nSkillRanks) );
            }
            else {

                nSpentSkillRanks = nSpentSkillRanks + 2*nSkillRanks;
                //SendMessageToPC( oPC, "Your skill points in cross-class "+ sValue + ": " + IntToString(nSkillRanks) );
            }

        }


        nClassSkill++;
        sValue = Get2DAString( sSkill2DA, "SkillIndex", nClassSkill );
    }


    sValue = Get2DAString( "classes", "SkillPointBase", nClass );
    nAvailableRanks = 4*( nIntMod + StringToInt( sValue ) );
    if ( nAvailableRanks == 0 ) nAvailableRanks = 4;


    // Humans get +4 skill points at first level. Ping!
    if ( GetRacialType( oPC ) == RACIAL_TYPE_HUMAN ){
        //SendMessageToPC( oPC, "You get 4 extra skill points for being human." );
        nAvailableRanks += 4;
    }
    //SendMessageToPC( oPC, "Your spent skill ranks:" + IntToString( nSpentSkillRanks ) );
    //SendMessageToPC( oPC, "Your available skill ranks:" + IntToString( nAvailableRanks ) );

    // If skill points spent in the PC's one and only class are greater than
    // the skill points available to them, they have too many.
    if ( nSpentSkillRanks > nAvailableRanks )
        return FALSE;
    else
        return TRUE;

}



void DoItemStrip( object oPC ){

    object oItem = GetFirstItemInInventory( oPC );

    while ( GetIsObjectValid( oItem ) )
    {
        DelayCommand( 0.0, DestroyObject( oItem ) );
        oItem = GetNextItemInInventory( oPC );
    }

    int i;
    for ( i = 0; i < NUM_INVENTORY_SLOTS; ++i )
    {
        if( GetItemInSlot( i, oPC ) != OBJECT_INVALID )
        {
            oItem = GetItemInSlot( i, oPC );
            DelayCommand( 0.0, DestroyObject( oItem ) );
        }
    }

    AssignCommand( oPC, TakeGoldFromCreature( GetGold( oPC ), oPC, TRUE ) );
}

