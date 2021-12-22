/*  Automatic Character Maintenance; Amia's Subrace System; Letoscript: Functions Library

    --------
    Verbatim
    --------
    This script contains Amia's racial system functionality;
    Auatmatic Character Maintenance helper functions;
    rewritten, bugfixed Leto code; and easy-to-use wrappers for Leto.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062005  kfw         Initial release.
    060606  kfw         Optimization, syntax.
    081906  kfw         Streamlined, and added new macros.
    091306  kfw         Extended Subrace keywords.
    121306  disco       Fixed Hobgoblin stats.
  20070310  disco       disabled exports inside LETO functions
2007/11/12  disco       using inc_ds_records
2008/04/12  disco       fixed some Shadow Elf issues
2008/05/25  disco       fixed some Genasi issues
2008/06/11  disco       fixed some Kobold issues
2008/09/02  disco       fixed some Elfling issues
2009/08/29  disco       Orogs, Ogrillions, and Hobs now get proper race
2017/10/11  Paladin     Added +1 dex/elven weapon proficiency to half-elves
2019/04/07 Tarnus       Ported from Leto to NWNX

    ----------------------------------------------------------------------------

*/


/* Includes. */
#include "cs_inc_xp"
#include "inc_ds_records"
#include "inc_td_sysdata"
#include "nwnx"
#include "nwnx_creature"
#include "nw_i0_tool"



//string GetServerVaultPath( );
//string GetArchiveVaultPath( );
/*
string GetServerVaultPath( ){

    string sReturn = GetLocalString( GetModule( ), "VAULT_PATH" );
    if( sReturn == "" ){

        sReturn = NWNX_ReadStringFromINI( "AMIA", "ServerVault", "./servervault/", "./NWNX.ini" );
        SetLocalString( GetModule( ), "VAULT_PATH", sReturn );
    }
    return sReturn;
}

string GetArchiveVaultPath( ){

    string sReturn = GetLocalString( GetModule( ), "ARCHIVE_PATH" );
    if( sReturn == "" ){

        sReturn = NWNX_ReadStringFromINI( "AMIA", "ArchiveVault", "./archive/servervault/", "./NWNX.ini" );
        SetLocalString( GetModule( ), "ARCHIVE_PATH", sReturn );
    }
    return sReturn;
}
*/

/* Constants. */

/* Conversation tokens. */
const int ACM_TOKEN_DIALOG          = 998;
const int ACP_TOKEN_DIALOG          = 5672;

/* Paths. */
//const string SERVERVAULT_PATH       = "G:/NWN_A/servervault/";
//const string ARCHIVEVAULT_PATH      = "G:/NWN_A/archive/servervault/";

/* General. */
/*const string LETO_HOOK              = "NWNX!LETO!SCRIPT";
const string LETO_BUFFER            = "                                                                                                                                                     ";
const int BIC_FILENAME_LIMIT        = 16;
*/
const int ACM_LISTEN_NO             = 113;
const int ACP_LISTEN_NO             = 114;

const string SUBRACE_AUTHORIZED     = "subrace_authorized";
//const string DC_TAG                 = "dreamcoin";
//const string PDC_TAG                = "platinum_coin";
//const string PDC_LVLREBUILD_TAG     = "platinum_coin_lvl_rebuild";
//const string PLATINUM_COIN_NAME     = "Platinum : Level Rebuild";

/* Variable storage. */

const string STORAGE_VARIABLE_1     = "CS_STORE_VAR_1";
const string STORAGE_VARIABLE_2     = "CS_STORE_VAR_2";
const string STORAGE_VARIABLE_3     = "CS_STORE_VAR_3";

const string STORAGE_DC_COUNT       = "ds_dc_account";
//const string STORAGE_PDC_LVLREBUILD = "PlatinumCoinLevelRebuild";


/* Prototype definitions. */


/* General. */
/*
// Gets the bic value of szFieldName on oPC's character file.
string GetBicFieldValue( object oPC, string szFieldName );

// Sets the bic value of szFieldName to szValue on oPC's character file. Requires booting.
void SetBicFieldValue( object oPC, string szFieldName, string szValue );

// Adds nFeat (See ./SOURCE/FEAT.2DA) to oPC's character file. Requires booting.
void AddFeatToPC( object oPC, int nFeat );

// Removes nFeat (See ./SOURCE/FEAT.2DA) from oPC's character file. Requires booting.
void RemoveFeatFromPC( object oPC, int nFeat );
*/
// Determines Dream Coin Supply.
int GetDreamCoinAmount( object oPC );

// Removes Dream Coins.
int TakeDreamCoins( object oPC, int nCoins, string szReason );
/*
// Executes LetoScript modification on a player object.
void ModifyPC( object oPC, string szLetoScript );

// Executes non-modifying LetoScript on a player object.
string ExecuteReadOnlyLetoOnPlayer( object oPC, string szLetoScript );

// Executes non-player specific LetoScript.
string ExecuteLeto( string szLetoScript );

// Get the bic path/file for oPC
string GetBicPath( object oPC );
*/
/* Subraces. */

// Check if player can take nSubRace Subrace, based on not having taken one already AND correct base race.
int CanTakeSubrace( object oPC, int nSubRace );

// Check if nSubRace is a Platinum Coin Race and the player is authorized for it.
int GetIsPlatinumCoinSubRaceAndAuthorized( object oPC );

// Aasimar abilities.Note: No direct Bic File manipulation is done anymore, NWNX handles this, the name is simply kept for compatibility reasons
void AddAasimarAbilitiesToBicFile( object oPC );

// Tiefling abilities.
void AddTieflingAbilitiesToBicFile( object oPC );

// Drow abilities.
void AddDrowAbilitiesToBicFile( object oPC );

// Half-drow abilities.
void AddHalfDrowAbilitiesToBicFile( object oPC );

// Air Genasi abilities.
void AddAirGenasiAbilitiesToBicFile( object oPC );

