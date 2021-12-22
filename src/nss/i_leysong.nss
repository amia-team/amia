// Custom song: LeySong
//
// An item that, when activated teleports the caster to its "home" ley
// spending 1 bard song use.
//
//
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2015/12/14 BasicHuman       Initial Release.
//

#include "x2_inc_switches"
#include "x0_i0_match"
#include "inc_ds_records"

void LesserLeyRecall( object oPC );

void main()
{
    object oPC;
    int nEvent = GetUserDefinedItemEventNumber();
    switch(nEvent)
    {
        case X2_ITEM_EVENT_ACTIVATE:
            oPC = GetItemActivator();
            object oItem = GetItemActivated();
            if(GetHasFeat(FEAT_BARD_SONGS, oPC))
            {
                DecrementRemainingFeatUses(oPC,FEAT_BARD_SONGS);
                if(GetHasFeat(FEAT_BARD_SONGS, oPC))
                {
                    DecrementRemainingFeatUses(oPC,FEAT_BARD_SONGS);
                    LesserLeyRecall(oPC);
                    return;
                }
                else
                {
                    IncrementRemainingFeatUses(oPC,FEAT_BARD_SONGS);
                }
            }
            SendMessageToPC(oPC, "Not enough Bard Song uses left.");
            break;
    }
}

// Copied from ds_cust_spell, not doing an include as that file has a main()
void LesserLeyRecall( object oPC )
{
    effect eVis = EffectVisualEffect(472);
    //check for hostiles
    object oEnemy = GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC );
    if ( GetIsObjectValid( oEnemy ) && GetDistanceBetween( oPC, oEnemy ) < 20.0 ){

        SendMessageToPC( oPC, "Your cowardly portal fails to materialise because hostiles are nearby." );
        return;
    }

     //go to home location
    object oWP = GetWaypointByTag( GetStartWaypoint( oPC, TRUE ) );

    object oPLC;
    oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_ley_light", GetLocation( oPC ) );
    DestroyObject( oPLC, 4.0 );
    DelayCommand( 2.5, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, GetLocation( oPC ) ) );
    DelayCommand( 3.0, AssignCommand(oPC, JumpToObject( oWP )) );
}

