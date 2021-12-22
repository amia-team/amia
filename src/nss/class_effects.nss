/*
    Author: ZoltanTheRed

    Last Edit:
        12-08-2020 - Added: if(HasTaggedEffect(player, DWD_PASSIVES)) return;
*/

#include "cls_defender_eff"
//void main (){}
void ApplyClassEffects(object player);
void RemoveClassEffects(object player);

void ApplyDefenderEffects(object player)
{
    if(!GetIsPC(player)) return;
    if(HasTaggedEffect(player, DWD_PASSIVES))
    {
        WriteTimestampedLogEntry("Returning so effects aren't applied twice...");
        return;
    }

    ApplyDefenderPassives(player);
}

void RemoveDefenderEffects(object player)
{
    RemoveDefenderPassives(player);
}