// Earth Genasi abilities.
void AddEarthGenasiAbilitiesToBicFile( object oPC );

// Fire Genasi abilities.
void AddFireGenasiAbilitiesToBicFile( object oPC );

// Water Genasi abilities.
void AddWaterGenasiAbilitiesToBicFile( object oPC );

// Strongheart Halfling abilities.
void AddStrongheartHalflingAbilitiesToBicFile( object oPC );

// Ghostwise Halfling abilities.
void AddGhostwiseHalflingAbilitiesToBicFile( object oPC );

// Faerie abilities.
void AddFaerieAbilitiesToBicFile( object oPC );

// Goblin abilities.
void AddGoblinAbilitiesToBicFile( object oPC );

// Kobold abilities.
void AddKoboldAbilitiesToBicFile( object oPC );

// Svirfneblin abilities.
void AddSvirfneblinAbilitiesToBicFile( object oPC );

// Duergar abilities.
void AddDuergarAbilitiesToBicFile( object oPC );

// Gold Dwarf abilities.
void AddGoldDwarfAbilitiesToBicFile( object oPC );

// Aquatic Elf abilities.
void AddAquaticElfAbilitiesToBicFile( object oPC );

//Woodelf abilities.
void AddWoodElfAbilitiesToBicFile( object oPC );

// Wild Elf abilities.
void AddWildElfAbilitiesToBicFile( object oPC );

// Sun Elf abilities
void AddSunElfAbilitiesToBicFile( object oPC );

// Ogrillion abilities.
void AddOgrillionAbilitiesToBicFile( object oPC );

// Orog abilities.
void AddOrogAbilitiesToBicFile( object oPC );


// New, added 082006.

// Chultan abilities.
void AddChultanAbilitiesToBicFile( object oPC );

// Calishite abiltiies.
void AddCalishiteAbilitiesToBicFile( object oPC );

// Ffolk abilities.
void AddFfolkAbilitiesToBicFile( object oPC );

// Shadovar abilities.
void AddShadovarAbilitiesToBicFile( object oPC );

// Durpari abilities.
void AddDurpariAbilitiesToBicFile( object oPC );

// Tuigan abilties.
void AddTuiganAbilitiesToBicFile( object oPC );

// Mulan abilities.
void AddMulanAbilitiesToBicFile( object oPC );

// Halruaan abilities.
void AddHalruaanAbilitiesToBicFile( object oPC );

// Damaran abilities.
void AddDamaranAbilitiesToBicFile( object oPC );

// Snow Elf abilities.
void AddSnowElfAbilitiesToBicFile( object oPC );

// Daemonfey abilities.
void AddFeyriAbilitiesToBicFile( object oPC );

// Feytouched abilities.
void AddFeytouchedAbilitiesToBicFile( object oPC );

// Shadow Elf abilities.
void AddShadowElfAbilitiesToBicFile( object oPC );

// Elfling abilities.
void AddElflingAbilitiesToBicFile( object oPC );

// Hobgoblin abilities.
void AddHobgoblinAbilitiesToBicFile( object oPC );


/* Function definitions. */


// Gets the bic value of szFieldName on oPC's character file.
/*string GetBicFieldValue( object oPC, string szFieldName ){

    return( ExecuteReadOnlyLetoOnPlayer( oPC, "print /" + szFieldName + ";" ) );

}


// Sets the bic value of szFieldName to szValue on oPC's character file. Requires booting.
void SetBicFieldValue( object oPC, string szFieldName, string szValue ){

    ModifyPC( oPC, "/" + szFieldName + "=q|" + szValue + "|;" );

    return;

}

*/
// Adds nFeat (See ./SOURCE/FEAT.2DA) to oPC's character file. Requires booting.
void AddFeatToPC( object oPC, int nFeat ){

    //ModifyPC( oPC, "add /FeatList/Feat, " + IntToString( nFeat ) + ", gffWord;" );
    NWNX_Creature_AddFeat( oPC, nFeat);

    return;

}


// Removes nFeat (See ./SOURCE/FEAT.2DA) from oPC's character file. Requires booting.
void RemoveFeatFromPC( object oPC, int nFeat ){

    //ModifyPC( oPC, "replace 'Feat', " + IntToString( nFeat ) + ", DeleteParent;" );
    NWNX_Creature_RemoveFeat( oPC, nFeat);

    return;

}


// Check if player can take nSubRace Subrace, based on not having taken one already AND correct base race.
int CanTakeSubrace( object oPC, int nSubRace ){

    // Taken a Subrace already.
    if( HasItem(oPC, "SubraceWidget")==TRUE){

        SendMessageToPC( oPC, " - You've already activated a subrace. - " );
        return( FALSE );
    }
    // Variables.
    int nBaseRace       = GetRacialType( oPC );
    int nRace           = GetRaceInteger( GetRacialType( oPC ), GetSubRace( oPC ) );
    int nValidRace      = -1;

    /*if( nTakenAlready ){


    }*/

    // Make sure Base race is appropriate for Subrace.
    switch( nRace ){

        // Dwarven.
        case RACE_DUERGAR:
        case RACE_GOLD_DWARF:{   nValidRace = RACIAL_TYPE_DWARF; break;   }

        // Elven.
        case RACE_SUN_ELF:
        case RACE_WILD_ELF:
        case RACE_WOOD_ELF:
        case RACE_DROW:
        case RACE_AQUATIC_ELF:
        case RACE_SNOW_ELF:
        case RACE_FEYRI:
        case RACE_SHADOW_ELF:{   nValidRace = RACIAL_TYPE_ELF; break;   }

        // Gnome.
        case RACE_SVIRFNEBLIN:{  nValidRace = RACIAL_TYPE_GNOME; break;   }

        // Half-Elf.
        case RACE_HALF_ELF:
        case RACE_HALF_DROW:
        case RACE_ELFLING:{      nValidRace = RACIAL_TYPE_HALFELF; break; }

        // Hin.
        case RACE_STRONGHEART_HIN:
        case RACE_GHOSTWISE_HIN:
        case RACE_FAERIE:
        case RACE_GOBLIN:
        case RACE_KOBOLD:{       nValidRace = RACIAL_TYPE_HALFLING; break;    }

        // Half-Orc.
        case RACE_HOBGOBLIN:
        case RACE_OROG:
        case RACE_OGRILLION:{    nValidRace = RACIAL_TYPE_HALFORC; break; }

        // Human.
        case RACE_CHULTAN:
        case RACE_CALISHITE:
        case RACE_FFOLK:
        case RACE_SHADOVAR:
        case RACE_DURPARI:
        case RACE_TUIGAN:
        case RACE_MULAN:
        case RACE_HALRUAAN:
        case RACE_DAMARAN:{      nValidRace = RACIAL_TYPE_HUMAN; break;   }

        // Universal, allow any race.
        case RACE_AASIMAR:
        case RACE_TIEFLING:
        case RACE_FEYTOUCHED:
        case RACE_AIR_GENASI:
        case RACE_EARTH_GENASI:
        case RACE_FIRE_GENASI:
        case RACE_WATER_GENASI:{ nValidRace = RACIAL_TYPE_ALL; break;   }

        default:{                nValidRace = -1; break; }

    }

    if ( nValidRace == RACIAL_TYPE_ALL || nValidRace == nBaseRace ){

        return( TRUE );
    }
    else{

        SetSubRace( oPC, "" );

        return( FALSE );
    }
}


