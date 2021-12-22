/*  x2_s3_intitemijc

--------
Verbatim
--------
Replaced onHit Intelligent Item to activate assassin poison

BH:
Moved script to an external script so speccraft save increase deosn't apply.

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2010-03-24   James       Start
2016-01-02   BasicHuman  Fix spellcraft
------------------------------------------------------------------

*/

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "jj_asn_include"

void main()
{
    object oTarget = GetSpellTargetObject();
  //  string textString = ObjectToString(oTarget);

    SetLocalObject(OBJECT_SELF, "assn_tl_otarget", oTarget);
   // FloatingTextStringOnCreature("1. oTarget is " + textString, OBJECT_SELF, FALSE);
    AssignCommand(OBJECT_SELF,ExecuteScript("bh_assn_onhit", OBJECT_SELF));
}
