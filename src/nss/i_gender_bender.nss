/////////////////////////////////////////////////////////////////////////////////////////////////
//This changes the gender of the player                                                        //
//                                                                                             //
//created by Frozen-ass                                                                        //
//date: 01-11-2022                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////

#include "cs_inc_leto"
#include "inc_td_appearanc"
#include "x2_inc_switches"
#include "x2_inc_itemprop"


void main(){

    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;
	SendMessageToPC (oPC, debug 0);
    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

			SendMessageToPC (oPC, debug 1);
            object oPC = GetItemActivator();
            int nNewGender = !GetGender(oPC);

							SendMessageToPC (oPC, debug 2);
                            NWNX_Creature_SetGender (oPC, GENDER_FEMALE);
							SendMessageToPC (oPC, debug 13;
                            string genderString = nNewGender == 0 ? "male" : "female";
                            FloatingTextStringOnCreature(( "<c Û >Changed gender to " + genderString + "</c>" ), oPC, FALSE );
         }
    }

