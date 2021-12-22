//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai_damaged
//group:   ds_ai
//used as: OnDamage
//date:    dec 23 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
object oCritter = OBJECT_SELF;
object oTarget;

void TrapSoul(object oCritter, object oTarget);
void StasisTouch(object oCritter, object oTarget);
void Teleport(object oCritter);
void SpawnAdd(object oCritter);
void RefreshTargetList(object oCritter);

void main(){

    object oDamager     = GetLastDamager();
    object oTarget      = GetLocalObject( oCritter, L_CURRENTTARGET );
    string sArchetype   = GetLocalString( oCritter, L_ARCHETYPE );
    int nReaction       = GetReaction( oCritter, oDamager );

    //Trap Soul at 50% HP
    if(GetPercentageHPLoss(oCritter) <= 50 && GetLocalInt(oCritter, "TSCount") == 1)
    {
        SetLocalInt(oCritter, "TSCount", 2);
        object oTarget = GetRandomEnemy(oCritter);

        if ( oTarget == OBJECT_INVALID )
        {
            return;
        }
        TrapSoul(oCritter, oTarget);
    }
    //Stasis Touch at 90%, 60% and 30% HP
    if(GetPercentageHPLoss(oCritter) <= 90 && GetLocalInt(oCritter, "STCount") == 1)
    {
        SetLocalInt(oCritter, "STCount", 2);
        object oTarget = GetRandomEnemy(oCritter);
        RefreshTargetList(oCritter);

        if ( oTarget == OBJECT_INVALID )
        {
            return;
        }
        StasisTouch(oCritter, oTarget);
    }
    if(GetPercentageHPLoss(oCritter) <= 60 && GetLocalInt(oCritter, "STCount") == 2)
    {
        SetLocalInt(oCritter, "STCount", 3);
        object oTarget = GetRandomEnemy(oCritter);
        RefreshTargetList(oCritter);

        if ( oTarget == OBJECT_INVALID )
        {
            return;
        }
        StasisTouch(oCritter, oTarget);
    }
    if(GetPercentageHPLoss(oCritter) <= 30 && GetLocalInt(oCritter, "STCount") == 3)
    {
        SetLocalInt(oCritter, "STCount", 4);
        object oTarget = GetRandomEnemy(oCritter);
        RefreshTargetList(oCritter);

        if ( oTarget == OBJECT_INVALID )
        {
            return;
        }
        StasisTouch(oCritter, oTarget);
    }
    //Greater Teleport at 90%, 75%, 50%, 25%, 10% HP to random waypoint & ability links
    if(GetPercentageHPLoss(oCritter) <= 90 && GetLocalInt(oCritter, "GTCount") == 1)
    {
        SetLocalInt(oCritter, "GTCount", 2);
        SpawnAdd(oCritter);
        Teleport(oCritter);
    }
    if(GetPercentageHPLoss(oCritter) <= 75 && GetLocalInt(oCritter, "GTCount") == 2)
    {
        SetLocalInt(oCritter, "GTCount", 3);
        SpawnAdd(oCritter);
        Teleport(oCritter);
    }
    if(GetPercentageHPLoss(oCritter) <= 50 && GetLocalInt(oCritter, "GTCount") == 3)
    {
        SetLocalInt(oCritter, "GTCount", 4);
        SpawnAdd(oCritter);
        Teleport(oCritter);
    }
    if(GetPercentageHPLoss(oCritter) <= 25 && GetLocalInt(oCritter, "GTCount") == 4)
    {
        SetLocalInt(oCritter, "GTCount", 5);
        SpawnAdd(oCritter);
        Teleport(oCritter);
    }
    if(GetPercentageHPLoss(oCritter) <= 10 && GetLocalInt(oCritter, "GTCount") == 5)
    {
        SpawnAdd(oCritter);
        Teleport(oCritter);
        SetLocalInt(oCritter, "GTCount", 6);
    }

    //Continue with standard script
    if ( nReaction == 2 ){

        if ( GetDistanceBetween( oCritter, oDamager ) < 5.0 ){

            ClearAllActions();
            ActionMoveAwayFromObject( oDamager, TRUE, 10.0 );
            SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
        }
    }
    else if ( nReaction == 1 ){

        if ( oTarget != oDamager ){

            if ( GetObjectSeen( oDamager, oCritter ) && ( d100() - 20 ) < 25 ){

                SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
            }
        }
    }
}

void TrapSoul(object oCritter, object oTarget)
{
    location lTarget = GetLocation(oTarget);
    CreateObject(OBJECT_TYPE_PLACEABLE, "temporalsoulcyst", lTarget);

    string sName = GetName(oTarget);
    string sSpeak = "**The Quarut throws a Temporal Cyst at " + sName + " , trapping their soul within!**";
    FloatingTextStringOnCreature(sSpeak, oCritter, FALSE);
    SpeakString(sSpeak, TALKVOLUME_SHOUT);

    SetLocalInt(oTarget, "TrapSoul", 2);
    SetLocalInt(oTarget, "HasQuarutAbility", 2);

    object oCyst = GetNearestObjectByTag("temporalsoulcyst", oTarget);
    event eCystSpawn = EventUserDefined(33333);
    DelayCommand(0.1, SetLocalObject(oCyst, "trapedsoul", oTarget));
    DelayCommand(0.2, SignalEvent(oCyst, eCystSpawn));
}

