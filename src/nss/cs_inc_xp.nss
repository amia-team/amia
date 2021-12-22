/*  Customized XP Function Library and Racial System Helper Functions

    --------
    Verbatim
    --------
    This library scriptfile calculates Amia's XP for killing monsters based
    on Challenge Rating, Effective Character Level and Favored Class Penalty.

    It also provides a function that applies Hide Items to players, which serves
    as property bonuses for non-standard racial types.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    122005  kfw         Initial Release.
    060406  kfw         Bug fixes, syntax.
    060906  kfw         Optimized Racial Traits, ECL and Favored XP Penalty routines.
    070606  kfw         Prevent XP banking functions.
    071606  kfw         XP banking limit modified to next level's worth of XP + 50% of next level.
    080806  kfw         Racial Trait Description fixed.
    082006  kfw         Added new Subraces!
    091206  kfw         Ogrillion Trait NAC changed to DAC.
    091706  kfw         Strongheart Hin Trait DeAC changed to DAC.
  20070412  disco       Smurphs now have ECL 2 and Duergar 0
  20090223  disco       Updated racial/class/area effects refresher
  20090228  disco       Added custom RDD support
  20090502  disco       There was a huge bug in here. Added GiveCorrectedXP() to deal with it.
  20110126  PoS         Removed ECL from Genasi, Orog are now +1.
  20110314  PoS         Removed ECL from Elfling and Shadow Elf.
  Nov152016 Mav-00053   Added new epic bonuses for Dragon Disciple!
    032216  RaveN       Removed Multi-classing, but left it intact for reversal.
    ----------------------------------------------------------------------------


*/

// Includes.
#include "x2_inc_itemprop"
#include "inc_lua"

// Structure definition.
//void main (){}
// This structure contains information about a character's Effective Character Level and related info.
struct _ECL_STATISTICS{
    float fECL;
    float fLevelAdjustment;
    float fXP_Penalty_ECL;
    float fXP_Penalty_Multiclass;
    float fXP_Penalty_Final;
};

// Constants.

// Generic.
const int FAVORED_CLASS_ANY                     = 254;
//const string RACE_HIDE_REF                      = "amia_race_hide";
const string PP_TOOL_REF                        = "pp_tool";

// Experience, gain and level values.
const string PLAYER_ECL                         = "CS_ECL";
const string PLAYER_LVL_ADJ                     = "CS_LVL_ADJ";

const string PLAYER_XP_PENALTY_ECL              = "CS_XP_PENALTY_ECL";
const string PLAYER_XP_PENALTY_MULTICLASS       = "CS_XP_PENALTY_MULTICLASS";

const string PLAYER_XP_PENALTY_FINAL            = "CS_XP_PENALTY_FINAL";

// Racial-trait custom races.
const int RACE_UNKNOWN          =  0;
const int RACE_DUERGAR          =  1;
const int RACE_DROW             =  2;
const int RACE_AQUATIC_ELF      =  3;
const int RACE_SVIRFNEBLIN      =  4;
const int RACE_STRONGHEART_HIN  =  5;
const int RACE_GHOSTWISE_HIN    =  6;
const int RACE_FAERIE           =  7;
const int RACE_GOBLIN           =  8;
const int RACE_KOBOLD           =  9;
const int RACE_AASIMAR          = 10;
const int RACE_TIEFLING         = 11;
const int RACE_AIR_GENASI       = 12;
const int RACE_EARTH_GENASI     = 13;
const int RACE_FIRE_GENASI      = 14;
const int RACE_WATER_GENASI     = 15;
const int RACE_OGRILLION        = 16;
// New, added 081906.
const int RACE_CHULTAN          = 17;
const int RACE_CALISHITE        = 18;
const int RACE_FFOLK            = 19;
const int RACE_SNOW_ELF         = 20;
const int RACE_FEYRI            = 21;
const int RACE_FEYTOUCHED       = 22;
const int RACE_SHADOW_ELF       = 23;
const int RACE_ELFLING          = 24;
const int RACE_HOBGOBLIN        = 25;


// Racial-non-trait custom races.

const int RACE_GOLD_DWARF       = 26;
const int RACE_SUN_ELF          = 27;
const int RACE_WILD_ELF         = 28;
const int RACE_WOOD_ELF         = 29;
const int RACE_HALF_DROW        = 30;
const int RACE_OROG             = 31;
// New, added 081906.
const int RACE_SHADOVAR         = 32;
const int RACE_DURPARI          = 33;
const int RACE_TUIGAN           = 34;
const int RACE_MULAN            = 35;
const int RACE_HALRUAAN         = 36;
const int RACE_DAMARAN          = 37;


// Racial-non-trait standard races.
const int RACE_SHIELD_DWARF     = 38;
const int RACE_MOON_ELF         = 39;
const int RACE_ROCK_GNOME       = 40;
const int RACE_HALF_ELF         = 41;
const int RACE_LIGHTFOOT_HIN    = 42;
const int RACE_HUMAN            = 43;
const int RACE_HALF_ORC         = 44;
const int RACE_UNDEAD           = 45;
const int RACE_SHAPECHANGER     = 46;
const int RACE_DRAGON           = 47;
const int RACE_REPTILE          = 48;
const int RACE_CONSTRUCT        = 49;
const int RACE_ABERRATION       = 50;
const int RACE_FEY              = 51;


// External prototypes.

// This function determines the Experience Point penalty between her highest, non-favored, core class and other core classes, if applicable.
float GetMultiClassPenalty( object oPC );

// This function calculates the player's Effective Character Level.
// S-29.06.2011
struct _ECL_STATISTICS GetECL( object oPC );

// Gives exact XP withotu any multiclass/ECL panalties.
void GiveExactXP( object oPC, int nXP, string sTrackingVar="" );

// Takes exact XP without any multiclass/ECL/etc penalties.
void TakeExactXP( object oPC, int nXP );

