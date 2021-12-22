// Air Genasi: Gust of Wind Spell-like Ability
// Rewritten 01292011 by PaladinOfSune
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"


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
            object oPC          = GetItemActivator();
            location lTarget    = GetItemActivatedTargetLocation();

            AssignCommand( oPC, ActivateRaceToy( oPC, lTarget ) );

            break;
        }

        default: break;
    }

    SetExecutedScriptReturnValue( nResult );

}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void ActivateRaceToy( object oPC, location lTarget ){

    // Declare major variables.
    string sAOETag;
    float fDelay;
    effect eVFX     = EffectVisualEffect( VFX_FNF_LOS_NORMAL_20 );
    effect eVFX2    = EffectVisualEffect( VFX_IMP_PULSE_WIND );

    // Gust of Wind DC = 10 + HD/2 + CHA mod.
    int nDC        = 10 + GetHitDice( oPC )/2 + GetAbilityModifier( ABILITY_CHARISMA, oPC );

    // Apply the impact visual at the location captured above.
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX, lTarget );

    // Cycle through the targets within the spell shape until an invalid object is captured.
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT );
    while ( GetIsObjectValid( oTarget ) )
    {
        if ( GetObjectType( oTarget ) == OBJECT_TYPE_AREA_OF_EFFECT )
        {
            // Gust of wind should only destroy "cloud/fog like" area of effect spells.
            sAOETag = GetTag( oTarget );
            if ( sAOETag == "VFX_PER_FOGACID" ||
                 sAOETag == "VFX_PER_FOGKILL" ||
                 sAOETag == "VFX_PER_FOGBEWILDERMENT" ||
                 sAOETag == "VFX_PER_FOGSTINK" ||
                 sAOETag == "VFX_PER_FOGFIRE" ||
                 sAOETag == "VFX_PER_FOGMIND" ||
                 sAOETag == "VFX_PER_CREEPING_DOOM" )
            {
                DestroyObject( oTarget );
            }
        }
        else
        if ( !GetIsReactionTypeFriendly( oTarget, oPC ) )
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GUST_OF_WIND));

            // Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations( lTarget, GetLocation( oTarget ) ) / 20;

            // * unlocked doors will reverse their open state
            if ( GetObjectType( oTarget ) == OBJECT_TYPE_DOOR )
            {
                if ( GetLocked( oTarget ) == FALSE)
                {
                    if ( GetIsOpen( oTarget) == FALSE)
                    {
                        AssignCommand( oTarget, ActionOpenDoor( oTarget ) );
                    }
                    else
                        AssignCommand( oTarget, ActionCloseDoor( oTarget ) );
                    }
                }
                if( FortitudeSave( oTarget, nDC, SAVING_THROW_TYPE_SPELL, oPC ) < 1 ){
                {
                    // Apply Knockdown effect.
                    effect eKnockdown = EffectKnockdown();
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds( 3 ) );
                    DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX2, oTarget ) );
                }
            }
        }
       // Select the next target within the spell shape.
       oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT );
    }
}
