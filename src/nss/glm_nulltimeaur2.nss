// Phane Null Time Aura: OnHeartbeat
//
// Aura forces a Will Save DC30 each round for all hostiles in a 10 meter radius
// to be paralyzed and invulnerable for 1 round.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/04/2012 Glim             Initial Release
//

#include "x2_inc_spellhook"

void main()
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

    // Variables.
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    location lTarget = GetLocation(oCaster);

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        // Apply if creature is hostile to the aura creator.
        if(GetIsReactionTypeHostile(oTarget, oCaster))
        {
            //Check that they aren't already affected by Stasis Touch
            if(GetLocalInt(oTarget, "HasPhaneAbility") <= 1 && !GetIsDead(oTarget))
            {
                if(WillSave(oTarget, 30, SAVING_THROW_TYPE_NONE, oCaster) == 0)
                {
                    effect eVFX = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2, FALSE);

                    SetLocalInt(oTarget, "NullTime", 2);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 5.9);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
                    DelayCommand(5.9, SetLocalInt(oTarget, "NullTime", 1));
                    DelayCommand(5.9, SetLocalInt(oTarget, "HasPhaneAbility", 1));
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}
