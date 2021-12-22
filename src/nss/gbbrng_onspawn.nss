//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  gbbrng_onspawn
//group:   ds_ai
//used as: OnSpawn for Brood Gibberling, Gibberslug, Gibbering Mouther and Alienist
//date:    sept 15 2012
//author:  disco (modified by Glim)

//  20071119  disco       Moved cleanup scripts to amia_include

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void DoSlugGrowth( object oCritter );
void SpawnPhase1( object oCritter );
void PortToStation( object oCritter );
void DoTakeCoverEmote( object oCritter );
void ChaosBlast( object oCritter );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oCritter = OBJECT_SELF;
    float scale = GetLocalFloat(oCritter, "scale");

    //Accounting for floating point error.
    if(scale > 0.1f)
    {
        SetObjectVisualTransform(oCritter, 10, scale);
    }

    DelayCommand( SPAWNBUFFDELAY, OnSpawnRoutines( oCritter ) );

    CreateMySpellLists( oCritter );

    SetLocalString( oCritter, "ai", "ds_ai2" );

    //Identify creature using the script to know how to act
    string sIdentity = GetResRef(oCritter);

    if(sIdentity == "gibberling_brood")
    {
        effect eAura = EffectAreaOfEffect(AOE_MOB_MENACE, "", "", "");
        eAura = SupernaturalEffect(eAura);
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, oCritter));
    }

    if(sIdentity == "gibberling_slug")
    {
        DelayCommand(6.0, SetCreatureAppearanceType(oCritter, 833));
        DelayCommand(12.0, SetCreatureAppearanceType(oCritter, 835));
        DelayCommand(18.0, DoSlugGrowth(oCritter));
        return;
    }
    if(sIdentity == "gibberingmouther")
    {
        effect eBiteRadius = EffectAreaOfEffect(AOE_MOB_INVISIBILITY_PURGE, "****", "gbbrng_aura_rnd", "****");
        effect eGibbering = EffectAreaOfEffect(AOE_MOB_DRAGON_FEAR, "gbbrng_aura_in", "****", "****");

        eBiteRadius = SupernaturalEffect(eBiteRadius);
        eGibbering = SupernaturalEffect(eGibbering);
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBiteRadius, oCritter));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGibbering, oCritter));
        DelayCommand(0.5, SetLocalInt(oCritter, "Attacks", 6));
    }
    if(sIdentity == "alienist_boss_2")
    {
        effect eShield = EffectVisualEffect( VFX_DUR_GLOBE_MINOR );
        effect eSummon = EffectVisualEffect( VFX_FNF_SUMMON_MONSTER_2 );
        object oSummon = GetNearestObjectByTag( "alienist_spawn", oCritter );
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eShield, oCritter ) );
        DelayCommand( 2.0, ActionPlayAnimation( ANIMATION_LOOPING_DEAD_BACK, 1.0, 900.0 ) );
        DelayCommand( 11.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eSummon, GetLocation( oSummon ) ) );
        DelayCommand( 12.0, SpawnPhase1( oCritter ) );
        DelayCommand( 17.0, SetLocalObject( GetNearestObjectByTag( "alienist_boss_1" ), "Boss2", oCritter ) );
        DelayCommand( 30.0, SetLocalInt( oCritter, "CS_DSPWN", 2 ) );
        DelayCommand( 900.0, SafeDestroyObject( oCritter ) );
    }
    if(sIdentity == "alienist_boss_1")
    {
        effect eGhost = EffectCutsceneGhost();
               eGhost = SupernaturalEffect( eGhost );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eGhost, oCritter );

        object oPortal1 = GetNearestObjectByTag( "alien_portal_1", oCritter );
        object oPortal2 = GetNearestObjectByTag( "alien_portal_2", oCritter );
        object oPortal3 = GetNearestObjectByTag( "alien_portal_3", oCritter );
        object oPortal4 = GetNearestObjectByTag( "alien_portal_4", oCritter );

        location lPortal1 = GetLocation( oPortal1 );
        location lPortal2 = GetLocation( oPortal2 );
        location lPortal3 = GetLocation( oPortal3 );
        location lPortal4 = GetLocation( oPortal4 );

        CreateObject( OBJECT_TYPE_PLACEABLE, "alienist_portal", lPortal1, FALSE, "alien_node_1" );
        CreateObject( OBJECT_TYPE_PLACEABLE, "alienist_portal", lPortal2, FALSE, "alien_node_2" );
        CreateObject( OBJECT_TYPE_PLACEABLE, "alienist_portal", lPortal3, FALSE, "alien_node_3" );
        CreateObject( OBJECT_TYPE_PLACEABLE, "alienist_portal", lPortal4, FALSE, "alien_node_4" );

        object oNode1 = GetNearestObjectByTag( "alien_node_1" );
        object oNode2 = GetNearestObjectByTag( "alien_node_2" );
        object oNode3 = GetNearestObjectByTag( "alien_node_3" );
        object oNode4 = GetNearestObjectByTag( "alien_node_4" );

        effect eBeam1 = EffectBeam( VFX_BEAM_SILENT_ODD, oNode1, BODY_NODE_CHEST, FALSE );
        effect eBeam2 = EffectBeam( VFX_BEAM_SILENT_ODD, oNode2, BODY_NODE_CHEST, FALSE );
        effect eBeam3 = EffectBeam( VFX_BEAM_SILENT_ODD, oNode3, BODY_NODE_CHEST, FALSE );
        effect eBeam4 = EffectBeam( VFX_BEAM_SILENT_ODD, oNode4, BODY_NODE_CHEST, FALSE );

        effect eAura = EffectAreaOfEffect( AOE_MOB_DRAGON_FEAR, "chaos_zone_enter", "****", "chaos_zone_exit" );

        object oCrystal1 = GetNearestObjectByTag( "alien_growth_1", oCritter );
        object oCrystal2 = GetNearestObjectByTag( "alien_growth_2", oCritter );
        object oCrystal3 = GetNearestObjectByTag( "alien_growth_3", oCritter );
        object oCrystal4 = GetNearestObjectByTag( "alien_growth_4", oCritter );
        location lCrystal1 = GetLocation( oCrystal1 );
        location lCrystal2 = GetLocation( oCrystal2 );
        location lCrystal3 = GetLocation( oCrystal3 );
        location lCrystal4 = GetLocation( oCrystal4 );

        effect ePLCAura = EffectAreaOfEffect( AOE_MOB_MENACE, "chaos_zone_enter", "****", "chaos_zone_exit" );

        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, ePLCAura, lCrystal1, 1700.0 );
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, ePLCAura, lCrystal2, 1700.0 );
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, ePLCAura, lCrystal3, 1700.0 );
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, ePLCAura, lCrystal4, 1700.0 );

        DelayCommand( 1.0, SpeakString( "<c¥ ¥>STOP! You will not wake the Conduit.</c>" ) );

        DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBeam1, oCritter ) );
        DelayCommand( 6.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBeam2, oCritter ) );
        DelayCommand( 6.0, SpeakString( "<c¥ ¥>His will shall forge this realm for his Master, and yours shall be subsumed with all the other non-believers...</c>" ) );
        DelayCommand( 9.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBeam3, oCritter ) );
        DelayCommand( 12.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBeam4, oCritter ) );
        DelayCommand( 18.0, SetPlotFlag( oNode1, FALSE ) );
        DelayCommand( 18.0, SetPlotFlag( oNode2, FALSE ) );
        DelayCommand( 18.0, SetPlotFlag( oNode3, FALSE ) );
        DelayCommand( 18.0, SetPlotFlag( oNode4, FALSE ) );
        DelayCommand( 18.0, PortToStation( oCritter ) );
        DelayCommand( 19.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eAura, oCritter ) );
        DelayCommand( 888.0, SafeDestroyObject( oCritter ) );
    }


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

