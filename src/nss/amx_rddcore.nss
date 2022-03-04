int BREATH_FEAT_FIRE = 1210;
int BREATH_FEAT_COLD = 1211;
int BREATH_FEAT_ELEC = 1215;
int BREATH_FEAT_ACID = 1214;
int BREATH_FEAT_NEG = 1212;

int getDDElement(object oDD) {
    if (GetHasFeat(BREATH_FEAT_COLD, oDD)) {
        return DAMAGE_TYPE_COLD;
    } else if (GetHasFeat(BREATH_FEAT_ELEC,oDD)) {
        return DAMAGE_TYPE_ELECTRICAL;
    } else if (GetHasFeat(BREATH_FEAT_ACID,oDD)) {
        return DAMAGE_TYPE_ACID;
    } else if (GetHasFeat(BREATH_FEAT_NEG,oDD)) {
        return DAMAGE_TYPE_NEGATIVE;
    } else if (GetHasFeat(BREATH_FEAT_FIRE,oDD)) {
        return DAMAGE_TYPE_FIRE;
    }
    return DAMAGE_TYPE_FIRE;

}

int getDDCL(object oCaster) {
    int nCL = GetCasterLevel(oCaster);

    int nBardLevels = GetLevelByClass(CLASS_TYPE_BARD,oCaster);
    int nSorcLevels = GetLevelByClass(CLASS_TYPE_SORCERER,oCaster);
    int nDDLevels = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oCaster);

    // Casted From item
    if(!GetIsObjectValid( GetSpellCastItem( ))) {
        //if (nDDLevels >= 1) {
        if (GetLastSpellCastClass() == CLASS_TYPE_DRAGON_DISCIPLE) {
            nCL = nCL + nBardLevels + nSorcLevels;
        }
    }
    return nCL;
}
int customDDSpellResist(object oCaster, object oTarget, int nCL) {
    int nSR = GetSpellResistance(oTarget);
    int nSP = nCL;
    if (GetHasFeat(FEAT_EPIC_SPELL_PENETRATION,oCaster)) {
        nSP = nSP + 6;
    } else if (GetHasFeat(FEAT_GREATER_SPELL_PENETRATION,oCaster)) {
        nSP = nSP + 4;
    } else if (GetHasFeat(FEAT_SPELL_PENETRATION,oCaster)) {
        nSP = nSP + 2;
    }

    if (d20(1)+nSP >= nSR) {
        return TRUE;
    }
    effect eVis = EffectVisualEffect(VFX_FNF_SMOKE_PUFF);
    DelayCommand(0.1,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    return FALSE;
}

int getDDDC(object oCaster, int nDC=-1) {
    int ndDC = 10 + GetLevelByClass( CLASS_TYPE_DRAGON_DISCIPLE, oCaster ) + GetAbilityModifier( ABILITY_CONSTITUTION, oCaster );
    if (ndDC < nDC) {
        ndDC = nDC;
    }
    return ndDC;
}

