// The Guardsman's Anti-Magic (Summon) Wand: OnUse (Unique Power: Target)

// Includes
#include "x2_inc_switches"

void main(){

    // Variables
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch(nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oVictim=GetItemActivatedTarget();
            object oPC=GetItemActivator();

            // Resolve Victim Status
            if(GetIsPC(oVictim)==FALSE){

                // Notify User of Error
                SendMessageToPC(
                    oPC,
                    "- OOC Error: Target isn't a PC. -");

                break;

            }

            /*  Unsummon Associate  */

            // Summon Spell Creature
            object oAssociate=GetAssociate(
                ASSOCIATE_TYPE_SUMMONED,
                oVictim,
                1);

            if(oAssociate==OBJECT_INVALID){

                // Familiar
                oAssociate=GetAssociate(
                    ASSOCIATE_TYPE_FAMILIAR,
                    oVictim,
                    1);

                if(oAssociate==OBJECT_INVALID){

                    // Animal Companion
                    oAssociate=GetAssociate(
                        ASSOCIATE_TYPE_ANIMALCOMPANION,
                        oVictim,
                        1);

                    if(oAssociate==OBJECT_INVALID){

                        // Dominated Creature
                        oAssociate=GetAssociate(
                            ASSOCIATE_TYPE_DOMINATED,
                            oVictim,
                            1);

                    }

                }

            }

            // Unsummon
            if(oAssociate!=OBJECT_INVALID){

                // Dispelling VFX Candy
                ApplyEffectToObject(
                    DURATION_TYPE_INSTANT,
                    EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION),
                    oAssociate,
                    0.0);

                // Actual Unsummon
                DestroyObject(
                    oAssociate,
                    2.0);

            }

            break;

        }

        default:{

            break;

        }

    }

    // Bug Out
    SetExecutedScriptReturnValue(nResult);

}