// This wrapper distributes XP in accordance with the player's ECL and Multiclass penalties.
void GiveCorrectedXP( object oPC, int nXP, string sTrackingVar="", int nCorrectECL=1, int nCorrectFavClass=1 );
//comes from the death scripts
int LevelMatchesXPRatio( object oPC );

// This function will adjust a character's traits based on Amia requirements.
void ApplyTraits( object oPC );


// Internal prototypes.

// This function will determine which class level is the highest and return its category position.
int GetClassLevelHighest_ByPosition( int nClass1_Level, int nClass2_Level, int nClass3_Level );

// This function will apply a 20% penalty to the existing floating point penalty based on uneveness between class levels more than a single unit.
float GetDiffPenalty( float fPenalty, int nClassX_Type, int nClassX_Level, int nClassY_Type, int nClassY_Level );

// This function converts a racial constant integer used in the Racial System into a readable text format. */
string GetRaceName( int nRaceInteger );

// This function determines if a class type is a Prestige Class, used for discounting favored class XP penalties.
int GetIsPrC( int nClassType );

// This function determines whether a class type is a default, Bioware race.
int GetIsStandardRace( int nRacialType );

// This function determines whether a class type is a customized subrace given its designated Racial System integer.
int GetIsCustomRace( int nRaceInteger );

// This function determines wheather a class type is a customized subrace racial-trait race given its designated Racial System integer.
int GetIsCustomRaceRacialTraitRace( int nRaceInteger );

// This function determines the favored class of a default, Bioware race.
int GetStandardRaceFavoredClass( int nRacialType );

// This function determines the favored class of a race.
int GetFavoredClass( int nRaceInteger, int nGender );

// This function will parse a player's race string or Bioware racial type into an integer used by the Racial System.
int GetRaceInteger( int nRacialType, string szSubRace );



// Function Definitions.


// This function will determine which class level is the highest and return its category position.
int GetClassLevelHighest_ByPosition( int nClass1_Level, int nClass2_Level, int nClass3_Level ){

    // Variables.
    int nHighestClass_Position      = 1;
    int nHighestClass_Level         = nClass1_Level;

    // Second is higher than the first.
    if( nClass1_Level < nClass2_Level ){
        nHighestClass_Position      = 2;
        nHighestClass_Level         = nClass2_Level;
    }

    // Third is higher than the highest.
    if( nHighestClass_Level < nClass3_Level )
        nHighestClass_Position      = 3;

    return( nHighestClass_Position );

}


// This function will apply a 20% penalty to the existing floating point penalty based on uneveness between class levels more than a single unit.
float GetDiffPenalty( float fPenalty, int nClassX_Type, int nClassX_Level, int nClassY_Type, int nClassY_Level ){

    // Error control.
    if( nClassX_Type == CLASS_TYPE_INVALID )
        return( fPenalty );
    if( nClassY_Type == CLASS_TYPE_INVALID )
        return( fPenalty );

    // Uneven, apply 20% penalty.
    if( abs( nClassX_Level - nClassY_Level ) > 1 )
        return( fPenalty -= 0.2 );
    // Even, no penalty.
    else
        return( fPenalty );

}


// This function determines if a class type is a Prestige Class, used for discounting favored class XP penalties.
int GetIsPrC( int nClassType ){

    // Class within PrC range? See classes.2da for detail.
    if( nClassType > CLASS_TYPE_VERMIN && nClassType < CLASS_TYPE_OOZE ){

        return TRUE;

    }
    else if ( nClassType == CLASS_TYPE_PURPLE_DRAGON_KNIGHT ){

        return TRUE;
    }


    return FALSE;

}


// This function determines whether a class type is a default, Bioware race.
int GetIsStandardRace( int nRacialType ){

    // Verify race is standard. See racialtypes.2da for detail.
    return( nRacialType < RACIAL_TYPE_ABERRATION ? TRUE : FALSE );

}


// This function determines whether a class type is a customized subrace given its designated Racial System integer.
int GetIsCustomRace( int nRaceInteger ){

    return( nRaceInteger < RACE_SHIELD_DWARF ? TRUE : FALSE );

}


// This function determines the favored class of a default, Bioware race.
int GetStandardRaceFavoredClass( int nRacialType ){

    switch( nRacialType ){

        case RACIAL_TYPE_DWARF:             return( CLASS_TYPE_FIGHTER );
        case RACIAL_TYPE_ELF:               return( CLASS_TYPE_WIZARD );
        case RACIAL_TYPE_GNOME:             return( CLASS_TYPE_WIZARD );
        case RACIAL_TYPE_HALFELF:           return( CLASS_TYPE_INVALID );
        case RACIAL_TYPE_HALFLING:          return( CLASS_TYPE_ROGUE );
        case RACIAL_TYPE_HUMAN:             return( CLASS_TYPE_INVALID );
        case RACIAL_TYPE_HALFORC:           return( CLASS_TYPE_BARBARIAN );
        default:                            return( FAVORED_CLASS_ANY );

    }

    return( FAVORED_CLASS_ANY );

}


