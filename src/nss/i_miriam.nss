/*  Miriam :: DC Item :: Random Male Morpher

    --------
    Verbatim
    --------
    This script will SetAppearance Miriam's character as a random male, or convert
    her back to her original form.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062206  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"

/* Constants */
const string FIRST_USE              = "cs_first_use";
const string ORIGINAL_APPEARANCE    = "cs_original_appearance";
const string CURRENT_APPEARANCE     = "cs_current_appearance";
const string VFX                    = "cs_vfx";

void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oMorpher     = GetItemActivated( );
            object oPC          = GetItemActivator( );
            int nVFX            = GetLocalInt( oMorpher, VFX );
            int nFirstUse       = GetLocalInt( oMorpher, FIRST_USE );

            // Current appearance.
            int nCurrent        = GetAppearanceType( oPC );
            // Original appearance.
            int nOriginal       = GetLocalInt( oMorpher, ORIGINAL_APPEARANCE );
            // Morphing appearance.
            int nMorph          = 0;
            switch( d4( ) ){
                case    1:      nMorph = APPEARANCE_TYPE_MALE_01;   break;
                case    2:      nMorph = APPEARANCE_TYPE_MALE_02;   break;
                case    3:      nMorph = APPEARANCE_TYPE_MALE_03;   break;
                case    4:      nMorph = APPEARANCE_TYPE_MALE_04;   break;
                default:        nMorph = APPEARANCE_TYPE_MALE_05;   break;
            }


            // First use?
            if( !nFirstUse ){
                // Store character's original appearance.
                SetLocalInt( oMorpher, ORIGINAL_APPEARANCE, nCurrent );
                // Sanity.
                SetLocalInt( oMorpher, FIRST_USE, 1 );
                // Integrity.
                ExportSingleCharacter( oPC );
            }

            // Alternate appearances.
            if( nCurrent == nOriginal || !nFirstUse )
                nCurrent = nMorph;
            else
                nCurrent = nOriginal;

            // Morph.
            SetCreatureAppearanceType( oPC, nCurrent );
            // Candy
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX ), oPC );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
