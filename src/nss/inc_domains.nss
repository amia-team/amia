//-------------------------------------------------------------------------------
// Header
//-------------------------------------------------------------------------------
// script:  inc_domains
// group:   Spells
// used as: include
// date:    10 July 2011
// author:  Selmak
// Notes:   Stores constants for Amia-specific domains
//          Functions for new domains
//
//

//-------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------
#include "NW_I0_SPELLS"
#include "inc_td_appearanc"
#include "inc_ds_summons"
#include "amia_include"

//-------------------------------------------------------------------------------
// Constants for scripted domain powers
//-------------------------------------------------------------------------------

const int SPELLABILITY_DIVINEWISDOM     = 903; //    Balance Domain Power
const int SPELLABILITY_GLIBNESS         = 904; //      Charm Domain Power
const int SPELLABILITY_LIONSVALOUR      = 905; //    Courage Domain Power
const int SPELLABILITY_ARTISAN          = 906; //      Craft Domain Power
const int SPELLABILITY_SHROUDS          = 907; //   Darkness Domain Power
const int SPELLABILITY_BRAVER           = 908; //      Dream Domain Power
const int SPELLABILITY_FATESTRANDS      = 909; //       Fate Domain Power
const int SPELLABILITY_SEETHINGASSAULT  = 910; //     Hatred Domain Power
const int SPELLABILITY_FORTUNESWHEEL    = 911; //       Luck Domain Power
const int SPELLABILITY_NOBLESMARCH      = 912; //   Nobility Domain Power
const int SPELLABILITY_RAPIDREGROWTH    = 913; //    Renewal Domain Power
const int SPELLABILITY_SWIFTVENGEANCE   = 914; //Retribution Domain Power
const int SPELLABILITY_HALFLING_SKILL   = 915; //    Halfing Domain Power
const int SPELLABILITY_ORC_STRENGTH     = 916; //        Orc Domain Power
const int SPELLABILITY_REPOSE_SUMMON    = 917; //     Repose Domain Power

//-------------------------------------------------------------------------------
// Constants for turn undead changes
//-------------------------------------------------------------------------------

const int FEAT_CHAOS_DOMAIN_POWER       = 1181;
const int FEAT_COLD_DOMAIN_POWER        = 1183;
const int FEAT_LAW_DOMAIN_POWER         = 1193;
const int FEAT_MOON_DOMAIN_POWER        = 1195;
const int FEAT_SCALYKIND_DOMAIN_POWER   = 1202;
const int FEAT_UNDEATH_DOMAIN_POWER     = 1204;

//-------------------------------------------------------------------------------
// Constants for spell changes
//-------------------------------------------------------------------------------

const int FEAT_GNOME_DOMAIN_POWER       = 1189;
const int FEAT_ILLUSION_DOMAIN_POWER    = 1192;
const int FEAT_PORTAL_DOMAIN_POWER      = 1198;
const int FEAT_TYRANNY_DOMAIN_POWER     = 1203;

//-------------------------------------------------------------------------------
// Constants for other domains
//-------------------------------------------------------------------------------

const int FEAT_BALANCE_DOMAIN_POWER     = 1180;
const int FEAT_CHARM_DOMAIN_POWER       = 1182;
const int FEAT_COURAGE_DOMAIN_POWER     = 1184;
const int FEAT_CRAFT_DOMAIN_POWER       = 1185;
const int FEAT_DARKNESS_DOMAIN_POWER    = 1186;
const int FEAT_DREAM_DOMAIN_POWER       = 1187;
const int FEAT_FATE_DOMAIN_POWER        = 1188;
const int FEAT_HALFLING_DOMAIN_POWER    = 1190;
const int FEAT_HATRED_DOMAIN_POWER      = 1191;
const int FEAT_FORTUITY_DOMAIN_POWER    = 1194; //Luck domain, but name already taken
const int FEAT_NOBILITY_DOMAIN_POWER    = 1196;
const int FEAT_RENEWAL_DOMAIN_POWER     = 1197;
const int FEAT_REPOSE_DOMAIN_POWER      = 1200;
const int FEAT_RETRIBUTION_DOMAIN_POWER = 1201;
const int FEAT_SUFFERING_DOMAIN_POWER   = 1205;

//-------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------

