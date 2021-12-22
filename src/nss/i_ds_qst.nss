//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:
//group:
//used as: item activation script
//date:
//author:


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "amia_include"
#include "inc_ds_qst"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void Hatch( object oPC, object oTarget, object oItem, location lTarget );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);
            location lTarget = GetItemActivatedTargetLocation();


            if ( sItemName == "Spider Eggs" ){

                AssignCommand( oPC, Hatch( oPC, oTarget, oItem, lTarget ) );
            }
            else if ( sItemName == "Snake Statuette" ){

                object oSnake = ds_spawn_critter( oPC, "ds_qst_snake", lTarget );
                DestroyObject( oSnake, 60.0 );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
void Hatch( object oPC, object oTarget, object oItem, location lTarget ){

    int nSpiderLover = 0;

    if ( GetDeity( oPC ) == "Lolth" ){

        nSpiderLover = 1;
    }

    if ( ds_quest( oPC, "ds_quest_14" ) == 1 ){

        if ( nSpiderLover ){

            ds_quest( oPC, "ds_quest_14", 3 );
        }
        else{

            ds_quest( oPC, "ds_quest_14", 2 );
        }
    }

    if ( oTarget != oPC ){

        if ( !nSpiderLover ){

            object oCreature = ds_spawn_critter( oPC, "ds_qst_spider_b", lTarget );

            SendMessageToPC( oPC, "After carrying the egg around for days it hatches. A furious spider emerges that has one thing on his mind: You inside its belly." );
        }
        else{

            effect eSpider = EffectSummonCreature( "ds_qst_spider" );

            ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSpider, lTarget, 600.0 );

            SendMessageToPC( oPC, "After carrying the egg around for days it hatches. A spider emerges and starts following you around." );
        }
    }
    else{

        if ( !nSpiderLover ){

            effect eHeal =  EffectHeal( GetMaxHitPoints( oPC ) / 2 );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oPC );

            SendMessageToPC( oPC, "You create a beautiful omelette out of one of your spider eggs. Eating it makes you feel great!" );
        }
        else{

            effect eKill =  EffectDamage( GetCurrentHitPoints( oPC ) + d6(6), DAMAGE_TYPE_ELECTRICAL );
            effect eVis  = EffectVisualEffect( VFX_IMP_LIGHTNING_M );


            ApplyEffectToObject( DURATION_TYPE_INSTANT, eKill, oPC );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

            SendMessageToPC( oPC, "Lolth is not amused..." );
        }
    }
}