// Check if nSubRace is a Platinum Coin Race and the player is authorized for it.
int GetIsPlatinumCoinSubRaceAndAuthorized( object oPC ){

    // Variables.
    int nAuthorized             = GetPCKEYValue( oPC, SUBRACE_AUTHORIZED );
    int nRace                   = GetRaceInteger( GetRacialType( oPC ), GetSubRace( oPC ) );

    // Verify Platinum Coin Races.
    switch( nRace ){

        case RACE_AQUATIC_ELF:      return( nAuthorized );    break;
        case RACE_SNOW_ELF:         return( nAuthorized );    break;
        case RACE_FEYRI:            return( nAuthorized );    break;
        case RACE_FAERIE:           return( nAuthorized );    break;
        case RACE_SHADOW_ELF:       return( nAuthorized );    break;
        case RACE_ELFLING:          return( nAuthorized );    break;
        default:                    return( 1 );           break;
    }

    return( 0 );
}


// Aasimar abilities.
void AddAasimarAbilitiesToBicFile( object oPC ){

    /*  CHA +2, WIS +2
        Spot, Listen + 2
        Darkvision
        Spell-like ability: Light               (item)
        Resist cold, electricity and fire 5     (vfx)
        Outsider Type                                   */

    if( !CanTakeSubrace( oPC, RACE_AASIMAR ) ){
        SendMessageToPC( oPC, "- You may not become an Aasimar because your Base Race is incorrect. -" );
        return;
    }

    CreateItemOnObject( "race_asmar_item1", oPC );

    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 2);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    SetSubRace(oPC, "Aasimar");
    CreateItemOnObject("subracewidget", oPC);

    return;
}


// Tiefling abilities.
void AddTieflingAbilitiesToBicFile( object oPC ){

    /*  DEX +2, INT +2, CHA -2
        Bluff, Hide +2
        Darkvision
        Spell-like ability: Darkness        (item)
        Resist acid, fire and electricity 5 (effect)
        Outsider Type                           */

    if( !CanTakeSubrace( oPC, RACE_TIEFLING ) ){
        SendMessageToPC( oPC, "- You may not become a Tiefling because your Base Race is incorrect. -" );
        return;
    }

    // Spell-like Ability.
    CreateItemOnObject( "race_drow_item1", oPC );


    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    SetSubRace(oPC, "Tiefling");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Drow abilities.
void AddDrowAbilitiesToBicFile( object oPC ){

    /*  DEX +2 [0], CON -2 [0], INT +2, CHA +2,
        Spell-like ability: Darkness        (item)
        Darkvision*/

    if( !CanTakeSubrace( oPC, RACE_DROW ) ){
        SendMessageToPC( oPC, "- You may not become a Drow because your Base Race is incorrect. -" );
        return;
    }

    // Spell-like Ability.
    CreateItemOnObject( "race_drow_item1", oPC );


    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    SetSubRace(oPC, "Drow");
    CreateItemOnObject("subracewidget", oPC);

    return;

}

// Half-elf abilities.
void AddHalfElfAbilitiesToBicFile( object oPC ){


    if( !CanTakeSubrace( oPC, RACE_HALF_ELF ) ){
        SendMessageToPC( oPC, "- You may not become a Half-Elf because your Base Race is incorrect. -" );
        return;
    }
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 1);
    NWNX_Creature_AddFeat(oPC, FEAT_WEAPON_PROFICIENCY_ELF);
    CreateItemOnObject("subracewidget", oPC);


    return;

}


// Half-drow abilities.
void AddHalfDrowAbilitiesToBicFile( object oPC ){

    // Darkvision.

    if( !CanTakeSubrace( oPC, RACE_HALF_DROW ) ){
        SendMessageToPC( oPC, "- You may not become a Half-Drow because your Base Race is incorrect. -" );
        return;
    }


    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 1);
    NWNX_Creature_AddFeat(oPC, FEAT_WEAPON_PROFICIENCY_ELF);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    SetSubRace(oPC, "Half-Drow");
    CreateItemOnObject("subracewidget", oPC);


    return;

}


// Air Genasi abilities.
void AddAirGenasiAbilitiesToBicFile( object oPC ){

    /*  DEX +2, INT +2, WIS –2, CHA –2,
        Darkvision
        Spell-like ability: Gust of Wind    (item)
        Outsider type                               */

    if( !CanTakeSubrace( oPC, RACE_AIR_GENASI ) ){
        SendMessageToPC( oPC, "- You may not become an Air Genasi because your Base Race is incorrect. -" );
        return;
    }

    // Spell-like Ability.
    CreateItemOnObject( "race_anasi_item1", oPC );

    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    SetSubRace(oPC, "Air Genasi");
    CreateItemOnObject("subracewidget", oPC);


    return;

}


