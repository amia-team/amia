/*  The Book of Vile Rituals

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032706  kfw         Initial release.
2007-11-19  disco       Uses PCKEY system now
    ----------------------------------------------------------------------------

    --------
    Verbatim
    --------
    Boosts a blackguard's summon using a variable in the Amia Journal.

*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "x2_inc_switches"

void main( ){

    // Variables
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oBook            = GetItemActivated( );
            object oVictim          = GetItemActivatedTarget( );
            object oPC              = GetItemActivator( );

            if( GetHasFeat( FEAT_EPIC_EPIC_FIEND, oPC ) && GetIsObjectValid( GetPCKEY( oPC ) ) ){

                SendMessageToPC(
                    oPC,
                    "- You carefully study the crusted pages of this delicious tome.." );

                ApplyEffectAtLocation(
                    DURATION_TYPE_INSTANT,
                    EffectVisualEffect( VFX_FNF_LOS_EVIL_30 ),
                    GetLocation( oPC ) );

                SetPCKEYValue( oPC, "cs_bgd_booster", 1 );

            }
            else{

                ApplyEffectToObject(
                    DURATION_TYPE_INSTANT,
                    EffectLinkEffects(
                        EffectDamage( 999, DAMAGE_TYPE_DIVINE ),
                        EffectVisualEffect( VFX_IMP_SUNSTRIKE ) ),
                    oPC );

                DestroyObject( oBook, 0.1 );

                SendMessageToPC(
                    oPC,
                    "- Your soul is drawn into the pages~!" );

            }

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

}
