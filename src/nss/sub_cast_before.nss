#include "nwnx_creature"
#include "amx_fallcheck"

const int WARLOCK = 57;
void main()
{
    object oPC = OBJECT_SELF;
    // Restore warlock spells...their invocations are infinite.
    if(GetLevelByClass(WARLOCK) > 0)
    {
       NWNX_Creature_RestoreSpells(OBJECT_SELF);
    }

    if (IsDivineCast()) {
        if (IsSpecificFallen(oPC)) {
            FloatingTextStringOnCreature( "The plea to your deity is not heard...", oPC, FALSE );
            ClearAllActions();
        }
    }
    // Full Fall check, commented out:
    //if (!FallenCastCheck(oPC)) {
    //    FloatingTextStringOnCreature( "The plea to your deity is not heard...", oPC, FALSE );
    //    ClearAllActions();
    //}

}