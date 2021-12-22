#include "nwnx_creature"


struct DomainInformation
{
    int firstDomain;
    int secondDomain;
};

struct DomainInformation GetPlayerDomainInformation(object player);

struct DomainInformation GetPlayerDomainInformation(object player)
{
    struct DomainInformation playerDomainInfo;

    playerDomainInfo.firstDomain = NWNX_Creature_GetDomain(player, CLASS_TYPE_CLERIC, 1);
    playerDomainInfo.secondDomain = NWNX_Creature_GetDomain(player, CLASS_TYPE_CLERIC, 2);

    return playerDomainInfo;
}

