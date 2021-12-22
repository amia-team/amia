// This is the main script to replicate Warlock essences and shapes.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 22/01/2011 PaladinOfSune    Initial release.
// 19/02/2011 PaladinOfSune    Massive expansion.
// 09/10/2011 PaladinOfSune    Added Hindering Blast.
// --/9/2016  Maverick00053    Added in Warlock epic feat code
// 29/10/2016 Maverick00053    Adding Bard Scaling/Level limits on abilities
// 24/09/2017 PaladinOfSune    Changed Eldritch Cone into Sphere
// 17/09/2018 Hrothmus         Moved BreakInvis Procedure definition to inc_func_classes

// Includes.
#include "x2_inc_switches"
#include "amia_include"
#include "x0_I0_SPELLS"
#include "inc_func_classes"

// Shapes.
void NoShape( object oTarget );      // Level 1
void EldritchChain( object oTarget );  // Level 5
void EldritchSphere( object oTarget );   // Level 10
void EldritchDoom( location lTarget );  // Level 15

// Essences.
void EldritchBlast( int nTouch, object oTarget, int nHalved );   // Level 1
void HellrimeBlast( int nTouch, object oTarget, int nHalved );// Level 6
void UtterdarkBlast( int nTouch, object oTarget, int nHalved );   // Level 15
void BrimstoneBlast( int nTouch, object oTarget, int nHalved );    // Level 12
void VitriolicBlast( int nTouch, object oTarget, int nHalved );    // Level 18
void NoxiousBlast( int nTouch, object oTarget, int nHalved );      // Level 21
void BeshadowedBlast( int nTouch, object oTarget, int nHalved );   // Level 9
void HinderingBlast( int nTouch, object oTarget, int nHalved );    // Level 3

//Return the damage increased by 50%
int EldrichMastery( int nDmg, object oPC );

// Changes between essences.
void ChangeEssence( object oPC, object oItem );

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:

            object oPC          = GetItemActivator();
            object oItem        = GetItemActivated();
            object oTarget      = GetItemActivatedTarget();
            location lTarget    = GetItemActivatedTargetLocation();
            int nSpellFailure   = GetArcaneSpellFailure( oPC );

            // If the PC targets themself, the essence changes.
            if( oTarget == oPC ) {
                ChangeEssence( oPC, oItem );
                break;
            }

            // They've targeted something, so remove any invisibility.
            RemoveInvis( oPC );

            // Account for spell failure if it's above 20%.
            if( nSpellFailure > 20 ) {
                if( Random( 100 ) + 1 < nSpellFailure ) {
                    FloatingTextStringOnCreature( "Spell failed due to arcane spell failure!", oPC, FALSE );
                    break;
                }
            }

             // Use the item name as a means of identifying the shape.
            string sName = GetName( oItem );
            if( GetStringLeft( sName, 8 ) == "No Shape" ) {

                // This shape requires a creature as a target.
                if( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ) {
                    FloatingTextStringOnCreature( "This shape must target a creature.", oPC, FALSE );
                    break;
                }

                // Apply the no shape blast.
                AssignCommand( oPC, NoShape( oTarget ) );
            }
            else if( GetStringLeft( sName, 14 ) == "Eldritch Chain" ) {

                // This shape requires a creature as a target.
                if( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ) {
                    FloatingTextStringOnCreature( "This shape must target a creature.", oPC, FALSE );
                    break;
                }

                // Apply the Eldritch Chain.
                AssignCommand( oPC, EldritchChain( oTarget ) );
            }

            else if( GetStringLeft( sName, 13 ) == "Eldritch Cone" ) {

                // Convert Cone into Sphere
                SetName( oItem, "Eldritch Sphere" );
                SetLocalInt( oItem, "Essence_Type", 7 );
                FloatingTextStringOnCreature( "Eldritch Cone has been converted into Eldritch Sphere.", oPC, FALSE );
                ChangeEssence( oPC, oItem );
            }

            else if( GetStringLeft( sName, 15 ) == "Eldritch Sphere" ) {

                // Apply the Eldritch Sphere.
                AssignCommand( oPC, EldritchSphere( oPC ) );
            }

            else if( GetStringLeft( sName, 13 ) == "Eldritch Doom" ) {

                // Apply the Eldritch Doom.
                AssignCommand( oPC, EldritchDoom( lTarget ) );
            }

            break;
    }
}

void NoShape( object oTarget ){

    // Major variables.
    effect eRay;
    object oItem    = GetItemActivated();

    int nEssence = GetLocalInt( oItem, "Essence_Type" );
    int nBeam;

    // Checks to see if they have the require Warlock levels to use ability
    if(GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF ) < 1)
    {
        SendMessageToPC(OBJECT_SELF, "You do not have the required Warlock levels (1) to activate this ability.");
        return;
    }

    // Find which beam to apply.
    switch ( nEssence ) {
        case 0: nBeam = VFX_BEAM_ODD; break;
        case 1: nBeam = VFX_BEAM_COLD; break;
        case 2: nBeam = VFX_BEAM_EVIL; break;
        case 3: nBeam = VFX_BEAM_FIRE; break;
        case 4: nBeam = VFX_BEAM_DISINTEGRATE; break;
        case 5: nBeam = VFX_BEAM_MIND; break;
        case 6: nBeam = VFX_BEAM_BLACK; break;
        case 7: nBeam = VFX_BEAM_MIND; break;
    }

    // Can't damage friendlies, prevents damaging party members, No PvP abuse etc.
    if( !GetIsReactionTypeFriendly( oTarget ) )
    {
        // Do a ranged touch attack.
        int nTouch = TouchAttackRanged( oTarget, TRUE );
        if( nTouch > 0 ) {

            switch ( nEssence ) {
                case 0: EldritchBlast( nTouch, oTarget, 0 ); break;
                case 1: HellrimeBlast( nTouch, oTarget, 0 ); break;
                case 2: UtterdarkBlast( nTouch, oTarget, 0 ); break;
                case 3: BrimstoneBlast( nTouch, oTarget, 0 ); break;
                case 4: VitriolicBlast( nTouch, oTarget, 0 ); break;
                case 5: NoxiousBlast( nTouch, oTarget, 0 ); break;
                case 6: BeshadowedBlast( nTouch, oTarget, 0 ); break;
                case 7: HinderingBlast( nTouch, oTarget, 0 ); break;
            }

            // Apply the beam visual.
            eRay = EffectBeam( nBeam, OBJECT_SELF, BODY_NODE_HAND );
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0 );
        }
        else {
            // Ranged touch attack missed, fire off missed beam visual.
            eRay = EffectBeam( nBeam, OBJECT_SELF, BODY_NODE_HAND, TRUE );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0 );
        }
    }
}

