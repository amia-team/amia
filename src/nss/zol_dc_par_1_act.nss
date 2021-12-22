#include "inc_dc_api"

void main()
{
    object dungeonMaster = GetPCSpeaker();
    object dcRod = GetItemPossessedBy(dungeonMaster, I_DM_DC_ROD);
    object player = GetLocalObject(dcRod, LVAR_LAST_ROD_TARGET);

    if(!GetIsPC(player))
    {
        // Not a player, do not execute.
        return;
    }

    object partyMember = GetFirstFactionMember(player, TRUE);

    while(GetIsObjectValid(partyMember) == TRUE)
    {
        if(GetArea(partyMember) == GetArea(player) && GetIsPC(partyMember))
        {
            FloatingTextStringOnCreature("1 DC given to " + GetName(partyMember) + ".", dungeonMaster, FALSE);
            ExecuteScript(SCRIPTNAME_GIVE_ONE_DC, partyMember);
        }
        partyMember = GetNextFactionMember(player, TRUE);
    }
}
