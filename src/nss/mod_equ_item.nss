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

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "inc_ds_records"
#include "class_effects"

void AddShadowdancerHiPS( object oPC, object oItem );

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
    int    nClass                   = GetLevelByClass(46, oPC);
    int    nClassCross              = GetLevelByClass(51, oPC);
    int    nClassDuel               = GetLevelByClass(52, oPC);
    string szItemScript             = "";
    int    strMod                   = GetAbilityModifier(ABILITY_STRENGTH,oPC);
    effect eAB;
    effect eABOff;
    effect eDamage;
    effect twoHanderBonus;
    effect eAC;
    effect eLink;
    effect eLoop                    = GetFirstEffect(oPC);
    int    eLoopSpellID;
    int    iDamage                  = strMod/2;
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



    // Two weapon fighter addition
  if(GetCreatureSize(oPC) == CREATURE_SIZE_SMALL)       // Small PCs
  {
    if((nClass == 5) && (GetIsObjectValid(oPrimaryHand)) && ((oItemType == BASE_ITEM_DOUBLEAXE || oItemType == BASE_ITEM_DIREMACE || oItemType == BASE_ITEM_TWOBLADEDSWORD) || (GetIsObjectValid(oOffHand) && (oOffItemType != BASE_ITEM_TOWERSHIELD) && (oOffItemType != BASE_ITEM_LARGESHIELD) && (oOffItemType != BASE_ITEM_SMALLSHIELD))))
    {
         effect eAC = EffectACIncrease(4,AC_SHIELD_ENCHANTMENT_BONUS);
         // AB Increase for using small weapons once you hit level 5 TWF
         if((oPrimaryType == BASE_ITEM_KAMA || oPrimaryType == BASE_ITEM_SICKLE || oPrimaryType == BASE_ITEM_WHIP
         || oPrimaryType == BASE_ITEM_SHORTSWORD || oPrimaryType == BASE_ITEM_LIGHTMACE || oPrimaryType == BASE_ITEM_LIGHTHAMMER) &&
         (oOffItemType == BASE_ITEM_KAMA || oOffItemType == BASE_ITEM_SICKLE || oOffItemType == BASE_ITEM_WHIP
         || oOffItemType == BASE_ITEM_SHORTSWORD || oOffItemType == BASE_ITEM_LIGHTMACE || oOffItemType == BASE_ITEM_LIGHTHAMMER ||
         oOffItemType == BASE_ITEM_HANDAXE))
         {
           eAB = EffectAttackIncrease(2,ATTACK_BONUS_MISC);
           eLink = EffectLinkEffects(eAC,eAB);
         }
         else
         {
           eLink = eAC;
         }
         eLink = SupernaturalEffect(eLink);
         eLink = TagEffect(eLink,"twfbuff");
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);

    }
    else if((nClass >= 3) && (GetIsObjectValid(oPrimaryHand)) && ((oItemType == BASE_ITEM_DOUBLEAXE || oItemType == BASE_ITEM_DIREMACE || oItemType == BASE_ITEM_TWOBLADEDSWORD) || (GetIsObjectValid(oOffHand) && (oOffItemType != BASE_ITEM_TOWERSHIELD) && (oOffItemType != BASE_ITEM_LARGESHIELD) && (oOffItemType != BASE_ITEM_SMALLSHIELD))))
    {
         effect eAC = EffectACIncrease(2,AC_SHIELD_ENCHANTMENT_BONUS);
         eAC = SupernaturalEffect(eAC);
         eAC = TagEffect(eAC,"twfbuff");
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
    }
    else if((nClass >= 1) && (GetIsObjectValid(oPrimaryHand)) && ((oItemType == BASE_ITEM_DOUBLEAXE || oItemType == BASE_ITEM_DIREMACE || oItemType == BASE_ITEM_TWOBLADEDSWORD) || (GetIsObjectValid(oOffHand) && (oOffItemType != BASE_ITEM_TOWERSHIELD) && (oOffItemType != BASE_ITEM_LARGESHIELD) && (oOffItemType != BASE_ITEM_SMALLSHIELD))))
    {
         effect eAC = EffectACIncrease(1,AC_SHIELD_ENCHANTMENT_BONUS);
         eAC = SupernaturalEffect(eAC);
         eAC = TagEffect(eAC,"twfbuff");
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
    }

    } //end
    else  // Medium PCs
    {

    if((nClass == 5) && (GetIsObjectValid(oPrimaryHand)) && ((oItemType == BASE_ITEM_DOUBLEAXE || oItemType == BASE_ITEM_DIREMACE || oItemType == BASE_ITEM_TWOBLADEDSWORD) || (GetIsObjectValid(oOffHand) && (oOffItemType != BASE_ITEM_TOWERSHIELD) && (oOffItemType != BASE_ITEM_LARGESHIELD) && (oOffItemType != BASE_ITEM_SMALLSHIELD))))
    {
         effect eAC = EffectACIncrease(4,AC_SHIELD_ENCHANTMENT_BONUS);
         // AB Increase for using medium weapons once you hit level 5 TWF
         if((oPrimaryType == BASE_ITEM_LONGSWORD ||oPrimaryType == BASE_ITEM_BASTARDSWORD || oPrimaryType == BASE_ITEM_BATTLEAXE || oPrimaryType == BASE_ITEM_DWARVENWARAXE
         || oPrimaryType == BASE_ITEM_KATANA || oPrimaryType == BASE_ITEM_MORNINGSTAR || oPrimaryType == BASE_ITEM_RAPIER
         || oPrimaryType == BASE_ITEM_SCIMITAR || oPrimaryType == BASE_ITEM_TRIDENT || oPrimaryType == BASE_ITEM_WARHAMMER || oPrimaryType == BASE_ITEM_LIGHTFLAIL) &&
         (oOffItemType == BASE_ITEM_LONGSWORD || oOffItemType == BASE_ITEM_BASTARDSWORD || oOffItemType == BASE_ITEM_BATTLEAXE || oOffItemType == BASE_ITEM_DWARVENWARAXE
         || oOffItemType == BASE_ITEM_KATANA || oOffItemType == BASE_ITEM_MORNINGSTAR || oOffItemType == BASE_ITEM_RAPIER
         || oOffItemType == BASE_ITEM_SCIMITAR || oOffItemType == BASE_ITEM_TRIDENT || oOffItemType == BASE_ITEM_WARHAMMER || oOffItemType == BASE_ITEM_LIGHTFLAIL))
         {
           eAB = EffectAttackIncrease(2,ATTACK_BONUS_MISC);
           eLink = EffectLinkEffects(eAC,eAB);
         }
         else
         {
           eLink = eAC;
         }
         eLink = SupernaturalEffect(eLink);
         eLink = TagEffect(eLink,"twfbuff");
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);

    }
    else if((nClass >= 3) && (GetIsObjectValid(oPrimaryHand)) && ((oItemType == BASE_ITEM_DOUBLEAXE || oItemType == BASE_ITEM_DIREMACE || oItemType == BASE_ITEM_TWOBLADEDSWORD) || (GetIsObjectValid(oOffHand) && (oOffItemType != BASE_ITEM_TOWERSHIELD) && (oOffItemType != BASE_ITEM_LARGESHIELD) && (oOffItemType != BASE_ITEM_SMALLSHIELD))))
    {
         effect eAC = EffectACIncrease(2,AC_SHIELD_ENCHANTMENT_BONUS);
         eAC = SupernaturalEffect(eAC);
         eAC = TagEffect(eAC,"twfbuff");
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
    }
    else if((nClass >= 1) && (GetIsObjectValid(oPrimaryHand)) && ((oItemType == BASE_ITEM_DOUBLEAXE || oItemType == BASE_ITEM_DIREMACE || oItemType == BASE_ITEM_TWOBLADEDSWORD) || (GetIsObjectValid(oOffHand) && (oOffItemType != BASE_ITEM_TOWERSHIELD) && (oOffItemType != BASE_ITEM_LARGESHIELD) && (oOffItemType != BASE_ITEM_SMALLSHIELD))))
    {
         effect eAC = EffectACIncrease(1,AC_SHIELD_ENCHANTMENT_BONUS);
         eAC = SupernaturalEffect(eAC);
         eAC = TagEffect(eAC,"twfbuff");
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
    }

    }

    //


    // Cavalry bow additions - do not let them equip a bow unless they have the mounted archery feat and it is a shortbow or light crossbow.
    if((mounted == 1) && ((oItemType == BASE_ITEM_LONGBOW) || (oItemType == BASE_ITEM_SLING) || (oItemType == BASE_ITEM_THROWINGAXE) || (oItemType == BASE_ITEM_DART) || (oItemType == BASE_ITEM_SHURIKEN) || (oItemType == BASE_ITEM_HEAVYCROSSBOW)))
    {
       SendMessageToPC( oPC, "You cannot use that weapon while mounted!");
       AssignCommand(oPC, ActionUnequipItem(oItem));

    }
    else if((mounted == 1) && (GetHasFeat(FEAT_MOUNTED_ARCHERY, oPC) != TRUE))
    {
      if ((oItemType == BASE_ITEM_SHORTBOW) || (oItemType == BASE_ITEM_LIGHTCROSSBOW))
      {
        SendMessageToPC( oPC, "You cannot use that weapon while mounted without proper training!");
        AssignCommand(oPC, ActionUnequipItem(oItem));
      }
    }


    // This is an adjustment to the EffectDamageIncrease constants, after 5 they have a weird 10 constant
    // section used for something else before going back to bonus damage.
    if((iDamage > 5))
    {
       iDamage = iDamage + 10;
    }
    else if(iDamage > 20)
    {
       iDamage = 30;
    }

    object armorInSlot = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nAppearance = GetItemAppearance(armorInSlot, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    int armorValue = StringToInt(Get2DAString("parts_chest", "ACBONUS", nAppearance));
    int isWearingHeavyArmor = armorValue >= 6;

    // Two hander bonus for hins/small races + making sure there is no shield from MG
    if(GetCreatureSize(oPC) == CREATURE_SIZE_SMALL  && !GetIsPolymorphed(oPC))
    {

    // Slashing
    if(((oItemType == BASE_ITEM_BASTARDSWORD) || (oItemType == BASE_ITEM_BATTLEAXE) ||
    (oItemType == BASE_ITEM_SCIMITAR) || (oItemType == BASE_ITEM_LONGSWORD) || (oItemType == BASE_ITEM_KATANA)
    || (oItemType == BASE_ITEM_DWARVENWARAXE)) && (oOffItemType != BASE_ITEM_TOWERSHIELD) && (oOffItemType != BASE_ITEM_SMALLSHIELD)
    && (oOffItemType != BASE_ITEM_LARGESHIELD))
    {
        eAB     = EffectAttackIncrease(2,ATTACK_BONUS_MISC);
        eDamage;
        if(!GetHasFeat(1246,oPC))
        {
          eDamage = EffectDamageIncrease(iDamage,DAMAGE_TYPE_SLASHING);
        }

        twoHanderBonus = EffectLinkEffects(eDamage, eAB);

        // Indomitable, check for feat 1246
        if(GetHasFeat(1246, oPC) && isWearingHeavyArmor)
        {
            effect acIncrease = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
            effect reflexDecrease = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 3);

            twoHanderBonus = EffectLinkEffects(twoHanderBonus, acIncrease);

            reflexDecrease = SupernaturalEffect(reflexDecrease);
            reflexDecrease = TagEffect(reflexDecrease, "twohanderbuff");
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, reflexDecrease, oPC);
        }

        twoHanderBonus = SupernaturalEffect(twoHanderBonus);
        twoHanderBonus = TagEffect(twoHanderBonus,"twohanderbuff");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, twoHanderBonus, oPC);

    }// Bludgeoning
    else if(((oItemType == BASE_ITEM_MAGICSTAFF) || (oItemType == BASE_ITEM_CLUB)
    || (oItemType == BASE_ITEM_LIGHTFLAIL) || (oItemType == BASE_ITEM_WARHAMMER)) && (oOffItemType != BASE_ITEM_TOWERSHIELD)
    && (oOffItemType != BASE_ITEM_SMALLSHIELD) && (oOffItemType != BASE_ITEM_LARGESHIELD))
    {
       eAB     = EffectAttackIncrease(2,ATTACK_BONUS_MISC);
       eDamage;
       if(!GetHasFeat(1246,oPC))
       {
         eDamage = EffectDamageIncrease(iDamage,DAMAGE_TYPE_BLUDGEONING);
       }
       twoHanderBonus = EffectLinkEffects(eDamage, eAB);

        if(GetHasFeat(1246, oPC) && isWearingHeavyArmor)
        {
            effect acIncrease = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
            effect reflexDecrease = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 3);

            twoHanderBonus = EffectLinkEffects(twoHanderBonus, acIncrease);

            reflexDecrease = SupernaturalEffect(reflexDecrease);
            reflexDecrease = TagEffect(reflexDecrease, "twohanderbuff");
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, reflexDecrease, oPC);
        }

       twoHanderBonus = SupernaturalEffect(twoHanderBonus);
       twoHanderBonus = TagEffect(twoHanderBonus,"twohanderbuff");
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, twoHanderBonus, oPC);


    }// Blud/Pierc
    else if(((oItemType == BASE_ITEM_MORNINGSTAR)) && (oOffItemType != BASE_ITEM_TOWERSHIELD) && (oOffItemType != BASE_ITEM_SMALLSHIELD)
    && (oOffItemType != BASE_ITEM_LARGESHIELD))
    {
       eAB     = EffectAttackIncrease(2,ATTACK_BONUS_MISC);
       eDamage;
       if(!GetHasFeat(1246,oPC))
       {
         eDamage = EffectDamageIncrease(iDamage,DAMAGE_TYPE_PIERCING);
       }
       twoHanderBonus = EffectLinkEffects(eDamage, eAB);

        if(GetHasFeat(1246, oPC) && isWearingHeavyArmor)
        {
            effect acIncrease = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
            effect reflexDecrease = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 3);

            twoHanderBonus = EffectLinkEffects(twoHanderBonus, acIncrease);

            reflexDecrease = SupernaturalEffect(reflexDecrease);
            reflexDecrease = TagEffect(reflexDecrease, "twohanderbuff");
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, reflexDecrease, oPC);
        }
       twoHanderBonus = SupernaturalEffect(twoHanderBonus);
       twoHanderBonus = TagEffect(twoHanderBonus,"twohanderbuff");
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, twoHanderBonus, oPC);

    } // Pierc
    else if(((oItemType == BASE_ITEM_RAPIER)) && (oOffItemType != BASE_ITEM_TOWERSHIELD) && (oOffItemType != BASE_ITEM_SMALLSHIELD)
    && (oOffItemType != BASE_ITEM_LARGESHIELD))
    {
       eAB     = EffectAttackIncrease(2,ATTACK_BONUS_MISC);
       eDamage;
       if(!GetHasFeat(1246,oPC))
       {
         eDamage = EffectDamageIncrease(iDamage,DAMAGE_TYPE_PIERCING);
       }
       twoHanderBonus = EffectLinkEffects(eDamage, eAB);

        if(GetHasFeat(1246, oPC) && isWearingHeavyArmor)
        {
            effect acIncrease = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
            effect reflexDecrease = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 3);

            twoHanderBonus = EffectLinkEffects(twoHanderBonus, acIncrease);

            reflexDecrease = SupernaturalEffect(reflexDecrease);
            reflexDecrease = TagEffect(reflexDecrease, "twohanderbuff");
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, reflexDecrease, oPC);
        }
       twoHanderBonus = SupernaturalEffect(twoHanderBonus);
       twoHanderBonus = TagEffect(twoHanderBonus,"twohanderbuff");
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, twoHanderBonus, oPC);
    }






    }
    else if(!GetIsPolymorphed(oPC))
    {
    // Two hander bonus for normal pcs + making sure there is no shield from MG
    if(((oItemType == BASE_ITEM_GREATAXE) || (oItemType == BASE_ITEM_GREATSWORD))
    && (oOffItemType != BASE_ITEM_TOWERSHIELD) && (oOffItemType != BASE_ITEM_SMALLSHIELD)
    && (oOffItemType != BASE_ITEM_LARGESHIELD))  // Slashing
    {

       eAB     = EffectAttackIncrease(2,ATTACK_BONUS_MISC);
       eDamage;
       if(!GetHasFeat(1246,oPC))
       {
         eDamage = EffectDamageIncrease(iDamage,DAMAGE_TYPE_SLASHING);
       }
       twoHanderBonus = EffectLinkEffects(eDamage, eAB);

        if(GetHasFeat(1246, oPC) && isWearingHeavyArmor)
        {
            effect acIncrease = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
            effect reflexDecrease = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 3);

            twoHanderBonus = EffectLinkEffects(twoHanderBonus, acIncrease);

            reflexDecrease = SupernaturalEffect(reflexDecrease);
            reflexDecrease = TagEffect(reflexDecrease, "twohanderbuff");
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, reflexDecrease, oPC);
        }
        twoHanderBonus = SupernaturalEffect(twoHanderBonus);
        twoHanderBonus = TagEffect(twoHanderBonus,"twohanderbuff");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, twoHanderBonus, oPC);

    }
    else if(((oItemType == BASE_ITEM_SCYTHE) || (oItemType == BASE_ITEM_HALBERD))
    && (oOffItemType != BASE_ITEM_TOWERSHIELD) && (oOffItemType != BASE_ITEM_SMALLSHIELD)
    && (oOffItemType != BASE_ITEM_LARGESHIELD)) // Slashing + Pierce
    {
       eAB     = EffectAttackIncrease(2,ATTACK_BONUS_MISC);
       eDamage;
       if(!GetHasFeat(1246,oPC))
       {
         eDamage = EffectDamageIncrease(iDamage,DAMAGE_TYPE_PIERCING);
       }
       twoHanderBonus = EffectLinkEffects(eDamage, eAB);

       twoHanderBonus = SupernaturalEffect(twoHanderBonus);
        if(GetHasFeat(1246, oPC) && isWearingHeavyArmor)
        {
            effect acIncrease = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
            effect reflexDecrease = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 3);

            twoHanderBonus = EffectLinkEffects(twoHanderBonus, acIncrease);

            reflexDecrease = SupernaturalEffect(reflexDecrease);
            reflexDecrease = TagEffect(reflexDecrease, "twohanderbuff");
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, reflexDecrease, oPC);
        }

       twoHanderBonus = TagEffect(twoHanderBonus,"twohanderbuff");
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, twoHanderBonus, oPC);
    }
    else if((oItemType == BASE_ITEM_HEAVYFLAIL) && (oOffItemType != BASE_ITEM_TOWERSHIELD)
    && (oOffItemType != BASE_ITEM_SMALLSHIELD) && (oOffItemType != BASE_ITEM_LARGESHIELD)) // Bludg
    {
       eAB     = EffectAttackIncrease(2,ATTACK_BONUS_MISC);
       eDamage;
       if(!GetHasFeat(1246,oPC))
       {
         eDamage = EffectDamageIncrease(iDamage,DAMAGE_TYPE_BLUDGEONING);
       }
       twoHanderBonus = EffectLinkEffects(eDamage, eAB);

        if(GetHasFeat(1246, oPC) && isWearingHeavyArmor)
        {
            effect acIncrease = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
            effect reflexDecrease = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 3);

            twoHanderBonus = EffectLinkEffects(twoHanderBonus, acIncrease);

            reflexDecrease = SupernaturalEffect(reflexDecrease);
            reflexDecrease = TagEffect(reflexDecrease, "twohanderbuff");
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, reflexDecrease, oPC);
        }
        twoHanderBonus = SupernaturalEffect(twoHanderBonus);
       twoHanderBonus = TagEffect(twoHanderBonus,"twohanderbuff");
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, twoHanderBonus, oPC);
    }
    else if((oItemType == BASE_ITEM_SHORTSPEAR) && (oOffItemType != BASE_ITEM_TOWERSHIELD)
    && (oOffItemType != BASE_ITEM_SMALLSHIELD)
    && (oOffItemType != BASE_ITEM_LARGESHIELD)) // Pierce
    {
       eAB     = EffectAttackIncrease(2,ATTACK_BONUS_MISC);
       eDamage;
       if(!GetHasFeat(1246,oPC))
       {
         eDamage = EffectDamageIncrease(iDamage,DAMAGE_TYPE_PIERCING);
       }
       twoHanderBonus = EffectLinkEffects(eDamage, eAB);

        if(GetHasFeat(1246, oPC) && isWearingHeavyArmor)
        {
            effect acIncrease = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
            effect reflexDecrease = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 3);

            twoHanderBonus = EffectLinkEffects(twoHanderBonus, acIncrease);

            reflexDecrease = SupernaturalEffect(reflexDecrease);
            reflexDecrease = TagEffect(reflexDecrease, "twohanderbuff");
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, reflexDecrease, oPC);
        }
       twoHanderBonus = SupernaturalEffect(twoHanderBonus);
       twoHanderBonus = TagEffect(twoHanderBonus,"twohanderbuff");
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, twoHanderBonus, oPC);
    }
    }




    if( GetIsDM( oPC ) ) WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - mod_equ_item 32: OnEquip started for DM..." );

    //If the 'copy_HIPS_to_poly' local int is set, the HiPS bonus feat is
    //added to the SD's equipped hide.  Then the local int is deleted.
    if ( GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC ) >= 6 )
    {
        DelayCommand( 2.0, AddShadowdancerHiPS( oPC, oItem ) );
    }


    if ( GetLocalInt( oItem, "ds_uneq" ) == 0 && GetName( GetArea( oPC ) ) != "" && GetLocalInt( oPC, "is_crafting" ) != 1 ){

        IPRemoveAllItemProperties( oItem, DURATION_TYPE_TEMPORARY );

        SendMessageToPC( oPC, "<c? ?>Stale temporary properties detected, cleaning item.</c>" );

        SetLocalInt( oItem, "ds_uneq", 0 );
    }

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

void AddShadowdancerHiPS( object oPC, object oItem )
{
    if ( GetItemInSlot( INVENTORY_SLOT_CARMOUR, oPC ) == oItem )
    {
        if ( GetLocalInt( oPC, "copy_HIPS_to_poly" ) )
        {
            //Add the HIPS bonus feat.
            itemproperty ipHIPS = ItemPropertyBonusFeat( IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT );
            IPSafeAddItemProperty( oItem, ipHIPS, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE );
            DeleteLocalInt( oPC, "copy_HIPS_to_poly" );
        }
    }
}