void EldritchChain( object oTarget ){

    // Variables.
    object oPC      = OBJECT_SELF;
    object oItem    = GetItemActivated();
    object oHolder;
    effect eRay;
    int nLevel = GetLevelByClass(CLASS_TYPE_BARD, oPC );
    int nBeam;

    // Limit increases every five levels.
    int nChainLimit = nLevel / 5;

    int nEssence = GetLocalInt( oItem, "Essence_Type" );

    // Checks to see if they have the require Warlock levels to use ability
    if(nLevel < 5)
    {
        SendMessageToPC(oPC, "You do not have the required Warlock levels (5) to activate this ability.");
        return;
    }

    // Find which beam to apply.
    switch ( nEssence ) {
        case 0: nBeam = VFX_BEAM_ODD; break;
        case 1: nBeam = VFX_BEAM_COLD; break;
        case 2: nBeam = VFX_BEAM_EVIL; break;
        case 3: nBeam = VFX_BEAM_FIRE; break;
        case 4: nBeam = VFX_BEAM_DISINTEGRATE; break;
        case 5: nBeam = VFX_BEAM_MIND; break;
        case 6: nBeam = VFX_BEAM_BLACK; break;
        case 7: nBeam = VFX_BEAM_MIND; break;
    }

    // Can't damage friendlies, prevents damaging party members, No PvP abuse etc.
    if( !GetIsReactionTypeFriendly( oTarget ) )
    {
        //Damage the initial target
        int nTouch = TouchAttackRanged( oTarget, TRUE );
        if( nTouch > 0 )
        {
            switch ( nEssence ) {
                case 0: EldritchBlast( nTouch, oTarget, 0 ); break;
                case 1: HellrimeBlast( nTouch, oTarget, 0 ); break;
                case 2: UtterdarkBlast( nTouch, oTarget, 0 ); break;
                case 3: BrimstoneBlast( nTouch, oTarget, 0 ); break;
                case 4: VitriolicBlast( nTouch, oTarget, 0 ); break;
                case 5: NoxiousBlast( nTouch, oTarget, 0 ); break;
                case 6: BeshadowedBlast( nTouch, oTarget, 0 ); break;
                case 7: HinderingBlast( nTouch, oTarget, 0 ); break;
            }

            // Apply the beam visual.
            eRay = EffectBeam( nBeam, OBJECT_SELF, BODY_NODE_HAND );
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0 );

            // Apply the beam effect to the next target to make it travel.
            eRay = EffectBeam( nBeam, oTarget, BODY_NODE_CHEST );

            // Count for keeping track of targets hit, delay for allowing time for the beam to hit.
            float fDelay = 0.2;
            int nCount = 0;

            //Get the first target in the spell shape
            object oNextTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oTarget ), TRUE, OBJECT_TYPE_CREATURE );
            while ( GetIsObjectValid(oNextTarget) && nCount < nChainLimit ) // Keep going until the limit is reached.
            {
                //Make sure the caster's faction is not hit and the first target is not hit
                if ( oNextTarget != oTarget && oNextTarget != OBJECT_SELF && !GetIsReactionTypeFriendly( oNextTarget ) )
                {
                    // Do a ranged touch attack.
                    nTouch = TouchAttackRanged( oNextTarget, TRUE );
                    if( nTouch > 0 )
                    {
                        switch ( nEssence ) {
                            case 0: DelayCommand( fDelay, EldritchBlast( nTouch, oNextTarget, 1 ) ); break;
                            case 1: DelayCommand( fDelay, HellrimeBlast( nTouch, oNextTarget, 1 ) ); break;
                            case 2: DelayCommand( fDelay, UtterdarkBlast( nTouch, oNextTarget, 1 ) ); break;
                            case 3: DelayCommand( fDelay, BrimstoneBlast( nTouch, oNextTarget, 1 ) ); break;
                            case 4: DelayCommand( fDelay, VitriolicBlast( nTouch, oNextTarget, 1 ) ); break;
                            case 5: DelayCommand( fDelay, NoxiousBlast( nTouch, oNextTarget, 1 ) ); break;
                            case 6: DelayCommand( fDelay, BeshadowedBlast( nTouch, oNextTarget, 1 ) ); break;
                            case 7: DelayCommand( fDelay, HinderingBlast( nTouch, oNextTarget, 1 ) ); break;
                        }

                        // Apply beam VFX to next target.
                        DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oNextTarget, 1.0 ) );

                        // Change the holder of the beam to the current target.
                        oHolder = oNextTarget;
                        eRay = EffectBeam( nBeam, oHolder, BODY_NODE_CHEST);

                        //Count the number of targets that have been hit.
                        nCount++;
                    }
                    else
                    {
                        return; // Beam missed, end Chain
                    }
                }

                // Find the next target.
                fDelay = fDelay + 0.1f;
                oNextTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oTarget), TRUE, OBJECT_TYPE_CREATURE);
            }
        }
        else {
            // Ranged touch attack missed, fire off missed beam visual.
            eRay = EffectBeam( nBeam, OBJECT_SELF, BODY_NODE_HAND, TRUE );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0 );
        }
    }
}

