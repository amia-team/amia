//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_ds_ondeath
//group:   treasure and XP reward generation
//used as: library
//date:    nov 28 2007
//author:  disco
//-----------------------------------------------------------------------------

/*

This is a combination of the old sei_xp, inc_custdrop, cs_inc_xp, and m_variables

2008-08-18   disco   added random item injection
2009-01-12   disco   added deity ring injection
2009-03-25   disco   added xp recording
2012-11-15   glim    added functionality for custom loot bins
2013-10-24   Glim    added function for rare loot drops during other loot drops
2015-12-13   FW      removed party cap, ecl, implemented scaling penalty
*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_inc_randstore"

//-------------------------------------------------------------------------------
// Constants
//-------------------------------------------------------------------------------
const string TREASURE_BIN_PREFIX                = "TreasureBinCR";
const string LOOTBIN_PREFIX                     = "CD_TREASURE_";
const string LOOTBIN_INIT                       = "CD_INIT";
const string LOOTBIN_COUNT                      = "CD_ITEM_COUNT";
const string ITEM_PREFIX                        = "CD_ITEM_";


//-------------------------------------------------------------------------------
// Structures
//-------------------------------------------------------------------------------
struct AR_PartyState {
    int    nPCs;            //!< Number of PCs.
    int    nHenchmen;       //!< Number of associates.
    float  fLevel;          //!< Average hit dice rating excluding associates.
    float  fLevelDiff;      //!< Difference between the highest and lowest level.
    float  fXPMultiplier;   //!< XP multiplier.
    object oArea;           //!< Current area of PC the last killer.
};


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
//void main (){}
/// Spins through the container's inventory and gives each item an index.
void InitialiseLootBin( object oContainer, int nForce = FALSE );

//gets the CR for the loot bin from the module
int GetLootBinCR( string sLootBin, int iDefault );

//returns lootbin from oCreatures CR
object GetLootBin( object oCreature );

//non returning version of CopyItem
void CopyItemVoid( object oItem, object oTargetInventory=OBJECT_INVALID, int bCopyVars=FALSE );

//non returning version of CreateItemOnObject
void CreateItemOnObjectVoid( string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1, string sNewTag="" );

//copied oItem in oLootbag, and creates the bag if it doesn't exist
object CopyInLootBag( object oLootBag, object oCritter, object oItem );

//creates sResRef item in oLootbag, and creates the bag if it doesn't exist
object CreateInLootBag( object oLootBag, object oCritter, string sResRef );

//creates a random item in oLootbag, and creates the bag if it doesn't exist
object CreateRandomInLootBag( object oLootBag, object oCritter, string sLootBinTag );

//Creates loot and chests.
//nXPResult = RewardXPForKill();
void GenerateLoot( object oCritter, int nXPResult, int nIsChest=0 );

//Determines XP positive multiplier.
float AR_GetXPPartyBonus( int nPCs );

//Returns the effective character level of a PC.
int SEI_GetEffectiveCharacterLevel( object a_oCharacter );

//Gives XP modified for a PCs favored class.
int SEI_ModifyXPForFavoredClass( object a_oCharacter, int a_nXP );

//Rewards a PC with experience for killing a creature.
//returns 1 when the party is out of level range or size if not
int RewardXPForKill();

//This function determines whether XP should be awarded based on XP to level ratio.
int GetLevelMatchesXPRatio( object oPC );

int GetDefaultModuleInt(string sVarName, int iDefault);
//Returns what kind of creature this is
//-1 : Invalid object or error
// 0 : Not a creature
// 1 : NPC
// 2 : Dominated NPC
// 3 : Summon
// 4 : Companion
// 5 : Henchman
// 6 : Familiar
// 7 : Possessed Familiar
// 8 : PC
// 9 : DM possessed creature
//10 : DM Avatar
int GetCreatureType( object oCreature );

//shortened function of the one in inc_ds_records
void InfuseRing( object oLootBag, object oCritter );

//adds nValue to the current value of sVariable
void UpdateModuleVariable2( string sVariable, int nValue );

// Generates an Epic Item in the select Chest/container/inventory
void GenerateEpicLoot(object oInventory);

// Generates an Epic Item in the select Chest/container/inventory. It then returns that object back to you.
object GenerateEpicLootReturn(object oInventory);

// Generates an Standard Item in the select Chest/container/inventory. Will never generate epic loot.
void GenerateStandardLoot(object oInventory, int nLevel);


//-------------------------------------------------------------------------------
// Helper Functions
//-------------------------------------------------------------------------------

// Clamps a value between some range, inclusive.
int ClampInt(int nValue, int nLow, int nHigh);

// Generates a curve based on the number of party members.
float GetLootChanceCurve(int nPartyMembers, int bEpic);


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void InitialiseLootBin( object oContainer, int nForce = FALSE ){

    if ( GetLocalInt(oContainer, LOOTBIN_INIT) == 1 && !nForce ){

        return;
    }

    int nIndex      = 0;
    object oItem    = GetFirstItemInInventory( oContainer );
    string sIndex   = "";

    while( GetIsObjectValid( oItem ) ) {

        ++nIndex;

        sIndex =ITEM_PREFIX + IntToString( nIndex );

        SetLocalObject( oContainer, sIndex, oItem );

        oItem = GetNextItemInInventory( oContainer );
    }

    SetLocalInt( oContainer, LOOTBIN_INIT, 1 );
    SetLocalInt( oContainer, LOOTBIN_COUNT, nIndex );

    //log_to_exploits( oContainer, "inc_custdrop, InitialiseLootBin", GetTag(oContainer), nIndex );

    return;
}

int GetLootBinCR( string sLootBin, int iDefault ){

    return( GetDefaultModuleInt( TREASURE_BIN_PREFIX + sLootBin, iDefault ) );
}

// Gets the container used for the specified treasure value.  If a
// container cannot be found, returns OBJECT_INVALID.
object GetLootBin( object oCreature ){

    // Variables.
    string sTag     = LOOTBIN_PREFIX;
    int nCR         = FloatToInt( GetChallengeRating( oCreature ) );

    // Treasure chest support (kfw)
    if( GetObjectType( oCreature ) == OBJECT_TYPE_PLACEABLE ){

        nCR = GetLocalInt( oCreature, "CR" );

        // cap treasure chests to a maximum of High loot
        if( nCR > 40 ){

            nCR = 40;
        }
    }

    //accidental 40+ CR critter protection
    if ( nCR > 40 && GetLocalInt( oCreature, "is_boss" ) != 1 ){

        nCR = 40;
    }

    // A creature can have a chest of items just for himself.  This chest
    // will have the creatures tag as the suffix.
    if ( GetLocalInt(oCreature, "CustDropByTag") == TRUE ){

        sTag += GetTag( oCreature );
    }
    // You can also set a custom loot bin for any given
    // creature with the following.
    else if ( GetLocalString( oCreature, "CustLootBin" ) != "" ){

        sTag += GetLocalString( oCreature, "CustLootBin" );
    }
    else if ( nCR >= GetLootBinCR( "Uber", 41 ) ){

        // Uber is 41+
        sTag += "UBER";
    }
    else if ( nCR >= GetLootBinCR( "High", 26 ) ){

        // High is 26-40
        sTag += "HIGH";
    }
    else if ( nCR >= GetLootBinCR( "Medium", 17 ) ){

        // Medium is 17-25
        sTag += "MEDIUM";
    }
    else if ( nCR >= GetLootBinCR( "Low", 9 ) ){

        // Low is 9-16
        sTag += "LOW";
    }
    else {

        // Uber low is 1-8
        sTag += "UBERLOW";
    }

    object oContainer = GetObjectByTag( sTag );

    InitialiseLootBin( oContainer );

    return ( oContainer );
}

void CopyItemVoid( object oItem, object oTargetInventory=OBJECT_INVALID, int bCopyVars=FALSE ){

    object oLootBag = CopyItem( oItem, oTargetInventory, bCopyVars );
}

void CreateItemOnObjectVoid( string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1, string sNewTag="" ){

    object oLootBag = CreateItemOnObject( sItemTemplate, oTarget, nStackSize, sNewTag );
}

object CopyInLootBag( object oLootBag, object oCritter, object oItem ){

    if ( oLootBag == OBJECT_INVALID ){

        string sLoot = "ds_daloot_"+IntToString( d6() );

        oLootBag = CreateObject( OBJECT_TYPE_PLACEABLE, sLoot, GetLocation( oCritter ) );
    }

    DelayCommand( 0.5, CopyItemVoid(  oItem, oLootBag, TRUE ) );

    return oLootBag;
}

object CreateInLootBag( object oLootBag, object oCritter, string sResRef ){

    if ( oLootBag == OBJECT_INVALID ){

        string sLoot = "ds_daloot_"+IntToString( d6() );

        oLootBag = CreateObject( OBJECT_TYPE_PLACEABLE, sLoot, GetLocation( oCritter ) );
    }

    DelayCommand( 0.5, CreateItemOnObjectVoid( sResRef, oLootBag ) );

    return oLootBag;
}

object CreateRandomInLootBag( object oLootBag, object oCritter, string sLootBinTag ){

    if ( oLootBag == OBJECT_INVALID ){

        string sLoot = "ds_daloot_"+IntToString( d6() );

        oLootBag = CreateObject( OBJECT_TYPE_PLACEABLE, sLoot, GetLocation( oCritter ) );
    }

    //get right level
    int nLevel;
    int nUnique = 5;

     if ( sLootBinTag == "CD_TREASURE_UBER" ){

        if ( d2() == 1 ){

            nLevel = 3;
            nUnique = 100;
        }
        else{

            nLevel = 4;
            nUnique = 0;
        }
     }
    else if ( sLootBinTag == "CD_TREASURE_HIGH" ){

        nLevel = 3;
    }
    else if ( sLootBinTag == "CD_TREASURE_MEDIUM" ) {

        nLevel = 2;
    }
    else if ( sLootBinTag == "CD_TREASURE_LOW" ){

        nLevel = 1;
        nUnique = 25;
    }
    else{

        nLevel = 1;
    }

    int nDie   = RandomNumber( 5, 1 );

    if ( nDie == 1 ){

        DelayCommand( 0.5, CreateWeapon( oLootBag, nLevel, "", nUnique ) );
    }
    else if ( nDie == 2 ){

        DelayCommand( 0.5, CreateArmour( oLootBag, nLevel, "", nUnique ) );
    }
    else if ( nDie == 3 ){

        DelayCommand( 0.5, CreateJewelry( oLootBag, nLevel, nUnique ) );
    }
    else if ( nDie == 4 ){

        DelayCommand( 0.5, CreateClothing( oLootBag, nLevel, nUnique ) );
    }
    else{

        DelayCommand( 0.5, CreateMagicSupplies( oLootBag, nLevel, nUnique ) );
    }

    return oLootBag;
}


void GenerateLoot( object oCritter, int nXPResult, int nIsChest=0 ){

    object oKiller = GetLastKiller( );

    //for animate dead
    if ( GetCreatureType( oCritter ) == 1 ){

        SetLocalString( GetArea( oKiller ), "ds_raise", GetResRef( oCritter ) );
        SetLocalFloat( GetArea( oKiller ), "ds_cr", GetChallengeRating( oCritter ) );
    }

    //no go when NPCs kill NPCs
    if ( GetCreatureType( oKiller ) < 2 && nIsChest == 0 ){

        return;
    }

    // Variables.
    object oLootBag;
    object oItem            = GetFirstItemInInventory( oCritter );
    int nIndex              = 0;
    string sIndex           = "";
    object oTemplate        = OBJECT_INVALID;
    object oLootBin         = GetLootBin( oCritter );
    string szTag            = GetTag( oLootBin );
    int nLoot;
    int nIsBoss             = GetLocalInt( OBJECT_SELF, "is_boss" ) ;

    // Treasure chest
    if( nIsChest == 1 ){

        nIndex       = Random( GetLocalInt( oLootBin, LOOTBIN_COUNT ) );
        sIndex       = ITEM_PREFIX + IntToString( nIndex );
        oTemplate    = GetLocalObject( oLootBin, sIndex );

        CopyItemVoid( oTemplate, oCritter, TRUE );

        return;
    }

    //get items in inventory
    while ( GetIsObjectValid( oItem ) == TRUE ){

        if ( GetDroppableFlag( oItem ) == TRUE && GetTag( oItem ) != "ds_delete" ){

            oLootBag = CopyInLootBag( oLootBag, oCritter, oItem );

            DestroyObject( oItem, 1.0 );
        }
        else if ( GetBaseItemType( oItem ) == BASE_ITEM_BOOK ){

            oLootBag = CopyInLootBag( oLootBag, oCritter, oItem );

            DestroyObject( oItem, 1.0 );
        }
        else{

            DestroyObject( oItem, 1.0 );
        }

        oItem = GetNextItemInInventory( oCritter );
    }

    // Loot Bins.
    // Module variable "TreasureChancePercent" overrides this default.
    int nRoll       = d100( );
    int nPercent    = GetLocalInt( oCritter, "CustDropPercent" );

    if( nPercent == -1 ){

        return;
    }

    if ( GetChallengeRating( oCritter ) > 40.0 ){

        nPercent = FloatToInt( GetLootChanceCurve( nXPResult, TRUE ) + 0.5 );
    }
    else if ( nPercent == 0 ){

        nPercent = FloatToInt( GetLootChanceCurve( nXPResult, FALSE ) + 0.5 );
    }


    //loot roll needs to go right creature
    object oMaster = GetMaster( oKiller );

    if ( GetIsObjectValid( oMaster ) ){

        oKiller = oMaster;
    }

    SendMessageToPC( oKiller, "[Check for loot: "+IntToString( nRoll )+" <= "+IntToString( nPercent )+"?]" );

    if( nRoll <= nPercent ){

        if ( d10() == 5 && !nIsBoss ){

            oLootBag = CreateRandomInLootBag( oLootBag, oCritter, szTag );

            nLoot = 1;
        }
        else{

            nIndex       = Random( GetLocalInt( oLootBin, LOOTBIN_COUNT ) ) + 1;
            sIndex       = ITEM_PREFIX + IntToString( nIndex );
            oTemplate    = GetLocalObject( oLootBin, sIndex );

            oLootBag = CopyInLootBag( oLootBag, oCritter, oTemplate );

            nLoot = 1;
        }

        //adding secondary roll for %chance of "rare items" drop where applicable
        if( d100( ) <= 5 )
        {
            string sRareLoot = GetLocalString( oCritter, "RareLoot" );
            CreateItemOnObject( sRareLoot, oLootBag );
        }
    }

    // Mythals
    string szMythalRef  = "mythal";

    // 0.9% chance.
    if( Random( 111 ) == 3 ){

        // Figure the CR.
        if(         szTag == "CD_TREASURE_UBER"     )   szMythalRef += "5";
        else if(    szTag == "CD_TREASURE_HIGH"     )   szMythalRef += "4";
        else if(    szTag == "CD_TREASURE_MEDIUM"   )   szMythalRef += "3";
        else if(    szTag == "CD_TREASURE_LOW"      )   szMythalRef += "2";
        else                                            szMythalRef += "1";

        // Spawn crystal in the loot.
        oLootBag = CreateInLootBag( oLootBag, oCritter, szMythalRef );

        nLoot = 1;
    }

    int nMoreStuff = Random( 1001 );

    if ( nMoreStuff == 5 ){

        // Bone wands.
        CreateInLootBag( oLootBag, oCritter, "x2_it_cfm_wand" );

        nLoot = 1;
    }
    else if ( nMoreStuff == 6 ){

        // Parchment.
        CreateInLootBag( oLootBag, oCritter, "x2_it_cfm_bscrl" );

        nLoot = 1;
    }
    else if ( ( nMoreStuff == 7 || nMoreStuff == 8 ) ){

        // Deity ring.
        InfuseRing( oLootBag, oCritter );

        nLoot = 1;
    }

    if ( nLoot ){

        FloatingTextStringOnCreature( "<c�  >Your defeated foe drops some loot!</c>", oKiller );
    }
}

//Deteremines current state of the party.
int RewardXPForKill(){

    // Variables.
    object oKiller          = GetLastKiller( );
    object oArea            = GetArea( oKiller );
    object oMember          = GetFirstFactionMember( oKiller, FALSE );

    float fLevelDiff        = 0.0;
    float fXPMultiplier     = 1.0;
    float fCharLevel        = 0.0;
    float fLowLevel         = 1000.0;
    float fHighLevel        = -10.0;
    float fPartyLevel       = 0.0;
    float fXP               = 0.0;
    float fMonsterCR        = GetChallengeRating( OBJECT_SELF );
    float fBaseXP           = 0.0;
    float fPenalty          = 0.15;
    int bHasPenalty         = FALSE;
    int nPCs                = 0;
    int nHenchmen           = 0;
    int nXP                 = 0;
    int nPartySize          = 0;
    int nCap                = 1000;
    int nRewardedXP         = 0;
    int nRewardedGold       = 0;
    int nPartyBlock         = 0;
    int nDoubleXP           = GetLocalInt(GetModule(),"doubleXP");

    if(nDoubleXP == 1)
    {
      nDoubleXP = 2;
    }
    else if(nDoubleXP == 0)
    {
      nDoubleXP = 1;
    }

    if ( fMonsterCR < 1.00 ){

        fMonsterCR = 1.0;
    }

    int nGold               = d8( FloatToInt( fMonsterCR ) );

    while ( GetIsObjectValid( oMember ) ) {

        if ( GetArea( oMember ) == oArea && !GetIsDead( oMember ) ) {

            if ( GetMaster( oMember ) == OBJECT_INVALID ) {

                ++nPCs;

                fCharLevel  = IntToFloat(GetHitDice( oMember));

                fPartyLevel = fPartyLevel + fCharLevel;

                if ( fCharLevel < fLowLevel ) fLowLevel = fCharLevel;
                if ( fCharLevel > fHighLevel ) fHighLevel = fCharLevel;
            }
            else if ( GetIsPossessedFamiliar( oMember ) ){

                ++nPCs;

                fCharLevel  = IntToFloat(GetHitDice( oMember));

                fPartyLevel = fPartyLevel + fCharLevel;

                if ( fCharLevel < fLowLevel ) fLowLevel = fCharLevel;
                if ( fCharLevel > fHighLevel ) fHighLevel = fCharLevel;
            }
            else {

                ++nHenchmen;
            }
        }

        oMember = GetNextFactionMember( oKiller, FALSE );
    }

    //get average party level
    if ( nPCs > 0 ){

        fPartyLevel = fPartyLevel / nPCs;
    }
    else{

        return 1;
    }

    //check if party meets criteria
    fLevelDiff = fHighLevel - fLowLevel;
    nPartySize = nPCs + nHenchmen;

    //cap at 6, if over 6.
    if( nPCs > 6 ) {
        nPCs = 6;
    }

    if ( fLevelDiff > 5.0 ){
        bHasPenalty = TRUE;
        fPenalty = ( FloatToInt(fLevelDiff) / 5 ) * fPenalty ;
        if( fLevelDiff > 25.0 ) {
            fPenalty = 0.80;
        }
    }

    fXPMultiplier = AR_GetXPPartyBonus( nPCs );
    nGold /= nPCs;

    //xp capped, but not for bosses
    if ( GetLocalInt( OBJECT_SELF, "is_boss" ) != 1 ){

        nCap = 50 + FloatToInt( ( fPartyLevel * fXPMultiplier ) + 0.5 );
    }

    // Normal XP Distribution
    fBaseXP  = ( 25.0 + ( 5.0 * ( fMonsterCR - fPartyLevel ) ) ) * fXPMultiplier;

    //loop through party
    oMember = GetFirstFactionMember( oKiller );

    while ( GetIsObjectValid(oMember) ) {

        if ( GetArea(oMember) == oArea && !GetIsDead( oMember ) ) {

            // Variables.
            int nLevelMatchesXPRatio        = GetLevelMatchesXPRatio( oMember );

            // Effective Character Level (ECL)
                float fECL                      = IntToFloat(GetHitDice( oMember)); // Changed this to not use the stored local variables - Mav
            //float fFavoredClass_modifier    = GetLocalFloat( oMember, "CS_XP_PENALTY_MULTICLASS" );
            int nBlock                      = GetLocalInt( oMember, "ds_xpbl" );

            if ( !nLevelMatchesXPRatio ){

                if ( !nBlock ){

                    SendMessageToPC( oMember, "- Please level-up before hunting any more creatures. -" );
                }

                nXP = 1;

                if ( fECL < 30.0 ){

                    nGold = 0;
                }
            }
            else if ( fECL >= 30.0 ){

                if ( !nBlock ){

                    SendMessageToPC( oMember, "You've reached your maximum level. 1 XP awarded." );
                }

                nXP = 1;
            }
            else{

                   fXP  = fBaseXP; // Use to have the CS_XP_PENALTY_MULTICLASS times here
                nXP  = FloatToInt( fXP );

                //XP is always 1 or larger
                if( nXP < 1 ){

                    nXP = 1;
                }
                else if ( nXP > nCap ){

                    nXP = nCap;
                }
            }

            if ( !nBlock ){
                if( bHasPenalty ) nXP = nXP - ( FloatToInt( nXP * fPenalty ) );
                if ( nXP < 1 ) nXP = 1;
                SetXP( oMember, GetXP( oMember ) + (nXP*nDoubleXP) );
            }
            else{

                SendMessageToPC( oMember, "You've activated your XP block. No XP awarded." );
            }

            AssignCommand( GetModule(), GiveGoldToCreature( oMember, nGold ) );

            nRewardedXP   += nXP;
            nRewardedGold += nGold;
        }
        oMember = GetNextFactionMember( oKiller );
    }

    UpdateModuleVariable2( "MonsterXP", nRewardedXP );
    UpdateModuleVariable2( "MonsterGold", nRewardedGold );

    if ( nPartyBlock == 1 ){

        return 1;
    }
    else{

        return nPCs;
    }
}



//Determines XP positive multiplier.
float AR_GetXPPartyBonus( int nPCs ){

    float fMultiplier = 1.0;

    switch ( nPCs ) {
        case 2:     fMultiplier = 1.025;     break;
        case 3:     fMultiplier = 1.05;      break;
        case 4:     fMultiplier = 1.075;     break;
        case 5:     fMultiplier = 1.1;       break;
    }

    return fMultiplier;
}

// This function determines whether XP should be awarded based on XP to level ratio or half-way into next level.
int GetLevelMatchesXPRatio( object oPC ){

    // Variables.
    int nXP_Current     = GetXP( oPC );

    int nNextLevel      = GetHitDice( oPC ) + 1;
    int nNextNextLevel  = GetHitDice( oPC ) + 2;

    int nXP_Limit       = 500 * nNextLevel * ( nNextLevel - 1 );
    int nXP_Limit2      = 500 * nNextNextLevel * ( nNextNextLevel -1 );
    int nXP_Limit3      = ( nXP_Limit2 - nXP_Limit ) / 2;
    int nXP_Limit4      = nXP_Limit + nXP_Limit3;

    // The player's current XP exceeds her next level or half-way into it, don't award anymore.
    if( nXP_Current >= nXP_Limit4 )
        return( FALSE );
    // The player's current XP is less then her next level or half-way into it, ok to award.
    else
        return( TRUE );

}

int GetDefaultModuleInt(string sVarName, int iDefault){

    int iVal = GetLocalInt(GetModule(), sVarName);
    if (!iVal) iVal = iDefault;
    return iVal;
}

//Returns what kind of creature this is
//-1 : Invalid object or error
// 0 : Not a creature
// 1 : NPC
// 2 : Dominated NPC
// 3 : Summon
// 4 : Companion
// 5 : Henchman
// 6 : Familiar
// 7 : Possessed Familiar
// 8 : PC
// 9 : DM possessed creature
//10 : DM Avatar
int GetCreatureType( object oCreature ){

    if ( !GetIsObjectValid( oCreature ) ){

        return -1;
    }

    int nType = GetObjectType( oCreature );

    if ( nType != OBJECT_TYPE_CREATURE ){

        return 0;
    }

    if ( GetIsDMPossessed( oCreature ) ){

        return 9;
    }

    if ( GetIsDM( oCreature ) ){

        return 10;
    }

    if ( GetIsPossessedFamiliar( oCreature ) ){

        return 7;
    }

    if ( GetIsPC( oCreature ) ){

        return 8;
    }

    nType = GetAssociateType( oCreature );

    if ( nType == ASSOCIATE_TYPE_DOMINATED ){

        return 2;
    }
    else if ( nType == ASSOCIATE_TYPE_SUMMONED ){

        return 3;
    }
    else if ( nType == ASSOCIATE_TYPE_ANIMALCOMPANION ){

        return 4;
    }
    else if ( nType == ASSOCIATE_TYPE_HENCHMAN ){

        return 5;
    }
    else if ( nType == ASSOCIATE_TYPE_FAMILIAR ){

        return 6;
    }

    return 1;
}


void InfuseRing(object oLootBag, object oCritter){

    // Variables.
    int nIndex              = 0;
    string sIndex           = "";
    object oTemplate        = OBJECT_INVALID;


    object oContainer = GetObjectByTag( "CD_TREASURE_GODRINGS" );
    InitialiseLootBin( oContainer );

    nIndex       = Random( GetLocalInt( oContainer, LOOTBIN_COUNT ) );
    sIndex       = ITEM_PREFIX + IntToString( nIndex );
    oTemplate    = GetLocalObject( oContainer, sIndex );

    CopyInLootBag( oLootBag, oCritter, oTemplate );


}

/*void BossLoot(object oLootBag, object oCritter){

    // Variables.
    int nIndex              = 0;
    string sIndex           = "";
    object oTemplate        = OBJECT_INVALID;

    object oContainer = GetObjectByTag( "CD_TREASURE_GODRINGS" );
    InitialiseLootBin( oContainer );

    nIndex       = Random( GetLocalInt( oContainer, LOOTBIN_COUNT ) );
    sIndex       = ITEM_PREFIX + IntToString( nIndex );
    oTemplate    = GetLocalObject( oContainer, sIndex );

    CopyInLootBag( oLootBag, oCritter, oTemplate );


}*/

