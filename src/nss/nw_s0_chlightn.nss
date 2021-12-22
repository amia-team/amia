#include "x0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"

int GetDamage(object oPC, object oTarget,int nCL, int nMeta);
void Arc(object oPC, object oTarget,int nCL, int nMeta, int nChainsLeft, int nFirst);
void SubArc(object oPC, object oTarget, int nMeta);
object FindTarget(object oPC, object oTarget, int nMeta, int nLast);

void main()
{

if (!X2PreSpellCastCode())
    return;

    int nCasterLevel = GetNewCasterLevel( OBJECT_SELF,GetCasterLevel(OBJECT_SELF));

    if (nCasterLevel > 20)
        nCasterLevel = 20;

    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    int nArc = 3;

    if(GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION,oPC))
        nArc++;

    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION,oPC))
        nArc++;

    if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION,oPC))
        nArc++;

    if(GetIsObjectValid(oTarget) && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC)){
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectBeam(VFX_BEAM_LIGHTNING,oPC,BODY_NODE_CHEST),oTarget,0.25);
        DelayCommand(0.25,Arc(oPC,oTarget,nCasterLevel,GetMetaMagicFeat(),nArc,TRUE));
    }
}

void Arc(object oPC, object oTarget,int nCL, int nMeta, int nChainsLeft, int nFirst){

    SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_CHAIN_LIGHTNING));

    if (!MyResistSpell(OBJECT_SELF, oTarget)){

        int nDmg = GetDamage(oPC, oTarget,nCL, nMeta);
        if(nDmg>0){

            if(!nFirst){
                nDmg = nDmg / 2;
            }

            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(nDmg, DAMAGE_TYPE_ELECTRICAL),oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_LIGHTNING_S),oTarget);
        }
    }

    int nLast = nChainsLeft<=0;
    object oNew = FindTarget(oPC,oTarget,nMeta,nLast);

    SendMessageToPC(oPC,"Chains left: "+IntToString(nChainsLeft)+" First: "+IntToString(nFirst)+" Last: "+IntToString(nLast));

    if(!nLast && GetIsObjectValid(oNew)){

        float delay = 0.25;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectBeam(VFX_BEAM_LIGHTNING,oTarget,BODY_NODE_CHEST),oNew,delay);
        DelayCommand(delay,Arc(oPC,oNew,nCL,nMeta,nChainsLeft-1,FALSE));
    }
}

int GetDamage(object oPC, object oTarget,int nCL, int nMeta){

    if(nCL<=0)
        nCL = 1;

    int nDamage = d6(nCL);

    if (nMeta == METAMAGIC_MAXIMIZE)
    {
        nDamage = 6 * nCL;
    }
    else if (nMeta == METAMAGIC_EMPOWER)
    {
        nDamage = nDamage + (nDamage/2);
    }

    return GetReflexAdjustedDamage(nDamage, oTarget, GetShifterDC( oPC,GetSpellSaveDC()), SAVING_THROW_TYPE_ELECTRICITY);
}

void SubArc(object oPC, object oTarget, int nMeta){

    int nDice = 2;

    if(GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION,oPC))
        nDice++;

    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION,oPC))
        nDice++;

    if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION,oPC))
        nDice++;

    int nDamage = d6(nDice);

    if (nMeta == METAMAGIC_MAXIMIZE)
    {
        nDamage = 6 * nDice;
    }
    else if (nMeta == METAMAGIC_EMPOWER)
    {
        nDamage = nDamage + (nDamage/2);
    }

    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetShifterDC( oPC,GetSpellSaveDC()), SAVING_THROW_TYPE_ELECTRICITY);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL),oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_LIGHTNING_S),oTarget);
}

object FindTarget(object oPC, object oTarget, int nMeta, int nLast){

    int nCount = 0;
    location lTarget = GetLocation(oTarget);
    object oObject = GetFirstObjectInShape(SHAPE_SPHERE,RADIUS_SIZE_HUGE,lTarget,FALSE);
    while(GetIsObjectValid(oObject)){

        if(oObject!=oPC && oObject!=oTarget && spellsIsTarget(oObject, SPELL_TARGET_SELECTIVEHOSTILE, oPC)){
            SetLocalObject(oPC,"chain_t_"+IntToString(nCount++),oObject);
        }

        oObject = GetNextObjectInShape(SHAPE_SPHERE,RADIUS_SIZE_HUGE,lTarget,FALSE);
    }

    if(nCount<=0)
        return OBJECT_INVALID;

    object oSelect = OBJECT_INVALID;
    if(nCount>1)
        oSelect = GetLocalObject(oPC,"chain_t_"+IntToString(Random(nCount)));
    else
        oSelect = GetLocalObject(oPC,"chain_t_0");

    object oTest;
    int n;
    for(n=0;n<nCount;n++){

        oTest =GetLocalObject(oPC,"chain_t_"+IntToString(n));
        if(oTest!=oSelect || nLast)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectBeam(VFX_BEAM_LIGHTNING,oTarget,BODY_NODE_CHEST),oTest,0.25);
            DelayCommand(0.1,SubArc(oPC,oTest,nMeta));
        }

        DeleteLocalObject(oPC,"chain_t_"+IntToString(n));
    }

    return oSelect;
}
