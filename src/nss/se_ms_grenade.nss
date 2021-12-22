
//-------------------------------------------------------------------------------
// Header
//-------------------------------------------------------------------------------
// script:  se_ms_grenade
// group:   Spells
// used as: spell script
// date:    07 July 2011
// author:  Selmak
// Notes:   Master Scout Grenades
//          Special grenade effects for use by the Amia
//          prestige class Master Scout, which replaces
//          the Harper Scout.


//-------------------------------------------------------------------------------
// Changelog
//-------------------------------------------------------------------------------
//
//

//-------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------

#include "x0_i0_spells"

//-------------------------------------------------------------------------------
// Constants
//-------------------------------------------------------------------------------

const int SPELL_GRENADE_KALEIDOSCOPE     = 900;
const int SPELL_GRENADE_SHRAPNEL         = 901;
const int SPELL_GRENADE_COMPRESSION      = 902;

//-------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------

// Master Scout grenade ability.  Performs a ranged touch attack on targets
// within fRadius of the target location, on a failed will save versus DC,
// target is confused and deafened for nDuration rounds.
void DoKaleidoscopeGrenade( int nDC, int nDuration, float fRadius );

// Master Scout grenade ability.  Damages enemies with a blast of shrapnel
// within fRadius of the target location.  Each shrapnel piece does d6 piercing
// damage, plus 1 extra damage per Master Scout level.  If a shrapnel piece
// doesn't succeed with the ranged touch attack, it doesn't harm anything.
void DoShrapnelShell( int nScoutLevel, float fRadius );

// Master Scout grenade ability.  Finds trap triggers (but does not disarm them)
// and disperses area-effect spells in the same fashion as Gust of Wind spell.
void DoCompressionGrenade();

//-------------------------------------------------------------------------------
// Main
//-------------------------------------------------------------------------------

void main()
{

    int nSpell      = GetSpellId();

    int nScoutLevel = GetLevelByClass( CLASS_TYPE_HARPER, OBJECT_SELF );

    if ( nSpell == 900 ){

        DoKaleidoscopeGrenade( 25 + nScoutLevel, 3 + nScoutLevel, 10.0 );

    }

    if ( nSpell == 901 ){

        DoShrapnelShell( nScoutLevel, 10.0 );

    }

    if ( nSpell == 902 ){

        DoCompressionGrenade();

    }


}

//-------------------------------------------------------------------------------
// Functions
//-------------------------------------------------------------------------------

// Master Scout grenade ability.  Performs a ranged touch attack on targets
// within fRadius of the target location, on a failed will save versus DC,
// target is confused and deafened for nDuration rounds.
void DoKaleidoscopeGrenade( int nDC, int nDuration, float fRadius ){

    int nTouch;
    float fDelay;
    float fDuration     = RoundsToSeconds( nDuration );
    int nObjectFilter   = OBJECT_TYPE_CREATURE;
    location lTarget    = GetSpellTargetLocation();

    effect eConfuse     = EffectConfused();
    effect eDeafen      = EffectDeaf();
    effect eDur         = EffectLinkEffects( eDeafen, eConfuse );
    effect eVFX         = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
    eDur                = EffectLinkEffects( eVFX, eDur );
    effect eVisExplode  = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_MIND );


    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, lTarget, TRUE, nObjectFilter );

    while (GetIsObjectValid(oTarget)){

        // * must touch enemy for this to work, else find next enemy
        nTouch = TouchAttackRanged( oTarget );
        if ( nTouch == 0 ){

            oTarget = GetNextObjectInShape( SHAPE_SPHERE, fRadius, lTarget, TRUE, nObjectFilter );
            continue;

        }
        // * only inflict status effects on enemies
        if ( spellsIsTarget ( oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF ) ){

            SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_GRENADE_KALEIDOSCOPE ) );
            fDelay = GetDistanceBetweenLocations( lTarget, GetLocation( oTarget ) ) / 20.0;
            if( !MySavingThrow( SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay ) ){

                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration ) );

            }
        }

        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 10.0, lTarget, TRUE, nObjectFilter );
    }

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVisExplode, lTarget );


}