// oPC casts Balance domain power, increasing Wisdom for a brief time
void domain_DivineWisdom( object oPC );

// oPC uses Charm domain power, increasing skill in Persuade and Bluff for a while
void domain_BewitchingGlibness( object oPC );

// oPC uses Halfling domain power, same effects as Trickery Domain
void domain_HalfingSkill( object oPC );

// oPC uses Courage domain power, gaining immunity to fear for a while
void domain_ValourOfLions( object oPC );

// oPC uses Craft domain power, increasing skill in Craft Armor/Weapon for a while
void domain_ArtisansMastery( object oPC );

// oPC uses Darkness domain power, creating a pool of magical darkness for a while
void domain_ShroudsOfShade( object oPC, location lTarg );

// oPC uses Dream domain power, gaining immunity to fear for a while
void domain_BraverOfNightmares( object oPC );

//Convert a given amount of damage to a particular DAMAGE_BONUS_* constant
int ConvertToDmgBonus( int nDamage );

//Determine and apply effects for Fate or Luck domain powers.
void domain_doFateOrLuckPower( object oPC );

// oPC uses Fate domain power, gaining random AB/divine damage bonus or penalty
void domain_FickleStrandsOfFate( object oPC );

// oPC uses Luck domain power, gaining random AB/divine damage bonus or penalty
void domain_FortunesWheel( object oPC );

// oPC uses Nobility domain power, inspiring their allies for a brief time
void domain_NoblesMarch( object oPC );

// oPC summons Repose domain summon
void domain_ReposeDomainSummon( object oPC, location lTarget );

// oPC uses Retribution domain power, gaining a damage shield for a brief time
void domain_SwiftVengeance( object oPC );

// oPC uses Renewal domain power and gains a Regneration bonus for a brief time
void domain_RapidRegrowth( object oPC );

//oPC uses Orc domain power, same effects as Strength domain
void domain_OrcStrength( object oPC );

//-------------------------------------------------------------------------------
// Functions
//-------------------------------------------------------------------------------

void domain_DivineWisdom( object oPC ){

    int nBonus          = 2 + GetLevelByClass( CLASS_TYPE_CLERIC, oPC )/3;
    int nDuration       = 5 + GetAbilityModifier( ABILITY_CHARISMA, oPC );

    effect eWisBonus    = EffectAbilityIncrease( ABILITY_WISDOM, nBonus );
    effect eVis         = EffectVisualEffect( VFX_IMP_HOLY_AID );
    //Fire cast spell at event for the specified target
    SignalEvent( oPC, EventSpellCastAt( oPC, SPELLABILITY_DIVINEWISDOM, FALSE) );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eWisBonus, oPC, RoundsToSeconds(nDuration) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

}

void domain_BewitchingGlibness( object oPC ){

    int nDuration       = 5 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int nBonus          = 1 + GetLevelByClass( CLASS_TYPE_CLERIC, oPC )/5;
    effect eBluff       = EffectSkillIncrease( SKILL_BLUFF, nBonus );
    effect ePersuade    = EffectSkillIncrease( SKILL_PERSUADE, nBonus );
    effect eLink        = EffectLinkEffects( ePersuade, eBluff );
    effect eVis         = EffectVisualEffect( VFX_IMP_CHARM );

    //Fire cast spell at event for the specified target
    SignalEvent(oPC, EventSpellCastAt( oPC, SPELLABILITY_GLIBNESS, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(nDuration) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

}

void domain_HalfingSkill( object oPC ){

    int nDuration = 5 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nLevel = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
    nLevel = 1 + nLevel/2;

    //Declare major variables
    effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nLevel);
    effect eDisable = EffectSkillIncrease(SKILL_DISABLE_TRAP, nLevel);
    effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nLevel);
    effect eOpen = EffectSkillIncrease(SKILL_OPEN_LOCK, nLevel);
    effect ePick = EffectSkillIncrease(SKILL_PICK_POCKET, nLevel);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, nLevel);
    effect ePers = EffectSkillIncrease(SKILL_PERSUADE, nLevel);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Link Effects
    effect eLink = EffectLinkEffects(eSearch, eDisable);
    eLink = EffectLinkEffects(eLink, eMove);
    eLink = EffectLinkEffects(eLink, eOpen);
    eLink = EffectLinkEffects(eLink, ePick);
    eLink = EffectLinkEffects(eLink, eHide);
    eLink = EffectLinkEffects(eLink, ePers);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    //Fire cast spell at event for the specified target
    SignalEvent(oPC, EventSpellCastAt( oPC, SPELLABILITY_HALFLING_SKILL, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);


}


