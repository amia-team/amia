/*  DC Item :: Arcane Sight :: OnUse: Unique Power: Target [Self]

    --------
    Verbatim
    --------
    This script will give the following boost (and penalties) for 2 hours:
        o   +10 Lore
        o   +10 Spellcraft
        o   -5 Search
        o   -5 Spot

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    081506  kfw         Initial release.
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

            effect eBoost       = EffectLinkEffects(
                                    EffectSkillIncrease( SKILL_LORE, 10 ),
                                    EffectSkillIncrease( SKILL_SPELLCRAFT, 10 ) );
            eBoost              = EffectLinkEffects(
                                    eBoost,
                                    EffectSkillDecrease( SKILL_SEARCH, 5 ) );

            eBoost              = EffectLinkEffects(
                                    eBoost,
                                    EffectSkillDecrease( SKILL_SPOT, 5 ) );

            effect eVFX         = EffectVisualEffect( VFX_IMP_MAGICAL_VISION );
            effect eVFX2        = EffectVisualEffect( VFX_DUR_MAGICAL_SIGHT );


            // Apply visual impact.
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oPC );

            // Apply boost.
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBoost, oPC, NewHoursToSeconds( 2 ) );

            // Apply boost visual.
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX2, oPC, NewHoursToSeconds( 2 ) );

            break;

        }

        default:
            break;

    }

    SetExecutedScriptReturnValue( nResult );
    return;

}