// Earth Genasi abilities.
void AddEarthGenasiAbilitiesToBicFile( object oPC ){

    /*  STR +2, CON +2, WIS –2, CHA –2,
        Darkvision
        Spell-like ability: Stoneskin       (item)
        Outsider type                               */

    if( !CanTakeSubrace( oPC, RACE_EARTH_GENASI ) ){
        SendMessageToPC( oPC, "- You may not become an Earth Genasi because your Base Race is incorrect. -" );
        return;
    }

    // Spell-like Ability.
    CreateItemOnObject( "race_enasi_item1", oPC );


    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    SetSubRace(oPC, "Earth Genasi");
    CreateItemOnObject("subracewidget", oPC);


    return;

}


// Fire Genasi abilities.
void AddFireGenasiAbilitiesToBicFile( object oPC ){

    /*  INT +2, CHA –2,
        Darkvision
        Spell-like ability: Fireball        (item)
        Outsider type                               */

    if( !CanTakeSubrace( oPC, RACE_FIRE_GENASI ) ){
        SendMessageToPC( oPC, "- You may not become a Fire Genasi because your Base Race is incorrect. -" );
        return;
    }

    // Spell-like Ability.
    CreateItemOnObject( "race_fnasi_item1", oPC );

    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    SetSubRace(oPC, "Fire Genasi");
    CreateItemOnObject("subracewidget", oPC);


    return;

}


// Water Genasi abilities.
void AddWaterGenasiAbilitiesToBicFile( object oPC ){

    /*  CON +2, CHA –2,
        Darkvision
        Spell-like ability: Ice Storm       (item)
        Outsider type                               */

    if( !CanTakeSubrace( oPC, RACE_WATER_GENASI ) ){
        SendMessageToPC( oPC, "- You may not become a Water Genasi because your Base Race is incorrect. -" );
        return;
    }

    // Spell-like Ability.
    CreateItemOnObject( "race_wnasi_item1", oPC );

    /*ModifyPC(
        oPC,
        "/Race='20';"                               +
        "/Subrace='Water Genasi';"                  +
        "/Con+='2';"                                +
        "/Cha-='2';"                                +
        "/BodyBag='1';"                             +
        "add /FeatList/Feat, 228, gffWord;" );*/
    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    SetSubRace(oPC, "Water Genasi");
    CreateItemOnObject("subracewidget", oPC);


    return;

}


// Strongheart Halfling abilities.
void AddStrongheartHalflingAbilitiesToBicFile( object oPC ){

    /*  STR +2 (+4), CON –2, DEX +2 (0)
        Dodge AC + 2                        (vfx)
        Discipline + 5                              */

    if( !CanTakeSubrace( oPC, RACE_STRONGHEART_HIN ) ){
        SendMessageToPC( oPC, "- You may not become a Strongheart Halfling because your Base Race is incorrect. -" );
        return;
    }

    /*ModifyPC(
        oPC,
        "/Subrace='Strongheart Halfling';"          +
        "/BodyBag='1';"                             +
        "/Str+='4';"                                +
        "/Con-='2';" );*/
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, 4);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, -2);
    SetSubRace(oPC, "Strongheart");
    CreateItemOnObject("subracewidget", oPC);


    return;

}


// Ghostwise Halfling abilities.
void AddGhostwiseHalflingAbilitiesToBicFile( object oPC ){

    /*  DEX +2 (0), STR -2 (0)
        Spot + 2, Animal Empathy + 2, -2 Concentration
        Spell-like ability: Clairvoyance (item)         */

    if( !CanTakeSubrace( oPC, RACE_GHOSTWISE_HIN ) ){
        SendMessageToPC( oPC, "- You may not become a Ghostwise Halfling because your Base Race is incorrect. -" );
        return;
    }

    // Spell-like Ability.
    CreateItemOnObject( "race_ghalf_item1", oPC );

    CreateItemOnObject("subracewidget", oPC);

    SetSubRace(oPC, "Ghostwise");

    return;

}


// Faerie abilities.
void AddFaerieAbilitiesToBicFile( object oPC ){

    /*  STR –4, CON -4, DEX +8, INT +1, CHA +2
        Pixie Appearance,
        Hide + 8, Taunt + 4
        20% movement speed increase
        Low-light vision
        Spell-like ability: Charm Person                (item)
        Does not receive any halfling-related feats or skills
        Remove feats [Skill Affinity: Move Silently, Skill Affinity: Listen, Lucky, Fearless, Good Aim] */

    if( !CanTakeSubrace( oPC, RACE_FAERIE ) ){
        SendMessageToPC( oPC, "- You may not become a Faerie because your Base Race is incorrect. -" );
        return;
    }

    if( GetIsPlatinumCoinSubRaceAndAuthorized( oPC ) != 1 ){
        SendMessageToPC( oPC, "- You may not become an Faerie because you haven't been authorized by a DM! -" );
        return;
    }

    // Spell-like Ability.
    CreateItemOnObject( "race_fae_item1", oPC );


    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_FEY);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, -4);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, -4);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 8);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 1);
    NWNX_Creature_AddFeat(oPC, FEAT_LOWLIGHTVISION);
    NWNX_Creature_RemoveFeat(oPC, 247);
    NWNX_Creature_RemoveFeat(oPC, 237);
    NWNX_Creature_RemoveFeat(oPC, 248);
    NWNX_Creature_RemoveFeat(oPC, 249);
    NWNX_Creature_RemoveFeat(oPC, 250);
    SetSubRace(oPC, "Faerie");
    NWNX_Creature_SetMovementRate(oPC, 5);
    SetCreatureAppearanceType(oPC, 55);
    CreateItemOnObject("subracewidget", oPC);
    return;

}


