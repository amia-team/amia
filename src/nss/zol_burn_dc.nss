#include "inc_dc_api"
#include "inc_ds_records"

void BurnOneDreamCoin(string cdkey);
void GiveDcXp(int level, object player);

void main()
{
    object player = GetPCSpeaker();
    string cdkey = GetPCPublicCDKey(player);

    // If a player burns a DC before getting their PCKey, it can block them
    // from entering the game and bug the character. This check stops that.
    object oKey = GetPCKEY( player );
    if ( !GetIsObjectValid( oKey ) ) {
        SendMessageToPC(player, "You must enter the game and get a valid PCKey before burning Dream Coins.");
        return;
    }

    // Naturally, we don't want players running into the negatives on Dream Coins...
    if(GetDreamCoins(cdkey) < 1)
    {
        SendMessageToPC(player, "You haven't a single Dream Coin to burn, friend.");
        return;
    }

    int playerXp = GetXP(player);
    int level = GetHitDice(player);
    int currentlevelxp = (level * (level - 1) / 2) * 1000;
    int nextlevelxp = level * 1000;
    int maxLevel = 30;
    int gold = 1500 * level;



    int xpForNextLevel = currentlevelxp + nextlevelxp;

    if(level < maxLevel)
    {
        if(playerXp < xpForNextLevel)
        {
            GiveDcXp(level, player);
        }
        else
        {
            SendMessageToPC(player, "Take your current level before burning another dreamcoin.");
            return;
        }
    }

    GiveGoldToCreature(player, gold);
    BurnOneDreamCoin(cdkey);
}


void GiveDcXp(int level, object player)
{
    object player = GetPCSpeaker();
    int nextlevelxp = level * 1000;
    int halflevelxp = level * 500;
    int level = GetHitDice(player);
    if(level <= 20)
    {
        GiveXPToCreature(player, nextlevelxp);
    }
    else
    {
        GiveXPToCreature(player, halflevelxp);
    }
}

void BurnOneDreamCoin(string cdkey)
{
    int currentDreamcoins = GetDreamCoins(cdkey);

    SetDreamCoins(cdkey, currentDreamcoins - 1);
}