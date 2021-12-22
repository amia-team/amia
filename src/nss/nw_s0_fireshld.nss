//::///////////////////////////////////////////////
//:: Elemental Shield
//:: NW_S0_FireShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster gains 50% cold and fire immunity.  Also anyone
    who strikes the caster with melee attacks takes
    1d6 + 1 per caster level in damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Created On: Aug 28, 2003, GZ: Fixed stacking issue
// Raven -  5/25/2017 redid the check for stacking
#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "inc_td_shifter"

effect MakeShifterVariant( int nPower, int nElementalType, int nVFX ){

    effect eShield = EffectDamageShield( nPower, DAMAGE_BONUS_1d6, nElementalType );
    effect eVis = EffectVisualEffect( nVFX );
    effect eDur = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );
    effect eLink = EffectLinkEffects( eShield, eVis );
    eLink = EffectLinkEffects( eLink, eDur );
    return eLink;
}

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    if( GetAppearanceType(OBJECT_SELF) == 376 ||
        GetAppearanceType(OBJECT_SELF) == 377 ||
        GetAppearanceType(OBJECT_SELF) == 378 ||
        GetAppearanceType(OBJECT_SELF) == 379 ||
        GetAppearanceType(OBJECT_SELF) == 380 ||
        GetAppearanceType(OBJECT_SELF) == 975 )
    {
        FloatingTextStringOnCreature( "This spell cannot be used in your current form!", OBJECT_SELF, FALSE );
        return;
    }


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
    int bIsItem = GetIsObjectValid(GetSpellCastItem());
    int nDuration = bIsItem ? GetCasterLevel(OBJECT_SELF) : GetNewCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = OBJECT_SELF;
    effect eShield = EffectDamageShield(nDuration, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCold = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
    effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eCold);
    eLink = EffectLinkEffects(eLink, eFire);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ELEMENTAL_SHIELD, FALSE));

    //  *GZ: No longer stack this spell
    if (GetHasSpellEffect(GetSpellId(),oTarget))
    {
         RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
    }

    // @@@ Custom Amia Changes
    // All of these damage reflection spells will not stack with each-other.
    //
    if (GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH) || GetHasSpellEffect(SPELL_DEATH_ARMOR) || GetHasSpellEffect(SPELL_WOUNDING_WHISPERS))   {
        effect eSpell = GetFirstEffect( oTarget );
        while( GetIsEffectValid( eSpell ) ){

            if( GetEffectSpellId( eSpell ) == SPELL_MESTILS_ACID_SHEATH || GetEffectSpellId( eSpell ) == SPELL_DEATH_ARMOR || GetEffectSpellId( eSpell ) == SPELL_WOUNDING_WHISPERS ){
                RemoveEffect( oTarget, eSpell );
            }
            eSpell = GetNextEffect( oTarget );
        }

        // RemoveSpellEffects(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, oTarget );  <-- This broke for some reason.
    }

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    if( GetIsPolymorphed( oTarget ) ){

        int nShape = GetAppearanceType( oTarget );

        if( nShape == 39 && !GetIsObjectValid( GetSpellCastItem() ) ) { // custom Risen Thane changes
            int nLevel = GetLevelByClass( CLASS_TYPE_SHIFTER, oTarget );
            nDuration  = GetNewCasterLevel( oTarget );
            eLink = MakeShifterVariant( nLevel, DAMAGE_TYPE_NEGATIVE, VFX_DUR_AURA_PULSE_RED_BLACK );
            eLink = EffectLinkEffects( EffectDamageImmunityIncrease( DAMAGE_TYPE_POSITIVE, 25 ), eLink );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetMaxHitPoints( oTarget ) / 20 ), oTarget );
        }

    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

