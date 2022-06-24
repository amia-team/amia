#include "nwnx_creature"
#include "amx_fallcheck"
#include "x2_inc_switches"

const int WARLOCK = 57;
void main()
{
    object oPC = OBJECT_SELF;
    // Restore warlock spells...their invocations are infinite.
    //if(GetLevelByClass(WARLOCK) > 0)
    //{
    //   NWNX_Creature_RestoreSpells(OBJECT_SELF);
    //}

    // Partial Fall check: ONLY checks if they have a widget
    //if (IsDivineCast()) {
    //    if (IsSpecificFallen(oPC)) {
    //        FloatingTextStringOnCreature( "The plea to your deity is not heard...", oPC, FALSE );
    //        ActionWait(0.5f);
    //        ClearAllActions();
    //    }
    //}
    // Full Fall check:
    if (!FallenCastCheck(oPC)) {
        FloatingTextStringOnCreature( "The plea to your deity is not heard...", oPC, FALSE );
        ClearAllActions();
        effect eFail = EffectSpellFailure();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFail,oPC,0.5f);
        SetModuleOverrideSpellScriptFinished();
		return;
    }

}