void DoSlugGrowth( object oCritter )
{
    location lCritter = GetLocation(oCritter);
    string sGrow = "<c¥  >**The Gibberslug has grown into a full sized Gibberling!**</c>";

    if(!GetIsDead(oCritter) && GetIsObjectValid(oCritter))
    {
        AssignCommand(oCritter, SpeakString(sGrow, TALKVOLUME_TALK));
        FloatingTextStringOnCreature(sGrow, oCritter, FALSE);

        DestroyObject(oCritter, 0.5);
        CreateObject(OBJECT_TYPE_CREATURE, "gibberling_norml", lCritter, FALSE, "");
    }
}

void SpawnPhase1( object oCritter )
{
    location lSpawn = GetLocation( GetNearestObjectByTag( "alienist_spawn", oCritter ) );
    CreateObject( OBJECT_TYPE_CREATURE, "alienist_boss_1", lSpawn );
}

void PortToStation( object oCritter )
{
    // Check for Barrier
    if( GetLocalInt( oCritter, "Barrier" ) == FALSE )
    {
        object oBarrier = GetNearestObjectByTag( "alienist_barrier", oCritter );
        location lBarrier = GetLocation( oBarrier );

        CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "scwall019", lBarrier, FALSE, "", 1800.0 );
        SetLocalInt( oCritter, "Barrier", 2 );
    }

    // Choose next location to stand in Phase 1
    string sStation;
    int nStation = d4(1);

    switch (nStation)
    {
        case 1:     sStation = "alien_port_s";       break;
        case 2:     sStation = "alien_port_w";       break;
        case 3:     sStation = "alien_port_e";       break;
        case 4:     sStation = "alien_port_n";       break;
        default:    break;
    }

    // Choose flavor speach
    int nSpeak1 = d3(1);
    string sSpeak1;
    string sSpeak2;

    switch (nSpeak1)
    {
        case 1:     sSpeak1 = "<c¥ ¥>Subsume the will...</c>";
                    sSpeak2 = "<c¥ ¥>...that all may know the truth!</c>";  break;
        case 2:     sSpeak1 = "<c¥ ¥>Harvest the seed...</c>";
                    sSpeak2 = "<c¥ ¥>...and bask in ultimate power!</c>";   break;
        case 3:     sSpeak1 = "<c¥ ¥>Cleanse the way...</c>";
                    sSpeak2 = "<c¥ ¥>...for the Master comes!</c>";         break;
    }

    // Move to new location and set ability delays
    object oFacing = GetNearestObjectByTag( "CS_WP_BOSS" );
    effect eConjure = EffectVisualEffect( VFX_FNF_PWKILL );
    effect ePulse = EffectVisualEffect( VFX_IMP_PDK_GENERIC_PULSE );
    effect ePort = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_EVIL );
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, ePort, GetLocation( oCritter ) );
    DelayCommand( 1.0, JumpToObject( GetNearestObjectByTag( sStation ) ) );
    DelayCommand( 1.1, TurnToFaceObject( oFacing, oCritter ) );
    DelayCommand( 40.9, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, ePort, GetLocation( oCritter ) ) );
    DelayCommand( 41.0, JumpToObject( GetNearestObjectByTag( "alienist_spawn" ) ) );
    DelayCommand( 41.1, TurnToFaceObject( oFacing, oCritter ) );
    DelayCommand( 42.0, SpeakString( sSpeak1 ) );
    DelayCommand( 42.5, DoTakeCoverEmote( oCritter ) );
    DelayCommand( 42.0, ActionPlayAnimation( ANIMATION_LOOPING_CONJURE1, 1.0, 8.0 ) );
    DelayCommand( 42.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eConjure, oCritter, 8.0 ) );
    DelayCommand( 49.0, SpeakString( sSpeak2 ) );
    DelayCommand( 50.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, ePulse, oCritter ) );
    DelayCommand( 50.0, ChaosBlast( oCritter ) );

    // Spawn adds
    DelayCommand(1.0, SpeakString( "<c¥ ¥>COME FORTH, MY BRETHREN!</c>" ) );

    int nCounter = GetLocalInt( oCritter, "Counter" );
    location lPortal1 = GetLocation( GetNearestObjectByTag( "alien_node_1" ) );
    location lPortal2 = GetLocation( GetNearestObjectByTag( "alien_node_2" ) );
    location lPortal3 = GetLocation( GetNearestObjectByTag( "alien_node_3" ) );
    location lPortal4 = GetLocation( GetNearestObjectByTag( "alien_node_4" ) );
    effect eAppear = EffectVisualEffect( VFX_IMP_DESTRUCTION );

    if( nCounter <= 1 )
    {
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eAppear, lPortal1 );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lPortal1 );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eAppear, lPortal2 );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lPortal2 );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eAppear, lPortal3 );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lPortal3 );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eAppear, lPortal4 );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lPortal4 );
    }
    if( nCounter >= 2 )
    {
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eAppear, lPortal1 );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_brood", lPortal1 );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eAppear, lPortal2 );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_brood", lPortal2 );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eAppear, lPortal3 );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_brood", lPortal3 );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eAppear, lPortal4 );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_brood", lPortal4 );
    }
}

