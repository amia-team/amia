//::///////////////////////////////////////////////
//:: Create Undead
//:: NW_S0_CrUndead.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spell summons a Ghoul, Shadow, Ghast, Wight or
    Wraith
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//2011/10/23    PoS         Added PM levels to caster level and SR calculation

#include "x2_inc_spellhook"
#include "amia_include"
#include "inc_ds_summons"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    //Trigger spellhook
    if (!X2PreSpellCastCode())
        return;

    sum_CreateUndead( OBJECT_SELF,0, GetCasterLevel(OBJECT_SELF), GetSpellTargetLocation());
}