void EldritchSphere( object oTarget ){

    // Major variables.
    object oItem    = GetItemActivated();
    int nEssence    = GetLocalInt( oItem, "Essence_Type" );
    int nVFX;
    location lTarget = GetLocation( oTarget );
    float fDelay;

   // Checks to see if they have the require Warlock levels to use ability
    if(GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF ) < 10)
    {
        SendMessageToPC(OBJECT_SELF, "You do not have the required Warlock levels (10) to activate this ability.");
        return;
    }

    // Find which beam to apply.
    switch ( nEssence ) {
        case 0: nVFX = VFX_IMP_PULSE_NEGATIVE;  break;
        case 1: nVFX = VFX_IMP_PULSE_COLD;      break;
        case 2: nVFX = VFX_IMP_PULSE_NEGATIVE;  break;
        case 3: nVFX = VFX_IMP_PULSE_FIRE;      break;
        case 4: nVFX = VFX_IMP_PULSE_NATURE;    break;
        case 5: nVFX = VFX_IMP_PULSE_NATURE;    break;
        case 6: nVFX = VFX_IMP_PULSE_NEGATIVE;  break;
        case 7: nVFX = VFX_IMP_PULSE_WIND;      break;
    }

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX ), lTarget );

    object oDoomTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while( GetIsObjectValid( oDoomTarget ) ) {

        if( !GetIsReactionTypeFriendly( oDoomTarget ) )
        {
            int nHalved = 0;

            if( MySavingThrow( SAVING_THROW_REFLEX, oDoomTarget, 16 + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ) ) )
            {
                nHalved = 1;
            }

            switch ( nEssence ) {
                case 0: DelayCommand( 0.1, EldritchBlast( 1, oDoomTarget, nHalved ) ); break;
                case 1: DelayCommand( 0.1, HellrimeBlast( 1, oDoomTarget, nHalved ) ); break;
                case 2: DelayCommand( 0.1, UtterdarkBlast( 1, oDoomTarget, nHalved ) ); break;
                case 3: DelayCommand( 0.1, BrimstoneBlast( 1, oDoomTarget, nHalved ) ); break;
                case 4: DelayCommand( 0.1, VitriolicBlast( 1, oDoomTarget, nHalved ) ); break;
                case 5: DelayCommand( 0.1, NoxiousBlast( 1, oDoomTarget, nHalved ) ); break;
                case 6: DelayCommand( 0.1, BeshadowedBlast( 1, oDoomTarget, nHalved ) ); break;
                case 7: DelayCommand( 0.1, HinderingBlast( 1, oDoomTarget, nHalved ) ); break;
            }
        }
        //Select the next target within the spell shape.
        oDoomTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }
}

void EldritchDoom( location lTarget ){

    // Major variables.
    object oItem    = GetItemActivated();
    int nEssence = GetLocalInt( oItem, "Essence_Type" );
    int nVFX;
    int nVFX2;
    location lLocation;
    location lLocation2;
    float fAngle;


    // Checks to see if they have the require Warlock levels to use ability
    if(GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF ) < 15)
    {
        SendMessageToPC(OBJECT_SELF, "You do not have the required Warlock levels (15) to activate this ability.");
        return;
    }

    // Find which beam to apply.
    switch ( nEssence ) {
        case 0:
            nVFX = VFX_IMP_PULSE_NEGATIVE;
            nVFX2 = VFX_FNF_GAS_EXPLOSION_GREASE;
            break;
        case 1:
            nVFX = VFX_IMP_PULSE_COLD;
            nVFX2 = VFX_FNF_GAS_EXPLOSION_MIND;
            break;
        case 2:
            nVFX = VFX_IMP_PULSE_NEGATIVE;
            nVFX2 = VFX_FNF_GAS_EXPLOSION_EVIL;
            break;
        case 3:
            nVFX = VFX_IMP_PULSE_FIRE;
            nVFX2 = VFX_FNF_GAS_EXPLOSION_FIRE;
            break;
        case 4:
            nVFX = VFX_IMP_PULSE_NATURE;
            nVFX2 = VFX_FNF_GAS_EXPLOSION_ACID;
            break;
        case 5:
            nVFX = VFX_IMP_PULSE_NATURE;
            nVFX2 = VFX_FNF_GAS_EXPLOSION_MIND;
            break;
        case 6:
            nVFX = VFX_IMP_PULSE_NEGATIVE;
            nVFX2 = VFX_FNF_GAS_EXPLOSION_GREASE;
            break;
        case 7:
            nVFX = VFX_IMP_PULSE_WIND;
            nVFX2 = VFX_FNF_GAS_EXPLOSION_MIND;
    }

    int x;
    for ( x = 0; x < 8; x++ ) {
        lLocation   = GenerateNewLocationFromLocation( lTarget, 2.0, fAngle, 0.0 );
        lLocation2   = GenerateNewLocationFromLocation( lTarget, 3.0, fAngle, 0.0 );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX ), lLocation );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX2 ), lLocation2 );
        fAngle      = fAngle + 45;
    }

    // Do a ranged touch attack.
    object oDoomTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while( GetIsObjectValid( oDoomTarget ) ) {

        if( !GetIsReactionTypeFriendly( oDoomTarget ) )
        {
            int nHalved = 0;

            if( MySavingThrow( SAVING_THROW_REFLEX, oDoomTarget, 18 + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ) ) )
            {
                nHalved = 1;
            }

            switch ( nEssence ) {
                case 0: DelayCommand( 0.1, EldritchBlast( 1, oDoomTarget, nHalved ) ); break;
                case 1: DelayCommand( 0.1, HellrimeBlast( 1, oDoomTarget, nHalved ) ); break;
                case 2: DelayCommand( 0.1, UtterdarkBlast( 1, oDoomTarget, nHalved ) ); break;
                case 3: DelayCommand( 0.1, BrimstoneBlast( 1, oDoomTarget, nHalved ) ); break;
                case 4: DelayCommand( 0.1, VitriolicBlast( 1, oDoomTarget, nHalved ) ); break;
                case 5: DelayCommand( 0.1, NoxiousBlast( 1, oDoomTarget, nHalved ) ); break;
                case 6: DelayCommand( 0.1, BeshadowedBlast( 1, oDoomTarget, nHalved ) ); break;
                case 7: DelayCommand( 0.1, HinderingBlast( 1, oDoomTarget, nHalved ) ); break;
            }
        }
        //Select the next target within the spell shape.
        oDoomTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }
}

