/*  Eyes of Ma'at (Ability Widget for the Chosen of Ma'at)

    --------
    Verbatim
    --------
    1 x Day
    Green eye glow vfx
    +1 Foresight Increase to all Saves
    Immunity to Fear
    Duration: special

    If used for longer than 20 turns the subject is struck Blind for Ten Turns.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    081312  Glim        Initial Release
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"

void EyesMaatOverload( object oCreator, object oPC );


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
            int iToggle = GetLocalInt(oPC, "EyesMaat");
            object oCreator = OBJECT_SELF;

            // Find the appropriate green glowing eyes vfx for the player.

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
            if(iToggle <= 1)
            {
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( EffectVisualEffect( nEyes ) ), oPC, TurnsToSeconds( 20 ) );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( EffectImmunity( IMMUNITY_TYPE_FEAR ) ), oPC, TurnsToSeconds( 20 ) );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( EffectSavingThrowIncrease( SAVING_THROW_ALL, 1) ), oPC, TurnsToSeconds( 20 ) );
                SetLocalInt(oPC, "EyesMaat", 2);
                SetLocalInt(oPC, "EyesMaatDur", 2);

                //And set up a delayed effect for the "you've used this too long" penalty
                DelayCommand( TurnsToSeconds( 20 ), EyesMaatOverload( oCreator, oPC ) );
            }

            // Or remove if necessary
            else if(iToggle = 2)
            {
                effect eLoop = GetFirstEffect( oPC );

                while ( GetIsEffectValid( eLoop ) )
                {
                    if ( GetEffectCreator( eLoop ) == oCreator &&
                        GetEffectSubType( eLoop ) == SUBTYPE_SUPERNATURAL )
                    {
                        RemoveEffect( oPC, eLoop );
                    }
                    eLoop = GetNextEffect( oPC );
                }
                DeleteLocalInt(oPC, "EyesMaat");
                DeleteLocalInt(oPC, "EyesMaatDur");
            }

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;
}


void EyesMaatOverload( object oCreator, object oPC )
{
    int nDur = GetLocalInt( oPC, "EyesMaatDur" );

    if ( nDur == 2 )
    {
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( EffectBlindness() ), oPC, TurnsToSeconds( 10 ) );
        DeleteLocalInt(oPC, "EyesMaat");
        DeleteLocalInt(oPC, "EyesMaatDur");
    }
}
