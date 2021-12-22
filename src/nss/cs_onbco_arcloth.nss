//::///////////////////////////////////////////////
//:: Associate: End of Combat End
//:: NW_CH_AC3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
#include "X0_INC_HENAI"
#include "X2_inc_spellhook"
void main()
{

    object oFoe = GetAttemptedAttackTarget( );
    if( !GetIsObjectValid( oFoe ) )
        oFoe = GetAttemptedSpellTarget( );

    // Flee melee.
    if( GetIsObjectValid( oFoe )                        &&
        GetIsEnemy( oFoe )                              &&
        GetDistanceBetween( oFoe, OBJECT_SELF ) < 20.0 ){

        ApplyEffectToObject(
            DURATION_TYPE_TEMPORARY,
            EffectLinkEffects(
                EffectFrightened( ),
                EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR ) ),
            OBJECT_SELF,
            6.0 );

        return;

    }

    // Re-equip xbow
    if( GetTag( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND ) ) != "cs_mrepxbow1" ){

        object oXbow = GetFirstItemInInventory( );

        while( GetIsObjectValid( oXbow ) ){

            if( GetTag( oXbow ) == "cs_mrepxbow1" ){

                AssignCommand( OBJECT_SELF, ActionEquipItem( oXbow, INVENTORY_SLOT_RIGHTHAND ) );

                break;

            }

            oXbow = GetNextItemInInventory( );

        }

    }

    if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
       HenchmenCombatRound(OBJECT_INVALID);
    }


    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1003));
    }

    // Check if concentration is required to maintain this creature
    X2DoBreakConcentrationCheck();
}