// Goblin abilities.
void AddGoblinAbilitiesToBicFile( object oPC ){

    /*  STR -2, DEX +2, CHA -2
        Goblin Appearance
        Darkvision
        Discipline +4, Move Silently +4
        Does not receive any halfling-related feats or skills
        Remove feats [Skill Affinity: Move Silently, Skill Affinity: Listen, Lucky, Fearless, Good Aim] */

    if( !CanTakeSubrace( oPC, RACE_GOBLIN ) ){
        SendMessageToPC( oPC, "- You may not become a Goblin because your Base Race is incorrect. -" );
        return;
    }

    // Class-dependant appearance.
    int nAppearanceType    = 0;
    int nClass              = GetClassByPosition( 1, oPC );

    switch( nClass ){

        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WIZARD:     nAppearanceType = 84;   break;

        case CLASS_TYPE_BARBARIAN:
        case CLASS_TYPE_FIGHTER:
        case CLASS_TYPE_PALADIN:    nAppearanceType = 87;   break;

        default:                    nAppearanceType = 86;   break;

    }


    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_HUMANOID_GOBLINOID);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    NWNX_Creature_RemoveFeat(oPC, 247);
    NWNX_Creature_RemoveFeat(oPC, 237);
    NWNX_Creature_RemoveFeat(oPC, 248);
    NWNX_Creature_RemoveFeat(oPC, 249);
    NWNX_Creature_RemoveFeat(oPC, 250);
    SetSubRace(oPC, "Goblin");
    SetCreatureAppearanceType(oPC, nAppearanceType);
    CreateItemOnObject("subracewidget", oPC);
    return;

}


// Kobold abilities.
void AddKoboldAbilitiesToBicFile( object oPC ){

    /*  STR -4, DEX +2
        Kobold Appearance
        Search +2, Craft Trap +2    [vfx]
        alertness
        darkvision
        Light Senstivity
        Does not receive any halfling-related feats or skills
        Remove feats [Skill Affinity: Move Silently, Skill Affinity: Listen, Lucky, Fearless, Good Aim]     */

    if( !CanTakeSubrace( oPC, RACE_KOBOLD ) ){
        SendMessageToPC( oPC, "- You may not become a Kobold because your Base Race is incorrect. -" );
        return;
    }

    // Class-dependant appearance
    int nAppearanceType     = 0;
    int nClass              = GetClassByPosition( 1, oPC );

    switch( nClass ){

        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WIZARD:     nAppearanceType = 301;  break;

        case CLASS_TYPE_BARBARIAN:
        case CLASS_TYPE_FIGHTER:
        case CLASS_TYPE_PALADIN:    nAppearanceType = 305;  break;

        default:                    nAppearanceType = 302;  break;

    }


    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_HUMANOID_REPTILIAN );
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, -4);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    NWNX_Creature_AddFeat(oPC, FEAT_ALERTNESS);
    NWNX_Creature_RemoveFeat(oPC, 247);
    NWNX_Creature_RemoveFeat(oPC, 237);
    NWNX_Creature_RemoveFeat(oPC, 248);
    NWNX_Creature_RemoveFeat(oPC, 249);
    NWNX_Creature_RemoveFeat(oPC, 250);
    SetSubRace(oPC, "Kobold");
    SetCreatureAppearanceType(oPC, nAppearanceType);
    CreateItemOnObject("subracewidget", oPC);
    return;

}


// Svirfneblin abilities.
void AddSvirfneblinAbilitiesToBicFile( object oPC ){

    /*  STR –2 [0], DEX +2, CON -2 [-4], WIS +2, CHA –4
        Natural AC + 3, Universal saving throws + 2     (vfx)
        Hide +2
        Darkvision, Stonecunning
        Spell-like abilities: Blindness/Deafness, Displacement, Camouflage  (item)
        Spell Resistance = 11 + Class level     (vfx)                               */

    if( !CanTakeSubrace( oPC, RACE_SVIRFNEBLIN ) ){
        SendMessageToPC( oPC, "- You may not become a Svirfneblin because your Base Race is incorrect. -" );
        return;
    }

    // Spell-like Abilities.
    CreateItemOnObject( "race_svirf_item1", oPC );
    CreateItemOnObject( "race_svirf_item2", oPC );
    CreateItemOnObject( "race_svirf_item3", oPC );


    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, -4);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -4);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    NWNX_Creature_AddFeat(oPC, FEAT_STONECUNNING);
    SetSubRace(oPC, "Svirfneblin");
    CreateItemOnObject("subracewidget", oPC);
    return;

}


// Duergar abilities.
void AddDuergarAbilitiesToBicFile( object oPC ){

    /*  CON +2 (0), CHA –4 (-2)
        Immunities: Paralysis, Poison, Phantasmal Killer (vfx)
        Move Silently + 4, Listen, Spot +1
        Spell-like ability: Invisibility    (item)
        Light Senstivity                                */

    if( !CanTakeSubrace( oPC, RACE_DUERGAR ) ){
        SendMessageToPC( oPC, "- You may not become a Duergar because your Base Race is incorrect. -" );
        return;
    }

    // Spell-like Ability.
    CreateItemOnObject( "race_dgar_item1", oPC );
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
    SetSubRace(oPC, "Duergar");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Gold Dwarf abilities.
void AddGoldDwarfAbilitiesToBicFile( object oPC ){

    /*  CON +2 (0), DEX -2, CHA -2 (+2)
        AB +1 Versus Aberrations [Favored enemy: Aberration]    */

    if( !CanTakeSubrace( oPC, RACE_GOLD_DWARF ) ){
        SendMessageToPC( oPC, "- You may not become a Gold Dwarf because your Base Race is incorrect. -" );
        return;
    }


    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, -2);
    NWNX_Creature_AddFeat(oPC, FEAT_FAVORED_ENEMY_ABERRATION);
    SetSubRace(oPC, "Gold Dwarf");
    CreateItemOnObject("subracewidget", oPC);

    return;
}


