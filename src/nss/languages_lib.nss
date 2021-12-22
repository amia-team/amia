/*
languages_lib

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
Include for language scripts

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
07-24-2006      disco      Start of header
------------------------------------------------
*/

//includes
#include "inc_ds_records"


//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void SetAutoLanguages( object oPC, string sRace );
void ShowAutoLanguages( object oPC, string sRace );
void ShowBonusLanguages( object oPC, string sRace );
void ShowSelectableLanguages( object oPC, string sRace );
int  GetSelectableLanguages( object oPC, string sRace );

string GetRaceIndex( object oPC);

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------

void SetAutoLanguages( object oPC, string sRace ){

    string sAllowed;
    int i;

    if ( GetPCKEYValue(oPC, "languages_set" ) == 1 )  {

        return;

    }

    for ( i=1; i<24; ++i ){

        sAllowed = Get2DAString("ds_languages", sRace, i);

        if ( sAllowed == "auto" ) {

            SetPCKEYValue(oPC, "lan_"+IntToString( i ), 1 );
            AddJournalQuestEntry( "lan_"+IntToString( i ), 1, oPC, FALSE );

        }
    }

    SetPCKEYValue( oPC, "languages_set", 1 );

    //save character
    ExportSingleCharacter( oPC );
}

void ShowAutoLanguages( object oPC, string sRace ){

    string sAllowed;
    int i;

    for ( i=1; i<24; ++i ){

        sAllowed = Get2DAString("ds_languages", sRace, i);

        if ( sAllowed == "auto" ) {

            SetLocalInt(oPC, "ds_check_"+IntToString(i), 1 );

        }
        else {

            SetLocalInt(oPC, "ds_check_"+IntToString(i), 0 );

        }
    }
}

void ShowBonusLanguages( object oPC, string sRace ){

    string sAllowed;
    int i;

    for ( i=1; i<24; ++i ){

        sAllowed = Get2DAString("ds_languages", sRace, i);

        if ( sAllowed == "bonus" ) {

            SetLocalInt(oPC, "ds_check_"+IntToString(i), 1 );

        }
        else {

            SetLocalInt(oPC, "ds_check_"+IntToString(i), 0 );

        }
    }
}

void ShowSelectableLanguages( object oPC, string sRace ){

    string sAllowed = "";
    int nBonusLeft  = GetSelectableLanguages( oPC, sRace );
    int nTaken      = 0;
    int i           = 0;

    SetLocalString( oPC, "ds_action", "a_c_languages" );

    for ( i=1; i<24; ++i ){

        sAllowed = Get2DAString( "ds_languages", sRace, i );
        nTaken   = GetPCKEYValue( oPC, "lan_"+IntToString(i) );

        if ( sAllowed == "bonus" && nTaken==0 && nBonusLeft!=0) {

            SetLocalInt(oPC, "ds_check_"+IntToString(i), 1 );
        }
        else {

            SetLocalInt(oPC, "ds_check_"+IntToString(i), 0 );
        }
    }
}

int GetSelectableLanguages( object oPC, string sRace ){

    string sAllowed             = "";

    //get ability scores
    //int nIntelligence           = ( GetAbilityScore( oPC, ABILITY_DEXTERITY, TRUE )-10 )/2;
    //int nLore                   = GetSkillRank( SKILL_LORE, oPC, TRUE ) / 5;
    //int nAllowedBonusLanguages  = ( nLore + nIntelligence )/2;
    int nAllowedBonusLanguages  = ( GetAbilityScore( oPC, ABILITY_DEXTERITY, TRUE )-10 )/2;

    int nBonusLanguages;
    int i                       = 0;

    //check bonus languages
    for ( i=1; i<24; ++i ){

        sAllowed = Get2DAString( "ds_languages", sRace, i );

        if ( sAllowed == "bonus" && GetPCKEYValue( oPC, "lan_"+IntToString( i ) ) == 1 ) {

            ++nBonusLanguages;

        }
    }

    //set custom tokens for language options
    SetCustomToken( 3500, IntToString( nAllowedBonusLanguages ) );
    SetCustomToken( 3501, IntToString( nAllowedBonusLanguages-nBonusLanguages ) );

    return ( nAllowedBonusLanguages - nBonusLanguages );

}



string GetRaceIndex( object oPC) {

    int nRacialType         = GetRacialType( oPC );
    string szSubRace        = GetSubRace( oPC );

    //SendMessageToPC(GetFirstPC(),"race: "+IntToString(nRacialType)+", subrace: "+szSubRace);

    if( szSubRace == "Duergar" )                return( "duergar" );
    if( szSubRace == "Drow" )                   return( "drow" );
    if( szSubRace == "Aquatic Elf" )            return( "aquatic" );
    if( szSubRace == "Svirfneblin" )            return( "svirf" );
    if( szSubRace == "Strongheart Halfling" )   return( "halfling" );
    if( szSubRace == "Ghostwise Halfling" )     return( "halfling" );
    if( szSubRace == "Faerie" )                 return( "fairy" );
    if( szSubRace == "Goblin" )                 return( "goblin" );
    if( szSubRace == "Kobold" )                 return( "kobold" );
    if( szSubRace == "Aasimar" )                return( "aasimar" );
    if( szSubRace == "Tiefling" )               return( "tiefling" );
    if( szSubRace == "Ogrillion" )              return( "ogrillion" );
    if( szSubRace == "Gold Dwarf" )             return( "dwarf" );
    if( szSubRace == "Sun Elf" )                return( "elf" );
    if( szSubRace == "Wild Elf" )               return( "elf" );
    if( szSubRace == "Wood Elf" )               return( "elf" );
    if( szSubRace == "Half-Drow" )              return( "halfdrow" );
    if( szSubRace == "Orog" )                   return( "orog" );
    if( szSubRace =="air genasi")               return( "a_genasi" );
    if( szSubRace =="earth genasi")             return( "e_genasi" );
    if( szSubRace =="fire genasi")              return( "f_genasi" );
    if( szSubRace =="water genasi")             return( "w_genasi" );
    if( nRacialType == RACIAL_TYPE_DWARF )      return( "dwarf" );
    if( nRacialType == RACIAL_TYPE_ELF )        return( "elf" );
    if( nRacialType == RACIAL_TYPE_GNOME )      return( "gnome" );
    if( nRacialType == RACIAL_TYPE_HALFELF )    return( "halfelf" );
    if( nRacialType == RACIAL_TYPE_HALFLING )   return( "halfling" );
    if( nRacialType == RACIAL_TYPE_HUMAN )      return( "human" );
    if( nRacialType == RACIAL_TYPE_HALFORC )    return( "halforc" );

    // Error.
    else                                        return( "bogus" );

}
