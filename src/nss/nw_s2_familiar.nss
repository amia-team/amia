//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
//::Terra; Le twidled cs_boost_fam inhere.

#include "x2_inc_itemprop"
#include "inc_td_appearanc"
#include "inc_ds_summons"

// prototypes

void Buff( object oPC );

void main()
{
    //Yep thats it
    SummonFamiliar( OBJECT_SELF );
    object familiar = GetAssociate( ASSOCIATE_TYPE_FAMILIAR, OBJECT_SELF );
    DelayCommand(10.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), familiar));
    DelayCommand(10.0, SendMessageToPC(OBJECT_SELF, GetName(familiar) + "'s collision bubble removed."));

    DelayCommand( 1.0, Buff( OBJECT_SELF ) );

}

void Buff( object oPC )
{
    //Vars
    object oFamiliar = GetAssociate( ASSOCIATE_TYPE_FAMILIAR, oPC );

    if( !GetIsObjectValid( oFamiliar ) ){

        IncrementRemainingFeatUses( oPC, FEAT_SUMMON_FAMILIAR );
        return;
    }

    int nRes                = 0;
    int nCasterLevel        = GetLevelByClass( CLASS_TYPE_SORCERER, oPC );
        nCasterLevel        += GetLevelByClass( CLASS_TYPE_WIZARD, oPC );

    // Handle reskins/optional visuals.
    DelayCommand( 2.0, HandleSummonVisuals( oPC, 3 ) );

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

    object oClaw1       = GetItemInSlot( INVENTORY_SLOT_CWEAPON_B, oFamiliar );
    object oClaw2       = GetItemInSlot( INVENTORY_SLOT_CWEAPON_L, oFamiliar );
    object oClaw3       = GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oFamiliar );

    IPSafeAddItemProperty( oClaw1, ipClaw, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oClaw2, ipClaw, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oClaw3, ipClaw, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBuff, oFamiliar, 0.0 );

    SendMessageToPC( oPC, "<cþ þ>Bonuses added to familiar:\n"        +
    "+ "+IntToString( nCasterLevel / 2 ) + " Natural AC.\n"           +
    "+ "+IntToString( nEnhancement ) + " Regeneration.\n"             +
    "+ "+IntToString( nEnhancement * 2 ) + " Attack.\n"               +
    "+ "+IntToString( nEnhancement ) + " Universal Saving Throw.\n"   +
    "+ "+IntToString( nRes ) + "/- Damage Reduction.\n"                +
    "+ "+IntToString( nEnhancement ) + " Enhancement added to claws." );
}
