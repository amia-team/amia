#include "nwnx_creature"

void main()
{
    object oPC  = GetLastSpeaker();
    object pact = GetItemPossessedBy(oPC,"l_wlkpact");

    NWNX_Creature_AddFeat(oPC, 1314);
    DestroyObject(pact);
}
