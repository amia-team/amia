// Divine Favor.
//
// Gives a caster +1 AB/magical damage for every five caster levels, to a
// maximum of +5, for one turn.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 15/07/2002 Brent Knowles    Initial release.
// ?????????  Terra            Nerfed to balance changes.
// 01/10/2011 PaladinOfSune    Changed to a different calcuation, also buffed.
//

// Includes.
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

int DamToConst( int nDam ){

    switch( nDam ){

        case 1: return DAMAGE_BONUS_1;
        case 2: return DAMAGE_BONUS_2;
        case 3: return DAMAGE_BONUS_3;
        case 4: return DAMAGE_BONUS_4;
        case 5: return DAMAGE_BONUS_5;
        case 6: return DAMAGE_BONUS_6;
        case 7: return DAMAGE_BONUS_7;
        case 8: return DAMAGE_BONUS_8;
        case 9: return DAMAGE_BONUS_9;
        case 10: return DAMAGE_BONUS_10;
        case 11: return DAMAGE_BONUS_11;
        case 12: return DAMAGE_BONUS_12;
        case 13: return DAMAGE_BONUS_13;
        case 14: return DAMAGE_BONUS_14;
        case 15: return DAMAGE_BONUS_15;
        case 16: return DAMAGE_BONUS_16;
        case 17: return DAMAGE_BONUS_17;
        case 18: return DAMAGE_BONUS_18;
        case 19: return DAMAGE_BONUS_19;
        case 20: return DAMAGE_BONUS_20;
    }
    return DAMAGE_BONUS_1;
}

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget;
    int nMetaMagic = GetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);

    // Minimum of +1, maximum of +5 at level 21.
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nValue;
    if( nCasterLevel >= 21 )
        nValue = 5;
    else if( nCasterLevel >= 16 )
        nValue = 4;
    else if( nCasterLevel >= 11 )
        nValue = 3;
    else if( nCasterLevel >= 6 )
        nValue = 2;
    else if( nCasterLevel >= 1 )
        nValue = 1;

    // 1+(lvl/5)

    // * determine the damage bonus to apply
    effect eAttack = EffectAttackIncrease( nValue );
    effect eDamage = EffectDamageIncrease( DamToConst( nValue ), DAMAGE_TYPE_MAGICAL);


    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink;

        eLink = EffectLinkEffects( eDamage, eDur );

        eLink = EffectLinkEffects( eAttack, eLink );


    int nDuration = 1; // * Duration 1 turn
    if ( nMetaMagic == METAMAGIC_EXTEND )
    {
        nDuration = nDuration * 2;
    }

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    oTarget = OBJECT_SELF;

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 414, FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));

}

