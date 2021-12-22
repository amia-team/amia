//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_ds_qst
//group:   quests
//used as: library
//date:    apr 02 2008
//author:  disco

// 2009-10-05   disco   expanded qst_check()


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "nw_i0_plot"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//checks the current state of the quest
//returns the next state (for ds_check_) or -1
// if nQuest=0 the quest of oNPC will be checked, no need to say which quest.
// use nQuest to check the status of a specific quest on oPC. In this case oNPC will be ignored.
int qst_check( object oPC, object oNPC=OBJECT_SELF, int nQuest=0 );

//moves the quest one step forward if possible
//you can also set a quest manually by using nQuest and nValue. In this case oNPC will be ignored.
int qst_update( object oPC, object oNPC=OBJECT_SELF, int nQuest=0, int nValue=0 );

//checks if LocalInt or LocalString sVariable is set to the corresponding value
void qst_resolve_party( object oPC, int nNextState, object oNPC=OBJECT_SELF );

//checks for class based rewards and returns item resref to give to PC
string glm_qst_classrwrd( object oPC, object oNPC, string sVariable );

/*
Each journalled quest has a q_id, and a state (1,2,..n).
The conditions and actions are triggered by the current state of the quest.
The local vars are created by prefixing the expected state with "q_" and adding the action.

You can also use this system for simple "give item, get gold" type of 'quests'.
To do this, set q_id to 0 and use 0 for the quest state. These quests won't be tracked.

------------------------------------------------------------------------------
FLAGS
------------------------------------------------------------------------------
Every NPC/PLC dealing with the quest needs to know which quest it's dealing with
q_id         = 11

First you need to make sure which steps of the quest the NPC/PLC reacts to.
This example NPC deals with 3 steps (1=giving the quest, 2=waiting for results, 3=getting results)
Each step gets his own set of ds_check_ and ds_action_ convo scripts.
Set the flag to 1 if the NPC just needs to do a dialog. This ignores all checks and actions.
Set the flag to 2 if the quests status needs to be updated
q_1          = 2
q_2          = 1
q_3          = 2

You can restrict the quest to a certain alignment with this flag
Only restrict the first step, or an align change will block the whole quest
q_1_alignm   = nIndex (1 = G, 2 = N, 3 = E, 4 = G+N, 5 = N+E )
q_1_gender   = nIndex (1 = M, 2 = F )

You can define a needed item for each step. This will be taken as well.
My example PC takes 50 gp when you start the quest, and an item on completion
q_1_take_gp  = 50
q_3_take_it  = it_quest11

On completion the PC gets a hug, a big sword, and 2000 GP + XP.
The NPC also gives you comments throughout the quest (in this case you actually don't need a convo)
q_3_give_it  = it_big_sword
q_3_give_it  = 3 (this is an INT! and sets the number of stack items)
q_3_give_gp  = 2000
q_3_give_xp  = 2000
q_3_emote    = *gives you a hug*

Messages are given throughout the quest. These are the only flags used if q_1 = 1.
q_1_message  = Get me flowers!
q_2_message  = Where are my flowers?
q_3_message  = Flowers! What a surprise?!
*/

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int qst_check( object oPC, object oNPC=OBJECT_SELF, int nQuest=0 ){

    if ( nQuest != 0 ){

        return ds_quest( oPC, "ds_quest_"+IntToString( nQuest ) );
    }

    string sQuest       = "ds_quest_"+IntToString( GetLocalInt( oNPC, "q_id" ) );
    int nCurrentState   = ds_quest( oPC, sQuest );
    int nNextState      = nCurrentState + 1;
    string sVariable    = "q_"+IntToString( nNextState );
    int nAction         = GetLocalInt( oNPC, sVariable );
    string sMessage     = GetLocalString( oNPC, sVariable+"_message" );
    string sCritter     = GetLocalString( oNPC, sVariable+"_spawn" );

// scan for waypoint called 'ds_qst_spawn' nearest to PC at which to spawn

    object oWaypoint = GetNearestObjectByTag( "ds_qst_spawn", oPC );

//spawn creature

    if ( sCritter != "" ){

            ds_spawn_critter_void( oPC, sCritter, GetLocation( oWaypoint ) );
        }

    if ( sMessage != "" ){

        if ( GetObjectType( oNPC ) == OBJECT_TYPE_CREATURE ){

            AssignCommand( oNPC, ActionSpeakString( sMessage ) );
        }
        else{

            FloatingTextStringOnCreature( sMessage, oPC );
        }
    }

    if ( nAction == 1 ){

        //SendMessageToPC( oPC, "[<cþ  >Unfinished quest: check your journal.</c>]" );

        return nNextState;
    }
    else if ( nAction == 2 ){

       //check for item
        string sResRef   = GetLocalString( oNPC, sVariable+"_take_it" );

        if ( sResRef != "" && !HasItem( oPC, sResRef ) ){

            SendMessageToPC( oPC, "[<cþ  >You need a certain item for this quest.</c>]" );
            return -1;
        }

        //check for gold
        int nGold = GetLocalInt( oNPC, sVariable+"_take_gp" );

        if ( nGold > 0 && GetGold( oPC ) < nGold ){

            SendMessageToPC( oPC, "[<cþ  >You need "+IntToString( nGold )+" gold for this quest.</c>]" );
            return -1;
        }

        //check for alignment
        int nGender = GetLocalInt( oNPC, sVariable+"_gender" );

        if ( nGender == 1 && GetGender( oPC ) != GENDER_MALE ){

            SendMessageToPC( oPC, "[<cþ  >Only males can do this quest.</c>]" );
            return -1;
        }
        else if ( nGender == 2 && GetGender( oPC ) != GENDER_FEMALE ){

            SendMessageToPC( oPC, "[<cþ  >Only females can do this quest.</c>]" );
            return -1;
        }

        //check for alignment
        int nAlignm = GetLocalInt( oNPC, sVariable+"_alignm" );

        if ( nAlignm == 1 && GetAlignmentGoodEvil( oPC ) != ALIGNMENT_GOOD ){

            SendMessageToPC( oPC, "[<cþ  >You don't have the right alignment for this quest.</c>]" );
            return -1;
        }
        else if ( nAlignm == 2 && GetAlignmentGoodEvil( oPC ) != ALIGNMENT_NEUTRAL ){

            SendMessageToPC( oPC, "[<cþ  >You don't have the right alignment for this quest.</c>]" );
            return -1;
        }
        else if ( nAlignm == 3 && GetAlignmentGoodEvil( oPC ) != ALIGNMENT_EVIL ){

            SendMessageToPC( oPC, "[<cþ  >You don't have the right alignment for this quest.</c>]" );
            return -1;
        }
        else if ( nAlignm == 4 && GetAlignmentGoodEvil( oPC ) == ALIGNMENT_EVIL ){

            SendMessageToPC( oPC, "[<cþ  >You don't have the right alignment for this quest.</c>]" );
            return -1;
        }
        else if ( nAlignm == 5 && GetAlignmentGoodEvil( oPC ) == ALIGNMENT_GOOD ){

            SendMessageToPC( oPC, "[<cþ  >You don't have the right alignment for this quest.</c>]" );
            return -1;
        }

        return nNextState;
    }

    return -1;
}

