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

    if((playerDreamCoins - 5) >= 0)
    {
    SetDreamCoins(pcCdKey, playerDreamCoins - 5);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT), player);
    FloatingTextStringOnCreature("You have had 5 DCs removed.", player, FALSE);
    SendMessageToAllDMs(GetPCPlayerName(player) + " has had 5 DCs removed.");
    }
    else
    {
      SendMessageToAllDMs(GetPCPlayerName(player) + " does not have enough DCs to take.");
    }
}
