/*  Item :: Oliritari Vines :: OnUse: Unique Power: Target [AoE]

    --------
    Verbatim
    --------
    This script will create powerful vines to AoE constrict enemies of the Arch-Druid within his domain.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080506  kfw         Initial release.
    081906  kfw         Bug fix.
    082406  kfw         Bleh, another bug fix, this item's cursed!
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "x2_inc_switches"
#include "amia_include"
#include "x2_inc_itemprop"
#include "x2_i0_spells"

void main(){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch(nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            location lOrigin    = GetLocation( oPC );

            // Candy.
            ApplyEffectAtLocation(
                DURATION_TYPE_TEMPORARY,
                EffectAreaOfEffect( AOE_PER_ENTANGLE, "****", "****", "****" ),
                lOrigin,
                6.0 );

            ApplyEffectAtLocation(
                DURATION_TYPE_TEMPORARY,
                EffectAreaOfEffect( AOE_PER_EVARDS_BLACK_TENTACLES, "****", "****", "****" ),
                lOrigin,
                6.0 );

            ApplyEffectAtLocation(
                DURATION_TYPE_INSTANT,
                EffectVisualEffect( VFX_FNF_SCREEN_SHAKE ),
                lOrigin );

            // Cycle all foes of the Arch-Druid within 40-feet.
            object oVictim      = GetFirstObjectInShape( SHAPE_SPHERE, 40.0, lOrigin );

            while( GetIsObjectValid( oVictim ) ){

                // Variables.
                int nEnemy      = GetIsEnemy( oVictim, oPC );
                int nWoodStride = GetHasFeat( FEAT_WOODLAND_STRIDE, oVictim );
                int nFreedom    = GetHasSpellEffect( SPELL_FREEDOM_OF_MOVEMENT, oVictim );
                int nSelf       = oVictim != oPC ? TRUE : FALSE;

                // Victim isn't the Arch-Druid, doesn't have Woodland Stride feat or Freedom, and is an enemy of the Arch-Druid.
                if( nEnemy && !nWoodStride && !nFreedom && !nSelf ){


                    // Roll Reflex DC 35.
                    if( ReflexSave( oVictim, 35, SAVING_THROW_TYPE_SPELL, oPC ) == 0 ){

                        // Contrict.
                        ApplyEffectToObject(
                            DURATION_TYPE_INSTANT,
                            EffectDamage( GetCurrentHitPoints( oVictim ) + 10 ),
                            oVictim );
                        // Candy.
                        ApplyEffectToObject(
                            DURATION_TYPE_INSTANT,
                            EffectLinkEffects(
                                EffectVisualEffect( VFX_COM_BLOOD_CRT_RED ),
                                EffectVisualEffect( VFX_IMP_ACID_S ) ),
                            oVictim );

                    }

                }

                oVictim         = GetNextObjectInShape( SHAPE_SPHERE, 40.0, lOrigin );

            }

            break;

        }

        default:
            break;

    }

    SetExecutedScriptReturnValue( nResult );
    return;

}