int qst_update( object oPC, object oNPC=OBJECT_SELF, int nQuest=0, int nValue=0 ){


    if ( nQuest != 0 && nValue != 0 ){

        return ds_quest( oPC, "ds_quest_"+IntToString( nQuest ), nValue );
    }

    string sQuest        = "ds_quest_"+IntToString( GetLocalInt( oNPC, "q_id" ) );
    int nCurrentState    = ds_quest( oPC, sQuest );
    int nNextState       = nCurrentState + 1;
    string sVariable     = "q_"+IntToString( nNextState );
    int nResult          = 0;
    object oItem;
    string szItem;

    if ( GetLocalInt( oNPC, sVariable ) == 2 ){


        //check for item
        string sResRef   = GetLocalString( oNPC, sVariable+"_take_it" );

        if ( sResRef != "" ){

            oItem = GetItemPossessedBy( oPC, GetLocalString( oNPC, sVariable+"_take_it" ) );

            if ( GetIsObjectValid( oItem ) ){

                nResult = 1;
            }
            else{

                SendMessageToPC( oPC, "[<cþ  >You need a certain item for this quest.</c>]" );
                return FALSE;
            }
        }

        //check for gold
        int nGold = GetLocalInt( oNPC, sVariable+"_take_gp" );

        if ( nGold > 0 ){

            if ( nGold <= GetGold( oPC ) ){

                nResult += 2;
            }
            else{

                SendMessageToPC( oPC, "[<cþ  >You need "+IntToString( nGold )+" gold for this quest.</c>]" );
                return FALSE;
            }
        }

        //We only take the item and gold if we know both conditions are TRUE
        if ( nResult == 1 || nResult == 3 ){

            DestroyObject( oItem );
        }

        if ( nResult == 2 || nResult == 3 ){

            TakeGoldFromCreature( nGold, oPC, TRUE );
        }

        //give gold & XP
        GiveGoldToCreature( oPC, GetLocalInt( oNPC, sVariable+"_give_gp" ) );
        ///GiveCorrectedXP( oPC, GetLocalInt( oNPC, sVariable+"_give_xp" ), "Quest", 0 );
        GiveXPToCreature( oPC, GetLocalInt( oNPC, sVariable+"_give_xp" ) );
        //give class-based reward items
        if( GetLocalString( oNPC, sVariable+"_it_base" ) != "" )
        {
            szItem = glm_qst_classrwrd( oPC, oNPC, sVariable );
            if( szItem != "" )
            {
                CreateItemOnObject( szItem, oPC, 1 );
            }
        }

        //UpdateModuleVariable( "QuestGold", GetLocalInt( oNPC, sVariable+"_give_gp" ) );

        int nStack = GetLocalInt( oNPC, sVariable+"_give_it" );

        if ( nStack > 1 ){

            CreateItemOnObject( GetLocalString( oNPC, sVariable+"_give_it" ), oPC, nStack );
        }
        else{

            CreateItemOnObject( GetLocalString( oNPC, sVariable+"_give_it" ), oPC );
        }

        string sEmote   = GetLocalString( oNPC, sVariable+"_emote" );

        if ( sEmote != "" ){

            FloatingTextStringOnCreature( sEmote, oPC );
        }

         //update state
        ds_quest( oPC, sQuest, nNextState );

        return TRUE;
    }

    return FALSE;
}


