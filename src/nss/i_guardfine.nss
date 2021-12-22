// The Guardsman's Fine OnUse (Unique Power: Target)

// Includes
#include "x2_inc_switches"
#include "amia_include"

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
                    "- OOC Error: Target isn't a PC! -");

                break;

            }

            // Fine timer (May only fine a particular PC once every 10 Minutes)
            if(GetLocalInt(
                oVictim,
                "cs_fined")==1){

                // Nofity User of Time Status
                SendMessageToPC(
                    oPC,
                    "- OOC Error: You may only fine a particular PC once every 10 minutes. -");

                break;

            }
            else{

                // Refresh Fine timer
                DelayCommand(
                    600.0,
                    SetLocalInt(
                        oVictim,
                        "cs_fined",
                        0));

                SetLocalInt(
                    oVictim,
                    "cs_fined",
                    1);

            }

            /*      Fine the Victim 100 GP per Level    */

            int nGP=100*GetHitDice(oPC);

            int nMaxGP=GetGold(oVictim);

            // Fine exceeds Victim's Current GP then Fine is Victim's Current GP
            if(nGP>nMaxGP){

                nGP=nMaxGP;

            }

            // Zero Fine, Inform User and Bug Out
            if(nGP<1){

                SendMessageToPC(
                    oPC,
                    "- Target is pennyless! -");

                break;

            }

            // Fine
            TakeGoldFromCreature(
                nGP,
                oPC,
                TRUE);

            // Notify User and Victim
            SendMessageToAllPCs(
                "- "                                                            +
                GetName(oVictim)                                                +
                " has been fined "                                              +
                IntToString(nGP)                                                +
                " gold pieces, by "                                             +
                GetName(oPC)                                                    +
                ", for breaking the Law! -");

            break;

        }

        default:{

            break;

        }

    }

    // Bug Out
    SetExecutedScriptReturnValue(nResult);

}
