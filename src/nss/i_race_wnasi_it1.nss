// Water Genasi: Icestorm Spell-like Ability
// Rewritten 01292011 by PaladinOfSune, now it actually behaves like Ice Storm...
//
// Date         Name        Reason
// 2012-05-22   Glim        Fix so that casting this counts as a hostile act to
//                          remove any Invisibility effects from the caster.
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x0_i0_spells"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
//makes sure the effects have the right creator
void ActivateRaceToy( object oPC, location lTarget );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch ( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // vars
            object  oPC       = GetItemActivator();
            location lTarget  = GetItemActivatedTargetLocation();

            AssignCommand( oPC, ActivateRaceToy( oPC, lTarget ) );

            break;
        }

        default:{

            break;
        }
    }

    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void ActivateRaceToy( object oPC, location lTarget ) {

    // Declare major variables.
    int nDamage, nDamage2, nDamage3;
    float fDelay;
    effect eExplode     = EffectVisualEffect( VFX_FNF_ICESTORM ); //USE THE ICESTORM FNF
    effect eVis         = EffectVisualEffect( VFX_IMP_FROST_S );
    effect eDam,eDam2, eDam3;
    int iInvis = GetHasSpellEffect(SPELL_INVISIBILITY, oPC);
    int iImpInvis = GetHasSpellEffect(SPELL_IMPROVED_INVISIBILITY, oPC);
    int iInvisSphere = GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oPC);

    int nCasterLevel    = GetHitDice( oPC );

    if ( nCasterLevel > 20 ) {
        nCasterLevel = 20; // PoS - cap damage at level 20, not 5
    }

    int nVariable       = nCasterLevel / 3;

    //Apply the ice storm VFX at the location captured above.
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eExplode, lTarget );

    //Cycle through the targets within the spell shape until an invalid object is captured.
    object oTarget      = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
    while ( GetIsObjectValid( oTarget ) )
    {
        if( !GetIsReactionTypeFriendly( oTarget, oPC ) )
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ICE_STORM));

            fDelay = GetRandomDelay( 0.75, 2.25 );
            //Roll damage for each target
            nDamage = d6( 3 );
            nDamage2 = d6( 2 );
            nDamage3 = d6( nVariable );
            nDamage2 = nDamage2 + nDamage3;
            //Set the damage effect
            eDam = EffectDamage( nDamage, DAMAGE_TYPE_BLUDGEONING );
            eDam2 = EffectDamage( nDamage2, DAMAGE_TYPE_COLD );

            // Apply effects to the currently selected target.
            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget ) );
            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam2, oTarget ) );
            //This visual effect is applied to the target object not the location as above.  This visual effect
            //represents the impact that erupts on the target not on the ground.
            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget ) );
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
    }
}