// This function determines the favored class of a race.
int GetFavoredClass( int nRaceInteger, int nGender ){

    switch( nRaceInteger ){

        case RACE_DUERGAR:                          return( CLASS_TYPE_FIGHTER );
        case RACE_DROW:                             return( nGender == GENDER_FEMALE ? CLASS_TYPE_CLERIC : CLASS_TYPE_WIZARD );
        case RACE_AQUATIC_ELF:                      return( CLASS_TYPE_FIGHTER );
        case RACE_SVIRFNEBLIN:                      return( CLASS_TYPE_WIZARD );
        case RACE_STRONGHEART_HIN:                  return( CLASS_TYPE_FIGHTER );
        case RACE_GHOSTWISE_HIN:                    return( CLASS_TYPE_RANGER );
        case RACE_FAERIE:                           return( CLASS_TYPE_SORCERER );
        case RACE_GOBLIN:                           return( CLASS_TYPE_ROGUE );
        case RACE_KOBOLD:                           return( CLASS_TYPE_SORCERER );
        case RACE_AASIMAR:                          return( CLASS_TYPE_PALADIN );
        case RACE_TIEFLING:                         return( CLASS_TYPE_ROGUE );
        case RACE_AIR_GENASI:                       return( CLASS_TYPE_FIGHTER );
        case RACE_EARTH_GENASI:                     return( CLASS_TYPE_FIGHTER );
        case RACE_FIRE_GENASI:                      return( CLASS_TYPE_FIGHTER );
        case RACE_WATER_GENASI:                     return( CLASS_TYPE_FIGHTER );
        case RACE_OGRILLION:                        return( CLASS_TYPE_BARBARIAN );
        case RACE_GOLD_DWARF:                       return( CLASS_TYPE_FIGHTER );
        case RACE_SUN_ELF:                          return( CLASS_TYPE_WIZARD );
        case RACE_WILD_ELF:                         return( CLASS_TYPE_SORCERER );
        case RACE_WOOD_ELF:                         return( CLASS_TYPE_RANGER );
        case RACE_HALF_DROW:                        return( FAVORED_CLASS_ANY );
        case RACE_OROG:                             return( CLASS_TYPE_FIGHTER );
        case RACE_SHIELD_DWARF:                     return( CLASS_TYPE_FIGHTER );
        case RACE_MOON_ELF:                         return( CLASS_TYPE_WIZARD );
        case RACE_ROCK_GNOME:                       return( CLASS_TYPE_WIZARD );
        case RACE_HALF_ELF:                         return( FAVORED_CLASS_ANY );
        case RACE_LIGHTFOOT_HIN:                    return( CLASS_TYPE_ROGUE );
        case RACE_HUMAN:                            return( FAVORED_CLASS_ANY );
        case RACE_HALF_ORC:                         return( CLASS_TYPE_BARBARIAN );
        // New, added 081906.
        case RACE_HOBGOBLIN:                        return( CLASS_TYPE_FIGHTER );
        case RACE_SHADOVAR:                         return( CLASS_TYPE_ROGUE );
        case RACE_DURPARI:                          return( CLASS_TYPE_BARD );
        case RACE_TUIGAN:                           return( CLASS_TYPE_FIGHTER );
        case RACE_MULAN:                            return( CLASS_TYPE_CLERIC );
        case RACE_HALRUAAN:                         return( CLASS_TYPE_WIZARD );
        case RACE_DAMARAN:                          return( CLASS_TYPE_MONK );
        case RACE_CHULTAN:                          return( CLASS_TYPE_RANGER );
        case RACE_CALISHITE:                        return( CLASS_TYPE_SORCERER );
        case RACE_FFOLK:                            return( CLASS_TYPE_DRUID );
        case RACE_SNOW_ELF:                         return( CLASS_TYPE_RANGER );
        case RACE_FEYRI:                            return( CLASS_TYPE_SORCERER );
        case RACE_FEYTOUCHED:                       return( CLASS_TYPE_BARD );
        case RACE_SHADOW_ELF:                       return( CLASS_TYPE_ROGUE );
        case RACE_ELFLING:                          return( CLASS_TYPE_ROGUE );
        default:                                    return( FAVORED_CLASS_ANY );

    }

    return( FAVORED_CLASS_ANY );

}


// This function determines the Experience Point penalty between her highest, non-favored, core class and other core classes, if applicable.
float GetMultiClassPenalty( object oPC ){

    // Variables.
    float fMultiClassPenalty        = 1.0;
    // Multiclassing Disabled
    return( fMultiClassPenalty );

    /*
    int nRacialType                 = GetRacialType( oPC );
    string szSubRace                = GetSubRace( oPC );
    int nGender                     = GetGender( oPC );
    int nFavoredClass               = 0;

    int nFavoredClass2              = 0;
    float fMultiClassPenalty2       = 1.0;

    int nDefaultRace                = GetIsStandardRace( nRacialType );
    int nRaceInteger                = GetRaceInteger( nRacialType, szSubRace );
    int nHighestClass_Position      = 0;


    // Character class variables.
    int nClass1_Type                = GetClassByPosition( 1, oPC );
    int nClass1_Level               = GetLevelByClass( nClass1_Type, oPC );

    int nClass2_Type                = GetClassByPosition( 2, oPC );
    int nClass2_Level               = GetLevelByClass( nClass2_Type, oPC );
    // Cancel out PrCs.
    if( GetIsPrC( nClass2_Type ) ){

        nClass2_Type = CLASS_TYPE_INVALID;
        nClass2_Level = 0;

    }
    int nClass3_Type                = GetClassByPosition( 3, oPC );
    int nClass3_Level               = GetLevelByClass( nClass3_Type, oPC );
    // Cancel out PrCs.
    if( GetIsPrC( nClass3_Type ) ){

        nClass3_Type = CLASS_TYPE_INVALID;
        nClass3_Level = 0;

    }
    // Single class, bug out.
    if( nClass2_Type == CLASS_TYPE_INVALID  &&
        nClass3_Type == CLASS_TYPE_INVALID  )
        return( fMultiClassPenalty );

    // Shuffle the third class up if the second one was a PrC.
    if( nClass3_Type != CLASS_TYPE_INVALID  &&
        nClass2_Type == CLASS_TYPE_INVALID  ){
            // Replace second class with third classes values.
            nClass2_Type            = nClass3_Type;
            nClass2_Level           = nClass3_Level;
            // Purge third class values.
            nClass3_Type            = CLASS_TYPE_INVALID;
            nClass3_Level           = 0;
    }

    // Determine custom races/custom subrace's favored class.
    nFavoredClass = GetFavoredClass( nRaceInteger, nGender );

    // Any favored class, pick highest level.
    if( nFavoredClass == FAVORED_CLASS_ANY ){

        // Pick highest level class.
        nHighestClass_Position = GetClassLevelHighest_ByPosition( nClass1_Level, nClass2_Level, nClass3_Level );

        // Cancel out highest level class as being favored and doesn't count towards multiclass penalties.
        if(         nHighestClass_Position == 1 ){
            nClass1_Type        = CLASS_TYPE_INVALID;
            nClass1_Level       = 0;
        }
        else if(    nHighestClass_Position == 2 ){
            nClass2_Type        = CLASS_TYPE_INVALID;
            nClass2_Level       = 0;
        }
        else{
            nClass3_Type        = CLASS_TYPE_INVALID;
            nClass3_Level       = 0;
        }

        // Get next highest level class and use it for calculating multiclass penalties.
        nHighestClass_Position = GetClassLevelHighest_ByPosition( nClass1_Level, nClass2_Level, nClass3_Level );

    }

    // Specific favored class, cancel it out.
    else{

        // Match up and cancel.
        if(         nClass1_Type == nFavoredClass ){
            nClass1_Type        = CLASS_TYPE_INVALID;
            nClass1_Level       = 0;
        }
        else if(    nClass2_Type == nFavoredClass ){
            nClass2_Type        = CLASS_TYPE_INVALID;
            nClass2_Level       = 0;
        }
        else if(    nClass3_Type == nFavoredClass ){
            nClass3_Type        = CLASS_TYPE_INVALID;
            nClass3_Level       = 0;
        }

        // Get highest level class.
        nHighestClass_Position = GetClassLevelHighest_ByPosition( nClass1_Level, nClass2_Level, nClass3_Level );

    }

    // Calculate cumulative multiclass penalty.

    // First is highest, compare seconds and thirds with it.
    if(         nHighestClass_Position == 1 ){
        fMultiClassPenalty = GetDiffPenalty( fMultiClassPenalty, nClass1_Type, nClass1_Level, nClass2_Type, nClass2_Level );
        fMultiClassPenalty = GetDiffPenalty( fMultiClassPenalty, nClass1_Type, nClass1_Level, nClass3_Type, nClass3_Level );
    }
    // Second is highest, compare firsts and thirds with it.
    else if(    nHighestClass_Position == 2 ){
        fMultiClassPenalty = GetDiffPenalty( fMultiClassPenalty, nClass2_Type, nClass2_Level, nClass1_Type, nClass1_Level );
        fMultiClassPenalty = GetDiffPenalty( fMultiClassPenalty, nClass2_Type, nClass2_Level, nClass3_Type, nClass3_Level );
    }
    // Third is highest, compare firsts and seconds with it.
    else{
        fMultiClassPenalty = GetDiffPenalty( fMultiClassPenalty, nClass3_Type, nClass3_Level, nClass1_Type, nClass1_Level );
        fMultiClassPenalty = GetDiffPenalty( fMultiClassPenalty, nClass3_Type, nClass3_Level, nClass2_Type, nClass2_Level );
    }

    return( fMultiClassPenalty );
    */
}


