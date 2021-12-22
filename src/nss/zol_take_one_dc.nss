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

    if((playerDreamCoins - 1) >= 0)
    {
    SetDreamCoins(pcCdKey, playerDreamCoins - 1);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT), player);
    FloatingTextStringOnCreature("You have had 1 DCs removed.", player, FALSE);
    SendMessageToAllDMs(GetPCPlayerName(player) + " has had 1 DC removed.");
    }
    else
    {
      SendMessageToAllDMs(GetPCPlayerName(player) + " does not have enough DCs to take.");
    }
}
