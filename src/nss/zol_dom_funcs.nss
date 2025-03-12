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

    playerDomainInfo.firstDomain = GetDomain(player, CLASS_TYPE_CLERIC, 1);
    playerDomainInfo.secondDomain = GetDomain(player, CLASS_TYPE_CLERIC, 2);

    return playerDomainInfo;
}

