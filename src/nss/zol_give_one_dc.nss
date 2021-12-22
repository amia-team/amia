#include "inc_dc_api"

void main()
{
    object player = OBJECT_SELF;

    if(!GetIsPC(player))
    {
        return;
    }

    string pcCdKey = GetPCPublicCDKey(player);

    int playerDreamCoins = GetDreamCoins(pcCdKey);

    SetDreamCoins(pcCdKey, playerDreamCoins + 1);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT), player);
    FloatingTextStringOnCreature("You have received 1 DC.", player, FALSE);
    SendMessageToAllDMs(GetPCPlayerName(player) + " received 1 DC.");
}
