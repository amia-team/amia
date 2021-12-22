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
void RemoveHurtingEffects( object oTarget, object oUser, int nEffectType );
void LowerAbility( object oTarget, object oUser, int nNode );
void LowerAllAbilities( object oTarget, object oUser, int nAmount );
void LowerSkill( object oTarget, object oUser, int nNode );
void LowerSave( object oTarget, object oUser, int nNode );
void DoDamage( object oTarget, object oUser, int nNode );
void ApplyLowDisease( object oTarget, object oUser, int nNode );
void ApplyHighDisease( object oTarget, object oUser, int nNode );
void ApplyLowPoison( object oTarget, object oUser, int nNode );
void ApplyHighPoison( object oTarget, object oUser, int nNode );
void ApplyStatusEffect( object oTarget, object oUser, int nNode );
void RemoveStatusEffects( object oTarget, object oUser );

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

        DeleteLocalInt( oUser, "ds_node" );
        DeleteLocalInt( oUser, "ds_section" );
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

        AssignCommand( oUser, LowerAbility( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 2 ){

        AssignCommand( oUser, LowerSkill( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 3 ){

        AssignCommand( oUser, LowerSave( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 4 ){

        AssignCommand( oUser, DoDamage( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 5  ){

        AssignCommand( oUser, ApplyLowDisease( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 6 ){

        AssignCommand( oUser, ApplyHighDisease( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 7 ){

        AssignCommand( oUser, ApplyLowPoison( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 8 ){

        AssignCommand( oUser, ApplyHighPoison( oTarget, oUser, nNode ) );
    }
    else if ( nSection == 9 ){

        AssignCommand( oUser, ApplyStatusEffect( oTarget, oUser, nNode ) );
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

void RemoveHurtingEffects( object oTarget, object oUser, int nEffectType ){

    effect eVis   = EffectVisualEffect(VFX_IMP_HEAD_EVIL);

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );

    effect eLoop = GetFirstEffect( oTarget );

    while ( GetIsEffectValid( eLoop ) ){

        if ( GetEffectType( eLoop ) == nEffectType && GetEffectCreator( eLoop ) == oUser ){

            RemoveEffect( oTarget, eLoop );
        }

        eLoop = GetNextEffect( oTarget );
    }
}

void LowerAbility( object oTarget, object oUser, int nNode ){

    effect ePenalty;
    effect eVis = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );

    switch ( nNode ){

        case 11: ePenalty  = EffectAbilityDecrease( ABILITY_STRENGTH, 1 );   break;
        case 12: ePenalty  = EffectAbilityDecrease( ABILITY_STRENGTH, 5 ); break;
        case 13: ePenalty  = EffectAbilityDecrease( ABILITY_DEXTERITY, 1 );   break;
        case 14: ePenalty  = EffectAbilityDecrease( ABILITY_DEXTERITY, 5 );   break;
        case 15: ePenalty  = EffectAbilityDecrease( ABILITY_CONSTITUTION, 1 );  break;
        case 16: ePenalty  = EffectAbilityDecrease( ABILITY_CONSTITUTION, 5 );   break;
        case 17: ePenalty  = EffectAbilityDecrease( ABILITY_INTELLIGENCE, 1 );   break;
        case 18: ePenalty  = EffectAbilityDecrease( ABILITY_INTELLIGENCE, 5 );  break;
        case 19: ePenalty  = EffectAbilityDecrease( ABILITY_WISDOM, 1 );   break;
        case 20: ePenalty  = EffectAbilityDecrease( ABILITY_WISDOM, 5 );   break;
        case 21: ePenalty  = EffectAbilityDecrease( ABILITY_CHARISMA, 1 ); break;
        case 22: ePenalty  = EffectAbilityDecrease( ABILITY_CHARISMA, 5 ); break;
        case 23: LowerAllAbilities( oTarget, oUser, 1 );   break;
        case 24: LowerAllAbilities( oTarget, oUser, 5 );  break;
        case 25: RemoveHurtingEffects( oTarget, oUser, EFFECT_TYPE_ABILITY_DECREASE ); return; break;

        default:     return; break;
    }

    if ( nNode > 10 && nNode < 23 ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oTarget );
    }
}

void LowerAllAbilities( object oTarget, object oUser, int nAmount ){

    int i;
    effect ePenalty;
    effect eVis = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );

    for ( i=0; i<6; ++i ){

        ePenalty  = EffectAbilityDecrease( i, nAmount );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oTarget );
}


void LowerSkill( object oTarget, object oUser, int nNode ){

    effect ePenalty;
    effect eVis = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );


    if ( nNode == 11 ){

        ePenalty = EffectSkillDecrease( SKILL_CONCENTRATION, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_DISCIPLINE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_PARRY, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_TUMBLE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 12 ){

        ePenalty = EffectSkillDecrease( SKILL_CRAFT_ARMOR, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_CRAFT_TRAP, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_CRAFT_WEAPON, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 13 ){

        ePenalty = EffectSkillDecrease( SKILL_SPOT, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_LISTEN, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 14 ){

        ePenalty = EffectSkillDecrease( SKILL_HIDE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_MOVE_SILENTLY, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 15 ){

        ePenalty = EffectSkillDecrease( SKILL_APPRAISE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_BLUFF, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_INTIMIDATE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_PERSUADE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_TAUNT, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 16 ){

        ePenalty = EffectSkillDecrease( SKILL_CONCENTRATION, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_SPELLCRAFT, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 17 ){

        ePenalty = EffectSkillDecrease( SKILL_OPEN_LOCK, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_PICK_POCKET, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_SET_TRAP, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ePenalty = EffectSkillDecrease( SKILL_DISABLE_TRAP, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 18 ){

        ePenalty = EffectSkillDecrease( SKILL_ANIMAL_EMPATHY, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 19 ){

        ePenalty = EffectSkillDecrease( SKILL_HEAL, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 20 ){

        ePenalty = EffectSkillDecrease( SKILL_LORE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 21 ){

        ePenalty = EffectSkillDecrease( SKILL_PERFORM, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 22 ){

        ePenalty = EffectSkillDecrease( SKILL_USE_MAGIC_DEVICE, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 23 ){

        ePenalty = EffectSkillDecrease( SKILL_ALL_SKILLS, 5 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
    }
    else if ( nNode == 24 ){

        RemoveHurtingEffects( oTarget, oUser, EFFECT_TYPE_SKILL_DECREASE );
    }


    if ( nNode > 10 && nNode < 24 ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oTarget );
    }
}

void LowerSave( object oTarget, object oUser, int nNode ){

    effect ePenalty;
    effect eVis = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );

    switch ( nNode ){

        case 11: ePenalty  = EffectSavingThrowDecrease( SAVING_THROW_FORT, 1 ); break;
        case 12: ePenalty  = EffectSavingThrowDecrease( SAVING_THROW_FORT, 5 );     break;
        case 13: ePenalty  = EffectSavingThrowDecrease( SAVING_THROW_REFLEX, 1 );   break;
        case 14: ePenalty  = EffectSavingThrowDecrease( SAVING_THROW_REFLEX, 5 );    break;
        case 15: ePenalty  = EffectSavingThrowDecrease( SAVING_THROW_WILL, 1 );    break;
        case 16: ePenalty  = EffectSavingThrowDecrease( SAVING_THROW_WILL, 5 );   break;
        case 17: ePenalty  = EffectSavingThrowDecrease( SAVING_THROW_ALL, 1 );   break;
        case 18: ePenalty  = EffectSavingThrowDecrease( SAVING_THROW_ALL, 5 ); break;
        case 19: RemoveHurtingEffects( oTarget, oUser, EFFECT_TYPE_SAVING_THROW_DECREASE ); return; break;

        default:     return; break;
    }

    if ( nNode > 10 && nNode < 19 ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePenalty, oTarget );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oTarget );
    }
}


void DoDamage( object oTarget, object oUser, int nNode ){

    effect eDamage;
    effect eVis;

    switch ( nNode ){

        case 11: eDamage  = EffectDamage(GetCurrentHitPoints(oTarget)/4, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis     = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED); break;
        case 12: eDamage  = EffectDamage(GetCurrentHitPoints(oTarget)/2, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis     = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED); break;
        case 13: eDamage  = EffectDamage(GetCurrentHitPoints(oTarget) * 3 / 4, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis     = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL); break;
        case 14: eDamage  = EffectDamage(GetCurrentHitPoints(oTarget)-1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
                 eVis     = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL); break;
        case 15: eDamage  = EffectHeal( GetMaxHitPoints( oTarget ) );
                 eVis     = EffectVisualEffect(VFX_IMP_HEAD_HEAL); break;

        default:     return; break;
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

void ApplyLowDisease( object oTarget, object oUser, int nNode ){

    effect eDisease;
    effect eVis = EffectVisualEffect( VFX_IMP_DISEASE_S );

    switch ( nNode ){

        case 11: eDisease = EffectDisease(DISEASE_FILTH_FEVER); break;
        case 12: eDisease = EffectDisease(DISEASE_MINDFIRE); break;
        case 13: eDisease = EffectDisease(DISEASE_DREAD_BLISTERS); break;
        case 14: eDisease = EffectDisease(DISEASE_SHAKES); break;
        case 15: eDisease = EffectDisease(DISEASE_VERMIN_MADNESS); break;
        case 16: eDisease = EffectDisease(DISEASE_DEVIL_CHILLS); break;
        case 17: eDisease = EffectDisease(DISEASE_SLIMY_DOOM); break;
        case 18: eDisease = EffectDisease(DISEASE_RED_ACHE); break;
        case 19: eDisease = EffectDisease(DISEASE_ZOMBIE_CREEP); break;
        case 20: RemoveHurtingEffects( oTarget, oUser, EFFECT_TYPE_DISEASE ); return; break;

        default:     return; break;
    }

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
}

void ApplyHighDisease( object oTarget, object oUser, int nNode ){

    effect eDisease;
    effect eVis = EffectVisualEffect( VFX_IMP_DISEASE_S );

    switch ( nNode ){

        case 11: eDisease = EffectDisease(DISEASE_BLINDING_SICKNESS); break;
        case 12: eDisease = EffectDisease(DISEASE_CACKLE_FEVER); break;
        case 13: eDisease = EffectDisease(DISEASE_BURROW_MAGGOTS); break;
        case 14: eDisease = EffectDisease(DISEASE_RED_SLAAD_EGGS); break;
        case 15: eDisease = EffectDisease(DISEASE_DEMON_FEVER); break;
        case 16: eDisease = EffectDisease(DISEASE_GHOUL_ROT); break;
        case 17: eDisease = EffectDisease(DISEASE_MUMMY_ROT); break;
        case 18: eDisease = EffectDisease(DISEASE_SOLDIER_SHAKES); break;
        case 19: RemoveHurtingEffects( oTarget, oUser, EFFECT_TYPE_DISEASE ); return; break;

        default:     return; break;
    }

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
}

void ApplyLowPoison( object oTarget, object oUser, int nNode ){

    effect ePoison;
    effect eVis = EffectVisualEffect( VFX_IMP_POISON_S );

    switch ( nNode ){

        case 11: ePoison = EffectPoison(POISON_TINY_SPIDER_VENOM); break;
        case 12: ePoison = EffectPoison(POISON_ARANEA_VENOM); break;
        case 13: ePoison = EffectPoison(POISON_MEDIUM_SPIDER_VENOM); break;
        case 14: ePoison = EffectPoison(POISON_CARRION_CRAWLER_BRAIN_JUICE); break;
        case 15: ePoison = EffectPoison(POISON_OIL_OF_TAGGIT); break;
        case 16: ePoison = EffectPoison(POISON_ARSENIC); break;
        case 17: ePoison = EffectPoison(POISON_GREENBLOOD_OIL); break;
        case 18: ePoison = EffectPoison(POISON_NITHARIT); break;
        case 19: ePoison = EffectPoison(POISON_PHASE_SPIDER_VENOM); break;
        case 20: RemoveHurtingEffects( oTarget, oUser, EFFECT_TYPE_POISON ); return; break;

        default:     return; break;
    }

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
}

void ApplyHighPoison( object oTarget, object oUser, int nNode ){

    effect ePoison;
    effect eVis = EffectVisualEffect( VFX_IMP_POISON_L );

    switch ( nNode ){

        case 11: ePoison = EffectPoison(POISON_LICH_DUST); break;
        case 12: ePoison = EffectPoison(POISON_SHADOW_ESSENCE); break;
        case 13: ePoison = EffectPoison(POISON_LARGE_SPIDER_VENOM); break;
        case 14: ePoison = EffectPoison(POISON_PURPLE_WORM_POISON); break;
        case 15: ePoison = EffectPoison(POISON_IRON_GOLEM); break;
        case 16: ePoison = EffectPoison(POISON_PIT_FIEND_ICHOR); break;
        case 17: ePoison = EffectPoison(POISON_WYVERN_POISON); break;
        case 18: ePoison = EffectPoison(POISON_BLACK_LOTUS_EXTRACT); break;
        case 19: ePoison = EffectPoison(POISON_GARGANTUAN_SPIDER_VENOM); break;
        case 20: RemoveHurtingEffects( oTarget, oUser, EFFECT_TYPE_POISON ); return; break;

        default:     return; break;
    }

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
}


void ApplyStatusEffect( object oTarget, object oUser, int nNode ){

    effect eStatus;

    switch ( nNode ){

        case 11: eStatus = EffectBlindness(); break;
        case 12: eStatus = EffectCurse(2,2,2,2,2,2); break;
        case 13: eStatus = EffectCurse(4,4,4,4,4,4); break;
        case 14: eStatus = EffectCurse(6,6,6,6,6,6); break;
        case 15: eStatus = EffectFrightened(); break;
        case 16: eStatus = EffectCutsceneImmobilize(); break;
        case 17: eStatus = EffectKnockdown(); break;
        case 18: eStatus = EffectParalyze(); break;
        case 19: eStatus = EffectCutsceneParalyze(); break;
        case 20: eStatus = EffectPetrify(); break;
        case 21: eStatus = EffectSilence(); break;
        case 22: eStatus = EffectSleep(); break;
        case 23: eStatus = EffectSlow(); break;
        case 24: eStatus = EffectStunned(); break;
        case 25: RemoveStatusEffects( oTarget, oUser ); break;

        default:     return; break;
    }

    if ( nNode == 17 ){

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatus, oTarget, 60.0 );
    }
    else{

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStatus, oTarget);
    }
}

void RemoveStatusEffects( object oTarget, object oUser ){

    effect eVis   = EffectVisualEffect(VFX_IMP_HEAD_HEAL);

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oTarget );

    effect eEffect = GetFirstEffect( oTarget );

    while ( GetIsEffectValid( eEffect ) ){

        if ( ( GetEffectType( eEffect ) == EFFECT_TYPE_BLINDNESS )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_CURSE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_FRIGHTENED )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_CUTSCENEIMMOBILIZE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_CUTSCENE_PARALYZE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_PARALYZE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_PETRIFY )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_SILENCE )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_SLEEP )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_SLOW )
          || ( GetEffectType( eEffect ) == EFFECT_TYPE_STUNNED ) ){

            if ( GetEffectCreator( eEffect ) == oUser ){

                RemoveEffect( oTarget, eEffect );
            }
        }

        eEffect = GetNextEffect( oTarget );
    }
}
