          // Item event script for the goblin mushroom brew.
//

#include "x2_inc_switches"


void CreateSecondaryEffect( object oTarget )
{
    SetCommandable( FALSE, oTarget );
    DelayCommand( 30.0, SetCommandable(TRUE, oTarget) );
}

void CreatePoisonEffect( object oTarget )
{
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_SLEEP),
        oTarget
    );
    AssignCommand( oTarget, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 15.0) );
    DelayCommand( 0.1, CreateSecondaryEffect(oTarget) );
}

void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );
    object oTarget = GetItemActivatedTarget( );

    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK) );

    if ( FortitudeSave(oTarget, 25, SAVING_THROW_TYPE_POISON, oPC) == 0 ) {
        DelayCommand( 0.1, CreatePoisonEffect(oTarget) );
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