// oPC uses Courage domain power, gaining immunity to fear for a while
void domain_ValourOfLions( object oPC ){

    int nDuration       = 5 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
    effect eDur         = EffectImmunity( IMMUNITY_TYPE_FEAR );
    effect eVisDur      = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_POSITIVE );
    effect eLink        = EffectLinkEffects( eVisDur, eDur );
    effect eVis         = EffectVisualEffect( VFX_FNF_LOS_HOLY_10 );

    SignalEvent( oPC, EventSpellCastAt( oPC, SPELLABILITY_LIONSVALOUR, FALSE ) );

    //Apply the VFX impact and effects
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(nDuration) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

}

// oPC uses Craft domain power, increasing skill in Craft Armor/Weapon for a while
void domain_ArtisansMastery( object oPC ){

    int nDuration       = 5 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int nBonus          = 1 + GetLevelByClass( CLASS_TYPE_CLERIC, oPC )/5;
    effect eCrArmour    = EffectSkillIncrease( SKILL_CRAFT_ARMOR, nBonus );
    effect eCrWeapon    = EffectSkillIncrease( SKILL_CRAFT_WEAPON, nBonus );

    effect eLink        = EffectLinkEffects( eCrArmour, eCrWeapon );
    effect eVis         = EffectVisualEffect( VFX_IMP_IMPROVE_ABILITY_SCORE );

    SignalEvent( oPC, EventSpellCastAt( oPC, SPELLABILITY_ARTISAN, FALSE ) );

    //Apply the VFX impact and effects
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(nDuration) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

}

// oPC uses Darkness domain power, creating a pool of magical darkness for a while
void domain_ShroudsOfShade( object oPC, location lTarget ){

    int nDuration       = 5 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
    effect eAOE         = EffectAreaOfEffect( AOE_PER_DARKNESS );


    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, TurnsToSeconds(nDuration) );

}

// oPC uses Dream domain power, gaining immunity to fear for a while
void domain_BraverOfNightmares( object oPC ){

    int nDuration       = 5 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
    effect eDur         = EffectImmunity( IMMUNITY_TYPE_FEAR );
    effect eVisDur      = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_POSITIVE );
    effect eLink        = EffectLinkEffects( eVisDur, eDur );
    effect eVis         = EffectVisualEffect( VFX_FNF_LOS_NORMAL_10 );

    SignalEvent( oPC, EventSpellCastAt( oPC, SPELLABILITY_BRAVER, FALSE ) );

    //Apply the VFX impact and effects
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(nDuration) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

}

//Convert a given amount of damage to a particular DAMAGE_BONUS_* constant
int ConvertToDmgBonus( int nDamage ){

    switch (nDamage){

    case 1:  return DAMAGE_BONUS_1;
    case 2:  return DAMAGE_BONUS_2;
    case 3:  return DAMAGE_BONUS_3;
    case 4:  return DAMAGE_BONUS_4;
    case 5:  return DAMAGE_BONUS_5;
    case 6:  return DAMAGE_BONUS_6;
    case 7:  return DAMAGE_BONUS_7;
    case 8:  return DAMAGE_BONUS_8;
    case 9:  return DAMAGE_BONUS_9;
    case 10: return DAMAGE_BONUS_10;
    case 11: return DAMAGE_BONUS_11;
    case 12: return DAMAGE_BONUS_12;
    default: return -1;
    }

    return -1;
}

//Determine and apply effects for Fate or Luck domain powers.
void domain_doFateOrLuckPower( object oPC ){

    effect eDur1, eDur2, eVis;

    int nDuration       = 5 + GetAbilityModifier( ABILITY_CHARISMA, oPC );

    int nBonus          = Random(5) - 1;

    if ( nBonus < 1 ){

        nBonus = nBonus - 1;

    }

    if ( nBonus > 0 ){

        eDur1           = EffectAttackIncrease( nBonus );
        eDur2           = EffectDamageIncrease( ConvertToDmgBonus( nBonus ), DAMAGE_TYPE_DIVINE );
        eVis            = EffectVisualEffect( VFX_IMP_SUPER_HEROISM );
    }

    if ( nBonus < 0 ){

        eDur1           = EffectAttackDecrease( -nBonus );
        eDur2           = EffectDamageDecrease( -nBonus, DAMAGE_TYPE_DIVINE );
        eVis            = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );
    }

    effect eLink        = EffectLinkEffects( eDur1, eDur2 );

    //Apply the VFX impact and effects
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );



}

