/*  i_asninv

    --------
    Verbatim
    --------
    Description

    ---------
    Changelog
    ---------

    Date    Name        Reason
    ------------------------------------------------------------------
    050106  Disco       Corrected OnActivate event
    ------------------------------------------------------------------


*/

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void ActivateItem(){
    object oUsed=GetItemActivated();
    if (GetTag(oUsed)== "asninv"){
        object oPC = GetItemActivator();
        object oTarget = GetItemActivatedTarget();
        effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
        effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eInvis, eDur);

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY, FALSE));

        int nDuration = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
        int iFail = GetArcaneSpellFailure(oPC);
        int iRoll = d100(1);

        if (iFail < iRoll){
             ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
        }
        else{
             FloatingTextStringOnCreature("*Arcane Spell Failure*", oPC);
        }
    }
}


void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}


