/*  DC Item :: Song of Amia [ Scroll ] :: OnUse: Unique Power: Target [Self]

    --------
    Verbatim
    --------
    This script will bless you for 15 minutes.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    081506  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

// Includes.
#include "x2_inc_switches"


void main(){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch(nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables.
            object oPC          = GetItemActivator( );
            float fDuration     = 600.0;

            effect eCast        = EffectLinkEffects(
                                    EffectVisualEffect( VFX_FNF_LOS_HOLY_10 ),
                                    EffectVisualEffect( VFX_FNF_PWSTUN ) );

            effect eBless1      = EffectSkillIncrease( SKILL_PERFORM, 3 );
            effect eBless2      = EffectSkillIncrease( SKILL_LORE, 5 );
            effect eBless3      = EffectDamageShield( 1, DAMAGE_BONUS_1, DAMAGE_TYPE_POSITIVE );
            effect eBless4      = EffectConcealment( 15, MISS_CHANCE_TYPE_VS_RANGED );
            effect eBless5      = EffectAbilityIncrease( ABILITY_CHARISMA, 1 );

            effect eVfx1        = EffectVisualEffect( VFX_DUR_AURA_PULSE_MAGENTA_YELLOW );
            effect eVfx2        = EffectVisualEffect( VFX_DUR_BARD_SONG );


            // Apply the initial effects.
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, oPC );

            // Apply the duration effects.
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVfx1, oPC, fDuration );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVfx2, oPC, fDuration );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBless1, oPC, fDuration );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBless2, oPC, fDuration );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBless3, oPC, fDuration );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBless4, oPC, fDuration );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBless5, oPC, fDuration );

            break;

        }

        default:
            break;

    }

    SetExecutedScriptReturnValue( nResult );
    return;

}
