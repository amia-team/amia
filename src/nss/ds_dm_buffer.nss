//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trans_actions
//group:   transmutation
//used as: action script
//date:    apr 02 2007
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_info"
#include "amia_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void ReportImmunity( object oTarget, object oUser );
void RemoveBuffEffects( object oTarget, object oUser, int nEffectType );
void RaiseAbility( object oTarget, object oUser, int nNode );
void RaiseAllAbilities( object oTarget, object oUser, int nAmount );
void RaiseSkill( object oTarget, object oUser, int nNode );
void RaiseSave( object oTarget, object oUser, int nNode );
void AddTempHP( object oTarget, object oUser, int nNode );
void ApplyImmunity1( object oTarget, object oUser, int nNode );
void ApplyImmunity2( object oTarget, object oUser, int nNode );
void ApplyImmunity3( object oTarget, object oUser, int nNode );
void ApplyImmunity4( object oTarget, object oUser, int nNode );
void ApplyVariousEffect( object oTarget, object oUser, int nNode );
void RemoveStatusEffects( object oTarget, object oUser );
void RemoveTempHP( object oTarget, object oUser );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oUser    = GetPCSpeaker( );
    object oTarget  = GetLocalObject( oUser, "ds_target" );
    int nSection    = GetLocalInt( oUser, "ds_section" );
    int nNode       = GetLocalInt( oUser, "ds_node" );

    if( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ){

        return;
    }

    if ( nNode == 30 ){

        DeleteLocalInt( oUser, "ds_section" );
        DeleteLocalInt( oUser, "ds_node" );
        return;
    }

    if ( nNode == 10 ){

        ReportImmunity( oTarget, oUser );
        return;
    }


    if ( nSection == 0 && nNode > 0 && nNode < 10 ){

        SetLocalInt( oUser, "ds_section", nNode );
    }
    else if ( nSection == 1 ){

        AssignCommand( oUser, RaiseAbility( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 2 ){

        AssignCommand( oUser, RaiseSkill( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 3 ){

        AssignCommand( oUser, RaiseSave( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 4 ){

        AssignCommand( oUser, AddTempHP( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 5  ){

        AssignCommand( oUser, ApplyImmunity1( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 6 ){

        AssignCommand( oUser, ApplyImmunity2( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 7 ){

        AssignCommand( oUser, ApplyImmunity3( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 8 ){

        AssignCommand( oUser, ApplyImmunity4( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 9 ){

        AssignCommand( oUser, ApplyVariousEffect( oTarget, oUser, nNode ) );
    }
}

//-------------------------------------------------------------------------------
// functions: general
//-------------------------------------------------------------------------------

void ReportImmunity( object oTarget, object oUser ){

    SendMessageToPC( oUser, GetName( oTarget )+" is immune to:" );

    if (GetIsImmune( oTarget, IMMUNITY_TYPE_ABILITY_DECREASE ) ){
        SendMessageToPC( oUser, " - Ability Decrease" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_AC_DECREASE ) ){
        SendMessageToPC( oUser, " - AC Decrease" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_ATTACK_DECREASE ) ){
        SendMessageToPC( oUser, " - Attack Decrease" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_BLINDNESS ) ){
        SendMessageToPC( oUser, " - Blindness" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_CHARM ) ){
        SendMessageToPC( oUser, " - Charm" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_CONFUSED ) ){
        SendMessageToPC( oUser, " - Confusion" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_CRITICAL_HIT ) ){
        SendMessageToPC( oUser, " - Critical Hit" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_CURSED ) ){
        SendMessageToPC( oUser, " - Cursed" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_DAMAGE_DECREASE ) ){
        SendMessageToPC( oUser, " - Damage Decrease" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE ) ){
        SendMessageToPC( oUser, " - Damage Immunity Decrease" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_DAZED ) ){
        SendMessageToPC( oUser, " - Dazed" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_DEAFNESS ) ){
        SendMessageToPC( oUser, " - Deafness" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_DEATH ) ){
        SendMessageToPC( oUser, " - Death" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_DISEASE ) ){
        SendMessageToPC( oUser, " - Disease" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_DOMINATE ) ){
        SendMessageToPC( oUser, " - Dominate" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_ENTANGLE ) ){
        SendMessageToPC( oUser, " - Entangle" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_FEAR ) ){
        SendMessageToPC( oUser, " - Fear" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) ){
        SendMessageToPC( oUser, " - Knockdown" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_MIND_SPELLS ) ){
        SendMessageToPC( oUser, " - Mind Spells" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE ) ){
        SendMessageToPC( oUser, " - Movement Speed Decrease" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL ) ){
        SendMessageToPC( oUser, " - Negative Level" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_PARALYSIS ) ){
        SendMessageToPC( oUser, " - Paralysis" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_POISON ) ){
        SendMessageToPC( oUser, " - Poison" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_SAVING_THROW_DECREASE ) ){
        SendMessageToPC( oUser, " - Saving Throw Decrease" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_SILENCE ) ){
        SendMessageToPC( oUser, " - Silence" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_SKILL_DECREASE ) ){
        SendMessageToPC( oUser, " - Skill Decrease" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_SLEEP ) ){
        SendMessageToPC( oUser, " - Sleep" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_SLOW ) ){
        SendMessageToPC( oUser, " - Slow" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_SNEAK_ATTACK ) ){
        SendMessageToPC( oUser, " - Sneak Attack" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE ) ){
        SendMessageToPC( oUser, " - Spell Resistance Decrease" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_STUN ) ){
        SendMessageToPC( oUser, " - Stun" ); }
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_TRAP ) ){
        SendMessageToPC( oUser, " - Trap" ); }
}

void RemoveBuffEffects( object oTarget, object oUser, int nEffectType ){

    effect eVis   = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
    effect eLoop  = GetFirstEffect( oTarget );
    int nResult;

    while ( GetIsEffectValid( eLoop ) ){

        if ( GetEffectType( eLoop ) == nEffectType && GetEffectCreator( eLoop ) == oUser ){

            RemoveEffect( oTarget, eLoop );

            ++nResult;
        }

        eLoop = GetNextEffect( oTarget );
    }

    if ( nResult ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );

        SendMessageToPC( oUser, "Removed "+IntToString( nResult )+" effects." );
    }
}

void RaiseAbility( object oTarget, object oUser, int nNode ){

    effect eBuff;
    effect eVis = EffectVisualEffect( VFX_IMP_GOOD_HELP );

    switch ( nNode ){

        case 11: eBuff  = EffectAbilityIncrease( ABILITY_STRENGTH, 1 );   break;
        case 12: eBuff  = EffectAbilityIncrease( ABILITY_STRENGTH, 5 ); break;
        case 13: eBuff  = EffectAbilityIncrease( ABILITY_DEXTERITY, 1 );   break;
        case 14: eBuff  = EffectAbilityIncrease( ABILITY_DEXTERITY, 5 );   break;
        case 15: eBuff  = EffectAbilityIncrease( ABILITY_CONSTITUTION, 1 );  break;
        case 16: eBuff  = EffectAbilityIncrease( ABILITY_CONSTITUTION, 5 );   break;
        case 17: eBuff  = EffectAbilityIncrease( ABILITY_INTELLIGENCE, 1 );   break;
        case 18: eBuff  = EffectAbilityIncrease( ABILITY_INTELLIGENCE, 5 );  break;
        case 19: eBuff  = EffectAbilityIncrease( ABILITY_WISDOM, 1 );   break;
        case 20: eBuff  = EffectAbilityIncrease( ABILITY_WISDOM, 5 );   break;
        case 21: eBuff  = EffectAbilityIncrease( ABILITY_CHARISMA, 1 ); break;
        case 22: eBuff  = EffectAbilityIncrease( ABILITY_CHARISMA, 5 ); break;
        case 23: RaiseAllAbilities( oTarget, oUser, 1 );   break;
        case 24: RaiseAllAbilities( oTarget, oUser, 5 );  break;
        case 25: RemoveBuffEffects( oTarget, oUser, EFFECT_TYPE_ABILITY_INCREASE ); return; break;

        default:     return; break;
    }

    if ( nNode > 10 && nNode < 23 ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oTarget );
    }
}

void RaiseAllAbilities( object oTarget, object oUser, int nAmount ){

    int i;
    effect eBuff;
    effect eVis = EffectVisualEffect( VFX_IMP_GOOD_HELP );

    for ( i=0; i<6; ++i ){

        eBuff  = EffectAbilityIncrease( i, nAmount );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oTarget );
}


void RaiseSkill( object oTarget, object oUser, int nNode ){

    effect eBuff;
    effect eVis = EffectVisualEffect( VFX_IMP_GOOD_HELP );


    if ( nNode == 11 ){

        eBuff = EffectSkillIncrease( SKILL_CONCENTRATION, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_DISCIPLINE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_PARRY, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_TUMBLE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 12 ){

        eBuff = EffectSkillIncrease( SKILL_CRAFT_ARMOR, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_CRAFT_TRAP, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_CRAFT_WEAPON, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 13 ){

        eBuff = EffectSkillIncrease( SKILL_SPOT, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_LISTEN, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 14 ){

        eBuff = EffectSkillIncrease( SKILL_HIDE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_MOVE_SILENTLY, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 15 ){

        eBuff = EffectSkillIncrease( SKILL_APPRAISE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_BLUFF, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_INTIMIDATE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_PERSUADE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_TAUNT, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 16 ){

        eBuff = EffectSkillIncrease( SKILL_CONCENTRATION, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_SPELLCRAFT, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 17 ){

        eBuff = EffectSkillIncrease( SKILL_OPEN_LOCK, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_PICK_POCKET, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_SET_TRAP, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        eBuff = EffectSkillIncrease( SKILL_DISABLE_TRAP, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 18 ){

        eBuff = EffectSkillIncrease( SKILL_ANIMAL_EMPATHY, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 19 ){

        eBuff = EffectSkillIncrease( SKILL_HEAL, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 20 ){

        eBuff = EffectSkillIncrease( SKILL_LORE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 21 ){

        eBuff = EffectSkillIncrease( SKILL_PERFORM, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 22 ){

        eBuff = EffectSkillIncrease( SKILL_USE_MAGIC_DEVICE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 23 ){

        eBuff = EffectSkillIncrease( SKILL_ALL_SKILLS, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
    }
    else if ( nNode == 24 ){

        RemoveBuffEffects( oTarget, oUser, EFFECT_TYPE_SKILL_INCREASE );
    }


    if ( nNode > 10 && nNode < 24 ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oTarget );
    }
}

void RaiseSave( object oTarget, object oUser, int nNode ){

    effect eBuff;
    effect eVis = EffectVisualEffect( VFX_IMP_GOOD_HELP );

    switch ( nNode ){

        case 11: eBuff  = EffectSavingThrowIncrease( SAVING_THROW_FORT, 1 );  break;
        case 12: eBuff  = EffectSavingThrowIncrease( SAVING_THROW_FORT, 5 );   break;
        case 13: eBuff  = EffectSavingThrowIncrease( SAVING_THROW_REFLEX, 1 ); break;
        case 14: eBuff  = EffectSavingThrowIncrease( SAVING_THROW_REFLEX, 5 );  break;
        case 15: eBuff  = EffectSavingThrowIncrease( SAVING_THROW_WILL, 1 ); break;
        case 16: eBuff  = EffectSavingThrowIncrease( SAVING_THROW_WILL, 5 );   break;
        case 17: eBuff  = EffectSavingThrowIncrease( SAVING_THROW_ALL, 1 ); break;
        case 18: eBuff  = EffectSavingThrowIncrease( SAVING_THROW_ALL, 5 );   break;
        case 19: RemoveBuffEffects( oTarget, oUser, EFFECT_TYPE_SAVING_THROW_INCREASE ); break;

        default:     return; break;
    }

    if ( nNode > 10 && nNode < 19 ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oTarget );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oTarget );
    }
}


void AddTempHP( object oTarget, object oUser, int nNode ){

    effect eDice;
    effect eVis;

    switch ( nNode ){

        case 11: eDice  = EffectTemporaryHitpoints( 10 );
                 eVis   = EffectVisualEffect(VFX_COM_HIT_DIVINE); break;
        case 12: eDice  = EffectTemporaryHitpoints( 50 );
                 eVis   = EffectVisualEffect(VFX_COM_HIT_DIVINE); break;
        case 13: eDice  = EffectTemporaryHitpoints( 100 );
                 eVis   = EffectVisualEffect(VFX_COM_HIT_DIVINE); break;
        case 14: eDice  = EffectTemporaryHitpoints( 500 );
                 eVis   = EffectVisualEffect(VFX_COM_HIT_DIVINE); break;
        case 15: RemoveTempHP( oTarget, oUser ); break;

        default:     return; break;
    }

    if ( nNode > 10 && nNode < 15 ){

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDice, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}

void ApplyImmunity1( object oTarget, object oUser, int nNode ){

    effect eBuff;
    effect eVis = EffectVisualEffect( VFX_IMP_AC_BONUS );

    switch ( nNode ){

        case 11: eBuff = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE); break;
        case 12: eBuff = EffectImmunity(IMMUNITY_TYPE_BLINDNESS); break;
        case 13: eBuff = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT); break;
        case 14: eBuff = EffectImmunity(IMMUNITY_TYPE_CURSED); break;
        case 15: eBuff = EffectImmunity(IMMUNITY_TYPE_DEATH); break;
        case 16: eBuff = EffectImmunity(IMMUNITY_TYPE_DOMINATE); break;
        case 17: eBuff = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN); break;
        case 18: eBuff = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS); break;
        case 19: eBuff = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE); break;
        case 20: RemoveBuffEffects( oTarget, oUser, EFFECT_TYPE_IMMUNITY ); break;

        default:     return; break;
    }

    if ( nNode > 10 && nNode < 20 ){

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuff, oTarget);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
    }
}

void ApplyImmunity2( object oTarget, object oUser, int nNode ){

    effect eBuff;
    effect eVis = EffectVisualEffect( VFX_IMP_AC_BONUS );

    switch ( nNode ){

        case 11: eBuff = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL); break;
        case 12: eBuff = EffectImmunity(IMMUNITY_TYPE_PARALYSIS); break;
        case 13: eBuff = EffectImmunity(IMMUNITY_TYPE_POISON); break;
        case 14: eBuff = EffectImmunity(IMMUNITY_TYPE_SILENCE); break;
        case 15: eBuff = EffectImmunity(IMMUNITY_TYPE_SLOW); break;
        case 16: eBuff = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK); break;
        case 17: eBuff = EffectImmunity(IMMUNITY_TYPE_STUN); break;
        case 18: eBuff = EffectImmunity(IMMUNITY_TYPE_TRAP); break;
        case 19: RemoveBuffEffects( oTarget, oUser, EFFECT_TYPE_IMMUNITY ); break;

        default:     return; break;
    }

    if ( nNode > 10 && nNode < 19 ){

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuff, oTarget);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
    }
}

void ApplyImmunity3( object oTarget, object oUser, int nNode ){

    effect eBuff;
    effect eVis = EffectVisualEffect( VFX_IMP_AC_BONUS );

    switch ( nNode ){

        case 11: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100 ); break;
        case 12: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100 ); break;
        case 13: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, 100 ); break;
        case 14: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100 ); break;
        case 15: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100 ); break;
        case 16: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 100 ); break;
        case 17: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100 ); break;
        case 18: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, 100 ); break;
        case 19: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100 ); break;
        case 20: RemoveBuffEffects( oTarget, oUser, EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE ); break;

        default:     return; break;
    }

    if ( nNode > 10 && nNode < 20 ){

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuff, oTarget);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
    }
}

void ApplyImmunity4( object oTarget, object oUser, int nNode ){

    effect eBuff;
    effect eVis = EffectVisualEffect( VFX_IMP_AC_BONUS );

    switch ( nNode ){

        case 11: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_BASE_WEAPON, 100 ); break;
        case 12: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100 ); break;
        case 13: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100 ); break;
        case 14: eBuff = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 100 ); break;
        case 15: RemoveBuffEffects( oTarget, oUser, EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE ); break;

        default:     return; break;
    }

    if ( nNode > 10 && nNode < 15 ){

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuff, oTarget);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
    }
}


