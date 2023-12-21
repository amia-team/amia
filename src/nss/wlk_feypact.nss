#include "nwnx_creature"

void main()
{
    object oPC  = GetLastSpeaker();
    object pact = GetItemPossessedBy(oPC,"wlk_pactchoose");

    NWNX_Creature_AddFeat(oPC, 1316);
    NWNX_Creature_AddFeat(oPC, 1325);
    SendMessageToPC(oPC,"Fey Pact added! You can now use Dancing Plague.");
    DestroyObject(pact);
}
