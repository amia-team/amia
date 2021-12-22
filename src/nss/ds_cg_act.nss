/*

    The idea: a PC gets a task which he has to complete within a session.
    One task can be done a week.

    Needed stored vars: week, status ( 0, 1=got quest, 2=spawned, 3=found NPC, 4= NPC to jail, 5=back to Looth, 6 completed, 7 declined, 8 failed )
    Needed local vars: NPC or package name, area resref, type of quest

    Quests: find NPC, find Package in sewers.
    Misdemeanor: NPCs can do: pickpocketing, burglary, arson, assault, theft, robbery.

    Scripting: use en_spawntrigger and chat triggers for spawning.
*/

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_actions"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void DoRoll( object oPC, int nModPC, int nFatal=0 );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){


    object oPC          = OBJECT_SELF;
    object oNPC         = GetLocalObject( oPC, "ds_target" );
    object oItem        = GetItemPossessedBy( oPC, "cg_item" );
    int nQuestStatus    = GetPCKEYValue( oPC, "cg_status" );
    int nQuestType      = GetLocalInt( oPC, "cg_type" );
    int nWeek           = GetPCKEYValue( oPC, "cg_week" );
    int nCurrentWeek    = GetLocalInt( GetModule(), "ds_week" );
    string sName        = GetLocalString( oPC, "cg_name" );
    int nNode           = GetLocalInt( oPC, "ds_node" );


    //this is for the contraband PLC
    if ( GetResRef( oNPC ) == "cg_ds_contraband" ){

        if ( nNode == 1 ){

            SetPCKEYValue( oPC, "cg_status", 5 );
            DestroyObject( GetNearestObjectByTag( "cg_"+GetPCPublicCDKey( oPC, TRUE ) ), 1.0 );
            clean_vars( oPC, 1 );
        }

        return;
    }


    //this part is for the fugitive
    if ( GetResRef( oNPC ) == "cg_ds_criminal" && nQuestStatus > 1 && nQuestStatus < 4 ){

        int nMod;

        if ( nNode == 11 ){

            nMod = ( GetAbilityModifier( ABILITY_STRENGTH ) + GetAbilityModifier( ABILITY_DEXTERITY ) ) / 2;
            DoRoll( oPC, nMod );
        }
        else if ( nNode == 12 ){

            nMod = GetAbilityModifier( ABILITY_CONSTITUTION );
            DoRoll( oPC, nMod );
        }
        else if ( nNode == 13 ){

            nMod = GetBaseAttackBonus( oPC );
            DoRoll( oPC, nMod, 1 );
        }
        else if ( nNode == 15 ){

            nMod = GetAbilityModifier( ABILITY_DEXTERITY );
            DoRoll( oPC, nMod );
        }
        else if ( nNode == 16 ){

            nMod = GetAbilityModifier( ABILITY_STRENGTH );
            DoRoll( oPC, nMod );
        }
        else if ( nNode == 17 ){

            nMod = GetBaseAttackBonus( oPC );
            DoRoll( oPC, nMod, 1 );
        }
        else if ( nNode == 21 ){

            AssignCommand( oNPC, SpeakString( "*escapes*" ) );
            SetPCKEYValue( oPC, "cg_status", 9 );
            DestroyObject( oNPC, 1.0 );
            clean_vars( oPC, 1 );
        }
        else if ( nNode == 22 ){

            AssignCommand( oNPC, SpeakString( "*is taken to jail*" ) );
            SetPCKEYValue( oPC, "cg_status", 4 );

            //jump to jail
            DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( GetWaypointByTag( "cg_jail" ) ) ) );
            DelayCommand( 1.0, AssignCommand( oNPC, JumpToObject( GetWaypointByTag( "cg_jail" ) ) ) );
            clean_vars( oPC, 1 );
        }
        else if ( nNode == 23 ){

            AssignCommand( oNPC, SpeakString( "*drops dead*" ) );
            SetPCKEYValue( oPC, "cg_status", 8 );
            DestroyObject( oNPC, 1.0 );
            clean_vars( oPC, 1 );
        }
        else if ( nNode == 29 ){

            SetPCKEYValue( oPC, "cg_status", 3 );
        }
        else if ( nNode == 30 ){

            SetPCKEYValue( oPC, "cg_status", 9 );
            AssignCommand( oNPC, SpeakString( "Ciao, loser!" ) );
            DestroyObject( oNPC, 1.0 );
            clean_vars( oPC, 1 );
        }

        return;
    }

    //this is for the dungeon master NPC
    if ( GetTag( oNPC ) == "cg_ds_jailer" && nNode == 1 ){

        SetPCKEYValue( oPC, "cg_status", 5 );
        DestroyObject( GetNearestObjectByTag( "cg_"+GetPCPublicCDKey( oPC, TRUE ) ), 1.0 );
        clean_vars( oPC, 1 );

        return;
    }

    //this part is for the corporal
    if ( nNode == 1 ){

        //quest accepted
        //set quest status to 'taken'
        SetPCKEYValue( oPC, "cg_status", 1 );
        SetPCKEYValue( oPC, "cg_week", nCurrentWeek );
    }
    else if ( nNode == 6 ){

        //prisoner has been delivered
        SetPCKEYValue( oPC, "cg_status", 6 );
        DeleteLocalInt( oPC, "cg_type" );
        DeleteLocalString( oPC, "cg_name" );
        DeleteLocalString( oPC, "cg_area" );
        GiveCorrectedXP( oPC, ( 150 * GetHitDice( oPC ) ) / 2, "Quest", 0 );
        GiveGoldToCreature( oPC, ( 100 + nQuestType ) * GetHitDice( oPC ) );
        UpdateModuleVariable( "QuestGold", ( 100 + nQuestType ) * GetHitDice( oPC ) );
    }
    else if ( nNode == 7 ){

        //quest declined
        SetPCKEYValue( oPC, "cg_status", 7 );
        DeleteLocalInt( oPC, "cg_type" );
        DeleteLocalString( oPC, "cg_name" );
        DeleteLocalString( oPC, "cg_area" );
    }
    else if ( nNode == 8 ){

        //loot found
        SetPCKEYValue( oPC, "cg_status", 10 );
        DeleteLocalInt( oPC, "cg_type" );
        DeleteLocalString( oPC, "cg_name" );
        DeleteLocalString( oPC, "cg_area" );
    }
    else if ( nNode == 9 ){

        //loot found
        SetPCKEYValue( oPC, "cg_status", 10 );
        DeleteLocalInt( oPC, "cg_type" );
        DeleteLocalString( oPC, "cg_name" );
        DeleteLocalString( oPC, "cg_area" );
    }
    else if ( nNode == 2 && nQuestStatus == 0 ){

        //didn't start convo
        DeleteLocalInt( oPC, "cg_type" );
        DeleteLocalString( oPC, "cg_name" );
        DeleteLocalString( oPC, "cg_area" );
    }

    clean_vars( oPC, 1 );
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void DoRoll( object oPC, int nModPC, int nFatal=0 ){

    int nRollPC   = 10 + d20();
    int nModNPC   = ( GetHitDice( oPC ) / 3 ) + 10 + d10();

    string sRoll  = IntToString( nModPC ) + " + " + IntToString( nRollPC ) + " vs DC " + IntToString( nModNPC );

    if ( ( nModPC + nRollPC ) >= ( nModNPC + 10 ) && nFatal == 1 ){

        SendMessageToPC( oPC, "FATAL SUCCES! " + sRoll );
        SetLocalInt( oPC, "ds_check_23", 1 );
    }
    else if ( ( nModPC + nRollPC ) >= ( nModNPC ) ){

        SendMessageToPC( oPC, "SUCCES! " + sRoll );
        SetLocalInt( oPC, "ds_check_22", 1 );
    }
    else{

        SendMessageToPC( oPC, "FAILURE! " + sRoll );
        SetLocalInt( oPC, "ds_check_21", 1 );
    }

}

