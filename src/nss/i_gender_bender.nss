#include "cs_inc_leto"
#include "inc_td_appearanc"
#include "x2_inc_switches"
#include "x2_inc_itemprop"


void main(){

    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:


            object oPC = GetItemActivator();
           	int nNewGender = !GetGender(oPC);

				            NWNX_Creature_SetGender(oPC, nNewGender);
				            string genderString = nNewGender == 0 ? "male" : "female";
				            AssignCommand( oPC, SpeakString( "<c Û >Changed gender to " + genderString + "</c>" ) );
         }
    }