// Aquatic Elf abilities.
void AddAquaticElfAbilitiesToBicFile( object oPC ){

    /*  DEX +2 (0), CON 0 (+2), INT -2 */

    if( !CanTakeSubrace( oPC, RACE_AQUATIC_ELF ) ){
        SendMessageToPC( oPC, "- You may not become an Aquatic Elf because your Base Race is incorrect. -" );
        return;
    }

    if( GetIsPlatinumCoinSubRaceAndAuthorized( oPC ) != 1 ){
        SendMessageToPC( oPC, "- You may not become an Aquatic Elf because you haven't been authorized by a DM! -" );
        return;
    }

    /*ModifyPC(
        oPC,
        "/Subrace='Aquatic Elf';"                   +
        "/Con+='2';"                                +
        "/BodyBag='1';"                             +
        "/Int-='2';" );*/
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, -2);
    SetSubRace(oPC, "Aquatic Elf");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Wood Elf abilities.
void AddWoodElfAbilitiesToBicFile( object oPC ){

    /*  DEX +2 (0), CON -2 (0), STR +2, INT -2  */

    if( !CanTakeSubrace( oPC, RACE_WOOD_ELF ) ){
        SendMessageToPC( oPC, "- You may not become a Wood Elf because your Base Race is incorrect. -" );
        return;
    }
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, -2);
    SetSubRace(oPC, "Wood Elf");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Wild Elf abilities.
void AddWildElfAbilitiesToBicFile( object oPC ){

    /*  DEX +2 (0), CON 0 (+2), INT -2 (-2) */

    if( !CanTakeSubrace( oPC, RACE_WILD_ELF ) ){
        SendMessageToPC( oPC, "- You may not become a Wild Elf because your Base Race is incorrect. -" );
        return;
    }

    /*ModifyPC(
        oPC,
        "/Subrace='Wild Elf';"                      +
        "/Con+='2';"                                +
        "/BodyBag='1';"                             +
        "/Int-='2';" );*/

    return;
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, -2);
    SetSubRace(oPC, "Wild Elf");
    CreateItemOnObject("subracewidget", oPC);
    return;

}


// Sun Elf abilities
void AddSunElfAbilitiesToBicFile( object oPC ){

    /*  DEX 0 (-2), INT +2, CON -2 (0) */

    if( !CanTakeSubrace( oPC, RACE_SUN_ELF ) ){
        SendMessageToPC( oPC, "- You may not become a Sun Elf because your Base Race is incorrect. -" );
        return;
    }

    /*ModifyPC(
        oPC,
        "/Subrace='Sun Elf';"                       +
        "/Dex-='2';"                                +
        "/BodyBag='1';"                             +
        "/Int+='2';" );*/


    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
    SetSubRace(oPC, "Sun Elf");
    CreateItemOnObject("subracewidget", oPC);
    return;

}


// Ogrillion abilities.
void AddOgrillionAbilitiesToBicFile( object oPC ){

    /*  STR +2 [0], INT -2 [0], CHA -2 [0], CON +2
        Natural AC +2   (vfx)
        race: ork
    */

    if( !CanTakeSubrace( oPC, RACE_OGRILLION ) ){
        SendMessageToPC( oPC, "- You may not become an Ogrillion because your Base Race is incorrect. -" );
        return;
    }


    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_HUMANOID_ORC);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
    SetSubRace(oPC, "Ogrillon");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Orog abilities.
void AddOrogAbilitiesToBicFile( object oPC ){
    /*
        +2 STR
        +2 CHA
        -2 WIS
        -2 DEX
        5/- fire 5/- Cold
        Light Blindness
        +2 craft weapon/armor
        +2 AC
        +2 ECL.
        race: ork
    */

    if( !CanTakeSubrace( oPC, RACE_OROG ) ){
        SendMessageToPC( oPC, "- You may not become an Orog because your Base Race is incorrect. -" );
        return;
    }


    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_HUMANOID_ORC);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
    SetSubRace(oPC, "Orog");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// New, added 082006.

// Chultan abilities.
void AddChultanAbilitiesToBicFile( object oPC ){

    /*  DEX +2, CHA -2, Feat: Snake Blood. */

    if( !CanTakeSubrace( oPC, RACE_CHULTAN ) ){
        SendMessageToPC( oPC, "- You may not become a Chultan because your Base Race is incorrect. -" );
        return;
    }

    /*ModifyPC(
        oPC,
        "/Subrace='Chultan';"                       +
        "/Dex+='2';"                                +
        "/Cha-='2';"                                +
        "add /FeatList/Feat, 386, gffWord;"         +
        "/BodyBag='1';" );*/
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
    NWNX_Creature_AddFeat(oPC, 386);
    SetSubRace(oPC, "Chultan");
    CreateItemOnObject("subracewidget", oPC);

    return;

}

// Calishite abiltiies.
void AddCalishiteAbilitiesToBicFile( object oPC ){

    /*  INT +1, CHA +1, CON -1, WIS -1, Feat: Silver Palm. */

    if( !CanTakeSubrace( oPC, RACE_CALISHITE ) ){
        SendMessageToPC( oPC, "- You may not become a Calishite because your Base Race is incorrect. -" );
        return;
    }

    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, -1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, -1);
    NWNX_Creature_AddFeat(oPC, 384);
    SetSubRace(oPC, "Calishite");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Ffolk abilities.
void AddFfolkAbilitiesToBicFile( object oPC ){

    /*  WIS +1, CON +1, STR -1, INT -1. */

    if( !CanTakeSubrace( oPC, RACE_FFOLK ) ){
        SendMessageToPC( oPC, "- You may not become a Ffolk because your Base Race is incorrect. -" );
        return;
    }

    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, -1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, -1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 1);
    NWNX_Creature_AddFeat(oPC, 384);
    SetSubRace(oPC, "Ffolk");
    CreateItemOnObject("subracewidget", oPC);

    return;

}

