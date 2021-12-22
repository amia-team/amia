// The Guardsman's Nightstick OnUse (Unique Power: Target)

// Includes
#include "x2_inc_switches"
#include "inc_ds_records"

void main(){

    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_EQUIP: {

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
        }

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oVictim=GetItemActivatedTarget();
            object oPC=GetItemActivator();
            string szNightstickMessage_User="- You swing your Nightstick and it cracks against your target's skull with a dull thud. -";
            string szNightstickMessage_Victim;

            // Resolve Victim Status
            if(GetIsPC(oVictim)==FALSE){

                // Notify User of Error
                SendMessageToPC(
                    oPC,
                    "- OOC Error: Target isn't a PC. -");

                break;

            }

            // Fortitude Save: Fail -> Unsummon associates AND Stun for 5 Turns
            if(FortitudeSave(
                oVictim,
                30,
                SAVING_THROW_TYPE_LAW,
                oPC)<1){

                // Victim Notification
                szNightstickMessage_Victim="- A Guardsman's Nightstick cracks against your skull with a dull thud, your vision goes blurry and your knees feel like jelly. -";

                // Stun
                ApplyEffectToObject(
                    DURATION_TYPE_TEMPORARY,
                    EffectLinkEffects(
                        EffectLinkEffects(
                            EffectCutsceneDominated(),
                            EffectVisualEffect(300)),
                        EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED)),
                    oVictim,
                    TurnsToSeconds(5));

            }
            else{

                // Victim Notification
                szNightstickMessage_Victim="- A Guardsman's Nightstick cracks against your skull with a dull thud but you maintain your composure, but only just. -";

            }

            // Notify User and Victim
            SendMessageToPC(
                oPC,
                szNightstickMessage_User);

            SendMessageToPC(
                oVictim,
                szNightstickMessage_Victim);

            break;

        }

        default:{

            break;

        }

    }

    // Bug Out
    SetExecutedScriptReturnValue(nResult);

}