// oPC uses Fate domain power, gaining random AB/divine damage bonus or penalty
void domain_FickleStrandsOfFate( object oPC ){

    domain_doFateOrLuckPower( oPC );

    SignalEvent( oPC, EventSpellCastAt( oPC, SPELLABILITY_FATESTRANDS, FALSE ) );


}

// oPC uses Luck domain power, gaining random AB/divine damage bonus or penalty
void domain_FortunesWheel( object oPC ){

    domain_doFateOrLuckPower( oPC );

    SignalEvent( oPC, EventSpellCastAt( oPC, SPELLABILITY_FORTUNESWHEEL, FALSE ) );


}

// oPC uses Hatred domain power, gaining divine damage bonus for a brief time
void domain_SeethingAssault( object oPC ){

    int nDuration       = 5 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int nBonus          = 2 + GetLevelByClass( CLASS_TYPE_CLERIC, oPC )/5;
    effect eDur         = EffectDamageIncrease( ConvertToDmgBonus(nBonus), DAMAGE_TYPE_DIVINE );
    effect eVis         = EffectVisualEffect( VFX_FNF_LOS_EVIL_10 );

    SignalEvent( oPC, EventSpellCastAt( oPC, SPELLABILITY_SEETHINGASSAULT, FALSE ) );

    //Apply the VFX impact and effects
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oPC, RoundsToSeconds(nDuration) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );


}

// oPC uses Nobility domain power, inspiring their allies for a brief time
void domain_NoblesMarch( object oPC ){

    int nDuration       = 5 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int nBonus          = 1 + GetLevelByClass( CLASS_TYPE_CLERIC, oPC )/10;

    float fDelay;

    effect eVisImp      = EffectVisualEffect( VFX_IMP_HEAD_HOLY );
    effect eVis         = EffectVisualEffect( VFX_FNF_LOS_NORMAL_30 );
    effect eAtkInc      = EffectAttackIncrease( nBonus );
    effect eChaInc      = EffectAbilityIncrease( ABILITY_CHARISMA, nBonus );
    effect eConInc      = EffectAbilityIncrease( ABILITY_CONSTITUTION, nBonus );
    effect eDexInc      = EffectAbilityIncrease( ABILITY_DEXTERITY, nBonus );
    effect eIntInc      = EffectAbilityIncrease( ABILITY_INTELLIGENCE, nBonus );
    effect eStrInc      = EffectAbilityIncrease( ABILITY_STRENGTH, nBonus );
    effect eWisInc      = EffectAbilityIncrease( ABILITY_WISDOM, nBonus );
    effect eSaveInc     = EffectSavingThrowIncrease( SAVING_THROW_ALL, nBonus );
    effect eSkillInc    = EffectSkillIncrease( SKILL_ALL_SKILLS, nBonus );

    effect eLink        = EffectLinkEffects( eSkillInc, eSaveInc );
    eLink               = EffectLinkEffects( eLink, eWisInc);
    eLink               = EffectLinkEffects( eLink, eStrInc );
    eLink               = EffectLinkEffects( eLink, eIntInc );
    eLink               = EffectLinkEffects( eLink, eDexInc );
    eLink               = EffectLinkEffects( eLink, eConInc );
    eLink               = EffectLinkEffects( eLink, eChaInc );
    eLink               = EffectLinkEffects( eLink, eAtkInc );

    //Get the first target in the radius around the caster
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), FALSE, OBJECT_TYPE_CREATURE );
    while( GetIsObjectValid(oTarget) )
    {
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget, oPC))
        {
            if( oTarget == oPC ){

                //Skip the caster and get the next target in the specified area around the caster
                oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), FALSE, OBJECT_TYPE_CREATURE );
                continue;
            }

            fDelay = GetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent( oTarget, EventSpellCastAt( oPC, SPELLABILITY_NOBLESMARCH, FALSE ) );
            //Apply VFX impact and bonus effects
            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVisImp, oTarget ) );
            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration) ) );
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), FALSE, OBJECT_TYPE_CREATURE );
    }


    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, GetLocation ( oPC ) );


}