void ApplyVariousEffect( object oTarget, object oUser, int nNode ){

    effect eStatus;
    effect eVis = EffectVisualEffect( VFX_IMP_AC_BONUS );

    switch ( nNode ){

        case 11: eStatus = EffectAttackIncrease( 5 ); break;
        case 12: eStatus = EffectACIncrease( 3 ); break;
        case 13: eStatus = EffectDamageIncrease( DAMAGE_BONUS_5, DAMAGE_TYPE_BASE_WEAPON ); break;
        case 14: eStatus = EffectSpellResistanceIncrease( 5 ); break;
        case 15: eStatus = EffectTurnResistanceIncrease( 5 ); break;
        case 16: eStatus = EffectConcealment( 25 ); break;
        case 17: eStatus = EffectConcealment( 50 ); break;
        case 18: eStatus = EffectEthereal(); break;
        case 19: eStatus = EffectHaste(); break;
        case 20: eStatus = EffectInvisibility( INVISIBILITY_TYPE_NORMAL ); break;
        case 21: eStatus = EffectRegenerate( 1, 6.0 ); break;
        case 22: eStatus = EffectRegenerate( 3, 6.0 ); break;
        case 23: eStatus = EffectTrueSeeing(); break;
        case 24: eStatus = EffectUltravision(); break;
        case 25: RemoveStatusEffects( oTarget, oUser ); break;

        default:     return; break;
    }

    if ( nNode == 18 || nNode == 19 ){

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatus, oTarget, 300.0 );
    }
    else{

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStatus, oTarget);
    }

    if ( nNode != 25 ){

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}

