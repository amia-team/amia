/*  Glowing Eyes [Flame Red]

    --------
    Verbatim
    --------
    Any player with this item will get green glowing eyes.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    042806  kfw         Initial Release.
    082306  kfw         Bugfix: Wasn't re-applying through relogs.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"


void main( ){

    // Variables
    int nEvent          = GetUserDefinedItemEventNumber( );
    int nResult         = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC  = GetItemActivator( );
            int nGender = GetGender( oPC );
            int nRace   = GetRacialType( oPC );
            int nEyes   = VFX_NONE;

            // Toggle the appropriate green glowing eyes vfx on the player.
            // Female
            if( nGender == GENDER_FEMALE ){

                switch( nRace ){

                    case RACIAL_TYPE_DWARF:     nEyes = VFX_EYES_GREEN_DWARF_FEMALE;    break;
                    case RACIAL_TYPE_ELF:       nEyes = VFX_EYES_GREEN_ELF_FEMALE;      break;
                    case RACIAL_TYPE_GNOME:     nEyes = VFX_EYES_GREEN_GNOME_FEMALE;    break;
                    case RACIAL_TYPE_HALFELF:   nEyes = VFX_EYES_GREEN_HALFELF_FEMALE;  break;
                    case RACIAL_TYPE_HALFLING:  nEyes = VFX_EYES_GREEN_HALFLING_FEMALE; break;
                    case RACIAL_TYPE_HALFORC:   nEyes = VFX_EYES_GREEN_HALFORC_FEMALE;  break;
                    case RACIAL_TYPE_HUMAN:     nEyes = VFX_EYES_GREEN_HUMAN_FEMALE;    break;

                    default: break;

                }

            }

            // Male
            else{

                switch( nRace ){

                    case RACIAL_TYPE_DWARF:     nEyes = VFX_EYES_GREEN_DWARF_MALE;      break;
                    case RACIAL_TYPE_ELF:       nEyes = VFX_EYES_GREEN_ELF_MALE;        break;
                    case RACIAL_TYPE_GNOME:     nEyes = VFX_EYES_GREEN_GNOME_MALE;      break;
                    case RACIAL_TYPE_HALFELF:   nEyes = VFX_EYES_GREEN_HALFELF_MALE;    break;
                    case RACIAL_TYPE_HALFLING:  nEyes = VFX_EYES_GREEN_HALFLING_MALE;   break;
                    case RACIAL_TYPE_HALFORC:   nEyes = VFX_EYES_GREEN_HALFORC_MALE;    break;
                    case RACIAL_TYPE_HUMAN:     nEyes = VFX_EYES_GREEN_HUMAN_MALE;      break;

                    default: break;

                }

            }

            // Verify Eye VFX status and apply if necessary.
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                SupernaturalEffect( EffectVisualEffect( nEyes ) ),
                oPC );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
