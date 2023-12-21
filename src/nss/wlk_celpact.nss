#include "nwnx_creature"

void main()
{
    object oPC  = GetLastSpeaker();
    object pact = GetItemPossessedBy(oPC,"wlk_pactchoose");

    NWNX_Creature_AddFeat(oPC, 1315);
    NWNX_Creature_AddFeat(oPC, 1324);
    SendMessageToPC(oPC,"Celestial Pact added! You can now use Light's Calling.");
    DestroyObject(pact);
}
