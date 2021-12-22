/*  Automatic Character Maintenance :: Head :: Previous

    --------
    Verbatim
    --------
    Cycles the character's previous head appearance.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    042806  kfw         Initial Release
    052507  kfw         Head #29 female elf head added.
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

    // Decrement (previous) the Head appearance.
    nHeadAppearance--;

    // Female
    if( nGender == GENDER_FEMALE ){

        // Race
        switch( nRacialType ){

            case RACIAL_TYPE_DWARF:     if( nHeadAppearance > 0 && nHeadAppearance < 15 ) break; else nHeadAppearance = 15; break;
            case RACIAL_TYPE_ELF:{
                                    if(         nHeadAppearance > 0 && nHeadAppearance < 21 )
                                        break;
                                    else if(    nHeadAppearance == 29 )
                                        nHeadAppearance = 20;
                                    else
                                        nHeadAppearance = 29;
                                    break;
            }
            case RACIAL_TYPE_GNOME:{
                                    if( nHeadAppearance < 1 )
                                        nHeadAppearance = 16;
                                    else if( nHeadAppearance > 9 && nHeadAppearance < 13 )
                                        nHeadAppearance = 9;
                                    else if( nHeadAppearance > 16 )
                                        nHeadAppearance = 16;
                                    break;
            }
            case RACIAL_TYPE_HALFELF:
            case RACIAL_TYPE_HUMAN:{
                                    if( nHeadAppearance < 1 )
                                        nHeadAppearance = 143;
                                    else if( nHeadAppearance > 15 && nHeadAppearance < 28 )
                                        nHeadAppearance = 15;
                                    else if( nHeadAppearance > 48 && nHeadAppearance < 143 )
                                        nHeadAppearance = 48;
                                    else if( nHeadAppearance > 143 )
                                        nHeadAppearance = 143;
                                    break;
            }
            case RACIAL_TYPE_HALFLING:  if( nHeadAppearance > 0 && nHeadAppearance < 21 ) break; else nHeadAppearance = 21; break;
            case RACIAL_TYPE_HALFORC:{
                                    if( nHeadAppearance < 1 )
                                        nHeadAppearance = 150;
                                    else if( nHeadAppearance > 11 && nHeadAppearance < 150 )
                                        nHeadAppearance = 11;
                                    else if( nHeadAppearance > 150 )
                                        nHeadAppearance = 150;
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
                                    if( nHeadAppearance < 1 )
                                        nHeadAppearance = 25;
                                    else if( nHeadAppearance > 10 && nHeadAppearance < 14 )
                                        nHeadAppearance = 10;
                                    else if( nHeadAppearance > 25 )
                                        nHeadAppearance = 25;
                                    break;
            }
            case RACIAL_TYPE_ELF:{
                                    if( nHeadAppearance < 1 )
                                        nHeadAppearance = 42;
                                    else if( nHeadAppearance > 42 )
                                        nHeadAppearance = 42;
                                    break;
            }
            case RACIAL_TYPE_GNOME:{
                                    if( nHeadAppearance < 1 )
                                        nHeadAppearance = 120;
                                    else if( nHeadAppearance > 11 && nHeadAppearance < 14 )
                                        nHeadAppearance = 11;
                                    else if( nHeadAppearance > 25 && nHeadAppearance < 112 )
                                        nHeadAppearance = 25;
                                    else if( nHeadAppearance > 120 )
                                        nHeadAppearance = 120;
                                    break;
            }
            case RACIAL_TYPE_HALFELF:
            case RACIAL_TYPE_HUMAN:{
                                    if( nHeadAppearance < 1 )
                                        nHeadAppearance = 163;
                                    else if( nHeadAppearance > 48 && nHeadAppearance < 124 )
                                        nHeadAppearance = 48;
                                    else if( nHeadAppearance > 163 )
                                        nHeadAppearance = 163;
                                    break;
            }
            case RACIAL_TYPE_HALFLING:{
                                    if( nHeadAppearance < 1 )
                                        nHeadAppearance = 112;
                                    else if( nHeadAppearance > 8 && nHeadAppearance < 11 )
                                        nHeadAppearance = 8;
                                    else if( nHeadAppearance > 25 && nHeadAppearance < 42 )
                                        nHeadAppearance = 25;
                                    else if( nHeadAppearance > 45 && nHeadAppearance < 112 )
                                        nHeadAppearance = 45;
                                    else if( nHeadAppearance > 112 )
                                        nHeadAppearance = 112;
                                    break;
            }
            case RACIAL_TYPE_HALFORC:{
                                    if( nHeadAppearance < 1 )
                                        nHeadAppearance = 150;
                                    else if( nHeadAppearance > 11 && nHeadAppearance < 14 )
                                        nHeadAppearance = 11;
                                    else if( nHeadAppearance > 32 && nHeadAppearance < 150 )
                                        nHeadAppearance = 32;
                                    else if( nHeadAppearance > 150 )
                                        nHeadAppearance = 150;
                                    break;
            }
            default: break;

        }

    }

    // Modify the character.
    SetCreatureBodyPart( CREATURE_PART_HEAD, nHeadAppearance, oPC );

    return;

}
