#include "cs_inc_leto"
#include "inc_td_appearanc"
#include "x2_inc_switches"
#include "x2_inc_itemprop"


void main(){

    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:


            object oPC       = GetItemActivator();{

                int oGender   = GetGender( oPC );

                if(  oGender = 0 )
                    {
                    NWNX_Creature_SetGender ( oPC, 1  );
                    AssignCommand( oPC, SpeakString( "<c Û >Changed gender to female.</c>" ) );
                    }

                else if( oGender = 1 )
                    {
                    NWNX_Creature_SetGender ( oPC, 0  );
                    AssignCommand( oPC, SpeakString( "<c Û >Changed gender to male.</c>" ) );
                    }
                else if( oGender >= 2 )
                    {
                    AssignCommand( oPC, SpeakString( "<cò  >You are neither male or female, contact a dm</c>" ) );
                    }
                }
         }
    }