void EldritchBlast( int nTouch, object oTarget, int nHalved ) {

    // Major variables.
    object oPC = OBJECT_SELF;
    effect eVFX;
    effect eDamage;
    int nDamage;
    int nSR = GetSpellResistance( oTarget );
    int nLevel = GetLevelByClass(CLASS_TYPE_BARD, oPC );
    int nCasterLevel = nLevel;

    // Checks to see if they have the require Warlock levels to use ability
    if(nLevel < 1)
    {
        SendMessageToPC(oPC, "You do not have the required Warlock levels (1) to activate this ability.");
        return;
    }

    // Damage increases every two levels.
    int nDice = nLevel/2;

    // xd6 damage.
    nDamage = d6( nDice );

    // Damage is doubled with critical.
    if( nTouch == 2 ) nDamage *= 2;

    if( nHalved == 1 ) nDamage /= 2;

    // Apply it as magical damage.
    eDamage = EffectDamage( EldrichMastery( nDamage, oPC ), DAMAGE_TYPE_MAGICAL );

    // Account for spell penetration feats, if any.
    if ( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 4;
    else if ( GetHasFeat( FEAT_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 2;

    // Check for Spell Resistance.
    if( d20() + nCasterLevel >= nSR ) {
        eVFX = EffectVisualEffect( VFX_IMP_MAGBLUE );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
    else {
        // Target resisted the spell.
        eVFX = EffectVisualEffect( VFX_IMP_MAGIC_RESISTANCE_USE );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
}

void HellrimeBlast( int nTouch, object oTarget, int nHalved ) {

    // Major variables.
    object oPC = OBJECT_SELF;
    effect eVFX;
    effect eVFX2;
    effect eDamage;
    effect eDexDecrease = SupernaturalEffect( EffectAbilityDecrease( ABILITY_DEXTERITY, 4 ) );
    int nDamage;
    int nSR = GetSpellResistance( oTarget );
    int nLevel = GetLevelByClass(CLASS_TYPE_BARD, oPC );
    int nCasterLevel = nLevel;

    // Checks to see if they have the require Warlock levels to use ability
    if(nLevel < 6)
    {
        SendMessageToPC(oPC, "You do not have the required Warlock levels (6) to activate this ability.");
        return;
    }

    // Damage increases every two levels.
    int nDice = nLevel/2;

    // xd6 damage.
    nDamage = d6( nDice );

    // Damage is doubled with critical.
    if( nTouch == 2 ) nDamage *= 2;

    if( nHalved == 1 ) nDamage /= 2;

    // Apply it as cold damage.
    eDamage = EffectDamage( EldrichMastery( nDamage, oPC ), DAMAGE_TYPE_COLD );

    // Account for spell penetration feats, if any.
    if ( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 4;
    else if ( GetHasFeat( FEAT_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 2;

    // Check for Spell Resistance.
    if( d20() + nCasterLevel >= nSR ) {

       // if( !GetIsBlocked( oTarget, "HellrimePenalty" ) ) {
            if(MySavingThrow( SAVING_THROW_FORT, oTarget, 14 + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ) ) == 0 )
            {
                // Target failed save, apply penalty.
                eVFX2 = EffectVisualEffect( VFX_DUR_ICESKIN );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX2, oTarget, 6.0 );
                DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDexDecrease, oTarget, TurnsToSeconds( 10 ) ) );
                //SetBlockTime( oTarget, 10, 0, "HellrimePenalty" );
            }
            else {
                // Target saved, do nothing.
                eVFX2 = EffectVisualEffect( VFX_IMP_FORTITUDE_SAVING_THROW_USE );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
            }
       // }
        // Apply damage.
        eVFX = EffectVisualEffect( VFX_IMP_FROST_S );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
    else {
        // Target resisted the spell.
        eVFX = EffectVisualEffect( VFX_IMP_MAGIC_RESISTANCE_USE );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
}

void UtterdarkBlast( int nTouch, object oTarget, int nHalved ) {

    // Major variables.
    object oPC = OBJECT_SELF;
    effect eVFX;
    effect eVFX2;
    effect eDamage;
    effect eLevelDrain = SupernaturalEffect( EffectNegativeLevel( 2 ) );
    int nDamage;
    int nSR = GetSpellResistance( oTarget );
    int nLevel = GetLevelByClass(CLASS_TYPE_BARD, oPC );
    int nCasterLevel = nLevel;


    // Checks to see if they have the require Warlock levels to use ability
    if(nLevel < 15)
    {
        SendMessageToPC(oPC, "You do not have the required Warlock levels (15) to activate this ability.");
        return;
    }

    // Damage increases every two levels.
    int nDice = nLevel/2;

    // xd6 damage.
    nDamage = d6( nDice );

    // Damage is doubled with critical.
    if( nTouch == 2 ) nDamage *= 2;

    if( nHalved == 1 ) nDamage /= 2;

    // Apply it as negative damage, or heal undead creatures.
    if( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD ){
        eDamage = EffectHeal( EldrichMastery( nDamage, oPC ) );
    }
    else {
        eDamage = EffectDamage( EldrichMastery( nDamage, oPC ), DAMAGE_TYPE_NEGATIVE );
    }

    // Account for spell penetration feats, if any.
    if ( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 4;
    else if ( GetHasFeat( FEAT_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 2;

    // Check for Spell Resistance
    if( d20() + nCasterLevel >= nSR ) {

        if(MySavingThrow( SAVING_THROW_FORT, oTarget, 18 + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ) ) == 0 )
        {
            // Target failed save, apply penalty.
            eVFX2 = EffectVisualEffect( VFX_IMP_DEATH_L );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLevelDrain, oTarget, NewHoursToSeconds( 1 ) );
        }
        else {

            // Target saved, do nothing.
            eVFX2 = EffectVisualEffect( VFX_IMP_FORTITUDE_SAVING_THROW_USE );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
        }
        // Apply damage.
        eVFX = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
    else {

        // Target resisted the spell.
        eVFX = EffectVisualEffect( VFX_IMP_MAGIC_RESISTANCE_USE );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
}

void BrimstoneBlast( int nTouch, object oTarget, int nHalved ) {

    // Major variables.
    object oPC = OBJECT_SELF;
    effect eVFX;
    effect eVFX2;
    effect eDamage;
    effect eTickDamage;
    int nDamage;
    int nSR = GetSpellResistance( oTarget );
    int nLevel = GetLevelByClass(CLASS_TYPE_BARD, oPC );
    int nCasterLevel = nLevel;
    float fDelay = 6.0;


    // Checks to see if they have the require Warlock levels to use ability
    if(nLevel < 12)
    {
        SendMessageToPC(oPC, "You do not have the required Warlock levels (12) to activate this ability.");
        return;
    }

    // Damage increases every two levels.
    int nDice = nLevel/2;

    // Duration increases every five levls.
    int nDurLimit = nLevel / 5;

    // xd6 damage.
    nDamage = d6( nDice );

    // Damage is doubled with critical.
    if( nTouch == 2 ) nDamage *= 2;

    if( nHalved == 1 ) nDamage /= 2;

    // Apply it as fire damage.
    eDamage = EffectDamage( EldrichMastery( EldrichMastery( nDamage, oPC ), oPC ), DAMAGE_TYPE_FIRE );

    // Damage over time is 2d6 fire.
    eTickDamage = EffectDamage( Random( 12 ) + 1, DAMAGE_TYPE_FIRE );

    // Account for spell penetration feats, if any.
    if ( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 4;
    else if ( GetHasFeat( FEAT_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 2;

    // Check for Spell Resistance.
    if( d20() + nCasterLevel >= nSR ) {
        if(MySavingThrow( SAVING_THROW_REFLEX, oTarget, 13 + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ) ) == 0 )
        {
            // Non-stackable.
            if( GetLocalInt( oTarget, "is_brimstoned" ) == 0 ) {
                // Target failed save, apply penalty.
                eVFX2 = EffectVisualEffect( 498 );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX2, oTarget, RoundsToSeconds( nDurLimit ) );

                // Apply it for rounds equal to caster level/5.
                int x;
                for ( x = 0; x < nDurLimit; x++ ) {

                    DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eTickDamage, oTarget ) );
                    eTickDamage = EffectDamage( Random( 12 ) + 1, DAMAGE_TYPE_FIRE ); // Reroll damage
                    fDelay = fDelay + 6.0;
                }
                // Set nonstacking variable and delete it in necessary rounds.
                SetLocalInt( oTarget, "is_brimstoned", 1 );
                DelayCommand( RoundsToSeconds( nDurLimit ), DeleteLocalInt( oTarget, "is_brimstoned" ) );
           }
        }
        else {
            // Target saved, do nothing.
            eVFX2 = EffectVisualEffect( VFX_IMP_REFLEX_SAVE_THROW_USE );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
        }
        // Apply damage.
        eVFX = EffectVisualEffect( VFX_IMP_FLAME_M );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
    else {
        // Target resisted the spell.
        eVFX = EffectVisualEffect( VFX_IMP_MAGIC_RESISTANCE_USE );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
}

void VitriolicBlast( int nTouch, object oTarget, int nHalved ) {

    // Major variables.
    object oPC = OBJECT_SELF;
    effect eVFX;
    effect eVFX2;
    effect eDamage;
    effect eTickDamage;
    int nDamage;
    int nSR = GetSpellResistance( oTarget );
    int nLevel = GetLevelByClass(CLASS_TYPE_BARD, oPC );
    int nCasterLevel = nLevel;
    float fDelay = 6.0;


    // Checks to see if they have the require Warlock levels to use ability
    if(nLevel < 18)
    {
        SendMessageToPC(oPC, "You do not have the required Warlock levels (18) to activate this ability.");
        return;
    }

    // Damage increases every two levels.
    int nDice = nLevel/2;

    // Duration increases every five levls.
    int nDurLimit = nLevel / 5;

    // xd6 damage.
    nDamage = d6( nDice );

    // Damage is doubled with critical.
    if( nTouch == 2 ) nDamage *= 2;

    if( nHalved == 1 ) nDamage /= 2;

    // Apply it as acid damage.
    eDamage = EffectDamage( EldrichMastery( nDamage, oPC ), DAMAGE_TYPE_ACID );

    // Damage over time is 2d6 acid.
    eTickDamage = EffectDamage( Random( 12 ) + 1, DAMAGE_TYPE_ACID );

    // Vitriolic Blast ignores Spell Resistance.
    if( MySavingThrow( SAVING_THROW_REFLEX, oTarget, 16 + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ) ) == 0 )
    {
        // Non stackable.
        if( GetLocalInt( oTarget, "is_acided" ) == 0 ) {
            // Target failed save, apply penalty.
            eVFX2 = EffectVisualEffect( VFX_IMP_ACID_S );

            // Apply it for rounds equal to caster level/5.
            int x;
            for ( x = 0; x < nDurLimit; x++ ) {

                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eTickDamage, oTarget ) );
                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget ) );
                eTickDamage = EffectDamage( Random( 12 ) + 1, DAMAGE_TYPE_ACID ); // Reroll damage
                fDelay = fDelay + 6.0;
            }

            // Set nonstacking variable and delete it in necessary rounds.
            SetLocalInt( oTarget, "is_acided", 1 );
            DelayCommand( RoundsToSeconds( nDurLimit ), DeleteLocalInt( oTarget, "is_acided" ) );
        }
    }
    else {
        // Target saved, do nothing.
        eVFX2 = EffectVisualEffect( VFX_IMP_REFLEX_SAVE_THROW_USE );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
    }

    // Apply damage.
    eVFX = EffectVisualEffect( VFX_IMP_ACID_L );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
}

void NoxiousBlast( int nTouch, object oTarget, int nHalved ) {

    // Major variables.
    object oPC = OBJECT_SELF;
    effect eVFX;
    effect eVFX2;
    effect eDamage;
    effect eDaze = EffectDazed();
    int nDamage;
    int nSR = GetSpellResistance( oTarget );
    int nLevel = GetLevelByClass(CLASS_TYPE_BARD, oPC );
    int nCasterLevel = nLevel;


    // Checks to see if they have the require Warlock levels to use ability
    if(nLevel < 21)
    {
        SendMessageToPC(oPC, "You do not have the required Warlock levels (21) to activate this ability.");
        return;
    }

    // Damage increases every two levels.
    int nDice = nLevel/2;

    // xd6 damage.
    nDamage = d6( nDice );

    // Damage is doubled with critical.
    if( nTouch == 2 ) nDamage *= 2;

    if( nHalved == 1 ) nDamage /= 2;

    // Apply it as magical damage.
    eDamage = EffectDamage( EldrichMastery( nDamage, oPC ), DAMAGE_TYPE_MAGICAL );

    // Account for spell penetration feats, if any.
    if ( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 4;
    else if ( GetHasFeat( FEAT_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 2;

    // Check for Spell Resistance
    if( d20() + nCasterLevel >= nSR ) {
        if(MySavingThrow( SAVING_THROW_FORT, oTarget, 16 + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ) ) == 0 )
        {
            // Target failed save, apply penalty.
            eVFX2 = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX2, oTarget, TurnsToSeconds( 1 ) );
            DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDaze, oTarget, TurnsToSeconds( 1 ) ) );
        }
        else {
            // Target saved, do nothing.
            eVFX2 = EffectVisualEffect( VFX_IMP_FORTITUDE_SAVING_THROW_USE );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
        }
        // Apply damage.
        eVFX = EffectVisualEffect( VFX_IMP_STARBURST_GREEN );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
    else {
        // Target resisted the spell.
        eVFX = EffectVisualEffect( VFX_IMP_MAGIC_RESISTANCE_USE );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
}

void BeshadowedBlast( int nTouch, object oTarget, int nHalved ) {

    // Major variables.
    object oPC = OBJECT_SELF;
    effect eVFX;
    effect eVFX2;
    effect eDamage;
    effect eBlind = EffectBlindness();
    effect eACMalus = EffectACDecrease( 2 );
    effect eSpeedMalus = EffectMovementSpeedDecrease( 50 );
    int nDamage;
    int nSR = GetSpellResistance( oTarget );
    int nLevel = GetLevelByClass(CLASS_TYPE_BARD, oPC );
    int nCasterLevel = nLevel;


    // Checks to see if they have the require Warlock levels to use ability
    if(nLevel < 9)
    {
        SendMessageToPC(oPC, "You do not have the required Warlock levels (9) to activate this ability.");
        return;
    }

    // Damage increases every two levels.
    int nDice = nLevel/2;

    // xd6 damage.
    nDamage = d6( nDice );

    // Damage is doubled with critical.
    if( nTouch == 2 ) nDamage *= 2;

    if( nHalved == 1 ) nDamage /= 2;

    // Apply it as magical damage.
    eDamage = EffectDamage( EldrichMastery( nDamage, oPC ), DAMAGE_TYPE_MAGICAL );

    effect ePenalty = EffectLinkEffects( eACMalus, eBlind );
    ePenalty = EffectLinkEffects( eSpeedMalus, ePenalty );

    // Account for spell penetration feats, if any.
    if ( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 4;
    else if ( GetHasFeat( FEAT_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 2;

    // Check for Spell Resistance
    if( d20() + nCasterLevel >= nSR ) {
        if(MySavingThrow( SAVING_THROW_FORT, oTarget, 14 + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ) ) == 0 )
        {
            // Target failed save, apply penalty.
            eVFX2 = EffectVisualEffect( VFX_IMP_BLIND_DEAF_M );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX2, oTarget, TurnsToSeconds( 1 ) );
            DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePenalty, oTarget, RoundsToSeconds( 1 ) ) );
        }
        else {
            // Target saved, do nothing.
            eVFX2 = EffectVisualEffect( VFX_IMP_FORTITUDE_SAVING_THROW_USE );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
        }
        // Apply damage.
        eVFX = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
    else {
        // Target resisted the spell.
        eVFX = EffectVisualEffect( VFX_IMP_MAGIC_RESISTANCE_USE );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
}

void HinderingBlast( int nTouch, object oTarget, int nHalved ) {

    // Major variables.
    object oPC = OBJECT_SELF;
    effect eVFX;
    effect eVFX2;
    effect eDamage;
    effect eSlow = EffectSlow();
    effect eABMalus = EffectAttackDecrease( 1 );
    effect eReflexMalus = EffectSavingThrowDecrease( SAVING_THROW_REFLEX, 1 );
    int nDamage;
    int nSR = GetSpellResistance( oTarget );
    int nLevel = GetLevelByClass(CLASS_TYPE_BARD, oPC );
    int nCasterLevel = nLevel;

    // Checks to see if they have the require Warlock levels to use ability
    if(nLevel < 3)
    {
        SendMessageToPC(oPC, "You do not have the required Warlock levels (3) to activate this ability.");
        return;
    }

    // Damage increases every two levels.
    int nDice = nLevel/2;

    // xd6 damage.
    nDamage = d6( nDice );

    // Damage is doubled with critical.
    if( nTouch == 2 ) nDamage *= 2;

    if( nHalved == 1 ) nDamage /= 2;

    // Apply it as magical damage.
    eDamage = EffectDamage( EldrichMastery( nDamage, oPC ), DAMAGE_TYPE_MAGICAL );

    effect ePenalty = EffectLinkEffects( eReflexMalus, eSlow );
    ePenalty = EffectLinkEffects( eABMalus, ePenalty );

    // Account for spell penetration feats, if any.
    if ( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 4;
    else if ( GetHasFeat( FEAT_SPELL_PENETRATION ) )
        nCasterLevel = nCasterLevel + 2;

    // Check for Spell Resistance
    if( d20() + nCasterLevel >= nSR ) {
        if(MySavingThrow( SAVING_THROW_WILL, oTarget, 16 + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ) ) == 0 )
        {
            // Target failed save, apply penalty.
            eVFX2 = EffectVisualEffect( VFX_IMP_SLOW );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
            DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePenalty, oTarget, TurnsToSeconds( 1 ) ) );
        }
        else {
            // Target saved, do nothing.
            eVFX2 = EffectVisualEffect( VFX_IMP_WILL_SAVING_THROW_USE );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
        }
        // Apply damage.
        eVFX = EffectVisualEffect( VFX_COM_SPECIAL_WHITE_BLUE );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
    else {
        // Target resisted the spell.
        eVFX = EffectVisualEffect( VFX_IMP_MAGIC_RESISTANCE_USE );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
    }
}

void ChangeEssence( object oPC, object oItem ) {

    // Variables used for constructing new name/description.
    string sName    = GetName( oItem );
    string sNewName;
    string sNewDesc;

    // Shape descriptions.
    string sNoShapeDesc = "There is no shape set. This blast will strike a single target with a ranged touch attack, dealing double damage on a natural roll of 20. \n\n";
    string sChainDesc = "This blast shape will arc from the first target and deal half damage to a secondary target. You can strike a target for every five caster levels, though you may not hit the same creature more than once in a single chain. The chain ends with any misses.\n\n";
    string sSphereDesc = "The eldritch sphere deals the normal eldritch blast damage to all targets in a 5 meter radius around the caster. This is not a ray attack, so it requires no ranged touch attack. Any creature in the area of the sphere can attempt a Reflex save for half damage.\n\n";
    string sDoomDesc = "This blast shape invocation allows you to invoke your eldritch blast as the dreaded eldritch doom. This causes bolts of mystical power to lash out and savage all targets within a 20 foot area. This is not a ray attack, so it requires no ranged touch attack. Each target can attempt a Reflex save for half damage.\n\n";

    // Essence descriptions.
    string sEldritchDesc = "An eldritch blast is a ray with a range of 60 feet. It affects a single target, allowing no saving throw. An eldritch blast deals 1d6 points of damage at 1st level and increases in power every two warlock levels, reaching its peak at 10d6 damage at level 19 warlock. It allows Spell Resistance.";
    string sHellrimeDesc = "A hellrime blast deals cold damage. Any creature struck by the attack must make a Fortitude save or take a -4 penalty to Dexterity for 10 minutes. The Dexterity penalties from multiple hellrime blasts do not stack.";
    string sUtterdarkDesc = "An utterdark blast deals negative energy damage, which heals undead creatures instead of damaging them (much like inflict spells). Any creature struck by the attack must make a Fortitude save or gain two negative levels. The negative levels fade after 1 hour. If a target ever has as many negative levels as Hit Dice, it dies.";
    string sBrimstoneDesc = "A brimstone blast deals fire damage. Any creature struck by a brimstone blast must succeed on a Reflex save or catch on fire, taking 2d6 points of fire damage per round until the duration expires. The fire damage persists for 1 round per five class levels you have.";
    string sVitriolicDesc = "A vitriolic blast deals acid damage, and is formed from conjured acid, making it different from all other eldritch essences because it ignores spell resistance. Creatures struck by a vitriolic blast automatically take an extra 2d6 points of acid damage on following rounds. This acid damage persists for 1 round per five class levels you have.";
    string sNoxiousDesc = "Any creature struck by a noxious blast must make a Fortitude save or suffer the effects of being dazed for 10 rounds.";
    string sBeshadowedDesc = "Any living creature struck by a beshadowed blast must succeed on a Fortitude save or be blinded for 1 round, giving it a 50% chance to miss in combat, removing any Dexterity bonuses to AC, adding an additional -2 penalty to AC, and causing it to move at half speed.";
    string sHinderingDesc = "In addition to normal eldritch blast damage, the hindering blast forces any creature struck to make a Will save or become slowed. A slowed creature moves and attacks at a drastically reduced rate, taking a -1 penalty on attack rolls, -4 penalty on AC, and -1 Reflex saves and moving at half its normal speed. Multiple slow effects don't stack.";

    // Find the shape name and description to be used.
    if( GetStringLeft( sName, 8 ) == "No Shape" ) {
        sNewName = "No Shape: ";
        sNewDesc = sNoShapeDesc;
    }
    else if( GetStringLeft( sName, 14 ) == "Eldritch Chain" ) {
        sNewName = "Eldritch Chain: ";
        sNewDesc = sChainDesc;
    }

    else if( GetStringLeft( sName, 15 ) == "Eldritch Sphere" ) {
        sNewName = "Eldritch Sphere: ";
        sNewDesc = sSphereDesc;
    }

    else if( GetStringLeft( sName, 13 ) == "Eldritch Doom" ) {
        sNewName = "Eldritch Doom: ";
        sNewDesc = sDoomDesc;
    }

    // Find the essence name and description to be used.
    if( GetLocalInt( oItem, "Essence_Type" ) == 0 ) {
        SetLocalInt( oItem, "Essence_Type", 1 );
        FloatingTextStringOnCreature( "Essence changed to Hellrime Blast.", oPC, FALSE );
        sNewName = sNewName + "Hellrime Blast";
        sNewDesc = sNewDesc + sHellrimeDesc;
    }
    else if( GetLocalInt( oItem, "Essence_Type" ) == 1 ) {
        SetLocalInt( oItem, "Essence_Type", 2 );
        FloatingTextStringOnCreature( "Essence changed to Utterdark Blast.", oPC, FALSE );
        sNewName = sNewName + "Utterdark Blast";
        sNewDesc = sNewDesc + sUtterdarkDesc;
    }
    else if( GetLocalInt( oItem, "Essence_Type" ) == 2 ) {
        SetLocalInt( oItem, "Essence_Type", 3 );
        FloatingTextStringOnCreature( "Essence changed to Brimstone Blast.", oPC, FALSE );
        sNewName = sNewName + "Brimstone Blast";
        sNewDesc = sNewDesc + sBrimstoneDesc;
    }
    else if( GetLocalInt( oItem, "Essence_Type" ) == 3 ) {
        SetLocalInt( oItem, "Essence_Type", 4 );
        FloatingTextStringOnCreature( "Essence changed to Vitriolic Blast.", oPC, FALSE );
        sNewName = sNewName + "Vitriolic Blast";
        sNewDesc = sNewDesc + sVitriolicDesc;
    }
    else if( GetLocalInt( oItem, "Essence_Type" ) == 4 ) {
        SetLocalInt( oItem, "Essence_Type", 5 );
        FloatingTextStringOnCreature( "Essence changed to Noxious Blast.", oPC, FALSE );
        sNewName = sNewName + "Noxious Blast";
        sNewDesc = sNewDesc + sNoxiousDesc;
    }

    else if( GetLocalInt( oItem, "Essence_Type" ) == 5 ) {
        SetLocalInt( oItem, "Essence_Type", 6 );
        FloatingTextStringOnCreature( "Essence changed to Beshadowed Blast.", oPC, FALSE );
        sNewName = sNewName + "Beshadowed Blast";
        sNewDesc = sNewDesc + sBeshadowedDesc;
    }

    else if( GetLocalInt( oItem, "Essence_Type" ) == 6 ) {
        SetLocalInt( oItem, "Essence_Type", 7 );
        FloatingTextStringOnCreature( "Essence changed to Hindering Blast.", oPC, FALSE );
        sNewName = sNewName + "Hindering Blast";
        sNewDesc = sNewDesc + sHinderingDesc;
    }

    else if( GetLocalInt( oItem, "Essence_Type" ) == 7 ) {
        SetLocalInt( oItem, "Essence_Type", 0 );
        FloatingTextStringOnCreature( "Essence changed to Eldritch Blast.", oPC, FALSE );
        sNewName = sNewName + "Eldritch Blast";
        sNewDesc = sNewDesc + sEldritchDesc;
    }

    // We've brought it all together, so set the new name and description!
    SetName( oItem, sNewName );
    SetDescription( oItem, sNewDesc );
}

int EldrichMastery( int nDmg, object oPC ){
    // Damage +50% if PC has eldritch mastery widget
    object oEldritchMaster = GetItemPossessedBy( oPC, "warlock_em" );
    if ( GetIsObjectValid( oEldritchMaster ) ) {
        return nDmg + (nDmg/2);
    } else {
        return nDmg;
    }
}