// This function will parse a player's race string or Bioware racial type into an integer used by the Racial System.
int GetRaceInteger( int nRacialType, string szSubRace ){

    // Convert input Subrace entry to lowercase.
    szSubRace = GetStringLowerCase( szSubRace );

    // Racial-trait custom races [VFX].
    if( szSubRace == "duergar" )                return( RACE_DUERGAR );
    if( szSubRace == "drow" )                   return( RACE_DROW );
    if( szSubRace == "aquatic elf" )            return( RACE_AQUATIC_ELF );
    if( szSubRace == "aquatic" )                return( RACE_AQUATIC_ELF );
    if( szSubRace == "svirfneblin" )            return( RACE_SVIRFNEBLIN );
    if( szSubRace == "strongheart halfling" )   return( RACE_STRONGHEART_HIN );
    if( szSubRace == "strongheart" )            return( RACE_STRONGHEART_HIN );
    if( szSubRace == "ghostwise halfling" )     return( RACE_GHOSTWISE_HIN );
    if( szSubRace == "ghostwise" )              return( RACE_GHOSTWISE_HIN );
    if( szSubRace == "faerie" )                 return( RACE_FAERIE );
    if( szSubRace == "goblin" )                 return( RACE_GOBLIN );
    if( szSubRace == "kobold" )                 return( RACE_KOBOLD );
    if( szSubRace == "aasimar" )                return( RACE_AASIMAR );
    if( szSubRace == "tiefling" )               return( RACE_TIEFLING );
    if( szSubRace == "ogrillion" )              return( RACE_OGRILLION );
    // New, added 081906.
    if( szSubRace == "chultan" )                return( RACE_CHULTAN );
    if( szSubRace == "calishite" )              return( RACE_CALISHITE );
    if( szSubRace == "ffolk" )                  return( RACE_FFOLK );
    if( szSubRace == "snow elf" )               return( RACE_SNOW_ELF );
    if( szSubRace == "snow" )                   return( RACE_SNOW_ELF );
    if( szSubRace == "daemonfey" )              return( RACE_FEYRI );
    if( szSubRace == "feytouched" )             return( RACE_FEYTOUCHED );
    if( szSubRace == "shadow elf" )             return( RACE_SHADOW_ELF );
    if( szSubRace == "shadow" )                 return( RACE_SHADOW_ELF );
    if( szSubRace == "elfling" )                return( RACE_ELFLING );


    // Racial-non-trait custom races [No VFX].
    if( szSubRace == "gold dwarf" )             return( RACE_GOLD_DWARF );
    if( szSubRace == "gold" )                   return( RACE_GOLD_DWARF );
    if( szSubRace == "sun elf" )                return( RACE_SUN_ELF );
    if( szSubRace == "sun" )                    return( RACE_SUN_ELF );
    if( szSubRace == "wild elf" )               return( RACE_WILD_ELF );
    if( szSubRace == "wild" )                   return( RACE_WILD_ELF );
    if( szSubRace == "wood elf" )               return( RACE_WOOD_ELF );
    if( szSubRace == "wood" )                   return( RACE_WOOD_ELF );
    if( szSubRace == "half-drow" )              return( RACE_HALF_DROW );
    if( szSubRace == "halfdrow" )               return( RACE_HALF_DROW );
    if( szSubRace == "orog" )                   return( RACE_OROG );
    // New, added 081906.
    if( szSubRace == "hobgoblin" )              return( RACE_HOBGOBLIN );
    if( szSubRace == "shadovar" )               return( RACE_SHADOVAR );
    if( szSubRace == "durpari" )                return( RACE_DURPARI );
    if( szSubRace == "tuigan" )                 return( RACE_TUIGAN );
    if( szSubRace == "mulan" )                  return( RACE_MULAN );
    if( szSubRace == "halruaan" )               return( RACE_HALRUAAN );
    if( szSubRace == "damaran" )                return( RACE_DAMARAN );

    // Missed ones.
    if( szSubRace == "air" )                    return( RACE_AIR_GENASI );
    if( szSubRace == "air genasi" )             return( RACE_AIR_GENASI );
    if( szSubRace == "fire" )                   return( RACE_FIRE_GENASI );
    if( szSubRace == "fire genasi" )            return( RACE_FIRE_GENASI );
    if( szSubRace == "earth genasi" )           return( RACE_EARTH_GENASI );
    if( szSubRace == "earth" )                  return( RACE_EARTH_GENASI );
    if( szSubRace == "water genasi" )           return( RACE_WATER_GENASI );
    if( szSubRace == "water" )                  return( RACE_WATER_GENASI );



    // Racial-non-trait default races [No VFX].
    if( nRacialType == RACIAL_TYPE_DWARF )      return( RACE_SHIELD_DWARF );
    if( nRacialType == RACIAL_TYPE_ELF )        return( RACE_MOON_ELF );
    if( nRacialType == RACIAL_TYPE_GNOME )      return( RACE_ROCK_GNOME );
    if( nRacialType == RACIAL_TYPE_HALFELF )    return( RACE_HALF_ELF );
    if( nRacialType == RACIAL_TYPE_HALFLING )   return( RACE_LIGHTFOOT_HIN );
    if( nRacialType == RACIAL_TYPE_HUMAN )      return( RACE_HUMAN );
    if( nRacialType == RACIAL_TYPE_HALFORC )    return( RACE_HALF_ORC );
    if( nRacialType == RACIAL_TYPE_UNDEAD )     return( RACE_UNDEAD );
    if( nRacialType == RACIAL_TYPE_SHAPECHANGER )           return( RACE_SHAPECHANGER );
    if( nRacialType == RACIAL_TYPE_HUMANOID_REPTILIAN )     return( RACE_REPTILE );
    if( nRacialType == RACIAL_TYPE_CONSTRUCT )     return( RACE_CONSTRUCT );
    if( nRacialType == RACIAL_TYPE_ABERRATION )     return( RACE_ABERRATION );
    if( nRacialType == RACIAL_TYPE_FEY)         return ( RACE_FEY );

    // Error.
    else                                        return( RACE_UNKNOWN );

}


