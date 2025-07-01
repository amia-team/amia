//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: NW_S2_AnimalComp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons a Druid's animal companion
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
//::Appended cs_boost_com togheter
#include "x2_inc_itemprop"
#include "inc_td_appearanc"
#include "inc_ds_summons"
#include "nwnx_creature"

void Buff( object oPC );

void EpicBuff( object oPC );

void RemovePowerAttack( object oPC );

void main()
{

    int nEpicCompanion = GetHasFeat(1240,OBJECT_SELF);

    //Yep thats it
    SummonAnimalCompanion();

    object companion = GetAssociate( ASSOCIATE_TYPE_ANIMALCOMPANION, OBJECT_SELF );
    DelayCommand(10.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), companion));
    DelayCommand(10.0, SendMessageToPC(OBJECT_SELF, GetName(companion) + "'s collision bubble removed."));

    if(nEpicCompanion == 1)
    {
     DelayCommand( 0.5, EpicBuff( OBJECT_SELF ) );
    }

    DelayCommand( 1.0, Buff( OBJECT_SELF ) );
}

void Buff( object oPC )
{
    //Vars
    object oAnimalCompanion = GetAssociate( ASSOCIATE_TYPE_ANIMALCOMPANION, oPC );

    if( !GetIsObjectValid( oAnimalCompanion ) ){

        IncrementRemainingFeatUses( oPC, FEAT_ANIMAL_COMPANION );
        return;
    }

    int nRes                = 0;
    int nCasterLevel        = GetLevelByClass( CLASS_TYPE_DRUID, oPC );
        nCasterLevel        += GetLevelByClass( CLASS_TYPE_RANGER, oPC );

    // Handle reskins/optional visuals.
    DelayCommand( 2.0, HandleSummonVisuals( oPC, 2 ) );

    int nEnhancement        = nCasterLevel / 5;

    if( nEnhancement < 1 )
        nEnhancement = 1;

    if( nCasterLevel < 11 )
        nRes = 5;

    else if( nCasterLevel < 21 )
        nRes = 10;

    else
        nRes = 15;

    // +5/- to resistances every 10th level [6.creature hide]
    /* 5/- bludgeoning, piercing, slashing < 11th caster level
       10/- "           "           "       < 21st caster level
       15/- "           "           "       21th+ caster level  */

    effect eCandy       = EffectVisualEffect( VFX_IMP_GLOBE_USE );
    effect eBuff        = EffectLinkEffects( eCandy, EffectACIncrease( nCasterLevel / 2, AC_NATURAL_BONUS ) );
    eBuff               = EffectLinkEffects( eBuff, EffectRegenerate( nEnhancement, 6.0 ) );
    eBuff               = EffectLinkEffects( eBuff, EffectAttackIncrease( nEnhancement * 2 ) );
    eBuff               = EffectLinkEffects( eBuff, EffectSavingThrowIncrease( SAVING_THROW_ALL, nEnhancement ) );
    eBuff               = EffectLinkEffects( eBuff,  EffectDamageResistance( DAMAGE_TYPE_BLUDGEONING, nRes ) );
    eBuff               = EffectLinkEffects( eBuff,  EffectDamageResistance( DAMAGE_TYPE_PIERCING, nRes ) );
    eBuff               = EffectLinkEffects( eBuff,  EffectDamageResistance( DAMAGE_TYPE_SLASHING, nRes ) );
    eBuff               = SupernaturalEffect( eBuff );

    itemproperty ipClaw = ItemPropertyEnhancementBonus( nEnhancement );

    object oClaw1       = GetItemInSlot( INVENTORY_SLOT_CWEAPON_B, oAnimalCompanion );
    object oClaw2       = GetItemInSlot( INVENTORY_SLOT_CWEAPON_L, oAnimalCompanion );
    object oClaw3       = GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oAnimalCompanion );

    IPSafeAddItemProperty( oClaw1, ipClaw, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oClaw2, ipClaw, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oClaw3, ipClaw, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oAnimalCompanion, 0.0 );
    effect eGhost = EffectCutsceneGhost();
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oAnimalCompanion);

    SendMessageToPC( oPC, "<c� �>Bonuses added to companion:\n "      +
    "+ "+IntToString( nCasterLevel / 2 ) + " Neutral AC.\n"           +
    "+ "+IntToString( nEnhancement ) + " Regeneration.\n"             +
    "+ "+IntToString( nEnhancement * 2 ) + " Attack.\n"               +
    "+ "+IntToString( nEnhancement ) + " Universal Saving Throw.\n"   +
    "+ "+IntToString( nRes ) + "/- Damage Reduction.\n"                +
    "+ "+IntToString( nEnhancement ) + " Enchantment added to claws." );
}

