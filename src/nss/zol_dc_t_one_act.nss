#include "inc_dc_api"

void main()
{
    object dungeonMaster = GetPCSpeaker();
    object dcRod = GetItemPossessedBy(dungeonMaster, I_DM_DC_ROD);
    object player = GetLocalObject(dcRod, LVAR_LAST_ROD_TARGET);

    ExecuteScript(SCRIPTNAME_TAKE_ONE_DC, player);
}
