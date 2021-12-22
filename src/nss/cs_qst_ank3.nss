//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  cs_qst_ankh3
//group:   quest
//used as: Ankhremun's Quest, rewarded
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// updates
//-------------------------------------------------------------------------------
//20071103        Disco      Now uses databased PCKEY functions


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    // vars
    object oPC          = GetPCSpeaker();
    object oItem        = GetItemPossessedBy( oPC, "cs_anhkring1" );

    if ( !GetIsObjectValid( oItem ) ){

        return;
    }

    // resolve taken status
    ds_quest( oPC, "ds_quest_19", 3 );

    //destroy ring
    DestroyObject( oItem );

    // reward the player
    GiveCorrectedXP( oPC, 2000, "Quest", 0 );

    int nFirstClass     = GetClassByPosition( 1, oPC );

    string szRing       = "cs_ring_pring";

    // Unique ring based on first Class-type
    switch(nFirstClass){

        case CLASS_TYPE_FIGHTER:
        case CLASS_TYPE_BARBARIAN:
        case CLASS_TYPE_PALADIN:{

            szRing+="1";
            break;
        }

        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SORCERER:{

            szRing+="2";
            break;
        }

        case CLASS_TYPE_ROGUE:
        case CLASS_TYPE_RANGER:{

            szRing+="3";
            break;
        }

        case CLASS_TYPE_WIZARD:{

            szRing+="4";
            break;
        }

        default:{

            szRing+="5";
            break;
        }
    }

    // Reward Unique-Class Ring
    CreateItemOnObject( szRing, oPC, 1 );

    return;

}
