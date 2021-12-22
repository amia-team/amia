/*  Automatic Character Maintenance :: Head :: Next

    --------
    Verbatim
    --------
    Cycles the character's next head appearance.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    042806  kfw         Initial Release
    052507  kfw         Head #29 female elf head added.
  20071209  disco       Fixed female elven heads.
    ----------------------------------------------------------------------------

*/

// Includes
#include "cs_inc_leto"
#include "logger"

void main(){

    // Variables
    object oPC          = GetPCSpeaker( );
    int nHeadAppearance = GetCreatureBodyPart( CREATURE_PART_HEAD, oPC );
    int nGender         = GetGender( oPC );
    int nRacialType     = GetRacialType( oPC );

    // Increment (next) the Head appearance.
    nHeadAppearance++;

    // Female
    if( nGender == GENDER_FEMALE ){

        // Race
        switch( nRacialType ){

            case RACIAL_TYPE_DWARF:     if( nHeadAppearance > 0 && nHeadAppearance < 15 ) break; else nHeadAppearance = 1; break;
            case RACIAL_TYPE_ELF:{
                                    if ( nHeadAppearance > 0 && nHeadAppearance < 42 )
                                        break;
                                    else
                                        nHeadAppearance = 1;
                                    break;
            }
            case RACIAL_TYPE_GNOME:{
                                    if ( nHeadAppearance > 9 && nHeadAppearance < 13 )
                                        nHeadAppearance = 13;
                                    else if(    nHeadAppearance > 16 )
                                        nHeadAppearance = 1;
                                    break;
            }
            case RACIAL_TYPE_HALFELF:
            case RACIAL_TYPE_HUMAN:{
                                    if ( nHeadAppearance > 15 && nHeadAppearance < 28 )
                                        nHeadAppearance = 28;
                                    else if(    nHeadAppearance > 48 && nHeadAppearance < 143 )
                                        nHeadAppearance = 143;
                                    else if(    nHeadAppearance > 143 )
                                        nHeadAppearance = 1;
                                    break;
            }
            case RACIAL_TYPE_HALFLING:  if( nHeadAppearance > 0 && nHeadAppearance < 21 ) break; else nHeadAppearance = 1; break;
            case RACIAL_TYPE_HALFORC:{
                                    if ( nHeadAppearance > 11 && nHeadAppearance < 150 )
                                        nHeadAppearance = 150;
                                    else if(    nHeadAppearance > 150 )
                                        nHeadAppearance = 1;
                                    break;
            }
            default: break;

        }

    }

    // Male
    else{

        // Race
        switch( nRacialType ){

            case RACIAL_TYPE_DWARF:{
                                    if ( nHeadAppearance > 10 && nHeadAppearance < 14 )
                                        nHeadAppearance = 14;
                                    else if(    nHeadAppearance > 25 )
                                        nHeadAppearance = 1;
                                    break;
            }
            case RACIAL_TYPE_ELF:{
                                    if ( nHeadAppearance > 10 && nHeadAppearance < 19 )
                                        nHeadAppearance = 19;
                                    else if(    nHeadAppearance > 42 )
                                        nHeadAppearance = 1;
                                    break;
            }
            case RACIAL_TYPE_GNOME:{
                                    if ( nHeadAppearance > 11 && nHeadAppearance < 14 )
                                        nHeadAppearance = 14;
                                    else if(    nHeadAppearance > 25 && nHeadAppearance < 112 )
                                        nHeadAppearance = 112;
                                    else if(    nHeadAppearance > 120 )
                                        nHeadAppearance = 1;
                                    break;
            }
            case RACIAL_TYPE_HALFELF:
            case RACIAL_TYPE_HUMAN:{
                                    if ( nHeadAppearance > 48 && nHeadAppearance < 124 )
                                        nHeadAppearance = 124;
                                    else if(    nHeadAppearance > 163 )
                                        nHeadAppearance = 1;
                                    break;
            }
            case RACIAL_TYPE_HALFLING:{
                                    if ( nHeadAppearance > 8 && nHeadAppearance < 11 )
                                        nHeadAppearance = 11;
                                    else if(    nHeadAppearance > 25 && nHeadAppearance < 42 )
                                        nHeadAppearance = 42;
                                    else if(    nHeadAppearance > 48 && nHeadAppearance < 124 )
                                        nHeadAppearance = 124;
                                    else if(    nHeadAppearance > 163 )
                                        nHeadAppearance = 1;
                                    break;
            }
            case RACIAL_TYPE_HALFORC:{
                                    if ( nHeadAppearance > 11 && nHeadAppearance < 14 )
                                        nHeadAppearance = 14;
                                    else if(    nHeadAppearance > 32 && nHeadAppearance < 150 )
                                        nHeadAppearance = 150;
                                    else if(    nHeadAppearance > 150 )
                                        nHeadAppearance = 1;
                                    break;
            }
            default: break;

        }

    }

    // Modify the character.
    SetCreatureBodyPart( CREATURE_PART_HEAD, nHeadAppearance, oPC );

    return;

}
