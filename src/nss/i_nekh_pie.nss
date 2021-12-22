// Nekhkbet's Pie Creator :: Initializes Pie Baking Conversation

// Includes
#include "x2_inc_switches"

void main(){

    // Variables
    int nEvent          = GetUserDefinedItemEventNumber( );
    int nResult         = X2_EXECUTE_SCRIPT_END;

    // Which event did the Item trigger ?
    switch( nEvent ){

        // Use: Unique Power
        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC = GetItemActivator( );
            string sItemName = GetName(GetItemActivated());

            // Initialize Pie Baking Conversation
            // and set variable on PC to set cookies, pie or sweets generation
            // and set custom tokens
            if(sItemName=="Most Delicious and Irresistable Pies"){

                SetLocalString(oPC,"killyourteethwith","pie");

                SetCustomToken(3951,"Apple Pie");
                SetCustomToken(3952,"Elderberry Pie");
                SetCustomToken(3953,"Safe Haven Sweetberry Pie");
                SetCustomToken(3954,"Mincemeat Pie");
                SetCustomToken(3955,"Fey Meringue Pie");
                SetCustomToken(3956,"Brogenstein Snow Pie");

                AssignCommand( oPC, ActionStartConversation( oPC, "c_nekh_pies", TRUE, FALSE ) );
            }
            else if(sItemName=="The Cookie Mongers"){

                SetLocalString(oPC,"killyourteethwith","cookies");

                SetCustomToken(3951,"Aasimar’s Dream");
                SetCustomToken(3952,"Pirates Of Warftown");
                SetCustomToken(3953,"Crunchy Surfacers");
                SetCustomToken(3954,"Grandma's Surprise");
                SetCustomToken(3955,"Double Chocolate Chip");
                SetCustomToken(3956,"Caramel Fudge");

                AssignCommand( oPC, ActionStartConversation( oPC, "c_nekh_pies", TRUE, FALSE ) );
            }
            else if(sItemName=="The Sweeteners"){

                SetLocalString(oPC,"killyourteethwith","sweet");

                SetCustomToken(3951,"Spun Sugar");
                SetCustomToken(3952,"Candid Apples");
                SetCustomToken(3953,"Almond Candy Jewels");
                SetCustomToken(3954,"Candied Confusion");
                SetCustomToken(3955,"Chocolate Kisses");
                SetCustomToken(3956,"Exploded Corn");

                AssignCommand( oPC, ActionStartConversation( oPC, "c_nekh_pies", TRUE, FALSE ) );
            }
            else if(sItemName=="Jud's Tureen"){

                SetLocalString(oPC,"killyourteethwith","soup");

                SetCustomToken(3951,"Rothe' Stew");
                SetCustomToken(3952,"Venison Stew");
                SetCustomToken(3953,"Spider Stew");
                SetCustomToken(3954,"Umber Hulk Soup");
                SetCustomToken(3955,"Potage d'Pedipalpis");
                SetCustomToken(3956,"Baphitaur Bowl");

                AssignCommand( oPC, ActionStartConversation( oPC, "c_nekh_pies", TRUE, FALSE ) );
            }



            break;

        }

        // Bug out on all other events
        default:
            break;

    }

    SetExecutedScriptReturnValue( nResult );

}