// This function converts a racial constant integer used in the Racial System into a readable text format. */
string GetRaceName( int nRaceInteger ){

    switch( nRaceInteger ){
        case RACE_AIR_GENASI:                   return( "Air Genasi" );
        case RACE_EARTH_GENASI:                 return( "Earth Genasi" );
        case RACE_WATER_GENASI:                 return( "Water Genasi" );
        case RACE_FIRE_GENASI:                  return( "Fire Genasi" );
        case RACE_DUERGAR:                      return( "Duergar" );
        case RACE_DROW:                         return( "Drow" );
        case RACE_AQUATIC_ELF:                  return( "Aquatic Elf" );
        case RACE_SVIRFNEBLIN:                  return( "Svirfneblin" );
        case RACE_STRONGHEART_HIN:              return( "Strongheart Halfling" );
        case RACE_GHOSTWISE_HIN:                return( "Ghostwise Halfling" );
        case RACE_FAERIE:                       return( "Faerie" );
        case RACE_GOBLIN:                       return( "Goblin" );
        case RACE_KOBOLD:                       return( "Kobold" );
        case RACE_AASIMAR:                      return( "Aasimar" );
        case RACE_TIEFLING:                     return( "Tiefling" );
        case RACE_OGRILLION:                    return( "Ogrillion" );
        case RACE_GOLD_DWARF:                   return( "Gold Dwarf" );
        case RACE_SUN_ELF:                      return( "Sun Elf" );
        case RACE_WILD_ELF:                     return( "Wild Elf" );
        case RACE_WOOD_ELF:                     return( "Wood Elf" );
        case RACE_HALF_DROW:                    return( "Half-Drow" );
        case RACE_OROG:                         return( "Orog" );
        case RACE_SHIELD_DWARF:                 return( "Shield Dwarf" );
        case RACE_MOON_ELF:                     return( "Moon Elf" );
        case RACE_ROCK_GNOME:                   return( "Rock Gnome" );
        case RACE_HALF_ELF:                     return( "Half-Elf" );
        case RACE_LIGHTFOOT_HIN:                return( "Lightfoot Halfling" );
        case RACE_HUMAN:                        return( "Human" );
        case RACE_HALF_ORC:                     return( "Half-Orc" );
        // New, added 081906.
        case RACE_HOBGOBLIN:                    return( "Hobgoblin" );
        case RACE_SHADOVAR:                     return( "Shadovar" );
        case RACE_DURPARI:                      return( "Durpari" );
        case RACE_TUIGAN:                       return( "Tuigan" );
        case RACE_MULAN:                        return( "Mulan" );
        case RACE_HALRUAAN:                     return( "Halruaan" );
        case RACE_DAMARAN:                      return( "Damaran" );
        case RACE_CHULTAN:                      return( "Chultan" );
        case RACE_CALISHITE:                    return( "Calishite" );
        case RACE_FFOLK:                        return( "Ffolk" );
        case RACE_SNOW_ELF:                     return( "Snow Elf" );
        case RACE_FEYRI:                        return( "Daemonfey" );
        case RACE_FEYTOUCHED:                   return( "Feytouched" );
        case RACE_SHADOW_ELF:                   return( "Shadow Elf" );
        case RACE_ELFLING:                      return( "Elfling" );
        default:                                return( "Unknown" );
    }

    return( "Unknown" );

}


