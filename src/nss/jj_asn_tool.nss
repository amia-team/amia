/*  jj_asn_include

--------
Verbatim
--------
The include script that contains the Apply Assassin Posion to simplify it

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2010-03-24   James       Start
------------------------------------------------------------------

*/

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "amia_include"
#include "x2_inc_spellhook"
#include "jj_asn_include"

//PROTOTYPES
void ApplyToWeapon(object oTarget,float fDuration, int nCasterLevel);
//FUNCTIONS

void main()
{
   object oPC       = GetPCSpeaker();
   int nNode        = GetLocalInt(oPC, "ds_node");
   int nCasterLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC);
   float fDuration  = TurnsToSeconds(nCasterLevel);
   object oTarget ;

   SetLocalInt( oPC, "ASSASSIN_POISON", nNode );
   //SetBlockTime( oPC, ASSASSIN_BLOCK_TIME, 0, "AssassinBlock" );
   SetBlockTime( oPC, 0, FloatToInt(fDuration), "NormalPoisonBlock" );
   SendMessageToPC(oPC, "Duration: " + IntToString(FloatToInt(fDuration)) + " seconds");

   oTarget = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
   if (IPGetIsMeleeWeapon(oTarget) || IPGetIsRangedWeapon(oTarget))
     ApplyToWeapon(oTarget,fDuration,nCasterLevel);
   oTarget = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
   if (IPGetIsMeleeWeapon(oTarget) || IPGetIsRangedWeapon(oTarget))
     ApplyToWeapon(oTarget,fDuration,nCasterLevel);
   oTarget = GetItemInSlot(INVENTORY_SLOT_ARROWS,oPC);
   ApplyToWeapon(oTarget,fDuration,nCasterLevel);
   oTarget = GetItemInSlot(INVENTORY_SLOT_BULLETS,oPC);
   ApplyToWeapon(oTarget,fDuration,nCasterLevel);
   oTarget = GetItemInSlot(INVENTORY_SLOT_BOLTS,oPC);
   ApplyToWeapon(oTarget,fDuration,nCasterLevel);
   oTarget = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
   ApplyToWeapon(oTarget,fDuration,nCasterLevel);

   //DelayCommand(fDuration,DeleteLocalInt(oPC,"ASSASSIN_POISON"));
   return;
}

void ApplyToWeapon(object oTarget, float fDuration, int nCasterLevel)
{
if (oTarget == OBJECT_INVALID) return;
    SetLocalInt(oTarget, "AssassinWeapon", TRUE);
   IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_INTELLIGENT_WEAPON_ONHIT,nCasterLevel), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);

}