// Master Scout grenade ability.  Damages enemies with a blast of shrapnel
// within fRadius of the target location.  Each shrapnel piece does d6 piercing
// damage, plus 1 extra damage per Master Scout level.  If a shrapnel piece
// doesn't succeed with the ranged touch attack, it doesn't harm anything.
void DoShrapnelShell( int nScoutLevel, float fRadius ){

    int nTouch;
    float fDelay;
    int nObjectFilter   = OBJECT_TYPE_CREATURE;
    location lTarget    = GetSpellTargetLocation();

    effect eDam;
    effect eVFX         = EffectVisualEffect( VFX_COM_BLOOD_SPARK_SMALL );


    int nFrags          = d4(3);
    int nDam;

    object oTarget;


    //Note that unlike the Kaleidoscope grenade, we have two nested loops to
    //make sure that targets receive an even number of shrapnel pieces
    while ( nFrags > 0 ){

        oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, lTarget, TRUE, nObjectFilter );

        while (GetIsObjectValid(oTarget)){

            // Only target enemies
            if ( spellsIsTarget ( oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF ) ){

                // * must touch enemy for this to work, else find next enemy
                nTouch = TouchAttackRanged( oTarget );
                if ( nTouch == 0 ){

                    //This one didn't hit, it is still expended.
                    nFrags--;

                    if ( nFrags < 1 ){

                        //If there are no shrapnel pieces left, no need to loop through any
                        //more creatures.
                        break;

                    }
                    else{

                        //We use continue here to skip to the next creature.
                        oTarget = GetNextObjectInShape( SHAPE_SPHERE, fRadius, lTarget, TRUE, nObjectFilter );
                        continue;

                    }

                }

                    SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_GRENADE_SHRAPNEL ) );
                    fDelay = GetDistanceBetweenLocations( lTarget, GetLocation( oTarget ) ) / 20.0;

                    nDam    = d6(1) + nScoutLevel;
                    eDam    = EffectDamage( nDam, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_PLUS_THREE );
                    eDam    = EffectLinkEffects( eVFX, eDam );

                    DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget ) );

                    nFrags--;

            }

            //If there are no shrapnel pieces left, no need to loop through any
            //more creatures.
            if ( nFrags < 1 ) break;

            oTarget = GetNextObjectInShape( SHAPE_SPHERE, 10.0, lTarget, TRUE, nObjectFilter );
        }
    }

}


// Master Scout grenade ability.  Finds trap triggers (but does not disarm them)
// and disperses area-effect spells in the same fashion as Gust of Wind spell.
void DoCompressionGrenade(){

    location lTarget    = GetSpellTargetLocation();

    // Borrowed from the Detect Traps script, but using lTarget as the radial
    // point instead.  Only works on triggers.
    effect eVis = EffectVisualEffect( VFX_IMP_HOLY_AID );
    int nCnt = 1;
    object oTrap = GetNearestObjectToLocation( OBJECT_TYPE_TRIGGER,  lTarget, nCnt);
    while( GetIsObjectValid(oTrap) && GetDistanceToObject( oTrap ) <= 30.0 )
    {
        if( GetIsTrapped( oTrap ) )
        {

            // Trap is now detected by the user, but not disarmed.
            SetTrapDetectedBy( oTrap, OBJECT_SELF );
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, GetLocation( oTrap ) );

        }
        nCnt++;
        oTrap = GetNearestObjectToLocation( OBJECT_TYPE_TRIGGER, lTarget, nCnt );
    }

    // Borrowed from Gust of Wind.
    // Only disperses spells, does not knock down characters.

    //Declare major variables
    string sAOETag;
    effect eExplode = EffectVisualEffect( VFX_FNF_LOS_NORMAL_20 );

    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eExplode, lTarget );


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_AREA_OF_EFFECT );


    //Cycle through the targets within the spell shape until an invalid object is captured.
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
                 sAOETag == "VFX_PER_CREEPING_DOOM")
            {
                DestroyObject( oTarget );
            }
        }

       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_AREA_OF_EFFECT);
    }




}