void StasisTouch(object oCritter, object oTarget)
{
    // Damage immunities.
    effect eDamage1     = EffectDamageImmunityIncrease( DAMAGE_TYPE_ACID, 100 );
    effect eDamage2     = EffectDamageImmunityIncrease( DAMAGE_TYPE_BLUDGEONING, 100 );
    effect eDamage3     = EffectDamageImmunityIncrease( DAMAGE_TYPE_COLD, 100 );
    effect eDamage4     = EffectDamageImmunityIncrease( DAMAGE_TYPE_DIVINE, 100 );
    effect eDamage5     = EffectDamageImmunityIncrease( DAMAGE_TYPE_ELECTRICAL, 100 );
    effect eDamage6     = EffectDamageImmunityIncrease( DAMAGE_TYPE_FIRE, 100 );
    effect eDamage7     = EffectDamageImmunityIncrease( DAMAGE_TYPE_MAGICAL, 100 );
    effect eDamage8     = EffectDamageImmunityIncrease( DAMAGE_TYPE_NEGATIVE, 100 );
    effect eDamage9     = EffectDamageImmunityIncrease( DAMAGE_TYPE_PIERCING, 100 );
    effect eDamage10    = EffectDamageImmunityIncrease( DAMAGE_TYPE_POSITIVE, 100 );
    effect eDamage11    = EffectDamageImmunityIncrease( DAMAGE_TYPE_SLASHING, 100 );
    effect eDamage12    = EffectDamageImmunityIncrease( DAMAGE_TYPE_SONIC, 100 );

    // Status immunities.
    effect eImmunity1   = EffectImmunity( IMMUNITY_TYPE_ABILITY_DECREASE );
    effect eImmunity2   = EffectImmunity( IMMUNITY_TYPE_AC_DECREASE );
    effect eImmunity3   = EffectImmunity( IMMUNITY_TYPE_ATTACK_DECREASE );
    effect eImmunity4   = EffectImmunity( IMMUNITY_TYPE_BLINDNESS );
    effect eImmunity5   = EffectImmunity( IMMUNITY_TYPE_CRITICAL_HIT );
    effect eImmunity6   = EffectImmunity( IMMUNITY_TYPE_CURSED );
    effect eImmunity7   = EffectImmunity( IMMUNITY_TYPE_ABILITY_DECREASE );
    effect eImmunity8   = EffectImmunity( IMMUNITY_TYPE_DAMAGE_DECREASE );
    effect eImmunity9   = EffectImmunity( IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE );
    effect eImmunity10  = EffectImmunity( IMMUNITY_TYPE_DEAFNESS );
    effect eImmunity11  = EffectImmunity( IMMUNITY_TYPE_DEATH );
    effect eImmunity12  = EffectImmunity( IMMUNITY_TYPE_DISEASE );
    effect eImmunity13  = EffectImmunity( IMMUNITY_TYPE_ENTANGLE );
    effect eImmunity14  = EffectImmunity( IMMUNITY_TYPE_KNOCKDOWN );
    effect eImmunity15  = EffectImmunity( IMMUNITY_TYPE_MIND_SPELLS );
    effect eImmunity16  = EffectImmunity( IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE );
    effect eImmunity17  = EffectImmunity( IMMUNITY_TYPE_NEGATIVE_LEVEL );
    effect eImmunity18  = EffectImmunity( IMMUNITY_TYPE_POISON );
    effect eImmunity19  = EffectImmunity( IMMUNITY_TYPE_SAVING_THROW_DECREASE );
    effect eImmunity20  = EffectImmunity( IMMUNITY_TYPE_SILENCE );
    effect eImmunity21  = EffectImmunity( IMMUNITY_TYPE_SKILL_DECREASE );
    effect eImmunity22  = EffectImmunity( IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE );
    effect eImmunity23  = EffectImmunity( IMMUNITY_TYPE_SNEAK_ATTACK );
    effect eImmunity24  = EffectImmunity( IMMUNITY_TYPE_SLOW );
    effect eImmunity25  = EffectImmunity( IMMUNITY_TYPE_SLEEP );

    // Link it all together... this goes on a while.
    effect eStop        = EffectCutsceneParalyze();
    effect eVis1        = EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION );
    effect eVis2        = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);

    effect eLink        = EffectLinkEffects( eDamage1, eLink );
           eLink        = EffectLinkEffects( eDamage2, eLink );
           eLink        = EffectLinkEffects( eDamage3, eLink );
           eLink        = EffectLinkEffects( eDamage4, eLink );
           eLink        = EffectLinkEffects( eDamage5, eLink );
           eLink        = EffectLinkEffects( eDamage6, eLink );
           eLink        = EffectLinkEffects( eDamage7, eLink );
           eLink        = EffectLinkEffects( eDamage8, eLink );
           eLink        = EffectLinkEffects( eDamage9, eLink );
           eLink        = EffectLinkEffects( eDamage10, eLink );
           eLink        = EffectLinkEffects( eDamage11, eLink );
           eLink        = EffectLinkEffects( eDamage12, eLink );
           eLink        = EffectLinkEffects( eImmunity1, eLink );
           eLink        = EffectLinkEffects( eImmunity2, eLink );
           eLink        = EffectLinkEffects( eImmunity3, eLink );
           eLink        = EffectLinkEffects( eImmunity4, eLink );
           eLink        = EffectLinkEffects( eImmunity5, eLink );
           eLink        = EffectLinkEffects( eImmunity6, eLink );
           eLink        = EffectLinkEffects( eImmunity7, eLink );
           eLink        = EffectLinkEffects( eImmunity8, eLink );
           eLink        = EffectLinkEffects( eImmunity9, eLink );
           eLink        = EffectLinkEffects( eImmunity10, eLink );
           eLink        = EffectLinkEffects( eImmunity11, eLink );
           eLink        = EffectLinkEffects( eImmunity12, eLink );
           eLink        = EffectLinkEffects( eImmunity13, eLink );
           eLink        = EffectLinkEffects( eImmunity14, eLink );
           eLink        = EffectLinkEffects( eImmunity15, eLink );
           eLink        = EffectLinkEffects( eImmunity16, eLink );
           eLink        = EffectLinkEffects( eImmunity17, eLink );
           eLink        = EffectLinkEffects( eImmunity18, eLink );
           eLink        = EffectLinkEffects( eImmunity19, eLink );
           eLink        = EffectLinkEffects( eImmunity20, eLink );
           eLink        = EffectLinkEffects( eImmunity21, eLink );
           eLink        = EffectLinkEffects( eImmunity22, eLink );
           eLink        = EffectLinkEffects( eImmunity23, eLink );
           eLink        = EffectLinkEffects( eImmunity24, eLink );
           eLink        = EffectLinkEffects( eImmunity25, eLink );
           eLink        = EffectLinkEffects( eStop, eLink);
           eLink        = EffectLinkEffects( eVis1, eLink);
           eLink        = EffectLinkEffects( eVis2, eLink);

    eLink = SupernaturalEffect(eLink);

    object oCritter = OBJECT_SELF;
    location lCritter = GetLocation(oCritter);

    string sName = GetName(oTarget);

    if (FortitudeSave(oTarget, 25) == 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 900.0);

        string sSpeak = "**" + sName + " has been trapped in Temporal Stasis by the Quarut!**";
        FloatingTextStringOnCreature(sSpeak, oTarget, FALSE);
        SpeakString(sSpeak, TALKVOLUME_SHOUT);

        SetLocalInt(oTarget, "StasisTouch", 2);
        SetLocalInt(oTarget, "HasQuarutAbility", 2);
        string sCreator = GetTag(oCritter);
        SetLocalString(oTarget, "PhaneTag", sCreator);
    }
}

