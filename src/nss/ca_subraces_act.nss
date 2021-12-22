/*  Amia :: Subraces :: Conversation : Activate PC Subrace

    --------
    Verbatim
    --------
    This script activates and gives the designated player's subrace abilities, items and whathaveyou.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    20060821  kfw         Initial release.
    20070310  disco       Added Journal variable
    20071118  Disco       Using inc_ds_records now
    20171011  Paladin     Rewrote to use GetRaceInteger(), added Half-Elf
    ------------------------------------------------------------------
*/

//includes
#include "inc_ds_records"
#include "cs_inc_leto"
#include "cs_inc_xp"



void main( ){

    // Variables.
    object oModule      = GetModule( );
    object oPC          = GetPCSpeaker( );
    int nRace           = GetRaceInteger( GetRacialType( oPC ), GetSubRace( oPC ) );

    // Select the Subrace chosen and activate it.
    switch( nRace ) {

         // Dwarven.
        case RACE_DUERGAR:          {   AddDuergarAbilitiesToBicFile( oPC );                break;   }
        case RACE_GOLD_DWARF:       {   AddGoldDwarfAbilitiesToBicFile( oPC );              break;   }

        // Elven.
        case RACE_SUN_ELF:          {   AddSunElfAbilitiesToBicFile( oPC );                 break;   }
        case RACE_WILD_ELF:         {   AddWildElfAbilitiesToBicFile( oPC );                break;   }
        case RACE_WOOD_ELF:         {   AddWoodElfAbilitiesToBicFile( oPC );                break;   }
        case RACE_DROW:             {   AddDrowAbilitiesToBicFile( oPC );                   break;   }
        case RACE_AQUATIC_ELF:      {   AddAquaticElfAbilitiesToBicFile( oPC );             break;   }
        case RACE_SNOW_ELF:         {   AddSnowElfAbilitiesToBicFile( oPC );                break;   }
        case RACE_FEYRI:            {   AddFeyriAbilitiesToBicFile( oPC );                  break;   }
        case RACE_SHADOW_ELF:       {   AddShadowElfAbilitiesToBicFile( oPC );              break;   }

        // Gnome.
        case RACE_SVIRFNEBLIN:      {   AddSvirfneblinAbilitiesToBicFile( oPC );            break;   }

        // Half-Elf.
        case RACE_HALF_ELF:         {   AddHalfElfAbilitiesToBicFile( oPC );                break;   }
        case RACE_HALF_DROW:        {   AddHalfDrowAbilitiesToBicFile( oPC );               break;   }
        case RACE_ELFLING:          {   AddElflingAbilitiesToBicFile( oPC );                break;   }

        // Hin.
        case RACE_STRONGHEART_HIN:  {   AddStrongheartHalflingAbilitiesToBicFile( oPC );    break;   }
        case RACE_GHOSTWISE_HIN:    {   AddGhostwiseHalflingAbilitiesToBicFile( oPC );      break;   }
        case RACE_FAERIE:           {   AddFaerieAbilitiesToBicFile( oPC );                 break;   }
        case RACE_GOBLIN:           {   AddGoblinAbilitiesToBicFile( oPC );                 break;   }
        case RACE_KOBOLD:           {   AddKoboldAbilitiesToBicFile( oPC );                 break;   }

        // Half-Orc.
        case RACE_HOBGOBLIN:        {   AddHobgoblinAbilitiesToBicFile( oPC );              break;   }
        case RACE_OROG:             {   AddOrogAbilitiesToBicFile( oPC );                   break;   }
        case RACE_OGRILLION:        {   AddOgrillionAbilitiesToBicFile( oPC );              break;   }

        // Human.
        case RACE_CHULTAN:          {   AddChultanAbilitiesToBicFile( oPC );                break;   }
        case RACE_CALISHITE:        {   AddCalishiteAbilitiesToBicFile( oPC );              break;   }
        case RACE_FFOLK:            {   AddFfolkAbilitiesToBicFile( oPC );                  break;   }
        case RACE_SHADOVAR:         {   AddShadovarAbilitiesToBicFile( oPC );               break;   }
        case RACE_DURPARI:          {   AddDurpariAbilitiesToBicFile( oPC );                break;   }
        case RACE_TUIGAN:           {   AddTuiganAbilitiesToBicFile( oPC );                 break;   }
        case RACE_MULAN:            {   AddMulanAbilitiesToBicFile( oPC );                  break;   }
        case RACE_HALRUAAN:         {   AddHalruaanAbilitiesToBicFile( oPC );               break;   }
        case RACE_DAMARAN:          {   AddDamaranAbilitiesToBicFile( oPC );                break;   }

        // Universal, allow any race.
        case RACE_AASIMAR:          {   AddAasimarAbilitiesToBicFile( oPC );                break;   }
        case RACE_TIEFLING:         {   AddTieflingAbilitiesToBicFile( oPC );               break;   }
        case RACE_FEYTOUCHED:       {   AddFeytouchedAbilitiesToBicFile( oPC );             break;   }
        case RACE_AIR_GENASI:       {   AddAirGenasiAbilitiesToBicFile( oPC );              break;   }
        case RACE_EARTH_GENASI:     {   AddEarthGenasiAbilitiesToBicFile( oPC );            break;   }
        case RACE_FIRE_GENASI:      {   AddFireGenasiAbilitiesToBicFile( oPC );             break;   }
        case RACE_WATER_GENASI:     {   AddWaterGenasiAbilitiesToBicFile( oPC );            break;   }

        default:{

            DelayCommand( 0.3, SendMessageToPC( oPC, "- Default or Invalid Race: Your abilities don't need to be activated. -" ) );

            //cleanup subrace field
            SetSubRace( oPC, "" );

            //set variable on PC
            SetLocalInt( oPC, "ds_subrace_activated", 1 );

            ExportSingleCharacter( oPC );

            break;
        }
    }
}