void UpdateModuleVariable2( string sVariable, int nValue ){

    object oModule = GetModule();

    SetLocalInt( oModule, sVariable, GetLocalInt( oModule, sVariable ) + nValue );
}


void GenerateEpicLoot(object oInventory)
{

    // Variables.
    int nIndex              = 0;
    string sIndex           = "";
    object oTemplate        = OBJECT_INVALID;


    object oContainer = GetObjectByTag( "CD_TREASURE_UBER" );
    InitialiseLootBin( oContainer );

    nIndex       = Random( GetLocalInt( oContainer, LOOTBIN_COUNT ) );
    sIndex       = ITEM_PREFIX + IntToString( nIndex );
    oTemplate    = GetLocalObject( oContainer, sIndex );

    if(GetIsObjectValid(oTemplate))
    {
     CopyItemVoid( oTemplate, oInventory, TRUE );
    }
    else // If it isn't valid it reruns it
    {
      GenerateEpicLoot(oInventory);
    }

}


object GenerateEpicLootReturn(object oInventory)
{

    // Variables.
    int nIndex              = 0;
    string sIndex           = "";
    object oTemplate        = OBJECT_INVALID;
    object oReturn;


    object oContainer = GetObjectByTag( "CD_TREASURE_UBER" );
    InitialiseLootBin( oContainer );