// Shadovar abilities.
void AddShadovarAbilitiesToBicFile( object oPC ){

    /*  DEX +1, INT +1, CON -2, WIS -1, Feat: Stealthy. */

    if( !CanTakeSubrace( oPC, RACE_SHADOVAR ) ){
        SendMessageToPC( oPC, "- You may not become a Shadovar because your Base Race is incorrect. -" );
        return;
    }

    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, -1);
    NWNX_Creature_AddFeat(oPC, 387);
    SetSubRace(oPC, "Shadovar");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Durpari abilities.
void AddDurpariAbilitiesToBicFile( object oPC ){

    /*  CHA +2, STR -1, CON -1, Feat: Artist. */

    if( !CanTakeSubrace( oPC, RACE_DURPARI ) ){
        SendMessageToPC( oPC, "- You may not become a Durpari because your Base Race is incorrect. -" );
        return;
    }


    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, -1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, -1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, -1);
    NWNX_Creature_AddFeat(oPC, 378);
    SetSubRace(oPC, "Durpari");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Tuigan abilties.
void AddTuiganAbilitiesToBicFile( object oPC ){

    /*  STR +1, DEX -1, Feat: Blooded. */

    if( !CanTakeSubrace( oPC, RACE_TUIGAN ) ){
        SendMessageToPC( oPC, "- You may not become a Tuigan because your Base Race is incorrect. -" );
        return;
    }

    /*ModifyPC(
        oPC,
        "/Subrace='Tuigan';"                        +
        "/Str+='1';"                                +
        "add /FeatList/Feat, 379, gffWord;"         +
        "/BodyBag='1';" );*/
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, -1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, 1);
    NWNX_Creature_AddFeat(oPC, 379);
    SetSubRace(oPC, "Tuigan");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Mulan abilities.
void AddMulanAbilitiesToBicFile( object oPC ){

    /*  WIS +1, DEX -1, Feat: Strong Soul. */
    if( !CanTakeSubrace( oPC, RACE_MULAN ) ){
        SendMessageToPC( oPC, "- You may not become a Mulan because your Base Race is incorrect. -" );
        return;
    }

    /*ModifyPC(
        oPC,
        "/Subrace='Mulan';"                         +
        "/Wis+='1';"                                +
        "/Dex-='1';"                                +
        "add /FeatList/Feat, 388, gffWord;"         +
        "/BodyBag='1';" );*/
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, -1);
    NWNX_Creature_AddFeat(oPC, 388);
    SetSubRace(oPC, "Mulan");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Halruaan abilities.
void AddHalruaanAbilitiesToBicFile( object oPC ){

    /*  INT +2, CON -2, WIS -1, Feat: Courteous Magocracy. */

    if( !CanTakeSubrace( oPC, RACE_HALRUAAN ) ){
        SendMessageToPC( oPC, "- You may not become a Halruaan because your Base Race is incorrect. -" );
        return;
    }

    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, -1);

    NWNX_Creature_AddFeat(oPC, 381);
    SetSubRace(oPC, "Halruaan");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Damaran abilities.
void AddDamaranAbilitiesToBicFile( object oPC ){

    /*  WIS +1, DEX +1, STR -2, INT -1, Feat: Bull-headed. */

    if( !CanTakeSubrace( oPC, RACE_DAMARAN ) ){
        SendMessageToPC( oPC, "- You may not become a Damaran because your Base Race is incorrect. -" );
        return;
    }

    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, -1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 1);
    NWNX_Creature_AddFeat(oPC, 380);
    SetSubRace(oPC, "Damaran");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Snow Elf abilities.
void AddSnowElfAbilitiesToBicFile( object oPC ){

    /*  STR +1, DEX +1 [-1], CON +1 [+3], WIS -2. */

    if( !CanTakeSubrace( oPC, RACE_SNOW_ELF ) ){
        SendMessageToPC( oPC, "- You may not become a Snow Elf because your Base Race is incorrect. -" );
        return;
    }

    if( GetIsPlatinumCoinSubRaceAndAuthorized( oPC ) != 1 ){
        SendMessageToPC( oPC, "- You may not become a Snow Elf because you haven't been authorized by a DM! -" );
        return;
    }

    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, 1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, -1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 3);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, -2);

    SetSubRace(oPC, "Snow Elf");
    CreateItemOnObject("subracewidget", oPC);

    return;

}

