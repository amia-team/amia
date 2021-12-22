//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  afr_gib_reward
//group:   quest
//used as: Gibbering Maw Quest, rewarded
//date:    12/19/12
//author:  Glim

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
    int nClass;

    // resolve taken status
    ds_quest( oPC, "ds_quest_34", 5 );

    // reward the player
    int nFirstClass     = GetLevelByPosition( 1, oPC );
    int nSecondClass    = GetLevelByPosition( 2, oPC );
    int nThirdClass     = GetLevelByPosition( 3, oPC );

    //check which is the highest level class
    if( nFirstClass > nSecondClass && nFirstClass > nThirdClass )
    {
        nClass = GetClassByPosition( 1, oPC );
    }
    else if( nSecondClass > nFirstClass && nSecondClass > nThirdClass )
    {
        nClass = GetClassByPosition( 2, oPC );
    }
    else if( nThirdClass > nFirstClass && nThirdClass > nSecondClass )
    {
        nClass = GetClassByPosition( 3, oPC );
    }
    else if( nFirstClass == nSecondClass && nSecondClass == nThirdClass )
    {
        nClass = GetClassByPosition( 1, oPC );
    }
    else if( nFirstClass == nSecondClass )
    {
        nClass = GetClassByPosition( 1, oPC );
    }
    else
    {
        //debug
        AssignCommand( oPC, SpeakString( "Debug Message: Unclear Class Type, Report This Message" ) );
        SendMessageToPC( oPC, "Debug Message: Unclear Class Type, Report This Message" );
    }

    string szBracer       = "gib_rewardbrace";

    // Unique Bracer based on highest level Class-type
    switch(nClass){

        case CLASS_TYPE_FIGHTER:
        case CLASS_TYPE_BARBARIAN:
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_DIVINE_CHAMPION:
        case CLASS_TYPE_DWARVEN_DEFENDER:
        case CLASS_TYPE_PURPLE_DRAGON_KNIGHT:
        case CLASS_TYPE_SHIFTER:
        case CLASS_TYPE_WEAPON_MASTER:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_MONK:
        case CLASS_TYPE_DRAGON_DISCIPLE:{

            szBracer+="1";
            break;
        }

        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SORCERER:{

            szBracer+="2";
            break;
        }

        case CLASS_TYPE_ROGUE:
        case CLASS_TYPE_ARCANE_ARCHER:
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_HARPER:
        case CLASS_TYPE_SHADOWDANCER:{

            szBracer+="3";
            break;
        }

        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_PALE_MASTER:{

            szBracer+="4";
            break;
        }

        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:{

            szBracer+="5";
            break;
        }

        default:{

            szBracer+="6";
            break;
        }
    }

    // Reward Unique-Class Bracer
    //debug check for unaccounted for class layout
    if( szBracer != "gib_rewardbrace6" )
    {
        CreateItemOnObject( szBracer, oPC, 1 );
    }

    return;

}
