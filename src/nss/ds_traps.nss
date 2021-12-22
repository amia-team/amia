//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_traps
//group:   dungeon stuff
//used as: OnEnter script in traps
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "NW_I0_SPELLS"
#include "amia_include"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
void main(){

    if ( GetIsBlocked( OBJECT_SELF ) > 0 ){

        return;
    }

    SetBlockTime( );

    object oPC          = GetEnteringObject();
    location lPC        = GetLocation( oPC );
    object oTarget;
    string sTag         = GetTag( OBJECT_SELF );
    int nDamage1;
    int nDamage2;

    if ( sTag == "ds_pit" ){

        effect eDamage   = EffectDamage( ( GetCurrentHitPoints( oPC ) / 2 ), DAMAGE_TYPE_BLUDGEONING  );
        object oWaypoint = GetWaypointByTag( "sc_glins_drop" );

        if( MySavingThrow( SAVING_THROW_REFLEX, oPC, 32, SAVING_THROW_TYPE_TRAP ) ){

            AssignCommand( oTarget, SpeakString( "*almost falls from the bridge*" ) );
        }
        else{

            AssignCommand( oPC, ClearAllActions(TRUE) );
            AssignCommand( oPC, SpeakString( "Aaaaargh!  *falls from bridge*" ) );
            AssignCommand( oPC, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC  ) );
            AssignCommand( oPC, PlayAnimation( ANIMATION_LOOPING_DEAD_BACK, 1.0, 60.0  ) );
            AssignCommand( oPC, JumpToObject( oWaypoint, 0 ) );
        }
    }
        if ( sTag == "ds_blackmoore" ){

        effect eDamage   = EffectDamage( ( GetCurrentHitPoints( oPC ) / 2 ) + 20, DAMAGE_TYPE_BLUDGEONING  );
        object oWaypoint = GetWaypointByTag( "car_bkw" );

        if( MySavingThrow( SAVING_THROW_REFLEX, oPC, 40, SAVING_THROW_TYPE_TRAP ) == 1) {

            AssignCommand( oTarget, SpeakString( "*You almost fall while climbing up!*" ) );
        }
        else{

            AssignCommand( oPC, ClearAllActions(TRUE) );
            AssignCommand( oPC, SpeakString( "Aaaaargh!  *You slip and fall off the wall*" ) );
            AssignCommand( oPC, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC  ) );
            AssignCommand( oPC, PlayAnimation( ANIMATION_LOOPING_DEAD_BACK, 1.0, 60.0  ) );
            AssignCommand( oPC, JumpToObject( oWaypoint, 0 ) );
        }
    }
    if ( sTag == "car_tbl_pit" ){

        effect eDamage   = EffectDamage( ( GetCurrentHitPoints( oPC ) / 2 ) + 20, DAMAGE_TYPE_BLUDGEONING  );
        object oWaypoint = GetWaypointByTag( "car_tbl_pit" );

        if( MySavingThrow( SAVING_THROW_REFLEX, oPC, 40, SAVING_THROW_TYPE_TRAP ) == 1) {

            AssignCommand( oTarget, SpeakString( "*You almost slipped and fell back into the pit!*" ) );
        }
        else{

            AssignCommand( oPC, ClearAllActions(TRUE) );
            AssignCommand( oPC, SpeakString( "Aaaaargh!  *You slip and fall into the pit*" ) );
            AssignCommand( oPC, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC  ) );
            AssignCommand( oPC, PlayAnimation( ANIMATION_LOOPING_DEAD_BACK, 1.0, 60.0  ) );
            AssignCommand( oPC, JumpToObject( oWaypoint, 0 ) );
        }
    }
    else if ( sTag == "ds_boulder" ){


        effect eDam1;
        effect eDam2;
        effect eVis   = EffectVisualEffect( VFX_FNF_METEOR_SWARM );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

        oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC );

        //Cycle through the targets within the spell shape until an invalid object is captured.
        while ( GetIsObjectValid( oTarget ) ){

           if ( GetIsPC( oTarget ) ||
                GetIsPossessedFamiliar( oTarget ) ||
                GetIsObjectValid( GetMaster( oTarget ) ) ){

                nDamage1  = d10( 6 );
                nDamage2  = d10( 6 );

                if( MySavingThrow( SAVING_THROW_REFLEX, oPC, 24, SAVING_THROW_TYPE_TRAP ) ){

                    AssignCommand( oTarget, SpeakString( "*dodges most of the falling stones*" ) );
                    AssignCommand( oTarget, PlayAnimation( ANIMATION_FIREFORGET_DODGE_SIDE ) );
                    nDamage1  = d10( 3 );
                    nDamage2  = d10( 3 );
                }
                else{

                    AssignCommand( oTarget, SpeakString( "*is knocked to the ground*" ) );
                    AssignCommand( oTarget, PlayAnimation( ANIMATION_LOOPING_DEAD_BACK, 1.0, 60.0  ) );
                }

                eDam1  = EffectDamage( nDamage1, DAMAGE_TYPE_BLUDGEONING );
                eDam2  = EffectDamage( nDamage2, DAMAGE_TYPE_FIRE );

                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam1, oTarget );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam2, oTarget );
           }

           //Select the next target within the spell shape.
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC );
        }
    }
    else if ( sTag == "ds_vs_good" ){

        int nDamage      = GetGoodEvilValue( oPC );

        if ( nDamage > 15 ){

            if( MySavingThrow( d3(), oPC, 33, SAVING_THROW_TYPE_TRAP ) ){

                nDamage      = nDamage / 2;
            }

            effect eDamage   = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE  );
            effect eVis      = EffectVisualEffect( VFX_IMP_EVIL_HELP );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
        }

    }
    else if ( sTag == "ds_vs_evil" ){

        int nDamage      = 100 - GetGoodEvilValue( oPC );

        if ( nDamage > 15 ){

            if( MySavingThrow( d3(), oPC, 33, SAVING_THROW_TYPE_TRAP ) ){

                nDamage      = nDamage / 2;
            }

            effect eDamage   = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE  );
            effect eVis      = EffectVisualEffect( VFX_IMP_EVIL_HELP );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
        }
    }
    else if ( sTag == "jump" ){

        oTarget = GetWaypointByTag( GetName( OBJECT_SELF ) );

        AssignCommand( oPC, JumpToObject( oTarget ) );
    }

}
