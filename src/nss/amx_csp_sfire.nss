

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "amx_rddcore"

void sunFireEffect(int dmgDice, int nMetaMagic, object oCaster, object oTarget, int nCL, int nDC) {
    int nDmg = d6(dmgDice);
    if (nMetaMagic == METAMAGIC_MAXIMIZE) {
        nDmg = 6*dmgDice;
    }

    if (nMetaMagic == METAMAGIC_EMPOWER) {
        nDmg = FloatToInt(nDmg * 1.5);
    }

    int nDamageType = DAMAGE_TYPE_FIRE;
    int nVFX = VFX_IMP_FLAME_M;

    effect eVis = EffectVisualEffect(nVFX);
    SignalEvent(oTarget,EventSpellCastAt(oCaster,GetSpellId()));
    if (customDDSpellResist(oCaster,oTarget,nCL) >= 1) {
        if (ReflexSave(oTarget, nDC, SAVING_THROW_TYPE_SPELL, oCaster) >= 1) {
            if (GetHasFeat(FEAT_EVASION,oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION,oTarget)) {
                return;
            }
            nDmg = nDmg / 2;
        } else if (GetHasFeat(FEAT_IMPROVED_EVASION,oTarget)) {
            nDmg = nDmg / 2;
        }
        effect eDmg = EffectDamage(nDmg, nDamageType);
        DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget));
        DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
    }

}

void main() {
   if (!X2PreSpellCastCode()) {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
   }

    int nCap = 15;

    //object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nMetaMagic = GetMetaMagicFeat();
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION,oCaster)) {
        nCap = nCap + 6;
    } else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION,oCaster)) {
        nCap = nCap + 4;
    } else if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION,oCaster)) {
        nCap = nCap + 2;
    }

    int nCL = getDDCL(oCaster);
    int dmgDice = nCL;

    if (dmgDice > nCap) {
        dmgDice = nCap;
    }
    int nDC = GetSpellSaveDC();

    location lTarget = GetLocation(oCaster);
    int iBoom = VFX_FNF_FIREBALL;
    effect eBoom = EffectVisualEffect(iBoom);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eBoom, lTarget);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,RADIUS_SIZE_HUGE,lTarget,TRUE,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget)){
        if (spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,oCaster)){
            if (oTarget != oCaster) {
                sunFireEffect(dmgDice, nMetaMagic, oCaster, oTarget, nCL, nDC);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE,RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

}
