// Roar of the Ma'at (OnEnter Aura)
//
// Uses one Bard Song per use, lasts Round/Bard level. Creates a 10
// meter aura, and enemies which enter the aura must roll
// Concentration vs Taunt or suffer -4 AB.  Allies which enter the
// aura gain +20% physical damage immunity.  The caster gains
// +20% physical damage immunity, but suffers -4 AC and -50% str
// modified damage.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/14/2012 Mathias          Initial Release.
//

void main(){

    // Variables.
    object oCreature        = GetEnteringObject( );
    object oPC              = GetItemActivator();
    int    nTaunt           = GetSkillRank( SKILL_TAUNT, oPC );
    int    nClass           = GetLevelByClass( CLASS_TYPE_BARD, oPC );
    int    nCreatureBAB     = GetBaseAttackBonus( oCreature );
    effect eRedGlow         = EffectVisualEffect( VFX_DUR_GLOW_RED );
    effect eGoldGlow        = EffectVisualEffect( VFX_DUR_GLOW_LIGHT_YELLOW );
    effect eSResist         = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 20);
    effect ePResist         = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 20);
    effect eBResist         = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 20);
    effect eABLoss          = EffectAttackDecrease( 4 );
    effect eLink;
    int    bDebug           = FALSE;  // set to TRUE to see debug messages

    // Dont affect the caster.
    if( oCreature == oPC )
    {
        // !!DEBUG!!
        if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oPC) + " was not affected because they are the object owner. -" ); }

        return;
    }

    // if creature is an ally, give it the physical damage immunity increase
    if ( GetIsReactionTypeFriendly ( oCreature, oPC ) ) {

        // Link effects
        eLink = EffectLinkEffects( eGoldGlow, eSResist );
        eLink = EffectLinkEffects( ePResist, eLink );
        eLink = SupernaturalEffect( EffectLinkEffects( eBResist, eLink ) );

        // Apply the effect
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oCreature );

        // !!DEBUG!!
        if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oPC) + " was not affected because they are the object owner. -" ); }


    // if creature is a hostile, give it -4 ab if they fail conc check.
    } else if ( GetIsReactionTypeHostile( oCreature, oPC ) ) {

        // Creature makes a concentration check vs PC's taunt, and if passes, no effect.
        int nCreatureConc       = GetSkillRank( SKILL_CONCENTRATION, oCreature );
        int nCreatureDiceRoll   = d20( );
        int nPCDiceRoll         = d20( );

        if ( ( nCreatureConc + nCreatureDiceRoll ) >= ( nTaunt + nPCDiceRoll ) ) {

            // !!DEBUG!!
            if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oCreature) + " rolled " + IntToString(nCreatureConc) + " + " + IntToString(nCreatureDiceRoll) + " against PC's taunt " + IntToString(nTaunt) + " + " + IntToString(nPCDiceRoll) + " and succeeded. -" ); }

            return;
        } else {

            // !!DEBUG!!
            if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oCreature) + " rolled " + IntToString(nCreatureConc) + " + " + IntToString(nCreatureDiceRoll) + " against PC's taunt " + IntToString(nTaunt) + " + " + IntToString(nPCDiceRoll) + " and failed, taking -4 AB -" ); }


            // Apply the AB loss.
            eLink    = SupernaturalEffect( EffectLinkEffects( eRedGlow, eABLoss ) );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oCreature );

        }
    }
}