void RemoveStatusEffects( object oTarget, object oUser ){

    effect eVis   = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
    effect eEffect = GetFirstEffect( oTarget );
    int nResult;

    while ( GetIsEffectValid( eEffect ) ){

        if ( ( GetEffectType( eEffect ) == EFFECT_TYPE_AC_INCREASE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_ATTACK_INCREASE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_DAMAGE_INCREASE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_TURN_RESISTANCE_INCREASE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_CONCEALMENT )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_ETHEREAL )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_HASTE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_INVISIBILITY )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_REGENERATE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_TRUESEEING )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_ULTRAVISION ) ){

            if ( GetEffectCreator( eEffect ) == oUser ){

                RemoveEffect( oTarget, eEffect );
                ++ nResult;
            }
        }

        eEffect = GetNextEffect( oTarget );
    }

    if ( nResult ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );

        SendMessageToPC( oUser, "Removed "+IntToString( nResult )+" effects." );
    }
}

void RemoveTempHP( object oTarget, object oUser ){

    int nMaxHP = GetMaxHitPoints( oTarget );
    int nNowHP = GetCurrentHitPoints( oTarget );

    if ( nNowHP <= nMaxHP ){

        return;
    }

    effect eDamage = EffectDamage( ( nNowHP - nMaxHP ), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY );
    effect eVis    = EffectVisualEffect( VFX_COM_CHUNK_RED_SMALL );

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