// This function calculates the player's Effective Character Level.
struct _ECL_STATISTICS GetECL( object oPC ){

    // Variables.
    struct _ECL_STATISTICS ECL_STATISTICS;
    float fECL                              = IntToFloat( GetHitDice( oPC ) );
    float fLevelAdj                         = 0.0;
    float fECL_XP_Penalty                   = fECL;
    float fMultiClass_XP_Penalty            = 0.0;
    float fFinal_XP_Penalty                 = 0.0;

    int nRacialType                         = GetRacialType( oPC );
    string szSubRace                        = GetSubRace( oPC );

    int nRaceInteger                        = GetRaceInteger( nRacialType, szSubRace );

    // Factor custom subrace Level Adjustment into character's Effective Character Level.
    switch( nRaceInteger ){

        // ECL + 1.
        case RACE_TIEFLING:         fECL += 1.0; fLevelAdj = 1.0; break;
        case RACE_AASIMAR:          fECL += 1.0; fLevelAdj = 1.0; break;
        case RACE_OGRILLION:        fECL += 1.0; fLevelAdj = 1.0; break;
        case RACE_FEYTOUCHED:       fECL += 1.0; fLevelAdj = 1.0; break;
        case RACE_FEYRI:            fECL += 1.0; fLevelAdj = 1.0; break;
        case RACE_OROG:             fECL += 1.0; fLevelAdj = 1.0; break;

        // ECL + 2.
        case RACE_DROW:             fECL += 2.0; fLevelAdj = 2.0; break;
        case RACE_SVIRFNEBLIN:      fECL += 2.0; fLevelAdj = 2.0; break;
        case RACE_STRONGHEART_HIN:  fECL += 2.0; fLevelAdj = 2.0; break;

        default:                break;
    }

    // Calculate the ECL penalty to XP (Original hit dice divided by ECL-adjusted hit dice).
    fECL_XP_Penalty /= fECL;


    // Store ECL, Level Adjustment and ECL penalty to XP for future retrieval.

    // ECL.
    SetLocalFloat( oPC, PLAYER_ECL, fECL );
    ECL_STATISTICS.fECL = fECL;
    // Level Adjustment.
    SetLocalFloat( oPC, PLAYER_LVL_ADJ, fLevelAdj );
    ECL_STATISTICS.fLevelAdjustment = fLevelAdj;
    // ECL penalty to XP.
    SetLocalFloat( oPC, PLAYER_XP_PENALTY_ECL, fECL_XP_Penalty );
    ECL_STATISTICS.fXP_Penalty_ECL = fECL_XP_Penalty;


    // Calculate Multiclass and the consequent Final XP penalties.

    fMultiClass_XP_Penalty = GetMultiClassPenalty( oPC );

    fFinal_XP_Penalty = fECL_XP_Penalty * fMultiClass_XP_Penalty;


    // Store Multiclass and Final XP penalties. for future retrieval.

    // Multiclass.
    SetLocalFloat( oPC, PLAYER_XP_PENALTY_MULTICLASS, fMultiClass_XP_Penalty );
    ECL_STATISTICS.fXP_Penalty_Multiclass = fMultiClass_XP_Penalty;
    // Final XP penalty.
    SetLocalFloat( oPC, PLAYER_XP_PENALTY_FINAL, fFinal_XP_Penalty );
    ECL_STATISTICS.fXP_Penalty_Final = fFinal_XP_Penalty;


    // Pass back the Player's Statistics structure to the caller.
    return( ECL_STATISTICS );

}


// This function determines wheather a class type is a customized subrace racial-trait race given its designated Racial System integer.
int GetIsCustomRaceRacialTraitRace( int nRaceInteger ){

    return( nRaceInteger < RACE_GOLD_DWARF ? TRUE : FALSE );

}


// This wrapper automatically distributes the exact XP desired.
void GiveExactXP( object oPC, int nXP, string sTrackingVar="" ){

    // Variables.
    int nCurrXP         = GetXP( oPC );

    // Give exact XP to player.
    SetXP( oPC, nCurrXP + nXP );

    if ( sTrackingVar != "" ){

        object oModule = GetModule();

        sTrackingVar = sTrackingVar+"XP";

        SetLocalInt( oModule, sTrackingVar, GetLocalInt( oModule, sTrackingVar ) + nXP );
    }

    return;
}

// This wrapper automatically subtracts the exact XP desired.
void TakeExactXP( object oPC, int nXP ){

    // Variables.
    int nCurrXP         = GetXP( oPC );

    // Take exact XP from player.
    SetXP( oPC, nCurrXP - nXP );

    return;

}

void GiveCorrectedXP( object oPC, int nXP, string sTrackingVar="", int nCorrectECL=1, int nCorrectFavClass=1 ){

    // Variables.
    int nLevelMatchesXPRatio        = LevelMatchesXPRatio( oPC );
    float fXP;

    // Effective Character Level (ECL)
    float fECL                      = GetLocalFloat( oPC, "CS_ECL" );
    float fFavoredClass_modifier    = GetLocalFloat( oPC, "CS_XP_PENALTY_MULTICLASS" );

    if ( !nLevelMatchesXPRatio ){

        SendMessageToPC( oPC, "- Please level-up before hunting anymore creatures. -" );
        nXP = 1;
    }
    else if ( fECL >= 30.0 ){

        SendMessageToPC( oPC, "You've reached your maximum level. 1 XP awarded instead of "+IntToString( nXP )+" XP." );
        nXP = 1;
    }
    else{

        fXP  = nXP * fFavoredClass_modifier;
        nXP  = FloatToInt( fXP );
    }

    if ( nXP > 0 ){

        SetXP( oPC, GetXP( oPC ) + nXP );
    }

    if ( sTrackingVar != "" ){

        object oModule = GetModule();

        sTrackingVar = sTrackingVar+"XP";

        SetLocalInt( oModule, sTrackingVar, GetLocalInt( oModule, sTrackingVar ) + nXP );
    }
}

