// Creature ability: Darkness

// Includes
#include "x2_inc_switches"
#include "NW_I0_SPELLS"
void main(){

    // Variables
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC=GetItemActivator();

            // Trigger Darkness spellscript with override duration set
            SetLocalInt(  oPC, "darkduration", GetHitDice(oPC) );
            // Owner has to see in her own darkness!
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectUltravision(), oPC, RoundsToSeconds(GetHitDice(oPC)));
            // Initialize Darkness
            AssignCommand( oPC, ActionCastSpellAtLocation( SPELL_DARKNESS, GetItemActivatedTargetLocation(), METAMAGIC_NONE, TRUE,
            PROJECTILE_PATH_TYPE_DEFAULT, TRUE ) );

            break;

        }

        default:{

            break;

        }

    }

    SetExecutedScriptReturnValue(nResult);

}


