/*  i_asnfree

    --------
    Verbatim
    --------
    <Description of script>

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

    if (GetTag(oUsed)== "asnfree"){
        object oPC = GetItemActivator();
        object oTarget = GetItemActivatedTarget();
        effect ePara = ExtraordinaryEffect(EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
        effect eSlow = ExtraordinaryEffect(EffectImmunity(IMMUNITY_TYPE_SLOW));
        effect eEnt = ExtraordinaryEffect(EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
        effect eDur = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FREEDOM_OF_MOVEMENT, FALSE));
        int nDuration = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
        int iFail = GetArcaneSpellFailure(oPC);
        int iRoll = d100(1);

        if (iFail < iRoll){
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, TurnsToSeconds(nDuration));
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, TurnsToSeconds(nDuration));
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEnt, oTarget, TurnsToSeconds(nDuration));
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, TurnsToSeconds(nDuration));
        }
        else {
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


