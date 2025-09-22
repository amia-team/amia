//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: mod_equ_item
//group: module events
//used as: OnEquipItem
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)

// 2010/02/20   disco       Added some exploit counters
// 2012/02/24   Selmak      Supports Shadowdancers with polymorph
// 2019/04/21   Maverick00053 Added in 2hander buff support
// 2019/06/17   Maverick00053 Added in Cav bow check and Two Weapon Fighter Check
// 2022/09/11   Opustus     Fixed TWF AB bonus from +4 to +2 as intended
// 2022/09/15   Opustus     Fixed Indomitable removed by (Lesser) Restoration
// 2023/05/13   Opustus     Fixed light crossbow not working with Cav
// 2025/06/16   Jes         Removed 2-Hander bonus and Indomitable

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "inc_ds_records"
#include "class_effects"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main( ){

    // Variables
    object oSource                  = OBJECT_SELF;
    object oPC                      = GetPCItemLastEquippedBy( );
    object oItem                    = GetPCItemLastEquipped( );
    object oOffHand                 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
    object oPrimaryHand             = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oWidget                  = GetItemPossessedBy(oPC, "r_mountwidget");
    object oPCKEY                   = GetItemPossessedBy(oPC, "ds_pckey");
    int    oPrimaryType             = GetBaseItemType(oPrimaryHand);
    int    oItemType                = GetBaseItemType(oItem);
    int    oOffItemType             = GetBaseItemType(oOffHand);
    int    nClassCross              = GetLevelByClass(51, oPC);
    int    nClassDuel               = GetLevelByClass(52, oPC);
    string szItemScript             = "";
    effect eAB;
    effect eDamage;
    effect eAC;
    effect eLink;
    effect eLoop                    = GetFirstEffect(oPC);
    int    eLoopSpellID;
    int    mounted                  = GetLocalInt(oWidget,"mounted");
    int    nCrossDamageAndAB;


    // Curse Item Script
    if((GetResRef(oItem) == "shroudarmor") || (GetResRef(oItem) == "shroudhelm")  || (GetResRef(oItem) == "shroudcloak"))
    {
       FloatingTextStringOnCreature("*The cursed item binds to your flesh as you put it on*",oPC);
    }


    // PRC Duelist - if there is something in both of their hands, the duelist buff is active, then go ahead and remove the buff
    if((nClassDuel >= 1) && (GetIsObjectValid(oOffHand)) && (GetIsObjectValid(oPrimaryHand)))
    {

       // Checks for and removes the class bonus
         while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((GetEffectTag(eLoop) == "duelistbuff"))
            {
                 RemoveEffect(oPC, eLoop);
                 DeleteLocalInt(oPC,"duelistbuff");
            }
                eLoop=GetNextEffect(oPC);
         }
    }


  // Duelist PRC Check Bonuses
  if((GetCreatureSize(oPC) == CREATURE_SIZE_SMALL) && !GetIsPolymorphed(oPC))       // Small PCs
  {


   if((!GetIsObjectValid(oOffHand)) && (nClassDuel >= 1) && ((GetBaseItemType(oItem)== BASE_ITEM_LIGHTMACE) || (GetBaseItemType(oItem)== BASE_ITEM_SICKLE) || (GetBaseItemType(oItem)== BASE_ITEM_HANDAXE) || (GetBaseItemType(oItem)== BASE_ITEM_LIGHTHAMMER) || (GetBaseItemType(oItem)== BASE_ITEM_KAMA) || (GetBaseItemType(oItem)== BASE_ITEM_WHIP) || (GetBaseItemType(oItem)== BASE_ITEM_DAGGER) || (GetBaseItemType(oItem)== BASE_ITEM_KUKRI) || (GetBaseItemType(oItem)== BASE_ITEM_SHORTSWORD)))
   {


      // Calculating Bonuses
      if(nClassDuel >= 5)
      {
       eDamage = EffectDamageIncrease(5,DAMAGE_TYPE_PIERCING);
       eAB = EffectAttackIncrease(1,ATTACK_BONUS_MISC);
       eAC = EffectACIncrease(7,AC_SHIELD_ENCHANTMENT_BONUS);

      }
      else if(nClassDuel >= 4)
      {
       eDamage = EffectDamageIncrease(4,DAMAGE_TYPE_PIERCING);
       eAC = EffectACIncrease(5,AC_SHIELD_ENCHANTMENT_BONUS);
      }
      else if(nClassDuel >= 3)
      {
       eDamage = EffectDamageIncrease(3,DAMAGE_TYPE_PIERCING);
       eAC = EffectACIncrease(4,AC_SHIELD_ENCHANTMENT_BONUS);
      }
      else if(nClassDuel >= 2)
      {
       eDamage = EffectDamageIncrease(2,DAMAGE_TYPE_PIERCING);
       eAC = EffectACIncrease(3,AC_SHIELD_ENCHANTMENT_BONUS);
      }
      else if(nClassDuel >= 1)
      {
       eDamage = EffectDamageIncrease(1,DAMAGE_TYPE_PIERCING);
       eAC = EffectACIncrease(1,AC_SHIELD_ENCHANTMENT_BONUS);
      }

      eLink = EffectLinkEffects(eAB,eDamage);
      eLink = EffectLinkEffects(eAC,eLink);
      eLink = SupernaturalEffect(eLink);
      eLink = TagEffect(eLink,"duelistbuff");
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
      SetLocalInt(oPC,"duelistbuff",1);
   }


   }
  else if((GetCreatureSize(oPC) == CREATURE_SIZE_MEDIUM) && !GetIsPolymorphed(oPC))       // Medium PCs
  {


   if((!GetIsObjectValid(oOffHand)) && (nClassDuel >= 1) && ((GetBaseItemType(oItem)== BASE_ITEM_BASTARDSWORD) || (GetBaseItemType(oItem)== BASE_ITEM_DAGGER) || (GetBaseItemType(oItem)== BASE_ITEM_DWARVENWARAXE)
   || (GetBaseItemType(oItem)== BASE_ITEM_HANDAXE) || (GetBaseItemType(oItem)== BASE_ITEM_KAMA) || (GetBaseItemType(oItem)== BASE_ITEM_KATANA) || (GetBaseItemType(oItem)== BASE_ITEM_KUKRI)
   || (GetBaseItemType(oItem)== BASE_ITEM_LIGHTFLAIL) || (GetBaseItemType(oItem)== BASE_ITEM_LIGHTHAMMER)  || (GetBaseItemType(oItem)== BASE_ITEM_LONGSWORD)
   || (GetBaseItemType(oItem)== BASE_ITEM_LIGHTMACE) || (GetBaseItemType(oItem)== BASE_ITEM_MORNINGSTAR) || (GetBaseItemType(oItem)== BASE_ITEM_RAPIER) || (GetBaseItemType(oItem)== BASE_ITEM_SCIMITAR)
   || (GetBaseItemType(oItem)== BASE_ITEM_SHORTSWORD) || (GetBaseItemType(oItem)== BASE_ITEM_SICKLE) || (GetBaseItemType(oItem)== BASE_ITEM_TRIDENT) || (GetBaseItemType(oItem)== BASE_ITEM_WARHAMMER)
   || (GetBaseItemType(oItem)== BASE_ITEM_WHIP) || (GetBaseItemType(oItem)== BASE_ITEM_BATTLEAXE) || (GetBaseItemType(oItem)== BASE_ITEM_CLUB)))
   {



      // Calculating Bonuses
      if(nClassDuel >= 5)
      {
       eDamage = EffectDamageIncrease(5,DAMAGE_TYPE_PIERCING);
       eAB = EffectAttackIncrease(1,ATTACK_BONUS_MISC);
       eAC = EffectACIncrease(7,AC_SHIELD_ENCHANTMENT_BONUS);
      }
      else if(nClassDuel >= 4)
      {
       eDamage = EffectDamageIncrease(4,DAMAGE_TYPE_PIERCING);
       eAC = EffectACIncrease(5,AC_SHIELD_ENCHANTMENT_BONUS);
      }
      else if(nClassDuel >= 3)
      {
       eDamage = EffectDamageIncrease(3,DAMAGE_TYPE_PIERCING);
       eAC = EffectACIncrease(4,AC_SHIELD_ENCHANTMENT_BONUS);
      }
      else if(nClassDuel >= 2)
      {
       eDamage = EffectDamageIncrease(2,DAMAGE_TYPE_PIERCING);
       eAC = EffectACIncrease(3,AC_SHIELD_ENCHANTMENT_BONUS);
      }
      else if(nClassDuel >= 1)
      {
       eDamage = EffectDamageIncrease(1,DAMAGE_TYPE_PIERCING);
       eAC = EffectACIncrease(1,AC_SHIELD_ENCHANTMENT_BONUS);
      }

      eLink = EffectLinkEffects(eAB,eDamage);
      eLink = EffectLinkEffects(eAC,eLink);
      eLink = SupernaturalEffect(eLink);
      eLink = TagEffect(eLink,"duelistbuff");
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
      SetLocalInt(oPC,"duelistbuff",1);


   }


  }

    // Arbalest Check Bonuses
   if(((GetBaseItemType(oItem)== BASE_ITEM_HEAVYCROSSBOW) || (GetBaseItemType(oItem)== BASE_ITEM_LIGHTCROSSBOW)) && (nClassCross >= 1))
   {
           if(nClassCross >= 20)
           {
             nCrossDamageAndAB = 4;
           }
           else if(nClassCross >= 15)
           {
             nCrossDamageAndAB = 3;
           }
           else if(nClassCross >= 10)
           {
             nCrossDamageAndAB = 2;
           }
           else if(nClassCross >= 5)
           {
             nCrossDamageAndAB = 1;
           }

           eAB = EffectAttackIncrease(nCrossDamageAndAB,ATTACK_BONUS_MISC);
           eDamage = EffectDamageIncrease(nCrossDamageAndAB,DAMAGE_TYPE_PIERCING);
           eLink = EffectLinkEffects(eAB,eDamage);
           eLink = SupernaturalEffect(eLink);
           eLink = TagEffect(eLink,"crossbowbuff");
           ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
    }


   // Monk Path of Enlightment - If something is in either hand then remove the feat buff
      if((GetIsObjectValid(oPrimaryHand) || GetIsObjectValid(oOffHand)) && GetHasFeat(1225,oPC))
   {


    // Checks for and removes the feat buff
         while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((GetEffectType(eLoop)==EFFECT_TYPE_ATTACK_INCREASE) && (eLoopSpellID == 948))
            {
                 RemoveEffect(oPC, eLoop);
            }

                eLoop=GetNextEffect(oPC);
         }


     DeleteLocalInt(oPC,"monkprc");

    }


    // Cavalry bow additions - do not let them equip a bow unless they have the mounted archery feat and it is a shortbow or light crossbow.
    if((mounted == 1) && ((oItemType == BASE_ITEM_LONGBOW) || (oItemType == BASE_ITEM_THROWINGAXE) || (oItemType == BASE_ITEM_DART) || (oItemType == BASE_ITEM_SHURIKEN) || (oItemType == BASE_ITEM_HEAVYCROSSBOW)))
    {
       SendMessageToPC( oPC, "You cannot use that weapon while mounted!");
       AssignCommand(oPC, ActionUnequipItem(oItem));

    }
    else if((mounted == 1) && (GetHasFeat(FEAT_MOUNTED_ARCHERY, oPC) != TRUE))
    {
      if ((oItemType == BASE_ITEM_SHORTBOW) || (oItemType == BASE_ITEM_LIGHTCROSSBOW) || (oItemType == BASE_ITEM_SLING))
      {
        SendMessageToPC( oPC, "You cannot use that weapon while mounted without proper training!");
        AssignCommand(oPC, ActionUnequipItem(oItem));
      }
    }

    object armorInSlot = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nAppearance = GetItemAppearance(armorInSlot, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    int armorValue = StringToInt(Get2DAString("parts_chest", "ACBONUS", nAppearance));
    int isWearingHeavyArmor = armorValue >= 6;


    if( GetIsDM( oPC ) ) WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - mod_equ_item 32: OnEquip started for DM..." );

    if ( GetStringLeft( GetTag( oItem ), 9 ) == "ds_j_res_"  ){

        // job system needs unique tags for pricing etc
        SetUserDefinedItemEventNumber( X2_ITEM_EVENT_EQUIP );

        ExecuteScriptAndReturnInt( "i_ds_j_activate", oSource );

        return;
    }

    // Set the Item Event : Item Equip
    SetUserDefinedItemEventNumber( X2_ITEM_EVENT_EQUIP );

    // Set the Item Event Scriptname
    szItemScript = GetUserDefinedItemEventScriptName( oItem );

    // Run the designated Item Event script
    if( (szItemScript != "") && (GetResRef(oItem) != "shroudhelm")){

        ExecuteScript( szItemScript, oSource );
    }

    if( GetIsDM( oPC ) ) WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - mod_equ_item 73: OnEquip finished for DM!" );

    return;
}
