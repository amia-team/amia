/*
tha_quests_res

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This is a generic quest solver

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
06-21-2006      disco      Check if the Priest is still in convo with a PC
20071103        Disco      Now uses databased PCKEY functions
2008-03-06      Disco      Updated Alf
2009-03-25      disco      added xp recording
------------------------------------------------
*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "nw_i0_tool"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void tha_reward( object oPC, string sHide, int nReputation );


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main( ){

    //variables
    object oPC          = GetPCSpeaker( );
    string sConvoNPCTag = GetTag( OBJECT_SELF );

    //sometimes an NPC reacts to SpeakString from another NPC
    if( GetIsPC( oPC )  ==  FALSE  ){

        return;
    }

    if ( sConvoNPCTag == "tha_highpriest" ){

        // Give the speaker some gold
        GiveGoldToCreature( oPC, 1000 );
        GiveCorrectedXP( oPC, 1000, "Quest", 0 );
        ds_quest( oPC, "tha_quest1", 2 );

        // Remove items from the player's inventory
        ds_take_item( oPC,"tha_ice" );
        ds_take_item( oPC,"tha_nuts" );
        ds_take_item( oPC,"tha_flour" );

        //adjust reputation
        tha_reputation( oPC,1 );

        UpdateModuleVariable( "QuestGold", 1000 );
    }
    else if ( sConvoNPCTag == "tha_vinni" ){

        // Give the speaker some gold
        GiveGoldToCreature( oPC, 1000 );
        GiveCorrectedXP( oPC, 1000, "Quest", 0 );
        ds_quest( oPC, "tha_quest2", 2 );

        // Remove items from the player's inventory
        ds_take_item( oPC,"tha_bread" );

        //adjust reputation
        tha_reputation( oPC,1 );

        UpdateModuleVariable( "QuestGold", 1000 );
    }
     //Thykkvi Monastery
     else if ( sConvoNPCTag == "tha_thorghir" ){

        // Give the speaker some gold & XP
        GiveGoldToCreature( oPC, 1000 );
        GiveCorrectedXP( oPC, 1000, "Quest", 0 );
        ds_quest( oPC, "tha_quest3", 2 );

        // Remove items from the player's inventory
        ds_take_item( oPC, "tha_book" );

        //adjust reputation
        tha_reputation( oPC, 1 );

        UpdateModuleVariable( "QuestGold", 1000 );
    }
    //Dragon Lair
     else if ( sConvoNPCTag == "tha_dragon" ){

      // Give the speaker some gold & XP
        GiveGoldToCreature( oPC, 1000 );
        GiveCorrectedXP( oPC, 1000, "Quest", 0 );
        ds_quest( oPC, "tha_quest4", 2 );

        // Remove items from the player's inventory. There's two copies of the book around.
        if (HasItem( oPC, "HowIlearendtobeanArchMageovernig" )) {
            ds_take_item( oPC, "HowIlearendtobeanArchMageovernig" );
        }
        else{
            ds_take_item( oPC,"archmagibook" );
        }

        UpdateModuleVariable( "QuestGold", 1000 );
    }
    //Howness Gate Street
    else if ( sConvoNPCTag == "tha_hrolf" ){

        if( ds_quest( oPC, "tha_quest5", 0 ) == 3 ){

            int nHasHeart  = ds_take_item( oPC, "tha_heart" );
            int nHasJacket = ds_take_item( oPC, "tha_cloth" );

            if ( !nHasHeart ){       //pun intended

                SpeakString( "You didn't cut out his heart for me?" );
                GiveCorrectedXP( oPC, 1000, "Quest", 0 );
                ds_quest( oPC, "tha_quest5", 5 );
            }
            else if ( nHasJacket ){

                //adjust reputation
                tha_reputation( oPC, 1 );

                SpeakString( "Ohh... my poor boy's jacket... I thank you, stranger." );
                GiveCorrectedXP( oPC, 2000, "Quest", 0 );
                ds_quest( oPC, "tha_quest5", 4 );
            }
            else{

                //adjust reputation
                tha_reputation( oPC, 1 );

                SpeakString( "The deed is done! I thank you, stranger." );
                GiveCorrectedXP( oPC, 1500, "Quest", 0 );
                ds_quest( oPC, "tha_quest5", 5 );
            }
        }
        else{

            SpeakString( "How cruel a game you play, stranger." );
        }
    }
    //Smith
    else if ( sConvoNPCTag == "tha_olaf" ){

        if ( HasItem( oPC, "x2_it_cmat_iron" ) ){

            GiveGoldToCreature( oPC, 50 );
            GiveCorrectedXP( oPC, 25, "Job" );
            ds_take_item( oPC,"x2_it_cmat_iron" );
        }
    }
    //old geezer in Howness West Street
    else if ( sConvoNPCTag == "tha_geezer" ){

        TakeGoldFromCreature(1000, oPC );
        ds_create_item( "tha_map",  oPC,1 );
    }
    //Ostman in the Thirsty Marauder
    else if ( sConvoNPCTag == "tha_ostman" ){

        // only give XP the first round
        if ( GetPCKEYValue( oPC, "tha_quest6" )  == 1 ){

            // Give the speaker some xp
            GiveCorrectedXP( oPC, 1000, "Quest", 0 );

            // Remove items from the player's inventory
            ds_take_item( oPC,"tha_notebook" );

            // Set variables
            ds_quest( oPC, "tha_quest6", 2 );
        }
    }
    //Child, Below the Forgotten ruins
    else if ( sConvoNPCTag == "tha_child" ){

        // Give the speaker some gold
        GiveCorrectedXP( oPC, 1000, "Quest", 0 );

        // Set variables
        ds_quest( oPC, "tha_quest7", 2 );

        //adjust reputation
        tha_reputation( oPC,1 );

        //despawn child
        SpeakString( "I must run!" );
        DestroyObject( OBJECT_SELF, 1.0 );
    }

    //Hide shop money and xp scales with reputation (positive) and level (negative)
    else if ( sConvoNPCTag == "tha_alf" ){

        int nReputation=tha_reputation( oPC, 0 );

        if ( nReputation < 1 ){

            SpeakString( "This is a LOCAL se'vice, for LOCAL people! Come back when I bother to remember yer name." );
        }
        else{

            if( GetHitDice( oPC )< 10 ){

                SpeakString( "Where did you get THAT skin, young one? You ent cheatin' on me, are you?" );
            }
            else{

                SpeakString( "Lemme see what ye got..." );

                object oItem = GetFirstItemInInventory( oPC );
                string sHide;
                string sOre;
                string sMetal;
                int nResult  = FALSE;

                while ( GetIsObjectValid( oItem ) == TRUE ){

                    if ( GetTag( oItem ) == "tha_hide" ){

                        sHide = GetName( oItem );

                        DestroyObject( oItem );

                        DelayCommand( 1.0, tha_reward( oPC, sHide, nReputation ) );
                    }

                    oItem = GetNextItemInInventory( oPC );
                }
            }
        }
    }
    //Amian Traders
    else if ( sConvoNPCTag == "tha_recruiter" ){

        ds_create_item( "tha_tradersuit",  oPC,1 );
        ds_create_item( "tha_pricewatch",  oPC,1 );
        ds_create_item( "tha_horn",  oPC,1 );
        ds_create_item( "tha_trader_papers",  oPC,1 );

        //adjust reputation
        tha_reputation( oPC,1 );
        RemoveJournalQuestEntry( "tha_traders",  oPC, FALSE, FALSE );
        ds_quest( oPC, "tha_traders", 1 );
    }
    //Amian Traders
    else if ( sConvoNPCTag == "tha_trader" ){

        ds_take_item( oPC, "tha_tradersuit" );
        ds_take_item( oPC, "tha_tradertool" );
        ds_take_item( oPC, "tha_trader_papers" );
        ds_take_item( oPC, "tha_tradertool" );

        //adjust reputation
        tha_reputation( oPC,-1 );
        ds_quest( oPC, "tha_traders", 2 );
    }
}

void tha_reward( object oPC, string sHide, int nReputation ){

    int nMod;

    if ( sHide == "Lion Hide" ){

        nMod = 10;
    }
    else if ( sHide == "Bear Hide" ){

        nMod = 20;
    }

    int nXP = nMod + ( 10 * nReputation ) - GetHitDice( oPC  );

    if ( nXP < ( nMod + 10 )  ){ nXP = nMod + 10; };

    int nGold = ( 20 * nReputation ) + d20();

    GiveCorrectedXP( oPC, nXP, "Job" );
    GiveGoldToCreature( oPC, nGold );

    UpdateModuleVariable( "JobGold", nGold );
}