// Daemonfey abilities.
void AddFeyriAbilitiesToBicFile( object oPC ){

    /*  INT +2, DEX +2 [0], CON -2, Feat: Darkvision, Spell-like Ability: Clairaudience/Clairvoyance. */

    if( !CanTakeSubrace( oPC, RACE_FEYRI ) ){
        SendMessageToPC( oPC, "- You may not become a Daemonfey because your Base Race is incorrect. -" );
        return;
    }

    if( GetIsPlatinumCoinSubRaceAndAuthorized( oPC ) != 1 ){
        SendMessageToPC( oPC, "- You may not become a Feyri because you haven't been authorized by a DM! -" );
        return;
    }

    // Spell-like ability.
    CreateItemOnObject( "race_ghalf_item1", oPC );


    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    SetSubRace(oPC, "Daeamonfey");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Feytouched abilities.
void AddFeytouchedAbilitiesToBicFile( object oPC ){

    /*  DEX +2, CON -2, CHA +2, Feat: Low-light vision, Spell-like Ability: Charm Person, Type change: Fey. */

    if( !CanTakeSubrace( oPC, RACE_FEYTOUCHED ) ){
        SendMessageToPC( oPC, "- You may not become a Feytouched because your Base Race is incorrect. -" );
        return;
    }

    // Spell-like Ability.
    CreateItemOnObject( "race_fae_item1", oPC );


    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_FEY);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
    NWNX_Creature_AddFeat(oPC, 354);
    SetSubRace(oPC, "Feytouched");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Shadow Elf abilities.
void AddShadowElfAbilitiesToBicFile( object oPC ){

    /*  INT +2, DEX +2 [0], CON -2 [0], CHA -2. */

    if( !CanTakeSubrace( oPC, RACE_SHADOW_ELF ) ){
        SendMessageToPC( oPC, "- You may not become a Shadow Elf because your Base Race is incorrect. -" );
        return;
    }

    if( GetIsPlatinumCoinSubRaceAndAuthorized( oPC ) != 1 ){
        SendMessageToPC( oPC, "- You may not become a Shadow Elf because you haven't been authorized by a DM! -" );
        return;
    }

    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    SetSubRace(oPC, "Shadow Elf");
    CreateItemOnObject("subracewidget", oPC);

    return;

}


// Elfling abilities.
void AddElflingAbilitiesToBicFile( object oPC ){

    /*  DEX +2, CON -1, STR -1, CHA +2, WIS -2, Feat: Low-light Vision, Feat: Immunity to Sleep. */

    if( !CanTakeSubrace( oPC, RACE_ELFLING ) ){

        SendMessageToPC( oPC, "- You may not become an Elfling because your Base Race is incorrect. -" );
        return;
    }

    if( GetIsPlatinumCoinSubRaceAndAuthorized( oPC ) != 1 ){

        SendMessageToPC( oPC, "- You may not become an Elfling because you haven't been authorized by a DM! -" );
        return;
    }

    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, -2);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, -1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, -1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
    NWNX_Creature_AddFeat(oPC, 375);
    NWNX_Creature_AddFeat(oPC, 250);
    NWNX_Creature_AddFeat(oPC, 249);
    NWNX_Creature_AddFeat(oPC, 248);
    NWNX_Creature_AddFeat(oPC, 247);
    NWNX_Creature_AddFeat(oPC, 237);
    NWNX_Creature_RemoveFeat(oPC, 244);
    NWNX_Creature_RemoveFeat(oPC, 245);
    NWNX_Creature_RemoveFeat(oPC, 246);
    SetCreatureAppearanceType(oPC, 3);
    CreateItemOnObject("subracewidget", oPC);

    SetSubRace(oPC, "Elfling");

    return;

}


// Hobgoblin abilities.
void AddHobgoblinAbilitiesToBicFile( object oPC ){

    // Variables.
    int nAppearance         = d100( ) < 51 ? 390 : 391;     // 50% chance to be a warrior or a wizard appearance.

    /*  STR 0 [-2], INT 0 [+2], CHA 0 [+2], DEX +1, CON +1, Feat: Darkvision, Appearance: Hobgoblin. */
    //race: goblinoid

    if( !CanTakeSubrace( oPC, RACE_HOBGOBLIN ) ){
        SendMessageToPC( oPC, "- You may not become a Hobgoblin because your Base Race is incorrect. -" );
        return;
    }


    NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_HUMANOID_GOBLINOID);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 1);
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 1);
    NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
    SetCreatureAppearanceType(oPC, nAppearance);
    SetSubRace(oPC, "Hobgoblin");
    CreateItemOnObject("subracewidget", oPC);

    return;
}


// Determines Dream Coin Supply.
int GetDreamCoinAmount( object oPC ){

    string sPCAccount   = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    int nCoins;

    string sQuery = "SELECT given_player, count( id ) AS account "
                   +"FROM dc_transactions "
                   +"WHERE given_player = '"+sPCAccount+"' "
                   +"AND isnull( taken_by)  "
                   +"GROUP BY given_player ";


    SQLExecDirect( sQuery );

    if( SQLFetch() != SQL_ERROR ){

        //get coin account
        nCoins = StringToInt( SQLGetData( 2 ) );

        //store on PC for further use
        SetLocalInt( oPC, STORAGE_DC_COUNT, nCoins );
    }

    return nCoins;
}


// Removes Dream Coins.
int TakeDreamCoins( object oPC, int nCoins, string szReason ){
    /*
    // Variables.
    int nNumberOfDreamCoinsTaken    = 0;

    // Cycle the player's inventory and subtract the DC requirement.
    object oSeek = GetFirstItemInInventory( oPC );

    while( GetIsObjectValid( oSeek ) ){

        // DC found, remove it.
        if( GetTag( oSeek ) == DC_TAG ){

            DestroyObject( oSeek );

            // Tally total DCs taken.
            if( ++nNumberOfDreamCoinsTaken == nNumberOfDreamCoinsToTake )
                break;

        }

        oSeek = GetNextItemInInventory( oPC );

    }

    // for security purposes, log the exact amount of DCs taken, and for what reason
    WriteTimestampedLogEntry(
        "|Automated Character Maintenance|Name="                                +
        GetPCPlayerName( oPC )                                                  +
        "|Character Name="                                                      +
        GetName( oPC )                                                          +
        "|DCs Required="                                                        +
        IntToString( nNumberOfDreamCoinsToTake )                                +
        "|DCs Taken="                                                           +
        IntToString( nNumberOfDreamCoinsTaken )                                 +
        "|Reason="                                                              +
        szReason                                                                +
        "|");

    return( nNumberOfDreamCoinsTaken );
    */

    if ( nCoins == 0 ){

        return 0;
    }

    //variables
    int nAccount    = GetDreamCoinAmount( oPC );
    string sPlayer  = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );

    if ( nCoins > nAccount ){

        SendMessageToPC( oPC, "Not enough Dreamcoins!" );
        return 0;
    }

    //SQL
    string sQuery = "UPDATE dc_transactions SET taken_by  = 'ACM', updated_at = NOW() "
                   +"WHERE given_player = '"+sPlayer+"' AND isnull( taken_by ) LIMIT "+IntToString( nCoins );

    SQLExecDirect( sQuery );

    //update local account
    nAccount = nAccount-nCoins;
    SetLocalInt( oPC, STORAGE_DC_COUNT, nAccount );

    SendMessageToPC( oPC, IntToString( nCoins )+" DC taken, "+IntToString( nAccount )+" left." );


    return nCoins;
}
