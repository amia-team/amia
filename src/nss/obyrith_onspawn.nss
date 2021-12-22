//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  obyrith_onspawn
//group:   obyrith
//used as: Custom OnSpawn for Obyrith-related critters
//date:    12/22/12
//author:  Glim

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"
#include "x0_i0_spells"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void GenerateTargets( object oCritter );
void DoWastrilithHeartB( object oCritter );
void DoUzollruHeartB( object oCritter );
void DoUnholyBlight( object oCritter, location lTarget );
void DoConeOfSteam( object oCritter, object oTarget );
void DoStunGaze( object oCritter, object oTarget );
void DoWastrilithSummon( object oCritter, location lTarget );
void DoUzollruGrapple( object oCritter, object oTarget );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oCritter = OBJECT_SELF;
    string sIdentity = GetResRef( oCritter );

    if( sIdentity == "wastrilith" )
    {
        effect eUnholyAura = EffectAreaOfEffect( AOE_MOB_DRAGON_FEAR, "unholyauraenter", "****", "unholyauraexit" );
        effect eDimVis = EffectVisualEffect( VFX_DUR_ANTI_LIGHT_10 );
        effect eSkin = EffectVisualEffect( VFX_DUR_ICESKIN );
        effect eLink = EffectLinkEffects( eUnholyAura, eDimVis );
               eLink = EffectLinkEffects( eSkin, eLink );
               eLink = SupernaturalEffect( eLink );

        //Gather random targetting data
        DelayCommand( 0.5, GenerateTargets( oCritter ) );

        //Aplly Unholy Aura
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oCritter ) );

        //Set up breath weapon
        int nBreathUse = d2(2);
        DelayCommand( 0.5, SetLocalInt( oCritter, "BreathUse", nBreathUse ) );

        //Set up random abilities
        int nAbilityUse = d2(3);
        DelayCommand( 0.5, SetLocalInt( oCritter, "AbilityUse", nAbilityUse ) );

        //Set up fake heartbeat for determining ability usage
        DelayCommand( 5.5, AssignCommand( oCritter, DoWastrilithHeartB( oCritter ) ) );
    }
    else if( sIdentity == "water_vortex" )
    {
        effect eAura = EffectAreaOfEffect( AOE_MOB_FROST, "watervortexenter", "****", "****" );
               eAura = SupernaturalEffect( eAura );
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eAura, oCritter ) );
    }
    else if( sIdentity == "obyrith_uzollru" )
    {
        effect eMadness = EffectAreaOfEffect( AOE_MOB_INVISIBILITY_PURGE, "****", "oby_madness_hrtb", "****" );
        effect eSkin = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );
        effect eLink = EffectLinkEffects( eMadness, eSkin );
               eLink = SupernaturalEffect( eLink );
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oCritter ) );

        //Gather random targetting data
        DelayCommand( 0.5, GenerateTargets( oCritter ) );

        //Set up stunning gaze
        int nGazeUse = d2(2) + 1;
        DelayCommand( 0.5, SetLocalInt( oCritter, "GazeUse", nGazeUse ) );

        //Set up fake heartbeat for determining ability usage
        DelayCommand( 5.5, AssignCommand( oCritter, DoUzollruHeartB( oCritter ) ) );
    }

    //Continue with standard script
    DelayCommand( SPAWNBUFFDELAY, OnSpawnRoutines( oCritter ) );

    CreateMySpellLists( oCritter );

    SetLocalString( oCritter, "ai", "ds_ai2" );

    //silent communication
    SetListening( OBJECT_SELF, TRUE );
    SetListenPattern( OBJECT_SELF, M_ATTACKED, 1001 );

    //set TS on self if it's on the hide.
    //you can't detect hide properties like effects
    object oHide = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oCritter );

    itemproperty IP = GetFirstItemProperty( oHide );

    while( GetIsItemPropertyValid( IP ) ){

        if( GetItemPropertyType( IP ) == ITEM_PROPERTY_TRUE_SEEING ) {

            effect eTS = SupernaturalEffect( EffectTrueSeeing() );

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eTS, oCritter );

            return;
        }

        IP = GetNextItemProperty( oHide );
    }
}

void GenerateTargets( object oCritter )
{
    location lCritter = GetLocation( oCritter );
    int nCritters = GetLocalInt( oCritter, "enemies" );
    object oTarget  = GetFirstObjectInShape( SHAPE_SPHERE, 300.0, lCritter, FALSE, OBJECT_TYPE_CREATURE );

    while ( GetIsObjectValid( oTarget ) )
    {
        if ( GetIsEnemy( oTarget, oCritter ) == TRUE && GetIsPC( oTarget ) == TRUE )
        {
            ++nCritters;
            SetLocalObject( oCritter, "pc_"+IntToString( nCritters ), oTarget );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 300.0, lCritter, FALSE, OBJECT_TYPE_CREATURE );
    }
    SetLocalInt( oCritter, "enemies", nCritters );
}

