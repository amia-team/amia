//:: FileName jes_xpup
//:: Created By: Jes
//:: Created On: 28/4/2019
//:://////////////////////////////////////////////

#include "nw_i0_tool"

void main()
{

object oPC = GetPCSpeaker();

RewardPartyXP(432000, oPC, FALSE);

RewardPartyGP(1000000, oPC, FALSE);

}
