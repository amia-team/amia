#include "nwnx_creature"

void main()
{
    object oPC  = GetLastSpeaker();
    object pact = GetItemPossessedBy(oPC,"wlk_pactchoose");

    NWNX_Creature_AddFeat(oPC, 1317);
    NWNX_Creature_AddFeat(oPC, 1326);
    SendMessageToPC(oPC,"Fiendish Pact added! You can now use Binding of Maggots.");
    DestroyObject(pact);
}
