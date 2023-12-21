#include "nwnx_creature"

void main()
{
    object oPC  = GetLastSpeaker();
    object pact = GetItemPossessedBy(oPC,"wlk_pactchoose");

    NWNX_Creature_AddFeat(oPC, 1318);
    NWNX_Creature_AddFeat(oPC, 1327);
    SendMessageToPC(oPC,"Elemental Pact added! You can now use Primordial Gust.");
    DestroyObject(pact);
}
