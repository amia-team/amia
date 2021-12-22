/*! \file aoe_irraerea.nss
 * \brief Irraere's feather AOE OnEnter event.
 *
 * Each PC that enters this AOE is restored.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 10/09/2004 jpavelch         Initial release.
 // 20050615   jking            Pickpocket
 // 20051210   kfw             Disabled SEI, True Race refresh
 * \endverbatim
 */

#include "pp_utils"
#include "cs_inc_xp"
#include "amia_include"

int GetEffectIsPolyEffect( effect eEffect, object oTarget ){

    int n = GetEffectSpellId( eEffect );
    int nLast = GetLocalInt( oTarget, "LAST_POLY_EFFECT" );

    if( n <= 0 || nLast <= 0 )
        return FALSE;

    return n==nLast;
}

int WhiteListedSpells(int nSpell){

    //KC Charge
    if(nSpell == 897)
        return TRUE;

    return FALSE;
}

//! Restores a PC.
/*!
 * This is a copy of the functionality of the Restore spell.
 * \param oPC PC to be restored.
 */
void RestorePlayer( object oPC )
{


    //Remove extra Age variable from Time Leach, even if no penalties were applied
    DeleteLocalInt( oPC, "AgeDrain" );

    effect eBad = GetFirstEffect( oPC );
    while ( GetIsEffectValid(eBad) ) {

        // Variables.
        int nEffectType = GetEffectType( eBad );

        switch( nEffectType ){

            // Ill effects.
            case EFFECT_TYPE_ABILITY_DECREASE:
            case EFFECT_TYPE_AC_DECREASE:
            case EFFECT_TYPE_ATTACK_DECREASE:
            case EFFECT_TYPE_DAMAGE_DECREASE:
            case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
            case EFFECT_TYPE_SAVING_THROW_DECREASE:
            case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
            case EFFECT_TYPE_SKILL_DECREASE:
            case EFFECT_TYPE_BLINDNESS:
            case EFFECT_TYPE_DEAF:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_NEGATIVELEVEL:{

                //remove if it isn't a custom spell effect
                if(GetName(GetEffectCreator( eBad )) != "ds_norestore" && !GetEffectIsPolyEffect( eBad, oPC ) && !WhiteListedSpells(GetEffectSpellId(eBad)))
                {

                    RemoveEffect( oPC, eBad);
                }

                break;

            }

            default:
                break;

        }

        eBad = GetNextEffect( oPC );
    }

    effect eVisual = EffectVisualEffect( VFX_IMP_RESTORATION );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVisual, oPC );

    // SEI_NOTE: We must reinitialize the subrace traits instead of using
    //           the 'safe' removal function because as of patch 1.30 some
    //           effects are supernatural.
    //Subraces_RespawnSubrace( oPC );   // kfw: disabled SEI

    //racial traits & area effects
    ApplyAreaAndRaceEffects( oPC );

}


//! Script entry point.
/*!
 * The restoration only works on PCs.
 */
void main( )
{
    object oPC = GetEnteringObject( );
    if ( !GetIsPC(oPC) ) return;

    RestorePlayer( oPC );
}
