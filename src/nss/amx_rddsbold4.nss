#include "x2_inc_spellhook"
#include "amx_rddcore"

void main() {
    string sSnuggybold = "summon_dd_4";

    if (!X2PreSpellCastCode()) {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    object oCaster = OBJECT_SELF;
    int nMetaMagic = GetMetaMagicFeat();
    int nCL = getDDCL(oCaster);
    int nDur = nCL;
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDur = nDur * 2;
    }
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eSummon = EffectSummonCreature(sSnuggybold);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDur));
    SendMessageToPC( oCaster, "Duration: "+IntToString(FloatToInt(TurnsToSeconds(nDur)))+" seconds." );
}