void DoWastrilithHeartB( object oCritter )
{
    //Make sure it isn't still doing stuff while dead
    if( GetIsDead( oCritter ) )
    {
        return;
    }

    //Breath Weapon status
    int nBreathCount = GetLocalInt( oCritter, "BreathCount" );
    int nBreath = GetLocalInt( oCritter, "BreathUse" );
    //Random Abilities status
    int nAbilityCount = GetLocalInt( oCritter, "AbilityCount" );
    int nAbility = GetLocalInt( oCritter, "AbilityUse" );

    if( nBreathCount == nBreath )
    {
        //Override Targetting AI
        SetLocalInt( oCritter, "OverrideAI", 1 );

        //Make sure that Breath Weapon and Special Ability aren't trying to
        //trigger at the same time and if so, bump Special Ability by 1 round
        if( nAbilityCount == nAbility )
        {
            nAbilityCount = nAbilityCount - 1;
            SetLocalInt( oCritter, "AbilityCount", nAbilityCount );
        }

        //Reset breath counter
        nBreath = d2(2);
        SetLocalInt( oCritter, "BreathUse", nBreath );
        SetLocalInt( oCritter, "BreathCount", 0 );

        //Breath Weapon - Cone of Steam every 1d4 rounds on nearest enemy
        object oTarget = GetNearestEnemy( oCritter );
        ClearAllActions();
        ActionCastFakeSpellAtObject( SPELLABILITY_DRAGON_BREATH_SLEEP, oTarget );
        DelayCommand( 5.0, DoConeOfSteam( oCritter, oTarget ) );

        //Make sure that standard AI functions are enabled again if they were disabled
        DelayCommand( 5.1, SetLocalInt( oCritter, "OverrideAI", 0 ) );
    }
    else
    {
        //Add one to breath counter
        nBreathCount = nBreathCount + 1;
        SetLocalInt( oCritter, "BreathCount", nBreathCount );
    }

    if( nAbilityCount == nAbility )
    {
        //Override Targetting AI
        SetLocalInt( oCritter, "OverrideAI", 1 );

        //Choose which ability
        int nRandomAbility = d4(1);

        //1) Unholy Blight at location of Random Target
        if( nRandomAbility == 1 )
        {
            object oTarget = GetRandomEnemy( oCritter );
            location lTarget = GetLocation( oTarget );
            effect eVis = EffectVisualEffect( VFX_FNF_PWKILL );

            ClearAllActions();
            ActionCastFakeSpellAtObject( SPELL_DEATH_ARMOR, oCritter );
            DelayCommand( 3.5, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, lTarget ) );
            DelayCommand( 5.0, DoUnholyBlight( oCritter, lTarget ) );
        }
        //2 & 3) Wall of Ice at location of Random Target
        if( nRandomAbility == 2 || nRandomAbility == 3 )
        {
            int nWall = GetLocalInt( oCritter, "IceWall" );
            nWall = nWall + 1;
            string sWall = IntToString( nWall );
            sWall = "wall_of_ice_"+sWall;

            object oTarget = GetRandomEnemy( oCritter );

            location lTarget = GetLocation( oTarget );
            effect eIce = EffectVisualEffect( VFX_DUR_ICESKIN );
            effect eStorm = EffectVisualEffect( VFX_FNF_ICESTORM );

            ClearAllActions();
            ActionCastFakeSpellAtLocation( SPELL_ICE_STORM, lTarget );
            DelayCommand( 3.5, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eStorm, lTarget ) );
            DelayCommand( 4.8, CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "wall_of_ice", lTarget, FALSE, sWall, 1800.0 ) );
            DelayCommand( 4.9, TurnToFaceObject( oCritter, GetNearestObjectByTag( sWall ) ) );
            DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eIce, GetNearestObjectByTag( sWall ) ) );

            SetLocalInt( oCritter, "IceWall", nWall );
        }
        //4) Summon Critters at location of Random Target
        if( nRandomAbility == 4 )
        {
            object oTarget = GetRandomEnemy( oCritter );
            location lTarget = GetLocation( oTarget );
            effect eVis = EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION );

            ClearAllActions();
            ActionCastFakeSpellAtLocation( SPELL_SUMMON_CREATURE_IX, lTarget );

            DelayCommand( 3.5, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, lTarget ) );
            DelayCommand( 5.0, DoWastrilithSummon( oCritter, lTarget ) );
        }

        //Reset ability counter
        nAbility = d2(3);
        SetLocalInt( oCritter, "AbilityUse", nAbility );
        SetLocalInt( oCritter, "AbilityCount", 0 );

        //Make sure that standard AI functions are enabled again if they were disabled
        DelayCommand( 5.1, SetLocalInt( oCritter, "OverrideAI", 0 ) );
    }
    else
    {
        //Add one to ability counter
        nAbilityCount = nAbilityCount + 1;
        SetLocalInt( oCritter, "AbilityCount", nAbilityCount );
    }
    //Repeat in 6 seconds for fake heartbeat
    DelayCommand( 6.0, AssignCommand( oCritter, DoWastrilithHeartB( oCritter ) ) );
}