// This function determines whether XP should be awarded based on XP to level ratio or half-way into next level.
int LevelMatchesXPRatio( object oPC ){

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

// This function will adjust a character's traits based on Amia requirements.
void ApplyTraits( object oPC ){

    if ( !GetIsPC( oPC ) && !GetIsPossessedFamiliar( oPC ) ){

        SendMessageToPC( oPC, "Subrace traits are only set for PCs" );
        return;
    }

    // Variables.
    object oModule      = GetModule( );
    int nAuthorized     = GetLocalInt( oPC, "subrace_authorized" );
    string szCharName   = GetName( oPC );
    string szGameSpy    = GetPCPlayerName( oPC );
    string szRace       = GetSubRace( oPC );
    int nRacialType     = GetRacialType( oPC );
    int nRace           = GetRaceInteger( nRacialType, szRace );
    int nLevel          = GetHitDice( oPC );
    string szTraitDesc  = "Traits: " + szRace;
    if( szRace == "" )
        szTraitDesc     += GetRaceName( nRace );


    // Specific variables.

    // Racial trait character.
    int nRacialTrait    = GetIsCustomRaceRacialTraitRace( nRace );

    // Red Dragon Disciple.
    int nRDD_rank       = GetLevelByClass( CLASS_TYPE_DRAGON_DISCIPLE, oPC );
    if( nRDD_rank ){
        szTraitDesc    += " | Red Dragon Disciple";
    }

    // Blackguard
    int nBG_rank = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );
    if( nBG_rank ){
        szTraitDesc    += " | Blackguard";
    }

    // Paladin
    int nPala_rank = GetLevelByClass( CLASS_TYPE_PALADIN, oPC );
    if( nPala_rank ){
        szTraitDesc    += " | Paladin";
    }

    // Monk
    int nMonk_rank = GetLevelByClass( CLASS_TYPE_MONK, oPC );
    if( nMonk_rank ){
        szTraitDesc    += " | Monk";
    }

    // Pickpocket rank - This skill is disabled on Amia.
    int nPP_rank        = GetSkillRank( SKILL_PICK_POCKET, oPC, TRUE );
    if( nPP_rank ){
        // Issue Pickpocket tool if the character doesn't have one.
        if( !GetIsObjectValid( GetItemPossessedBy( oPC, PP_TOOL_REF ) ) )
            CreateItemOnObject( PP_TOOL_REF, oPC );
        szTraitDesc    += " | Pickpocket disabled";
    }


    //SendMessageToPC( oPC, szTraitDesc );

    // Apply primary racial traits to the hide as item properties; or as effects.
    switch( nRace ){

        // Duergar :: Imm:Paralysis/Poison/Phantasmal Killer, Move Silently+4, Listen+1, Spot+1.
        case RACE_DUERGAR:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectImmunity( IMMUNITY_TYPE_PARALYSIS ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectImmunity( IMMUNITY_TYPE_POISON ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSpellImmunity( SPELL_PHANTASMAL_KILLER ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_MOVE_SILENTLY, 4 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_LISTEN, 1 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_SPOT, 1 ) ), oPC );
            break;
        }

        // Drow :: SR = 11 + HD, Will save +2.
        case RACE_DROW:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSpellResistanceIncrease( 11 + nLevel ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSavingThrowIncrease( SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_SPELL ) ), oPC );
            break;
        }

        // Aquatic Elf :: Imm: Drown (spells and SL-abilities).
        case RACE_AQUATIC_ELF:{
            // Not authorized, notify the player and online DM's, and don't give them traits.
            /*if( !nAuthorized ){
                SendMessageToPC( oPC, "- You aren't authorized to receive Aquatic Elf traits! -" );
                break;
            }*/
            // Authorized.
            SetLocalInt( oPC, "cs_immunity_drown", TRUE );  // Hack, since Bioware don't provide an interface for it.
            break;
        }

        // Svirfneblin :: NAC+3, +2 uni. saves, Hide +4, SR 11 + CL.
        case RACE_SVIRFNEBLIN:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectACIncrease( 3, AC_DODGE_BONUS ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSavingThrowIncrease( SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_SPELL ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_HIDE, 4 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSpellResistanceIncrease( 11 + nLevel ) ), oPC );
            break;
        }

        // Strongheart Halfling :: DAC+2, Discpline +5.
        case RACE_STRONGHEART_HIN:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectACIncrease( 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_DISCIPLINE, 5 ) ), oPC );
            break;
        }

        // Ghostwise Halfling :: Anim.Emp. +2, Conc. -2, Spot +2.
        case RACE_GHOSTWISE_HIN:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_ANIMAL_EMPATHY, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillDecrease( SKILL_CONCENTRATION, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_SPOT, 2 ) ), oPC );
            break;
        }

        // Faerie :: Hide +8, Taunt +4, Movement +20%.
        case RACE_FAERIE:{
            /*ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_HIDE, 8 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_TAUNT, 4 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectMovementSpeedIncrease( 20 ) ), oPC );
            break;*/
        }

        // Goblin :: Discipline +4, Move Silently +4.
        case RACE_GOBLIN:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_DISCIPLINE, 4 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_MOVE_SILENTLY, 4 ) ), oPC );
            break;
        }

        // Kobold :: Craft Trap +2, Search +2.
        case RACE_KOBOLD:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_CRAFT_TRAP, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_SEARCH, 2 ) ), oPC );
            break;
        }

        // Aasimar :: Listen +2, Spot +2, Resist Cold5,Light5,Fire5.
        case RACE_AASIMAR:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_LISTEN, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_SPOT, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectDamageResistance( DAMAGE_TYPE_COLD, 5 )  ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectDamageResistance( DAMAGE_TYPE_ELECTRICAL, 5 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectDamageResistance( DAMAGE_TYPE_FIRE, 5 ) ), oPC );
            break;
        }

        // Tiefling :: Bluff +2, Hide +2, Resist Acid5,Light5,Fire5.
        case RACE_TIEFLING:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_BLUFF, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_HIDE, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectDamageResistance( DAMAGE_TYPE_ACID, 5 )  ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectDamageResistance( DAMAGE_TYPE_ELECTRICAL, 5 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectDamageResistance( DAMAGE_TYPE_FIRE, 5 ) ), oPC );
            break;
        }

        // Ogrillion :: NAC +2 [Dodge].
        case RACE_OGRILLION:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectACIncrease( 2 ) ), oPC );
            break;
        }

        // Ogrillion :: NAC +2 [Dodge]. Resist Fire & Cold 5, Craft Weapon/Armor +2.
        case RACE_OROG:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectACIncrease( 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectDamageResistance( DAMAGE_TYPE_FIRE, 5 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectDamageResistance( DAMAGE_TYPE_COLD, 5 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_CRAFT_ARMOR, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_CRAFT_WEAPON, 2 ) ), oPC );
            break;
        }

        // New, added 081906.

        // Chultans :: -1 Will Saves.
        case RACE_CHULTAN:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSavingThrowDecrease( SAVING_THROW_WILL, 1 ) ), oPC );
            break;
        }

        // Calishite :: -2 Discipline.
        case RACE_CALISHITE:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillDecrease( SKILL_DISCIPLINE, 2 ) ), oPC );
            break;
        }

        // Ffolk :: +2 to Animal Empathy, Lore.
        case RACE_FFOLK:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_ANIMAL_EMPATHY, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_LORE, 2 ) ), oPC );
            break;
        }

        // Snow Elf :: Resist Cold5.
        case RACE_SNOW_ELF:{
            // Not authorized, notify the player and online DM's, and don't give them traits.
            /*if( !nAuthorized ){
                SendMessageToPC( oPC, "- You aren't authorized to receive Snow Elf traits! -" );

                break;
            }
            // Authorized.
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectDamageResistance( DAMAGE_TYPE_COLD, 5 ) ), oPC );
            break;*/
        }

        // Feyri (Daemonfey) :: +2 to Bluff, Hide; Resist Fire10.
        case RACE_FEYRI:{
            // Not authorized, notify the player and online DM's, and don't give them traits.
            /*if( !nAuthorized ){
                SendMessageToPC( oPC, "- You aren't authorized to receive Daemonfey traits! -" );

                break;
            }
            // Authorized.
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_BLUFF, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_HIDE, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectDamageResistance( DAMAGE_TYPE_FIRE, 10 ) ), oPC );
            break;*/
        }

        // Feytouched :: +4 Will Saving Throw.
        case RACE_FEYTOUCHED:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSavingThrowIncrease( SAVING_THROW_WILL, 4 ) ), oPC );
            break;
        }

        // Shadow Elf :: +4 to Hide and Move Silently; Permanent Ultravision.
        case RACE_SHADOW_ELF:{

            //SendMessageToPC( oPC, "Shadow Elf: Refreshing Racial Traits." );

            // Not authorized, notify the player and online DM's, and don't give them traits.
            /*if( !nAuthorized ){

                SendMessageToPC( oPC, "- You aren't authorized to receive Shadow Elf traits! -" );

                break;
            }

            //wrong race name
            if ( GetStringLowerCase( szRace ) == "shadow" ){

                SetSubRace( oPC, "Shadow Elf" );
                SendMessageToPC( oPC, "Updating subrace field to Shadow Elf" );
            }


            // Authorized.
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_HIDE, 4 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_MOVE_SILENTLY, 4 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectUltravision( ) ), oPC );      // Perma. Ultravision.
            break;*/
        }

        // Elfling :: +2 Will Saving Throw; 5% Movement Speed Decrease; +2 to Hide, Move Silently, Search and Spot.
        case RACE_ELFLING:{

            // Not authorized, notify the player and online DM's, and don't give them traits.
            /*if( !nAuthorized ){
                SendMessageToPC( oPC, "- You aren't authorized to receive Elfling traits! -" );

                break;
            }
            // Authorized.
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSavingThrowIncrease( SAVING_THROW_WILL, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_HIDE, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_MOVE_SILENTLY, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_SEARCH, 2 ) ), oPC );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_SPOT, 2 ) ), oPC );
            break;*/
        }

        // Hobgoblin :: +4 Move Silently.
        case RACE_HOBGOBLIN:{
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillIncrease( SKILL_MOVE_SILENTLY, 4 ) ), oPC );
            break;
        }

        default:
            break;

    }


    //Fix for overcapping monk AC, blackguard saves and palasaves

    //Pala gets their cha to saves at level 1
    if( nPala_rank > 0 ){

        int nCha = GetAbilityModifier( ABILITY_CHARISMA, oPC );
        int nMod = nCha - nPala_rank;
        if( nMod > 0 ){

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSavingThrowDecrease( SAVING_THROW_ALL, nMod ) ), oPC );
        }
    }

    //Bg gets their cha to saves at level 2
    if( nBG_rank >= 2 ){

        int nCha = GetAbilityModifier( ABILITY_CHARISMA, oPC );
        int nMod = nCha - nBG_rank;
        if( nMod > 0 ){

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSavingThrowDecrease( SAVING_THROW_ALL, nMod ) ), oPC );
        }
    }

    //Monk gets their wis to ac at level 3 as per Amian standard
    if( nMonk_rank >= 3 ){

        int nWis = GetAbilityModifier( ABILITY_WISDOM, oPC );
        int nMod = nWis - nMonk_rank;
        if( nMod > 0 ){

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectACDecrease( nMod, AC_NATURAL_BONUS ) ), oPC );
        }

    }

    // Pickpocket disabling: Decrease by the exact number of ranks + 20 to disable it.
    if ( nPP_rank && !GetLocalInt( oPC, "is_DM" ) ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectSkillDecrease( SKILL_PICK_POCKET, 50 ) ), oPC );
    }

    return;
}
