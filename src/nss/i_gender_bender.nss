/////////////////////////////////////////////////////////////////////////////////////////////////
//This changes the gender of the player                                                        //
//                                                                                             //
//created by Frozen-ass                                                                        //
//date: 01-11-																				   //
//																							   //
// 09--07-2023	- frozen	- Fixed script after nwnx removed the function                     //
/////////////////////////////////////////////////////////////////////////////////////////////////

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

                            SetGender(oPC, nNewGender);
                            string genderString = nNewGender == 0 ? "male" : "female";
                            FloatingTextStringOnCreature(( "<c � >Changed gender to " + genderString + "</c>" ), oPC, FALSE );
         }
    }


