#include "nwnx_creature"

void main()
{
    object oPC  = GetLastSpeaker();
    object pact = GetItemPossessedBy(oPC,"wlk_pactchoose");

    NWNX_Creature_AddFeat(oPC, 1314);
    NWNX_Creature_AddFeat(oPC, 1323);
    SendMessageToPC(oPC,"Aberrant Pact added! You can now use Loud Decay.");
    DestroyObject(pact);
}
