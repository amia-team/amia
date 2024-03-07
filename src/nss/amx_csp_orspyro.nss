/*
Orson's Pyromagic (Evocation):

Level: Wizard/Sorcerer 2, Bard 2
Components: V,S
Range: Personal
Area of effect: 5 foot Aura around the caster
Duration: 1 round/Caster Level
Valid Metamagic: Still, Silent, Extend, Empower, Maximize
Save: Reflex Negates
Spell Resistance: Yes

The caster surrounds themselves with flaming wisps. Every round, any enemies who
get within 5 feet of the caster are struck by the wisps. They must make a reflex
save or take 1d6 + 1 per caster level fire damage, to a maximum of 1d6+10 fire
damage. A passed reflex save negates the damage completely.
*/

void main()
{
/*//Set and apply AOE object
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    } */

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = OBJECT_SELF;

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    effect eAOE = EffectAreaOfEffect(AOE_MOB_FIRE, "amx_csp_orspyroa", "amx_csp_orspyrob");
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, RoundsToSeconds(nDuration));

}