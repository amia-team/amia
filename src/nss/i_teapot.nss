// Luna's Teapot : Grants the user a +5 Concentration Boost
//obsolete

// Includes
#include "x2_inc_switches"
#include "amia_include"

void main(){

    int nEvent  =   GetUserDefinedItemEventNumber();
    int nResult =   X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            // vars
            object oPC                  =   GetItemActivator();
            effect eTeaVFX              =   EffectVisualEffect( VFX_IMP_PULSE_HOLY );
            effect eConcentrationBoost  =   EffectSkillIncrease( SKILL_CONCENTRATION, 5 );
            effect eTea                 =   EffectLinkEffects(
                                                eTeaVFX,
                                                eConcentrationBoost);
            string szTeaSoundAnim       =   "as_mg_frstmagic1";


            // Apply Concentration boost
            if( GetIsObjectValid( oPC ) ){

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTea, oPC, NewHoursToSeconds( 1 ) );

                AssignCommand( oPC, PlaySound( szTeaSoundAnim ) );

                SendMessageToPC( oPC, "- You take a sip of tea and it perks you up! -" );

            }

            break;

        }

        default:{

            break;

        }

    }

    SetExecutedScriptReturnValue(nResult);

}