// oPC uses Retribution domain power, gaining a damage shield for a brief time
void domain_SwiftVengeance( object oPC ){

    int nDuration       = 5 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int nDamageBonus    = GetLevelByClass( CLASS_TYPE_CLERIC, oPC )/3;
    effect eShield      = EffectDamageShield( nDamageBonus, DAMAGE_BONUS_1d10, DAMAGE_TYPE_DIVINE );
    effect eVisDur      = EffectVisualEffect( VFX_DUR_DEATH_ARMOR );
    effect eLink        = EffectLinkEffects( eVisDur, eShield );
    effect eVis         = EffectVisualEffect( VFX_IMP_HOLY_AID );

    SignalEvent( oPC, EventSpellCastAt( oPC, SPELLABILITY_SWIFTVENGEANCE, FALSE ) );

    //Apply the VFX impact and effects
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration) );

}

void domain_ReposeDomainSummon( object oPC, location lTarget ){

    int nCasterLevel = GetLevelByClass( CLASS_TYPE_CLERIC, oPC );

    // Variables
    string szSummon          = "";

    // Summon selected depends on Caster Level

    if (      nCasterLevel < 8  ){

    szSummon  =  "dd_undead_1";
    }
    else if ( nCasterLevel < 12  ){

        szSummon  =  "dd_undead_2";
    }
    else if ( nCasterLevel < 17  ){

        szSummon  =  "dd_undead_3";
    }
    else if ( nCasterLevel < 22  ){

        szSummon  =  "dd_undead_4";
    }
    else if ( nCasterLevel < 27  ){

            if ( GetHasSpellEffect( SPELL_ETHEREALNESS, oPC ) ){

            RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
            SendMessageToPC( oPC, "Summoning level 23+ monsters removes GS." );

            }

        szSummon  =  "dd_undead_5";
    }
    else{

            if ( GetHasSpellEffect( SPELL_ETHEREALNESS, oPC ) ){

            RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
            SendMessageToPC( oPC, "Summoning level 23+ monsters removes GS." );

            }

        szSummon  =  "dd_undead_6";
    }

    //Repose domain doesn't get undead summons, so no 'u' added to string.

    effect eSummon  =  EffectSummonCreature( szSummon, VFX_FNF_PWKILL, 1.0 );

    //Apply VFX impact and summon effect
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummon, lTarget, NewHoursToSeconds( 24 ) );

    // Handle reskins/optional visuals.
    DelayCommand( 2.0, HandleSummonVisuals( oPC, 1 ) );


    //time feedback
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( NewHoursToSeconds( 24 ) ) )+" seconds." );

}

// oPC uses Renewal domain power and gains a Regneration bonus for a brief time
void domain_RapidRegrowth( object oPC ){

    int nDuration       = 5 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int nRegen          = 2 + GetLevelByClass( CLASS_TYPE_CLERIC, oPC )/5;
    effect eRegen       = EffectRegenerate( nRegen, RoundsToSeconds(1) );
    effect eVis         = EffectVisualEffect( VFX_IMP_HEAD_NATURE );

    SignalEvent( oPC, EventSpellCastAt( oPC, SPELLABILITY_RAPIDREGROWTH, FALSE ) );

    //Apply the VFX impact and effects
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eRegen, oPC, RoundsToSeconds(nDuration) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );


}

//oPC uses Orc domain power, same effects as Strength domain
void domain_OrcStrength( object oPC ){

    effect eStr;
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nCasterLvl = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
    int nModify = (nCasterLvl/3) + 2;
    int nDuration = 5 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    //Fire cast spell at event for the specified target
    SignalEvent( oPC, EventSpellCastAt( oPC, SPELLABILITY_ORC_STRENGTH, FALSE));

    //Apply effects and VFX to target
    eStr = EffectAbilityIncrease(ABILITY_STRENGTH,nModify);
    effect eLink = EffectLinkEffects(eStr, eDur);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

}

