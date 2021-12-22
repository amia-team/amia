// nw_s0_findtrap - Find Traps
// Copyright (c) 2001 Bioware Corp.
//
// Finds all traps within 30m.
//
// Revision History
// Date       Name                Description
// ---------- ----------------    ---------------------------------------------
// 10/29/2001 Preston Watamaniuk  Initial Release
// 08/16/2003 jpavelch            Removed disarming of traps and changed visual
//                                effect (so PC knows it's a modified spell)
//

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID); // originally KNOCK
    int nCnt = 1;
    object oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTrap) && GetDistanceToObject(oTrap) <= 30.0)
    {
        if(GetIsTrapped(oTrap))
        {
            SetTrapDetectedBy(oTrap, OBJECT_SELF);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTrap));
//            DelayCommand(2.0, SetTrapDisabled(oTrap));
        }
        nCnt++;
        oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
}
