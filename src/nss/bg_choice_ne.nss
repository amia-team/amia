// Rest Script for BG - Maverick00053


#include "x2_i0_spells"
#include "x2_inc_toollib"
#include "inc_ds_records"
#include "x2_inc_spellhook"
#include "inc_td_appearanc"
#include "amia_include"
#include "inc_td_shifter"
#include "nwnx_creature"

void main()
{
    object oPC = GetPCSpeaker();
    object oPCKey = GetItemPossessedBy(oPC,"ds_pckey");

    SetLocalInt(oPCKey,"BgChoice",3);

}