void DoTakeCoverEmote( object oCritter )
{
    location lCritter = GetLocation( oCritter );
    object oPC = GetFirstObjectInShape( SHAPE_SPHERE, 100.0, lCritter, FALSE, OBJECT_TYPE_CREATURE);

    while( GetIsObjectValid( oPC) )
    {
        if( GetIsPC( oPC) )
        {
            AssignCommand( oPC, SpeakString( "Take cover behind the pillars!" ) );
        }
        oPC = GetNextObjectInShape( SHAPE_SPHERE, 100.0, lCritter, FALSE, OBJECT_TYPE_CREATURE);
    }
}

void ChaosBlast( object oCritter )
{
    location lCritter = GetLocation( oCritter );
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 200.0, lCritter, TRUE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        if(GetRacialType( oTarget ) != RACIAL_TYPE_ABERRATION )
        {
            float fMaxHP = IntToFloat( GetMaxHitPoints( oTarget ) );
            int nFailed = FloatToInt( fMaxHP * 0.7 );
            int nSuccess = FloatToInt( fMaxHP * 0.4 );

            int iRandom = d6(1);

            if( iRandom == 1 )
            {
                int iReflex = ReflexSave( oTarget, 18, SAVING_THROW_TYPE_CHAOS, oCritter );

                if( iReflex == 0 )
                {
                    effect eFire = EffectDamage( nFailed, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY );
                    effect eVis = EffectVisualEffect( VFX_IMP_FLAME_S );

                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eFire, oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                else if( iReflex == 1)
                {
                    effect eFire = EffectDamage( nSuccess, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY );
                    effect eVis = EffectVisualEffect( VFX_IMP_FLAME_S );

                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eFire, oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
            if( iRandom == 2 )
            {
                int iReflex = ReflexSave( oTarget, 18, SAVING_THROW_TYPE_CHAOS, oCritter );

                if( iReflex == 0 )
                {
                    effect eAcid = EffectDamage( nFailed, DAMAGE_TYPE_ACID, DAMAGE_POWER_ENERGY );
                    effect eVis = EffectVisualEffect( VFX_IMP_ACID_S );

                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eAcid, oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                else if( iReflex == 1)
                {
                    effect eAcid = EffectDamage( nSuccess, DAMAGE_TYPE_ACID, DAMAGE_POWER_ENERGY );
                    effect eVis = EffectVisualEffect( VFX_IMP_ACID_S );

                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eAcid, oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
            if( iRandom == 3 )
            {
                int iReflex = ReflexSave( oTarget, 18, SAVING_THROW_TYPE_CHAOS, oCritter );

                if( iReflex == 0 )
                {
                    effect eCold = EffectDamage( nFailed, DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY );
                    effect eVis = EffectVisualEffect( VFX_IMP_FROST_S );

                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eCold, oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                else if( iReflex == 1)
                {
                    effect eCold = EffectDamage( nSuccess, DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY );
                    effect eVis = EffectVisualEffect( VFX_IMP_FROST_S );

                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eCold, oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
            if( iRandom == 4 )
            {
                int iReflex = ReflexSave( oTarget, 18, SAVING_THROW_TYPE_CHAOS, oCritter );

                if( iReflex == 0 )
                {
                    effect eElec = EffectDamage( nFailed, DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_ENERGY );
                    effect eVis = EffectVisualEffect( VFX_IMP_LIGHTNING_S );

                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eElec, oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                else if( iReflex == 1)
                {
                    effect eElec = EffectDamage( nSuccess, DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_ENERGY );
                    effect eVis = EffectVisualEffect( VFX_IMP_LIGHTNING_S );

                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eElec, oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
            if( iRandom == 5 )
            {
                int iFort = FortitudeSave( oTarget, 18, SAVING_THROW_TYPE_CHAOS, oCritter );

                if( iFort == 0 )
                {
                    effect eWeak = EffectAbilityDecrease( ABILITY_STRENGTH, d3(2) );
                    effect eVis = EffectVisualEffect( VFX_IMP_REDUCE_ABILITY_SCORE );

                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eWeak, oTarget, 12.0 );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
                }
            }
            if( iRandom == 6 )
            {
                int iFort = FortitudeSave( oTarget, 18, SAVING_THROW_TYPE_CHAOS, oCritter );

                if( iFort == 0 )
                {
                    effect eSick = EffectAbilityDecrease( ABILITY_CONSTITUTION, d3(2) );
                    effect eVis = EffectVisualEffect( VFX_IMP_DESTRUCTION );

                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSick, oTarget, 12.0 );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
                }
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 200.0, lCritter, TRUE, OBJECT_TYPE_CREATURE );
    }

    PortToStation( oCritter );
}
