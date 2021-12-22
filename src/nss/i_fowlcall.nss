// Egg of the Fowl Caller item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/20/2004 jpavelch         Initial Release
// 12/20/2004 jpavelch         Changed spawned chicken to one with a custom
//                             faction to prevent PC reputation change with
//                             commoner faction.
//

#include "x2_inc_switches"


// Creates a chicken at the target location or destroys a targetted chicken.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );
    object oTarget = GetItemActivatedTarget( );
    location lTarget = GetItemActivatedTargetLocation( );

    if ( GetIsObjectValid(oTarget) && GetLocalInt(oTarget, "AR_FowlCall") ) {
        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE),
            GetLocation(oTarget)
        );
        DestroyObject( oTarget, 0.5 );
    } else {
        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1),
            lTarget
        );
        object oChicken =   CreateObject(
                                OBJECT_TYPE_CREATURE,
                                "am_chicken",
                                lTarget,
                                TRUE
                            );
        SetLocalInt( oChicken, "AR_FowlCall", TRUE );
        AssignCommand( oChicken, ActionForceFollowObject(oPC, 3.0) );
    }
}


void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
