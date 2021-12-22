//::///////////////////////////////////////////////
//:: glm_jelly_ondeth
//:://////////////////////////////////////////////
/*
    OnDeath script for any jelly or pudding
    type creatures.If the critter is a clone from
    the split function, skip loot, xp and gold.
*/
//:://////////////////////////////////////////////
//:: Created By: Glim
//:: Created On: 03/20/13
//:://////////////////////////////////////////////


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "inc_ds_qst"
#include "ds_ai2_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter         = OBJECT_SELF;
    object oKiller          = GetLastKiller();

    //if it's a split version of a creature, give nothing
    if( GetTag( oCritter ) == "split_clone" )
    {
        return;
    }

    //else if it's the original, give loot/xp/gp as normal
    if( GetLastKiller() != OBJECT_SELF && GetLocalInt( oCritter, L_ISDEAD ) != 1 ){

        //check if it's a quest kill and run ds_qst_ondeath instead if true
        if( GetLocalInt( OBJECT_SELF, "q_id" ) != 0 )
        {
            int nNextState = qst_check( oKiller );
            qst_resolve_party( oKiller, nNextState );
        }

        // Set have died once, stops giving out multiple amounts of XP.
        SetLocalInt( oCritter, L_ISDEAD, 1 );

        // Reward XP.
        int nXPResult = RewardXPForKill( );

        // Generate treasure.
        GenerateLoot( oCritter, nXPResult );
    }
}
