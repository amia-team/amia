/*  The Book of Vile Darkness

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032706  kfw         Initial release.
    ----------------------------------------------------------------------------

    --------
    Verbatim
    --------
    Summons forth a deliciously powerful fiend for the player.

*/

/* Includes */
#include "x2_inc_switches"
#include "x2_inc_toollib"

void main( ){

    // Variables
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oBook            = GetItemActivated( );
            object oPC              = GetItemActivator( );
            object oArea            = GetArea( oPC );
            int nAlignment          = GetAlignmentGoodEvil( oPC );
            location lOrigin        = GetLocation( oPC );

            if( nAlignment == ALIGNMENT_EVIL                        &&
                WillSave( oPC, 15, SAVING_THROW_TYPE_EVIL, oBook )  ){

                SendMessageToPC(
                    oPC,
                    "- You carefully study the cursed pages of this delicious tome.. -" );

                TLVFXPillar(
                    VFX_IMP_DEATH_L,
                    lOrigin,
                    4,
                    0.0f,
                    6.0f );

                ExecuteScript( "cs_vile_darkness", oPC );

            }
            else{

                ApplyEffectToObject(
                    DURATION_TYPE_INSTANT,
                    EffectLinkEffects(
                        EffectDamage( 999, DAMAGE_TYPE_DIVINE ),
                        EffectVisualEffect( VFX_IMP_SUNSTRIKE ) ),
                    oPC );

                SendMessageToPC(
                    oPC,
                    "- Your soul is drawn into the pages~! -" );

            }

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

}