void DoUzollruHeartB( object oCritter )
{
    //Make sure it isn't still doing stuff while dead
    if( GetIsDead( oCritter ) )
    {
        return;
    }

    //Stunning Gaze status
    int nGazeCount = GetLocalInt( oCritter, "GazeCount" );
    int nGaze = GetLocalInt( oCritter, "GazeUse" );

    if( nGazeCount == nGaze )
    {
        //Reset breath counter
        nGaze = d2(2) + 1;
        SetLocalInt( oCritter, "GazeUse", nGaze );
        SetLocalInt( oCritter, "GazeCount", 0 );

        //Only actually use the Gaze if not Blinded currently
        if( !GZCanNotUseGazeAttackCheck( oCritter ) )
        {
            //Override Targetting AI
            SetLocalInt( oCritter, "OverrideAI", 1 );

            //Debug
            SpeakString( "Starting: Stunning Gaze" );

            //Stunning Gaze - Cone of Stun every 2d2 rounds on nearest enemy
            object oTarget = GetNearestEnemy( oCritter );
            ClearAllActions();
            ActionCastFakeSpellAtObject( SPELLABILITY_GAZE_STUNNED, oTarget );
            DelayCommand( 5.0, DoStunGaze( oCritter, oTarget ) );

            //Make sure that standard AI functions are enabled again if they were disabled
            DelayCommand( 5.1, SetLocalInt( oCritter, "OverrideAI", 0 ) );
        }
    }
    else
    {
        //Add one to gaze counter
        nGazeCount = nGazeCount + 1;
        SetLocalInt( oCritter, "GazeCount", nGazeCount );
    }

    //Tentacle Attacks on 5 nearest targets within 10 meters every round
    int nCycle = 1;
    int nCounter = 0;
    object oTarget = GetNearestPerceivedEnemy( oCritter, nCycle, CREATURE_TYPE_IS_ALIVE, TRUE );
    float fRange = GetDistanceBetween( oCritter, oTarget );

    while( nCounter < 5 && fRange <= 10.0 && GetIsObjectValid( oTarget ) )
    {
        int nTentacle = TouchAttackMelee( oTarget );
        int nDamage = d8(2) + 13;

        if( nTentacle == 1 )
        {
            effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL );
            effect eBeam = EffectBeam( VFX_BEAM_BLACK, oCritter, BODY_NODE_CHEST, FALSE );
            effect eTentacle = EffectVisualEffect( VFX_DUR_TENTACLE );
            effect eConHit = EffectAbilityDecrease( ABILITY_CONSTITUTION, d6(1) );
                   eConHit = MagicalEffect( eConHit );
            effect eConVis = EffectVisualEffect( VFX_IMP_REDUCE_ABILITY_SCORE );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 6.0 );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTentacle, oTarget, 6.0 );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eConVis, oTarget );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eConHit, oTarget );
        }
        else if( nTentacle == 2 )
        {
            nDamage = nDamage * 2;
            effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL );
            effect eBeam = EffectBeam( VFX_BEAM_BLACK, oCritter, BODY_NODE_CHEST, FALSE );
            effect eTentacle = EffectVisualEffect( VFX_DUR_TENTACLE );
            effect eConHit = EffectAbilityDecrease( ABILITY_CONSTITUTION, d6(1) );
                   eConHit = MagicalEffect( eConHit );
            effect eConVis = EffectVisualEffect( VFX_IMP_REDUCE_ABILITY_SCORE );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 6.0 );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTentacle, oTarget, 6.0 );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eConVis, oTarget );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eConHit, oTarget );
        }
        nCounter = nCounter + 1;
        nCycle = nCycle + 1;
        oTarget = GetNearestPerceivedEnemy( oCritter, nCycle, CREATURE_TYPE_IS_ALIVE, TRUE );
        fRange = GetDistanceBetween( oCritter, oTarget );
    }

    //Repeat in 6 seconds for fake heartbeat
    DelayCommand( 6.0, AssignCommand( oCritter, DoUzollruHeartB( oCritter ) ) );
}