void Teleport(object oCritter)
{
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eSanc = EffectSanctuary(999);
    location lCritter = GetLocation(oCritter);
    int iTarget = Random(7)+1;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 200.0, lCritter, FALSE, OBJECT_TYPE_WAYPOINT);

    while(GetIsObjectValid(oTarget))
    {
        string sTag = GetTag(oTarget);
        string sNumber = IntToString(iTarget);
        string sTarget = "QTeleport" + sNumber;

        if(sTag == sTarget)
        {
            ClearAllActions();
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, oCritter);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSanc, oCritter, 1.0);
            object oNewTarget = GetNearestEnemy(oCritter);
            DelayCommand(0.5, ActionAttack(oNewTarget));
            DelayCommand(0.1, JumpToObject(oTarget));
            return;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 200.0, lCritter, FALSE, OBJECT_TYPE_WAYPOINT);
    }
}

void SpawnAdd(object oCritter)
{
    location lCritter = GetLocation(oCritter);
    effect eSummon1 = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND, FALSE);

    object oCopy = CreateObject(OBJECT_TYPE_CREATURE, "shadow_2", lCritter);

    DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon1, oCopy));
    DelayCommand(0.2, SetName(oCopy, "Temporal Echo"));
    DelayCommand(0.2, ChangeToStandardFaction(oCopy, STANDARD_FACTION_HOSTILE));
}

void RefreshTargetList(object oCritter)
{
    location lCritter = GetLocation( oCritter );
    object oTarget  = GetFirstObjectInShape( SHAPE_SPHERE, 300.0, lCritter, FALSE,
                                            OBJECT_TYPE_CREATURE );
    int nCritters = GetLocalInt( oCritter, "enemies" );

    while ( GetIsObjectValid( oTarget ) )
    {
        if ( GetIsEnemy( oTarget, oCritter ) == TRUE && GetIsPC( oTarget ) == TRUE )
        {
            ++nCritters;
            SetLocalObject( oCritter, "pc_"+IntToString( nCritters ), oTarget );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 300.0, lCritter, FALSE,
                                        OBJECT_TYPE_CREATURE );
    }
    SetLocalInt( oCritter, "enemies", nCritters );
}