void EpicBuff( object oPC )
{
    //Vars
    object oAnimalCompanion = GetAssociate( ASSOCIATE_TYPE_ANIMALCOMPANION, oPC );

    if( !GetIsObjectValid( oAnimalCompanion ) ){

        IncrementRemainingFeatUses( oPC, FEAT_ANIMAL_COMPANION );
        return;
    }

    int nCompanionType = GetAnimalCompanionCreatureType(oPC);
    int nStr;
    int nCon;
    int nDex;
    int nHP;

    effect eBonus1;
    effect eBonus2;
    effect eBonus3;
    effect eFreedom;

    // Freedom
    effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
    effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
    effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
    effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);

    // Freedom
    eFreedom = EffectLinkEffects(eParal, eEntangle);
    eFreedom = EffectLinkEffects(eFreedom, eSlow);
    eFreedom = EffectLinkEffects(eFreedom, eMove);

    // Do the buffs
    switch( nCompanionType )
    {

    // Badger = 0, Wolf = 1, Bear = 2, Boar = 3, Hawk = 4, Panther = 5, Spider = 6
    // Dire Wolf = 7, Dire Rat = 8, None = 255

        case ANIMAL_COMPANION_CREATURE_TYPE_BADGER:
            nStr = 6; nCon = 6; nDex = 6; nHP = 200;
            eBonus1 = EffectSkillIncrease(SKILL_DISCIPLINE,40);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_WOLF:
            nStr = 6; nCon = 6; nDex = 6; nHP = 200;
            eBonus1 = EffectConcealment(50);
            eBonus2 = EffectUltravision();
            eBonus3 = EffectDamageIncrease(DAMAGE_BONUS_6,DAMAGE_TYPE_BLUDGEONING);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_BEAR:
            nStr = 6; nCon = 12; nDex = 6; nHP = 300;
            eBonus1 = EffectDamageIncrease(DAMAGE_BONUS_10,DAMAGE_TYPE_BLUDGEONING);
            eBonus2 = EffectSkillIncrease(SKILL_DISCIPLINE,50);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_BOAR:
            nStr = 6; nCon = 6; nDex = 6; nHP = 200;
            eBonus1 = EffectDamageIncrease(DAMAGE_BONUS_10,DAMAGE_TYPE_BLUDGEONING);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_HAWK:
            nStr = 10; nCon = 6; nDex = 4; nHP = 200;
            eBonus1 = EffectSkillIncrease(SKILL_SPOT,13);
            eBonus2 = eFreedom;
            eBonus3 = EffectDamageIncrease(DAMAGE_BONUS_5,DAMAGE_TYPE_PIERCING);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_PANTHER:
            nStr = 6; nCon = 8; nDex = 6; nHP = 200;
            eBonus1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING,10);
            eBonus1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,10);
            eBonus1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,10);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_SPIDER:
            nStr = 9; nCon = 6; nDex = 6; nHP = 200;
            eBonus1 = EffectDamageIncrease(DAMAGE_BONUS_5,DAMAGE_TYPE_PIERCING);
            eBonus2 = EffectDamageIncrease(DAMAGE_BONUS_2d6,DAMAGE_TYPE_ACID);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_DIREWOLF:
            nStr = 10; nCon = 10; nDex = 10; nHP = 200;
            eBonus1 = EffectDamageIncrease(DAMAGE_BONUS_10,DAMAGE_TYPE_BLUDGEONING);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_DIRERAT:
            nStr = 8; nCon = 8; nDex = 8; nHP = 200;
            eBonus1 = EffectDamageResistance(DAMAGE_TYPE_FIRE,10);
            break;
    }

    RemovePowerAttack(oAnimalCompanion);

    effect eHP          = EffectTemporaryHitpoints(nHP);
    effect eBuff        = EffectAbilityIncrease(ABILITY_STRENGTH,nStr);
    eBuff               = EffectLinkEffects( eBuff, EffectAbilityIncrease(ABILITY_CONSTITUTION,nCon) );
    eBuff               = EffectLinkEffects( eBuff, EffectAbilityIncrease(ABILITY_DEXTERITY,nDex) );
    eBuff               = EffectLinkEffects( eBuff, eBonus1 );
    eBuff               = EffectLinkEffects( eBuff, eBonus2 );
    eBuff               = EffectLinkEffects( eBuff, eBonus3 );
    eBuff               = SupernaturalEffect( eBuff );


    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eHP, oAnimalCompanion, 0.0 );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oAnimalCompanion, 0.0 );

    SendMessageToPC( oPC, "<c� �>Epic Feat Bonuses added to companion:\n "      +
    "+ "+IntToString( nStr ) + " Strength Attribute.\n"           +
    "+ "+IntToString( nCon ) + " Constitution Attribute.\n"             +
    "+ "+IntToString( nDex ) + " Dexterity Attribute.\n"               +
    "+ " + "Companion Specific Buffs.\n"   +
    "+ "+IntToString( nHP ) + " Temporary HP.\n" );


    // Lastly, check if the player has opted out of the Epic Companion appearance, this is controlled by EpicCompanionHandler in AmiaReforged.Classes.Ranger
    object oPCKey = GetItemPossessedBy(oPC,"ds_pckey");
    int nEpicCompanionAppearance = GetLocalInt(oPCKey, "epic_companion_appearance");
    
    // If epic companion appearance is untoggled, don't apply the custom appearance
    if (nEpicCompanionAppearance == FALSE) return;

    switch( nCompanionType )
    {
        case ANIMAL_COMPANION_CREATURE_TYPE_BADGER:
            SetDescription(oAnimalCompanion,"Wyverns are vicious and deadly predators. Only an exceptional Druid or Ranger would be able to befriend one.");
            SetCreatureAppearanceType(oAnimalCompanion,834); // Wyvern
            SetCreatureTailType(490,oAnimalCompanion);
            SetPortraitId(oAnimalCompanion,1040);
            SetObjectVisualTransform(oAnimalCompanion, OBJECT_VISUAL_TRANSFORM_SCALE, 0.7f);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_WOLF:
            SetDescription(oAnimalCompanion, "Displacer Beasts are evil creatures that most don't live long enough to tell about. It would take a terrifyingly skilled and special individual to claim one as their companion.");
            SetCreatureAppearanceType(oAnimalCompanion,835);  // Displacer Beast   SPELLABILITY_HOWL_FEAR
            SetCreatureTailType(595,oAnimalCompanion);
            SetPortraitId(oAnimalCompanion,1052);
            SetObjectVisualTransform(oAnimalCompanion,OBJECT_VISUAL_TRANSFORM_SCALE, 0.8f);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_BEAR:
            SetDescription(oAnimalCompanion,"Dire Bears are larger, more vicious versions of their common cousins. They are often found in the company of powerful rangers or druids.");
            SetCreatureAppearanceType(oAnimalCompanion,1174); // Uber Dire Bear  1746
            SetPortraitResRef(oAnimalCompanion, "po_phod_klar_");
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_BOAR:
            SetDescription(oAnimalCompanion,"Quick, vicious and smart, Raptors make excellent companions as they do enjoy to hunt in company.");
            SetCreatureAppearanceType(oAnimalCompanion,570); // Dinosaur - Small T-Rex skin
            SetCreatureTailType(665,oAnimalCompanion);
            SetPortraitId(oAnimalCompanion,1040);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_HAWK:
            SetDescription(oAnimalCompanion,"Giant Eagles are terrifying raptors that can lift a full grown deer off the ground with ease. They are smart, fast, and have talons the size of human forearms.");
            SetCreatureAppearanceType(oAnimalCompanion,914); // Giant Eagle
            SetPortraitId(oAnimalCompanion,206);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_PANTHER:
            SetDescription(oAnimalCompanion,"Lions are one of the few social cats. Once their trust is earned they make excellent partners in hunts, and other coordinated activities.");
            SetCreatureAppearanceType(oAnimalCompanion,967); // Male Lion
            SetPortraitId(oAnimalCompanion,167);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_SPIDER:
            SetDescription(oAnimalCompanion,"Large, hungry, and venomous, beware the Gargantuan Spider and the one skilled enough to tame it.");
            SetCreatureAppearanceType(oAnimalCompanion,856); // Giant Spider
            SetCreatureTailType(590,oAnimalCompanion);
            SetPortraitId(oAnimalCompanion,718);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_DIREWOLF:
            SetDescription(oAnimalCompanion,"Guardian Wolves are rare, massive, and intelligent super predators. They make indispensable lifelong companions.");
            SetCreatureAppearanceType(oAnimalCompanion,1140); // Fenrir Wolf - Model being weird
            SetPortraitId(oAnimalCompanion,321);
            break;
        case ANIMAL_COMPANION_CREATURE_TYPE_DIRERAT:
            SetDescription(oAnimalCompanion,"Giant Scorpions are armored beasts that kill, eat and do whatever they please. Stay away unless you are prepared to fight an almost unstoppable mass of armor, pincers, and stinger.");
            SetCreatureAppearanceType(oAnimalCompanion,338); // Giant Scorpion
            SetPortraitId(oAnimalCompanion,1040);
            break;
    }
}


void RemovePowerAttack( object oPC )
{
    if(GetHasFeat(FEAT_IMPROVED_POWER_ATTACK,oPC))
    {
      NWNX_Creature_RemoveFeat(oPC,FEAT_IMPROVED_POWER_ATTACK);
    }

    if(GetHasFeat(FEAT_POWER_ATTACK,oPC))
    {
      NWNX_Creature_RemoveFeat(oPC,FEAT_POWER_ATTACK);
    }

}