    nIndex       = Random( GetLocalInt( oContainer, LOOTBIN_COUNT ) );
    sIndex       = ITEM_PREFIX + IntToString( nIndex );
    oTemplate    = GetLocalObject( oContainer, sIndex );

    if(GetIsObjectValid(oTemplate))
    {
     oReturn = CopyItem(oTemplate, oInventory, TRUE);
    }
    else // If it isn't valid it reruns it
    {
      GenerateEpicLootReturn(oInventory);
    }

    return oReturn;
}



void GenerateStandardLoot(object oInventory, int nLevel)
{

    // Variables.
    int nIndex              = 0;
    string sIndex           = "";
    string sTag             = LOOTBIN_PREFIX;
    object oTemplate        = OBJECT_INVALID;
    object oContainer;

    if ( nLevel >= GetLootBinCR( "High", 26 ) ){

        // High is 26-40+
        sTag += "HIGH";
    }
    else if ( nLevel >= GetLootBinCR( "Medium", 17 ) ){

        // Medium is 17-25
        sTag += "MEDIUM";
    }
    else if ( nLevel >= GetLootBinCR( "Low", 9 ) ){

        // Low is 9-16
        sTag += "LOW";
    }
    else {

        // Uber low is 1-8
        sTag += "UBERLOW";
    }

    oContainer = GetObjectByTag(sTag);

    InitialiseLootBin( oContainer );

    nIndex       = Random( GetLocalInt( oContainer, LOOTBIN_COUNT ) );
    sIndex       = ITEM_PREFIX + IntToString( nIndex );
    oTemplate    = GetLocalObject( oContainer, sIndex );

    if(GetIsObjectValid(oTemplate))
    {
     CopyItemVoid( oTemplate, oInventory, TRUE );
    }
    else // If it isn't valid it reruns it
    {
      GenerateStandardLoot(oInventory,nLevel);
    }

}

int ClampInt(int nValue, int nLow, int nHigh)
{
    if (nValue < nLow) return nLow;
    if (nValue > nHigh) return nHigh;
    return nValue;
}

float GetLootChanceCurve(int nPartyMembers, int bEpic)
{
    if (nPartyMembers < 1) nPartyMembers = 1;

    float fChance;
    if (nPartyMembers <= 6)
    {
        fChance = 5.0 + 3.0 * IntToFloat(nPartyMembers - 1);
    }
    else if (nPartyMembers <= 12)
    {
        fChance = 20.0 + 5.0 * IntToFloat(nPartyMembers - 6);
    }
    else if (nPartyMembers <= 16)
    {
        fChance = 50.0 + 0.5 * IntToFloat(nPartyMembers - 12);
    }
    else
    {
        fChance = 52.0 + 0.2 * IntToFloat(nPartyMembers - 16);
    }

    if (bEpic)
    {
        float fBase = 5.0;
        fChance = fBase + (fChance - fBase) * 0.6666667;
    }

    if (fChance < 5.0)
    {
        fChance = 5.0;
    }

    return fChance;
}
