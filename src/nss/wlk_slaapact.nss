#include "nwnx_creature"

void main()
{
    object oPC  = GetLastSpeaker();
    object pact = GetItemPossessedBy(oPC,"wlk_pactchoose");

    NWNX_Creature_AddFeat(oPC, 1319);
    NWNX_Creature_AddFeat(oPC, 1328);
    SendMessageToPC(oPC,"Slaad Pact added! You can now use Frog Drop.");
    DestroyObject(pact);
}