void DoUnholyBlight( object oCritter, location lTarget )
{
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 6.1, lTarget, FALSE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        //Full Damage to Good - Half Damage to Neutral - No Damage to Evil
        int nAlign = GetAlignmentGoodEvil( oTarget );

        if( nAlign == ALIGNMENT_EVIL )
        {
            return;
        }
        else if( nAlign == ALIGNMENT_GOOD )
        {
            int nDamage;
            effect eImpact = EffectVisualEffect( VFX_IMP_DISEASE_S );

            int nRace = GetRacialType( oTarget );
            //More damage to Good Outsiders
            if( nRace == RACIAL_TYPE_OUTSIDER )
            {
                nDamage = d10(6) + 30;
            }
            else
            {
                nDamage = d8(5) + 15;
            }

            //Will save for half damage and no sickness
            int nWill = WillSave( oTarget, 38, SAVING_THROW_TYPE_EVIL, oCritter );
            if( nWill == 0 )
            {
                //Sickness
                effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
                effect eAttack = EffectAttackDecrease(2);
                effect eDamagePen = EffectDamageDecrease(2);
                effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
                effect eSick = EffectLinkEffects(eAttack, eDamagePen);
                       eSick = EffectLinkEffects(eSick, eSaves);
                       eSick = EffectLinkEffects(eSick, eSkill);
                       eSick = ExtraordinaryEffect( eSick );
                float fDur = IntToFloat( d4(1) );
                //Damage
                effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSick, oTarget, fDur );
            }
            else if( nWill == 1 )
            {
                nDamage = nDamage / 2;
                effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget );
            }
            SignalEvent( oTarget, EventSpellCastAt( oCritter, SPELL_STINKING_CLOUD ) );
        }
        //Neutral not affected by Sickness
        else if( nAlign == ALIGNMENT_NEUTRAL )
        {
            int nDamage = d8(5) + 15;
            nDamage = nDamage / 2;
            effect eImpact = EffectVisualEffect( VFX_IMP_DISEASE_S );

            //Will save for half damage
            int nWill = WillSave( oTarget, 38, SAVING_THROW_TYPE_EVIL, oCritter );
            if( nWill == 0 )
            {
                effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget );
            }
            else if( nWill == 1 )
            {
                nDamage = nDamage / 2;
                effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget );
            }
            SignalEvent( oTarget, EventSpellCastAt( oCritter, SPELL_STINKING_CLOUD ) );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 6.1, lTarget, FALSE, OBJECT_TYPE_CREATURE );
    }
}

void DoConeOfSteam( object oCritter, object oTarget )
{
    location lTarget = GetLocation( oTarget );

    oTarget = GetFirstObjectInShape( SHAPE_SPELLCONE, 18.3, lTarget, TRUE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        int nDamage = d10(3) + 30;
        nDamage = GetReflexAdjustedDamage( nDamage, oTarget, 40, SAVING_THROW_TYPE_FIRE, oCritter );

        if( nDamage != 0 && oTarget != oCritter )
        {
            effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY );
            effect eImpact = EffectVisualEffect( VFX_DUR_GHOST_SMOKE_2 );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImpact, oTarget, 4.0 );

            SignalEvent( oTarget, EventSpellCastAt( oCritter, SPELLABILITY_DRAGON_BREATH_WEAKEN ) );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPELLCONE, 18.3, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }
}

void DoStunGaze( object oCritter, object oTarget )
{
    location lTarget = GetLocation( oTarget );

    oTarget = GetFirstObjectInShape( SHAPE_SPELLCONE, 18.3, lTarget, TRUE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        int nWill = WillSave( oTarget, 38, SAVING_THROW_TYPE_MIND_SPELLS, oCritter );

        if( nWill == 0 )
        {
            effect eStun = EffectStunned();
            effect eDur = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
            effect eImpact = EffectVisualEffect( VFX_IMP_STUN );
            effect eLink = EffectLinkEffects( eStun, eDur );
                   eLink = SupernaturalEffect( eLink );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, 12.0 );
            SignalEvent( oTarget, EventSpellCastAt( oCritter, SPELLABILITY_GAZE_STUNNED ) );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPELLCONE, 18.3, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }
}

void DoWastrilithSummon( object oCritter, location lTarget )
{
    CreateObjectVoid( OBJECT_TYPE_CREATURE, "water_vortex", lTarget, FALSE, "", 120.0 );
    CreateObject( OBJECT_TYPE_CREATURE, "abyss_lacedon", lTarget );
    CreateObject( OBJECT_TYPE_CREATURE, "abyss_lacedon", lTarget );
    CreateObject( OBJECT_TYPE_CREATURE, "abyss_lacedon", lTarget );
}
