/*  DC Item :: Appearance Morph version 2 :: SetAppearances 24 Hours, Appearance Ref Using Item Integer, Old Ref Stored.

    --------
    Verbatim
    --------
    This script will SetAppearance the character. It uses integers on the item itself to store its current state.
    Version 2 adds a delay and a portrait changer.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062307  kfw         Initial release.
    062407  kfw         Delayed the portrait as well.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"

/* Constants */
const string FIRST_USE              = "cs_first_use";
const string ORIGINAL_APPEARANCE    = "i_ds_customitem2";
const string MORPH_APPEARANCE       = "cs_morph_appearance";
const string CURRENT_APPEARANCE     = "cs_current_appearance";
const string VFX                    = "cs_vfx";
const string DELAY                  = "cs_delay";
const string ORIGINAL_PORTRAIT      = "cs_orig_portraitres";
const string MORPH_PORTRAIT         = "cs_morph_portraitres";
const string CURRENT_PORTRAIT       = "cs_current_portraitres";

void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oMorpher         = GetItemActivated( );
            object oPC              = GetItemActivator( );
            int nVFX                = GetLocalInt( oMorpher, VFX );
            int nFirstUse           = GetLocalInt( oMorpher, FIRST_USE );
            float fDelay            = GetLocalFloat( oMorpher, DELAY );

            // Current appearance.
            int nCurrent            = GetAppearanceType( oPC );
            string sCurrentPort     = GetPortraitResRef( oPC );
            // Original appearance.
            int nOriginal           = GetLocalInt( oMorpher, ORIGINAL_APPEARANCE );
            string sOriginalPort    = GetLocalString( oMorpher, ORIGINAL_PORTRAIT );
            // Morphing appearance.
            int nMorph              = GetLocalInt( oMorpher, MORPH_APPEARANCE );
            string sMorphPort       = GetLocalString( oMorpher, MORPH_PORTRAIT );


            // First use?
            if( !nFirstUse ){
                // Store character's original appearance and portrait resref.
                SetLocalInt( oMorpher, ORIGINAL_APPEARANCE, nCurrent );
                SetLocalString( oMorpher, ORIGINAL_PORTRAIT, sCurrentPort );
                // Sanity.
                SetLocalInt( oMorpher, FIRST_USE, 1 );
                // Integrity.
                ExportSingleCharacter( oPC );
            }

            // Alternate the appearance and portrait resref.
            if( nCurrent == nOriginal || !nFirstUse ){
                nCurrent = nMorph;
                sCurrentPort = sMorphPort;
            }
            else{
                nCurrent = nOriginal;
                sCurrentPort = sOriginalPort;
            }

            // Morph in DELAY seconds time.
            FloatingTextStringOnCreature( "- Morphing in " + IntToString( FloatToInt( fDelay ) ) + " seconds. -", oPC, FALSE );
            DelayCommand( fDelay, SetCreatureAppearanceType( oPC, nCurrent ) );
            DelayCommand( fDelay, SetPortraitResRef( oPC, sCurrentPort ) );
            // Candy
            if ( nVFX ){

                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX ), oPC );
            }

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