//performs qst_check and qst_update on a whole party
//only use this in drop scripts
void qst_resolve_party( object oPC, int nNextState, object oNPC=OBJECT_SELF ){

    // Get the first PC party member
    object oPartyMember = GetFirstFactionMember( oPC );
    object oTriggerer = GetLocalObject( OBJECT_SELF, "Triggerer" );
    int nResult;

    // We stop when there are no more valid PC's in the party.
    while ( GetIsObjectValid( oPartyMember ) == TRUE ){

        if ( GetArea( oPC ) == GetArea( oPartyMember ) ){

            if( oPartyMember != oTriggerer )
            {
                nNextState = qst_check( oPartyMember, oNPC );
            }

            if ( nNextState > 0 ){

                qst_update( oPartyMember );
            }
        }

        oPartyMember = GetNextFactionMember( oPC );
    }
}

string glm_qst_classrwrd( object oPC, object oNPC, string sVariable )
{
    object oKey         = GetPCKEY( oPC );
    int nFirstClass     = GetLevelByPosition( 1, oPC );
    int nSecondClass    = GetLevelByPosition( 2, oPC );
    int nThirdClass     = GetLevelByPosition( 3, oPC );
    int nClass;

    string szItem = GetLocalString( oNPC, sVariable+"_it_base" );
    int nCategory = GetLocalInt( oNPC, sVariable+"_it_cat" );

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
        return "";
    }

    // Ability Stat reward based on highest level Class-type
    if( nCategory == 1 )
    {
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

                szItem+="1";
                break;
            }

            case CLASS_TYPE_BARD:
            case CLASS_TYPE_SORCERER:{

                szItem+="2";
                break;
            }

            case CLASS_TYPE_ROGUE:
            case CLASS_TYPE_ARCANE_ARCHER:
            case CLASS_TYPE_ASSASSIN:
            case CLASS_TYPE_HARPER:
            case CLASS_TYPE_SHADOWDANCER:{

                szItem+="3";
                break;
            }

            case CLASS_TYPE_WIZARD:
            case CLASS_TYPE_PALE_MASTER:{

                szItem+="4";
                break;
            }

            case CLASS_TYPE_CLERIC:
            case CLASS_TYPE_DRUID:{

                szItem+="5";
                break;
            }

            default:{

                szItem+="6";
                break;
            }
        }
    }
    else if( nCategory == 2 )
    {
        switch( nClass )
        {
            case CLASS_TYPE_BARD:
            case CLASS_TYPE_MONK:
            case CLASS_TYPE_ROGUE:
            case CLASS_TYPE_SORCERER:
            case CLASS_TYPE_WIZARD:
            case CLASS_TYPE_ASSASSIN:
            case CLASS_TYPE_HARPER:
            case CLASS_TYPE_SHADOWDANCER:
            {
                szItem+="7";
                break;
            }

            case CLASS_TYPE_CLERIC:
            case CLASS_TYPE_DRUID:
            case CLASS_TYPE_PALADIN:
            case CLASS_TYPE_BLACKGUARD:
            case CLASS_TYPE_DWARVEN_DEFENDER:
            case CLASS_TYPE_PALE_MASTER:
            case CLASS_TYPE_DRAGON_DISCIPLE:
            {
                szItem+="8";
                break;
            }

            case CLASS_TYPE_BARBARIAN:
            case CLASS_TYPE_FIGHTER:
            case CLASS_TYPE_RANGER:
            case CLASS_TYPE_ARCANE_ARCHER:
            case CLASS_TYPE_DIVINE_CHAMPION:
            case CLASS_TYPE_PURPLE_DRAGON_KNIGHT:
            case CLASS_TYPE_SHIFTER:
            case CLASS_TYPE_WEAPON_MASTER:
            {
                szItem+="9";
                break;
            }

            default:
            {
                szItem+="6";
                break;
            }
        }
    }

    return szItem;
}
