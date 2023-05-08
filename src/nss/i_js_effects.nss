/*

    Job System Master Effects Script For On Use Unique

    - Maverick00053



    Changes:

    8/8/2022 Lord Jyssev - Moved scripts for Artificer storage items and made them modular. Also moved Tailor backpack, quiver, and scabbards into js_effects

*/


#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "tcs_include"
#include "inc_td_itemprop"

void JobSystemItemEffects(object oPC, object oWidget, location lTarget, object oTarget);
void CreateZombie(object oPC, object oWidget, location lTarget);
void CreateGolem(object oPC, object oWidget, location lTarget);
void CreateDemon(object oPC, object oWidget, location lTarget);
void StoreItem(object oPC, object oWidget, object oTarget, int nCapacity, string sContainerType);
void RetrieveItem(object oPC, object oWidget, int nItemCount, int nBatch);

// On Attacked for Soldier Combat Dummy
void CombatDummy(object oPC, object oDummy);

int CheckIfSpellAlreadyPresent(object oPC, string sTag);


void main()
{

  object oPC = GetItemActivator();
  object oWidget = GetItemActivated();
  object oDummy = OBJECT_SELF;
  location lTarget = GetItemActivatedTargetLocation();
  object oTarget = GetItemActivatedTarget();



  if(GetResRef(OBJECT_SELF) == "js_s_combatd")
  {
  oPC = GetLastAttacker();
  CombatDummy(oPC,oDummy);
  }
  else
  {
  JobSystemItemEffects(oPC,oWidget,lTarget,oTarget);
  }


}

void JobSystemItemEffects(object oPC, object oWidget, location lTarget, object oTarget)
{
   string sItemResRef = GetResRef(oWidget);
   effect eVFX;
   effect eLink;
   effect eEffect;
   effect eEffect2;
   effect eEffect3;
   object oHenchmen;


   if(sItemResRef == "js_alch_poai")   // Potion of Elemental Resistance: Air
   {
     if(CheckIfSpellAlreadyPresent(oPC,"potionair") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     eEffect = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 25);
     eEffect = TagEffect(eEffect,"potionair");
     AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0,1.0));
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 60.0);
   }
   else if(sItemResRef == "js_alch_poea")   // Potion of Elemental Resistance: Earth
   {
     if(CheckIfSpellAlreadyPresent(oPC,"potionearth") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     eEffect = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 25);
     eEffect = TagEffect(eEffect,"potionearth");
     AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0,1.0));
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 60.0);
   }
   else if(sItemResRef == "js_alch_pofi")   // Potion of Elemental Resistance: Fire
   {
     if(CheckIfSpellAlreadyPresent(oPC,"potionfire") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     eEffect = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 25);
     eEffect = TagEffect(eEffect,"potionfire");
     AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0,1.0));
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 60.0);
   }
   else if(sItemResRef == "js_alch_powa")   // Potion of Elemental Resistance: Water
   {
     if(CheckIfSpellAlreadyPresent(oPC,"potionwater") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     eEffect = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 25);
     eEffect = TagEffect(eEffect,"potionwater");
     AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0,1.0));
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 60.0);
   }
   else if(sItemResRef == "js_alch_slee")   // Sleeping Tea
   {
     if(CheckIfSpellAlreadyPresent(oPC,"sleepingtea") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     eEffect = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2);
     eEffect2 = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 1);
     eEffect3 = EffectTemporaryHitpoints(20);
     eLink = EffectLinkEffects(eEffect,eEffect2);
     eLink = TagEffect(eLink,"sleepingtea");
     AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0,1.0));
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 60.0);
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect3, oPC, 60.0);

   }
   else if(sItemResRef == "js_alch_ince")   // Incense
   {
     if(CheckIfSpellAlreadyPresent(oPC,"incense") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     eEffect = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2);
     eEffect2 = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 1);
     eEffect3 = EffectTemporaryHitpoints(20);
     eLink = EffectLinkEffects(eEffect,eEffect2);
     eLink = TagEffect(eLink,"incense");
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 60.0);
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect3, oPC, 60.0);

   }
   else if(sItemResRef == "js_arca_zom" || sItemResRef == "js_arca_zom_w" || sItemResRef == "js_arca_zom_e"
   || sItemResRef == "js_arca_zom_f" || sItemResRef == "shroudhelm")   // Zombies
   {
      CreateZombie(oPC,oWidget,lTarget);
   }
   else if(sItemResRef == "js_arca_gol" || sItemResRef == "js_arca_gol_g" || sItemResRef == "js_arca_gol_c"
   || sItemResRef == "js_arca_gol_h")   // Golems
   {
      CreateGolem(oPC,oWidget,lTarget);
   }
   else if(sItemResRef == "js_arca_dem")   // Trapped Demonic Entity
   {
      CreateDemon(oPC,oWidget,lTarget);
   }
   else if(sItemResRef == "js_sco_druw")   // Weed Concentrate Drug
   {
     if(CheckIfSpellAlreadyPresent(oPC,"weeddrug") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     eVFX = EffectVisualEffect(VFX_FNF_SMOKE_PUFF);
     eEffect = EffectSlow();
     eEffect2 = EffectDamageReduction(5,DAMAGE_POWER_PLUS_FIVE);
     eLink = EffectLinkEffects(eEffect,eEffect2);
     eLink = EffectLinkEffects(eVFX,eLink);
     eLink = TagEffect(eLink,"weeddrug");
     SendMessageToPC(oPC,"You feel relaxed, calm, and almost numb to issues. You are also quite hungry.");
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 60.0);
   }
   else if(sItemResRef == "js_sco_drus")   // Zoom Drug
   {
     if(CheckIfSpellAlreadyPresent(oPC,"zoomdrug") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     eEffect = EffectHaste();
     eEffect2 = EffectSavingThrowDecrease(SAVING_THROW_WILL,2);
     eLink = EffectLinkEffects(eEffect,eEffect2);
     eLink = TagEffect(eLink,"zoomdrug");
     SendMessageToPC(oPC,"You feel energized, almost unstoppable.");
     AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0,1.0));
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 60.0);
   }
   else if(sItemResRef == "js_sco_drum")   // Shrooms Drug
   {
     if(CheckIfSpellAlreadyPresent(oPC,"shroomsdrug") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }

     if(GetIsImmune(oPC, IMMUNITY_TYPE_CONFUSED) || GetIsImmune(oPC, IMMUNITY_TYPE_MIND_SPELLS))
     {
       SendMessageToPC(oPC,"The drug seems to have no effect on you because of your protections");
       return;
     }
     eVFX = EffectVisualEffect(VFX_DUR_GLOW_LIGHT_RED);
     eEffect = EffectConfused();
     eEffect2 = EffectDamageIncrease(DAMAGE_BONUS_5,DAMAGE_TYPE_BLUDGEONING);
     eEffect3 = EffectAttackIncrease(3,ATTACK_BONUS_MISC);
     eLink = EffectLinkEffects(eEffect,eEffect2);
     eLink = EffectLinkEffects(eLink,eEffect3);
     eLink = EffectLinkEffects(eVFX,eLink);
     eLink = TagEffect(eLink,"shroomsdrug");
     SendMessageToPC(oPC,"You become enraged, confused, and almost unstoppable as you begin to foam at the mouth.");
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 60.0);
   }
   else if((sItemResRef == "js_che_meba") || (sItemResRef == "js_che_frto") || (sItemResRef == "js_che_sapa"))   //Tier 3 Food
   {
     if(CheckIfSpellAlreadyPresent(oPC,"cheffood") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     eVFX = EffectVisualEffect(555);
     eEffect = EffectTemporaryHitpoints(40);
     eEffect2 = EffectSavingThrowIncrease(SAVING_THROW_FORT,3);
     eEffect3 = EffectAttackIncrease(1,ATTACK_BONUS_MISC);
     eLink = EffectLinkEffects(eVFX,eEffect2);
     eLink = EffectLinkEffects(eLink,eEffect3);
     eEffect = TagEffect(eEffect,"cheffood");
     eLink = TagEffect(eLink,"cheffood");
     SendMessageToPC(oPC,"You consume food");
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 300.0);
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 300.0);
   }
   else if((sItemResRef == "js_che_coco") || (sItemResRef == "js_che_mepi") || (sItemResRef == "js_che_appi")
    || (sItemResRef == "js_che_chpi") || (sItemResRef == "js_che_brea") || (sItemResRef == "js_che_capi") || (sItemResRef == "js_che_cake")
     || (sItemResRef == "js_che_batr") || (sItemResRef == "js_che_bans") || (sItemResRef == "js_che_frap") || (sItemResRef == "js_che_spmu")
      || (sItemResRef == "js_che_baho"))   //Tier 2 Food
   {
     if(CheckIfSpellAlreadyPresent(oPC,"cheffood") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     eVFX = EffectVisualEffect(555);
     eEffect = EffectTemporaryHitpoints(30);
     eEffect2 = EffectSavingThrowIncrease(SAVING_THROW_FORT,3);
     eLink = EffectLinkEffects(eVFX,eEffect2);
     eEffect = TagEffect(eEffect,"cheffood");
     eLink = TagEffect(eLink,"cheffood");
     SendMessageToPC(oPC,"You consume food");
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 300.0);
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 300.0);
   }
   else if((sItemResRef == "js_che_smsa") || (sItemResRef == "js_che_quic") || (sItemResRef == "js_che_poso") || (sItemResRef == "js_che_smst")
    || (sItemResRef == "js_che_baom") || (sItemResRef == "js_che_frba") || (sItemResRef == "js_che_cheg") || (sItemResRef == "js_che_swca") || (sItemResRef == "js_che_porr")
     || (sItemResRef == "js_che_caso") || (sItemResRef == "js_che_hcwi") || (sItemResRef == "js_che_hgha") || (sItemResRef == "js_che_sufr") || (sItemResRef == "js_che_bocr")
      || (sItemResRef == "js_che_rolo") || (sItemResRef == "js_che_clch") || (sItemResRef == "js_che_roro") || (sItemResRef == "js_che_dtpl") || (sItemResRef == "js_che_romo")
       || (sItemResRef == "js_che_zuje") || (sItemResRef == "js_che_saus"))   //Tier 1 Food
   {
     if(CheckIfSpellAlreadyPresent(oPC,"cheffood") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     eVFX = EffectVisualEffect(555);
     eEffect = EffectTemporaryHitpoints(20);
     eVFX = TagEffect(eVFX,"cheffood");
     eEffect = TagEffect(eEffect,"cheffood");
     SendMessageToPC(oPC,"You consume food");
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 300.0);
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 300.0);
   }
   else if((sItemResRef == "js_bre_fili") || (sItemResRef == "js_bre_ale") || (sItemResRef == "js_bre_mead") ||
   (sItemResRef == "js_bre_puru") || (sItemResRef == "js_bre_babe"))   //Tier 3 Drink
   {
     if(CheckIfSpellAlreadyPresent(oPC,"brewerdrink") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     //eVFX = EffectVisualEffect(566);
     eEffect = EffectAbilityDecrease(ABILITY_INTELLIGENCE,1);
     eEffect2 = EffectSavingThrowIncrease(SAVING_THROW_ALL,2);
     eEffect3 = EffectAbilityIncrease(ABILITY_CONSTITUTION,1);
     eLink = EffectLinkEffects(eEffect,eEffect2);
     eLink = EffectLinkEffects(eLink,eEffect3);
     //eLink = EffectLinkEffects(eVFX,eLink);
     eLink = TagEffect(eLink,"brewerdrink");
     SendMessageToPC(oPC,"You consume a drink");
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 300.0);
     AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0,1.0));
   }
   else if((sItemResRef == "js_bre_tual") || (sItemResRef == "js_bre_firl")
   || (sItemResRef == "js_bre_velv"))   //Tier 2 Drink
   {
     if(CheckIfSpellAlreadyPresent(oPC,"brewerdrink") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     //eVFX = EffectVisualEffect(566);
     eEffect = EffectAbilityDecrease(ABILITY_INTELLIGENCE,1);
     eEffect2 = EffectSavingThrowIncrease(SAVING_THROW_ALL,2);
     eEffect3 = EffectAbilityIncrease(ABILITY_CONSTITUTION,1);
     eLink = EffectLinkEffects(eEffect,eEffect2);
     eLink = EffectLinkEffects(eLink,eEffect3);
     //eLink = EffectLinkEffects(eVFX,eLink);
     eLink = TagEffect(eLink,"brewerdrink");
     SendMessageToPC(oPC,"You consume a drink");
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 300.0);
     AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0,1.0));
   }
   else if((sItemResRef == "js_bre_wine") || (sItemResRef == "js_bre_cide")
   || (sItemResRef == "js_bre_chju") || (sItemResRef == "js_bre_comi") ||
   (sItemResRef == "js_bre_grju") || (sItemResRef == "js_bre_apju"))   //Tier 1 Drink
   {
     if(CheckIfSpellAlreadyPresent(oPC,"brewerdrink") == 1)
     {
       FloatingTextStringOnCreature("*You cannot gain the benefits of this item till the old effects fade*",oPC);
       return;
     }
     //eVFX = EffectVisualEffect(566);
     eEffect = EffectAbilityDecrease(ABILITY_INTELLIGENCE,1);
     eEffect2 = EffectSavingThrowIncrease(SAVING_THROW_WILL,2);
     eLink = EffectLinkEffects(eEffect,eEffect2);
     //eLink = EffectLinkEffects(eVFX,eLink);
     eLink = TagEffect(eLink,"brewerdrink");
     SendMessageToPC(oPC,"You consume a drink");
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 300.0);
     AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0,1.0));
   }
   else if(sItemResRef == "js_alch_nebrew") // Negative Energy Brew
   {
     eVFX = EffectVisualEffect(246);
     eEffect = EffectHeal(100);
     eEffect2 = EffectDamage(100,DAMAGE_TYPE_NEGATIVE);

     if(GetRacialType(oPC) == RACIAL_TYPE_UNDEAD || GetLevelByClass(CLASS_TYPE_UNDEAD, oPC) > 0 )
     {
       eLink = EffectLinkEffects(eVFX,eEffect);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oPC);
     }
     else
     {
       eLink = EffectLinkEffects(eVFX,eEffect2);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oPC);
     }

   }
   else if(sItemResRef == "js_alch_underw") // Turns any equipment except weapons into underwater gear
   {
     if((GetObjectType(oTarget) == OBJECT_TYPE_ITEM))
     {
       if((GetBaseItemType(oTarget) == BASE_ITEM_RING) || (GetBaseItemType(oTarget) == BASE_ITEM_CLOAK) || (GetBaseItemType(oTarget) == BASE_ITEM_HELMET) || (GetBaseItemType(oTarget) == BASE_ITEM_AMULET) || (GetBaseItemType(oTarget) == BASE_ITEM_ARMOR) || (GetBaseItemType(oTarget) == BASE_ITEM_BELT) || (GetBaseItemType(oTarget) == BASE_ITEM_BOOTS) || (GetBaseItemType(oTarget) == BASE_ITEM_BRACER) || (GetBaseItemType(oTarget) == BASE_ITEM_GLOVES) || (GetBaseItemType(oTarget) == BASE_ITEM_SMALLSHIELD) || (GetBaseItemType(oTarget) == BASE_ITEM_TOWERSHIELD) || (GetBaseItemType(oTarget) == BASE_ITEM_LARGESHIELD))
       {
         FloatingTextStringOnCreature("*You have successfully enchanted this item for underwater breathing*",oPC);
         SetTag(oTarget,"ds_underwater");
         string sDescription = GetDescription(oTarget);
         SetDescription(oTarget,sDescription + "\n\n<c~Îë>-Underwater Enabled-</c>");
       }
       else
       {
         FloatingTextStringOnCreature("*The enchantment does not work on this type of item*",oPC);
         CreateItemOnObject(sItemResRef,oPC);
       }
     }
     else
     {
       FloatingTextStringOnCreature("*The enchantment only works on items*",oPC);
       CreateItemOnObject(sItemResRef,oPC);
     }

   }
   else if(sItemResRef == "js_poison")  // Scoundrel Poison Mixture
   {
      if(IPGetIsMeleeWeapon(oTarget))
      {
        IPSafeAddItemProperty(oTarget,ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN,IP_CONST_ONHIT_SAVEDC_26,2),60.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
      }
      else
      {
       FloatingTextStringOnCreature("*Only works on melee weapons*",oPC);
      }
   }
   else if(sItemResRef == "js_bindingrope")  //
   {
      if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
      {
       FloatingTextStringOnCreature("*Bindings failed! What are you even doing!?*",oPC);
       return;
      }

      if((GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID) && (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE))
      {
        if(GetHasSpellEffect(SPELL_SLEEP,oTarget))
        {
         FloatingTextStringOnCreature("*Successfully binded the creature!*",oPC);
         DestroyObject(oTarget);
         CreateItemOnObject("js_b_slavegoblin",oPC);
        }
        else
        {
         FloatingTextStringOnCreature("*The goblinoid fights you and breaks free! Perhaps if they weren't so active it might be easier?*",oPC);
        }

      }
      else
      {
       FloatingTextStringOnCreature("*Bindings failed! They are ill fitted for this creature*",oPC);
      }

   }
   else if(sItemResRef == "js_b_slavegoblin")  //
   {
      object oHenchmen = CreateObject(OBJECT_TYPE_CREATURE,"js_slavegoblin",lTarget,FALSE);
      AddHenchman(oPC,oHenchmen);

   }
   else if(sItemResRef == "js_arca_spiderl") // Spawns Spider Egg Sacks
   {
     object oEgg = CreateObject(OBJECT_TYPE_PLACEABLE,"js_hun_eggsack",lTarget);
     SetLocalString(oEgg,"owner",GetName(oPC));
   }
   else if(GetSubString(sItemResRef, 0, 10) == "js_art_col") //Artist Bag Dyes
   {
     int nBaseItem = GetBaseItemType(oTarget);
     int nAppearance = GetItemAppearance(oTarget, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
     int nColorModifier = GetLocalInt(oWidget, "ColorModifier"); //This variable is set on the base item of the dye and modifies the base bag item icon to correspond to the colored bag appearance

     if(nBaseItem == BASE_ITEM_LARGEBOX)
     {
        switch (nAppearance)
        {
            case 1: nAppearance=(1 + nColorModifier); break;
            case 2: nAppearance=(2 + nColorModifier); break;
            case 3: nAppearance=(3 + nColorModifier); break;
            case 4: nAppearance=(1 + nColorModifier); break;
            case 5: nAppearance=(2 + nColorModifier); break;
            case 6: nAppearance=(3 + nColorModifier); break;
            case 7: nAppearance=(1 + nColorModifier); break;
            case 8: nAppearance=(2 + nColorModifier); break;
            case 9: nAppearance=(3 + nColorModifier); break;
            case 10: nAppearance=(1 + nColorModifier); break;
            case 11: nAppearance=(2 + nColorModifier); break;
            case 12: nAppearance=(3 + nColorModifier); break;
            case 13: nAppearance=(1 + nColorModifier); break;
            case 14: nAppearance=(2 + nColorModifier); break;
            case 15: nAppearance=(3 + nColorModifier); break;
            case 16: nAppearance=(1 + nColorModifier); break;
            case 17: nAppearance=(2 + nColorModifier); break;
            case 18: nAppearance=(3 + nColorModifier); break;
            case 19: nAppearance=(1 + nColorModifier); break;
            case 20: nAppearance=(2 + nColorModifier); break;
            case 21: nAppearance=(3 + nColorModifier); break;
            case 22: nAppearance=(1 + nColorModifier); break;
            case 23: nAppearance=(2 + nColorModifier); break;
            case 24: nAppearance=(3 + nColorModifier); break;
            case 25: nAppearance=(1 + nColorModifier); break;
            case 26: nAppearance=(2 + nColorModifier); break;
            case 27: nAppearance=(3 + nColorModifier); break;
            case 28: nAppearance=(1 + nColorModifier); break;
            case 29: nAppearance=(2 + nColorModifier); break;
            case 30: nAppearance=(3 + nColorModifier); break;
        }
        object oNewItem = CopyItemAndModifyFixed( oTarget, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nAppearance, TRUE );

        if (GetIsObjectValid(oNewItem)){
            SetLocalObject(oPC, "ds_target", oNewItem);
            DestroyObject(oTarget);
        }
        else
        {
            SendMessageToPC(oPC,"Empty your container before dyeing.");
            CreateItemOnObject(sItemResRef,oPC);
        }
     }
     else
     {
        SendMessageToPC(oPC,"This pigment can only be used to dye inventory containers.");
        CreateItemOnObject(sItemResRef,oPC);
     }
   }
   else if(sItemResRef == "js_tai_bpack1" || sItemResRef == "js_tai_quiver1" || GetSubString(sItemResRef, 0, 12) == "js_tai_scbrd") //Tailor Back items
   {
     int nCurrent  = GetCreatureWingType( oPC );
     int nBackpack;

     if(sItemResRef == "js_tai_bpack1") { nBackpack = 79; }
     else if(sItemResRef == "js_tai_quiver1") { nBackpack = 81; }
     else if(sItemResRef == "js_tai_scbrd1") { nBackpack = 83; }
     else if(sItemResRef == "js_tai_scbrd2") { nBackpack = 85; }
     else if(sItemResRef == "js_tai_scbrd3") { nBackpack = 87; }

     int nVariant  = nBackpack + 1;

     if (( nCurrent > 0 && nCurrent < 79 )|| ( nCurrent > 90 && nCurrent < 112 ))
     {
         SendMessageToPC( oPC, "You can't use this item if you have wings." );
         return;
     }

     if ( nCurrent == nBackpack && nCurrent  < 112 )
     {
         SetCreatureWingType( nVariant, oPC );
     }
     else if (( nCurrent == nVariant ) || ( nCurrent > 112 && nCurrent < 121 ))
     {
         SetCreatureWingType( 0, oPC );
     }
     else
     {
         SetCreatureWingType( nBackpack, oPC );
     }
   }
   else if(sItemResRef == "js_arca_bdbg")//Artificer Bandage Bag
   {
      string sTargetResRef = GetResRef( oTarget );
      string sContainerType = "Bag";
         string sTarget;
      int nCapacity = 10000;
      int nItemCount = GetLocalInt(oWidget, "ItemCount");
      int nBatch = 100;

          if((sTargetResRef == "js_alch_kit1") ||(sTargetResRef == "nw_it_medkit001") || (sTargetResRef == "medkitx1x10")  || (sTargetResRef == "it_medkit002") ) { sTarget = "js_alch_kit1"; }
     else if((sTargetResRef == "js_alch_kit3") ||(sTargetResRef == "nw_it_medkit002") || (sTargetResRef == "medkitx3x10")  || (sTargetResRef == "it_medkit003") ) { sTarget = "js_alch_kit3"; }
     else if((sTargetResRef == "js_alch_kit6") ||(sTargetResRef == "nw_it_medkit003") || (sTargetResRef == "medkitx6x10")  || (sTargetResRef == "it_medkit004") ) { sTarget = "js_alch_kit6"; }
     else if((sTargetResRef == "js_alch_kit10")||(sTargetResRef == "nw_it_medkit004") || (sTargetResRef == "medkitx10x10") || (sTargetResRef == "it_medkit005") ) { sTarget = "js_alch_kit10";}

      if ( ( GetSubString(sTarget, 0, 11) == "js_alch_kit" ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM  )
      {
         StoreItem(oPC, oWidget, oTarget, nCapacity, sContainerType);
      }
      else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ) //Get items from a targeted container
      {
          if ( nItemCount == 0 )
          {
              SendMessageToPC( oPC, "<cþ  >You need to dedicate this "+ GetStringLowerCase(sContainerType) +" to an item type before you can use it on a container.</c>" );
              return;
          }

          object oInContainer = GetFirstItemInInventory( oTarget );
          string sStoredItem = GetLocalString(oWidget, "StoredItem");

          while (GetIsObjectValid( oInContainer ) == TRUE)
          {

              if (sTarget == sStoredItem)
              {
                  StoreItem(oPC, oWidget, oInContainer, nCapacity, sContainerType);
              }

              oInContainer = GetNextItemInInventory( oTarget );
          }
      }
      else if ( oTarget == oPC )
      {
          RetrieveItem(oPC, oWidget, nItemCount, nBatch);
      }
      else
      {
          //invalid target
          SendMessageToPC( oPC, "<cþ  >This is not a valid target for this container. You can use it on yourself, bandages, or storage containers.</c>" );
      }
   }
   else if(sItemResRef == "js_arca_gmpo")//Artificer Gem Pouch
   {
      string sTarget = GetResRef( oTarget );
      string sContainerType = "Pouch";
      int nCapacity = 10000;
      int nItemCount = GetLocalInt(oWidget, "ItemCount");
      int nBatch = 100;

      if ( ( GetStringLeft( sTarget, 7 ) == "js_gem_"
             || sTarget == "js_jew_sapp"
             || sTarget == "js_jew_ruby"
             || sTarget == "js_jew_crys"
             || sTarget == "js_jew_diam"
             || sTarget == "js_jew_emer"
             && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ) )
      {
         StoreItem(oPC, oWidget, oTarget, nCapacity, sContainerType);
      }
      else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ) //Get items from a targeted container
      {
          if ( nItemCount == 0 )
          {
              SendMessageToPC( oPC, "<cþ  >You need to dedicate this "+ GetStringLowerCase(sContainerType) +" to an item type before you can use it on a container.</c>" );
              return;
          }

          object oInContainer = GetFirstItemInInventory( oTarget );
          string sStoredItem = GetLocalString(oWidget, "StoredItem");

          while (GetIsObjectValid( oInContainer ) == TRUE)
          {
              sTarget = GetResRef(oInContainer);

              if (sTarget == sStoredItem)
              {
                  StoreItem(oPC, oWidget, oInContainer, nCapacity, sContainerType);
              }

              oInContainer = GetNextItemInInventory( oTarget );
          }
      }
      else if ( oTarget == oPC )
      {
          RetrieveItem(oPC, oWidget, nItemCount, nBatch);
      }
      else
      {
          //invalid target
          SendMessageToPC( oPC, "<cþ  >This is not a valid target for this container. You can use it on yourself, gems, or storage containers.</c>" );
      }
   }
   else if(sItemResRef == "js_arca_mytu")//Artificer Mythal Tube
   {
      string sTarget = GetResRef( oTarget );
      string sContainerType = "Tube";
      int nCapacity = 100;
      int nItemCount = GetLocalInt(oWidget, "ItemCount");
      int nBatch = 1;

      if ( ( sTarget == "mythal1"
          || sTarget == "mythal2"
          || sTarget == "mythal3"
          || sTarget == "mythal4"
          || sTarget == "mythal5"
          || sTarget == "mythal6"
          || sTarget == "mythal7" )
          && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM )
      {
         StoreItem(oPC, oWidget, oTarget, nCapacity, sContainerType);
      }
      else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ) //Get items from a targeted container
      {
          if ( nItemCount == 0 )
          {
              SendMessageToPC( oPC, "<cþ  >You need to dedicate this "+ GetStringLowerCase(sContainerType) +" to an item type before you can use it on a container.</c>" );
              return;
          }

          object oInContainer = GetFirstItemInInventory( oTarget );
          string sStoredItem = GetLocalString(oWidget, "StoredItem");

          while (GetIsObjectValid( oInContainer ) == TRUE)
          {
              sTarget = GetResRef(oInContainer);

              if (sTarget == sStoredItem)
              {
                  StoreItem(oPC, oWidget, oInContainer, nCapacity, sContainerType);
              }

              oInContainer = GetNextItemInInventory( oTarget );
          }
      }
      else if ( oTarget == oPC )
      {
          RetrieveItem(oPC, oWidget, nItemCount, nBatch);
      }
      else
      {
          //invalid target
          SendMessageToPC( oPC, "<cþ  >This is not a valid target for this container. You can use it on yourself, mythals, or storage containers.</c>" );
      }
   }
   else if(sItemResRef == "js_arca_scbx")//Artificer Scroll Holder
   {
      string sTarget = GetResRef( oTarget );
      string sContainerType = "Holder";
      int nCapacity = 100;
      int nItemCount = GetLocalInt(oWidget, "ItemCount");
      int nBatch = 10;

      if ( GetBaseItemType( oTarget ) == BASE_ITEM_SPELLSCROLL || GetBaseItemType( oTarget ) == BASE_ITEM_BLANK_SCROLL )
      {
         StoreItem(oPC, oWidget, oTarget, nCapacity, sContainerType);
      }
      else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ) //Get items from a targeted container
      {
          if ( nItemCount == 0 )
          {
              SendMessageToPC( oPC, "<cþ  >You need to dedicate this "+ GetStringLowerCase(sContainerType) +" to an item type before you can use it on a container.</c>" );
              return;
          }

          object oInContainer = GetFirstItemInInventory( oTarget );
          string sStoredItem = GetLocalString(oWidget, "StoredItem");

          while (GetIsObjectValid( oInContainer ) == TRUE)
          {
              sTarget = GetResRef(oInContainer);

              if (sTarget == sStoredItem)
              {
                  StoreItem(oPC, oWidget, oInContainer, nCapacity, sContainerType);
              }

              oInContainer = GetNextItemInInventory( oTarget );
          }
      }
      else if ( oTarget == oPC )
      {
          RetrieveItem(oPC, oWidget, nItemCount, nBatch);
      }
      else
      {
          //invalid target
          SendMessageToPC( oPC, "<cþ  >This is not a valid target for this container. You can use it on yourself, scrolls, or storage containers.</c>" );
      }
   }
   else if(sItemResRef == "js_arca_trca")//Artificer Trap Case
   {
      string sTarget = GetResRef( oTarget );
      string sContainerType = "Case";
      int nCapacity = 20;
      int nItemCount = GetLocalInt(oWidget, "ItemCount");
      int nBatch = 1;

      if ( GetBaseItemType( oTarget ) == BASE_ITEM_TRAPKIT )
      {
         StoreItem(oPC, oWidget, oTarget, nCapacity, sContainerType);
      }
      else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ) //Get items from a targeted container
      {
          if ( nItemCount == 0 )
          {
              SendMessageToPC( oPC, "<cþ  >You need to dedicate this "+ GetStringLowerCase(sContainerType) +" to an item type before you can use it on a container.</c>" );
              return;
          }

          object oInContainer = GetFirstItemInInventory( oTarget );
          string sStoredItem = GetLocalString(oWidget, "StoredItem");

          while (GetIsObjectValid( oInContainer ) == TRUE)
          {
              sTarget = GetResRef(oInContainer);

              if (sTarget == sStoredItem)
              {
                  StoreItem(oPC, oWidget, oInContainer, nCapacity, sContainerType);
              }

              oInContainer = GetNextItemInInventory( oTarget );
          }
      }
      else if ( oTarget == oPC )
      {
          RetrieveItem(oPC, oWidget, nItemCount, nBatch);
      }
      else
      {
          //invalid target
          SendMessageToPC( oPC, "<cþ  >This is not a valid target for this container. You can use it on yourself, traps, or storage containers.</c>" );
      }
   }
   else if(sItemResRef == "js_arca_wdca")//Artificer Wand Case
   {
      string sTarget = GetResRef( oTarget );
      string sContainerType = "Case";
      int nCapacity = 100;
      int nItemCount = GetLocalInt(oWidget, "ItemCount");
      int nBatch = 10;

      if ( GetBaseItemType( oTarget ) == BASE_ITEM_BLANK_WAND )
      {
         StoreItem(oPC, oWidget, oTarget, nCapacity, sContainerType);
      }
      else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ) //Get items from a targeted container
      {
          if ( nItemCount == 0 )
          {
              SendMessageToPC( oPC, "<cþ  >You need to dedicate this "+ GetStringLowerCase(sContainerType) +" to an item type before you can use it on a container.</c>" );
              return;
          }

          object oInContainer = GetFirstItemInInventory( oTarget );
          string sStoredItem = GetLocalString(oWidget, "StoredItem");

          while (GetIsObjectValid( oInContainer ) == TRUE)
          {
              sTarget = GetResRef(oInContainer);

              if (sTarget == sStoredItem)
              {
                  StoreItem(oPC, oWidget, oInContainer, nCapacity, sContainerType);
              }

              oInContainer = GetNextItemInInventory( oTarget );
          }
      }
      else if ( oTarget == oPC )
      {
          RetrieveItem(oPC, oWidget, nItemCount, nBatch);
      }
      else
      {
          //invalid target
          SendMessageToPC( oPC, "<cþ  >This is not a valid target for this container. You can use it on yourself, bone wands, or storage containers.</c>" );
      }
   }



}

void CombatDummy(object oPC, object oDummy) // Combat Dummy XP Giver
{
  int nLevel = GetLocalInt(oDummy, "level");
  object oTrainer = GetLocalObject(oDummy, "trainer");
  int nPCLevel = GetLevelByPosition(1,oPC) + GetLevelByPosition(2,oPC) + GetLevelByPosition(3,oPC);

  if(nPCLevel < nLevel)
  {
    if(GetDistanceBetween(oPC,oTrainer) < 30.0) // If the trainer is nearby give extra xp
    {
      GiveXPToCreature(oPC,2);
    }
    else
    {
      GiveXPToCreature(oPC,1);
    }
  }
}


int CheckIfSpellAlreadyPresent(object oPC, string sTag)
{

   int eLoopSpellID;
   effect eLoop;

     eLoop = GetFirstEffect(oPC);
     // Checks for the buff on the caster PC. If present stops casting.
     while(GetIsEffectValid(eLoop))
     {
       eLoopSpellID = GetEffectSpellId(eLoop);

       if ((GetEffectTag(eLoop) == sTag))
       {
         return 1;
       }
         eLoop=GetNextEffect(oPC);
      }

      return 0;
}

void CreateZombie(object oPC, object oWidget, location lTarget)
{
   string sItemResRef = GetResRef(oWidget);
   string sWeaponName;
   effect eVFX;
   effect eVFXBurning = EffectVisualEffect(474);
   effect eLink;
   effect eEffect;
   effect eEffect2;
   effect eEffect3;
   object oHenchmen;
   object oWeapon;
   string sWeapon = GetLocalString(oWidget, "weapon");
   int nMaterial = GetLocalInt(oWidget, "material");     // Iron = 0, Steel = 2, Mithal = 4, Adam = 6
   itemproperty iEnhancement = ItemPropertyEnhancementBonus(nMaterial);
   itemproperty iWeaponVisual = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
   itemproperty iFireDamage = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_1d6);


   if(nMaterial == 0)
   {
     sWeaponName = "<c~Îë>Crafted Iron</c> ";
   }
   else if(nMaterial == 2)
   {
     sWeaponName = "<c~Îë>Crafted Steel</c> ";
   }
   else if(nMaterial == 3)
   {
     sWeaponName = "<c~Îë>Crafted Silver</c> ";
   }
   else if(nMaterial == 4)
   {
     sWeaponName = "<c~Îë>Crafted Mithral</c> ";
   }
   else if(nMaterial == 6)
   {
     sWeaponName = "<c~Îë>Crafted Adamantine</c> ";
   }


   if(sItemResRef == "js_arca_zom")   // Bound Zombie
   {
      eVFX = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
      oHenchmen = CreateObject(OBJECT_TYPE_CREATURE,"js_zombie",lTarget,FALSE);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lTarget);
      AddHenchman(oPC,oHenchmen);
   }
   else if(sItemResRef == "js_arca_zom_w")   // Bound Warrior Zombie
   {
      eVFX = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
      oHenchmen = CreateObject(OBJECT_TYPE_CREATURE,"js_w_zombie",lTarget,FALSE);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lTarget);
      AddHenchman(oPC,oHenchmen);
      // Add Weapon to creature
      oWeapon = CreateItemOnObject(sWeapon,oHenchmen,1);
      // Set the name and properties
      SetName(oWeapon,sWeaponName + GetName(oWeapon));
      AddItemProperty(DURATION_TYPE_TEMPORARY,iEnhancement,oWeapon,28800.0);
      SetItemCursedFlag(oWeapon,1);
      //Have the henchman equip the weapon
      AssignCommand(oHenchmen,ActionEquipItem(oWeapon,INVENTORY_SLOT_RIGHTHAND));
   }
   else if(sItemResRef == "js_arca_zom_e")   // Bound Elite Zombie
   {
      eVFX = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
      oHenchmen = CreateObject(OBJECT_TYPE_CREATURE,"js_e_zombie",lTarget,FALSE);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lTarget);
      AddHenchman(oPC,oHenchmen);
      // Add Weapon to creature
      oWeapon = CreateItemOnObject(sWeapon,oHenchmen,1);
      // Set the name and properties
      SetName(oWeapon,sWeaponName + GetName(oWeapon));
      AddItemProperty(DURATION_TYPE_TEMPORARY,iEnhancement,oWeapon,28800.0);
      SetItemCursedFlag(oWeapon,1);
      //Have the henchman equip the weapon
      AssignCommand(oHenchmen,ActionEquipItem(oWeapon,INVENTORY_SLOT_RIGHTHAND));
   }
   else if(sItemResRef == "js_arca_zom_f" || sItemResRef == "shroudhelm")   // Bound Infernal Zombie
   {

      eVFX = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
      oHenchmen = CreateObject(OBJECT_TYPE_CREATURE,"js_f_zombie",lTarget,FALSE);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lTarget);
      AddHenchman(oPC,oHenchmen);
      // Add Weapon to creature
      oWeapon = CreateItemOnObject(sWeapon,oHenchmen,1);
      // Set the name and properties
      SetName(oWeapon,sWeaponName + GetName(oWeapon));
      AddItemProperty(DURATION_TYPE_TEMPORARY,iEnhancement,oWeapon,28800.0);
      AddItemProperty(DURATION_TYPE_PERMANENT,iWeaponVisual,oWeapon);
      AddItemProperty(DURATION_TYPE_TEMPORARY,iFireDamage,oWeapon,28800.0);
      SetItemCursedFlag(oWeapon,1);
      //Have the henchman equip the weapon
      AssignCommand(oHenchmen,ActionEquipItem(oWeapon,INVENTORY_SLOT_RIGHTHAND));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVFXBurning,oHenchmen);
   }


}

void CreateGolem(object oPC, object oWidget, location lTarget)
{

   string sItemResRef = GetResRef(oWidget);
   string sWeaponName;
   string sArmorName;
   object oHenchmen;
   object oWeapon;
   int nArmorMaterial = GetLocalInt(oWidget, "armormaterial");
   string sWeapon = GetLocalString(oWidget, "weapon");
   int nMaterial = GetLocalInt(oWidget, "material");   // Iron = 0, Steel = 2, Mithal = 4, Adam = 6
   itemproperty iEnhancement = ItemPropertyEnhancementBonus(nMaterial);
   itemproperty iDamage = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEBONUS_1d6);
   effect eVFX;
   effect eLink;
   itemproperty iStrength = ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,nArmorMaterial);
   itemproperty iConstitution = ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,nArmorMaterial);
   itemproperty iDexterity = ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,nArmorMaterial);
   effect eEffect;
   effect eEffect2;
   effect eEffect3;

   // Weapon Naming
   if(nMaterial == 0)
   {
     sWeaponName = "<c~Îë>Crafted Iron</c> ";
   }
   else if(nMaterial == 2)
   {
     sWeaponName = "<c~Îë>Crafted Steel</c> ";
   }
   else if(nMaterial == 3)
   {
     sWeaponName = "<c~Îë>Crafted Silver</c> ";
   }
   else if(nMaterial == 4)
   {
     sWeaponName = "<c~Îë>Crafted Mithral</c> ";
   }
   else if(nMaterial == 6)
   {
     sWeaponName = "<c~Îë>Crafted Adamantine</c> ";
   }

   // Armor Naming
   if(nArmorMaterial == 0)
   {
     sArmorName = "<c~Îë>Iron</c> ";
   }
   else if(nArmorMaterial == 2)
   {
     sArmorName = "<c~Îë>Steel</c> ";
   }
   else if(nArmorMaterial == 3)
   {
     sArmorName = "<c~Îë>Silver</c> ";
   }
   else if(nArmorMaterial == 4)
   {
     sArmorName = "<c~Îë>Mithral</c> ";
   }
   else if(nArmorMaterial == 6)
   {
     sArmorName = "<c~Îë>Adamantine</c> ";
   }

   if(sItemResRef == "js_arca_gol")   // Elementary Golem
   {
      eVFX = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
      oHenchmen = CreateObject(OBJECT_TYPE_CREATURE,"js_golem",lTarget,FALSE);
      SetName(oHenchmen,sArmorName + GetName(oHenchmen));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lTarget);
      AddHenchman(oPC,oHenchmen);
   }
   else if(sItemResRef == "js_arca_gol_g")   // Guard Golem
   {
      eVFX = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
      oHenchmen = CreateObject(OBJECT_TYPE_CREATURE,"js_golem_g",lTarget,FALSE);
      SetName(oHenchmen,sArmorName + GetName(oHenchmen));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lTarget);
      AddHenchman(oPC,oHenchmen);
      // Add Weapon to creature
      oWeapon = CreateItemOnObject(sWeapon,oHenchmen,1);
      // Set the name and properties
      SetName(oWeapon,sWeaponName + GetName(oWeapon));
      AddItemProperty(DURATION_TYPE_TEMPORARY,iEnhancement,oWeapon,28800.0);
      SetItemCursedFlag(oWeapon,1);
      //Have the henchman equip the weapon
      AssignCommand(oHenchmen,ActionEquipItem(oWeapon,INVENTORY_SLOT_RIGHTHAND));
   }
   else if(sItemResRef == "js_arca_gol_c")   // Combat Golem
   {
      eVFX = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
      oHenchmen = CreateObject(OBJECT_TYPE_CREATURE,"js_golem_c",lTarget,FALSE);
      SetName(oHenchmen,sArmorName + GetName(oHenchmen));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lTarget);
      AddHenchman(oPC,oHenchmen);
      // Add Weapon to creature
      oWeapon = CreateItemOnObject(sWeapon,oHenchmen,1);
      // Set the name and properties
      SetName(oWeapon,sWeaponName + GetName(oWeapon));
      AddItemProperty(DURATION_TYPE_TEMPORARY,iEnhancement,oWeapon,28800.0);
      SetItemCursedFlag(oWeapon,1);
      //Have the henchman equip the weapon
      AssignCommand(oHenchmen,ActionEquipItem(oWeapon,INVENTORY_SLOT_RIGHTHAND));
   }
   else if(sItemResRef == "js_arca_gol_h")   // Helmed Horror
   {
      eVFX = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
      oHenchmen = CreateObject(OBJECT_TYPE_CREATURE,"js_golem_h",lTarget,FALSE);
      SetName(oHenchmen,sArmorName + GetName(oHenchmen));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lTarget);
      AddHenchman(oPC,oHenchmen);
      // Add Weapon to creature
      oWeapon = CreateItemOnObject(sWeapon,oHenchmen,1);
      // Set the name and properties
      SetName(oWeapon,sWeaponName + GetName(oWeapon));
      AddItemProperty(DURATION_TYPE_TEMPORARY,iEnhancement,oWeapon,28800.0);
      AddItemProperty(DURATION_TYPE_TEMPORARY,iDamage,oWeapon,28800.0);
      SetItemCursedFlag(oWeapon,1);
      //Have the henchman equip the weapon
      AssignCommand(oHenchmen,ActionEquipItem(oWeapon,INVENTORY_SLOT_RIGHTHAND));
   }

     object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oHenchmen);
     AddItemProperty(DURATION_TYPE_PERMANENT,iStrength,oHide);
     AddItemProperty(DURATION_TYPE_PERMANENT,iConstitution,oHide);
     AddItemProperty(DURATION_TYPE_PERMANENT,iDexterity,oHide);

}

void CreateDemon(object oPC, object oWidget, location lTarget)
{
   string sItemResRef = GetResRef(oWidget);
   effect eVFX;
   effect eLink;
   effect eEffect;
   effect eEffect2;
   effect eEffect3;
   object oHenchmen;

   if(sItemResRef == "js_arca_dem")   // Trapped Demonic Entity
   {
      eVFX = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
      CreateObject(OBJECT_TYPE_CREATURE,"js_demon",lTarget,FALSE);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lTarget);
   }

}

void StoreItem(object oPC, object oWidget, object oTarget, int nCapacity, string sContainerType)
{
   string sDescription = GetDescription(oWidget, TRUE);
   string sTarget = GetResRef(oTarget);
   string sName   = GetName(oTarget, TRUE);
   int nItemCount = GetLocalInt(oWidget, "ItemCount");

   if(GetLocalInt(oWidget, "ItemCount") == 0)
   {
      string sBox = "<c~Îë>"+ sName +" "+ sContainerType +"</c>";

      SendMessageToPC(oPC, "Dedicating your "+ GetStringLowerCase(sContainerType) +" to "+sName+".");
      SetName(oWidget, sBox);
      SetLocalString(oWidget, "StoredItem", sTarget);
   }
   else if(sTarget != GetLocalString(oWidget, "StoredItem"))
   {
      SendMessageToPC(oPC, "<cþ  >You cannot store "+sName+" in this "+ GetStringLowerCase(sContainerType) +".</c>");
      return;
   }

   int nNewItemCount = nItemCount + GetNumStackedItems(oTarget);

   if (nNewItemCount > nCapacity)
   {
      SendMessageToPC( oPC, "<cþ  >You cannot store more than " + IntToString(nCapacity) + " items in this "+ GetStringLowerCase(sContainerType) +".</c>" );
      return;
   }

   SendMessageToPC( oPC, "Storing "+sName );

   SetDescription( oWidget, "Number of stored items: "+IntToString(nNewItemCount) +"\n\n"+sDescription);
   SetLocalInt(oWidget, "ItemCount", nNewItemCount);

   DestroyObject( oTarget, 1.0 );
}

void RetrieveItem(object oPC, object oWidget, int nItemCount, int nBatch)
{
   string sStoredResRef = GetLocalString(oWidget, "StoredItem");
   string sDescription = GetDescription(oWidget, TRUE);
   int nNewItemCount;


   if (nItemCount > nBatch+1)
   {
      nNewItemCount = nItemCount - nBatch;
   }
   else if(nItemCount < nBatch && nItemCount > nBatch/2+1)
   {
      nBatch = nBatch/2;
      nNewItemCount = nItemCount - nBatch;
   }
   else if(nItemCount > 1)
   {
      nBatch = 1;
      nNewItemCount = nItemCount - nBatch;
   }
   else if (nItemCount == 1)
   {
      nBatch = 1;
      string sNameReset = GetName(oWidget, TRUE);

      SetName(oWidget, sNameReset);
      DeleteLocalString(oWidget, "StoredItem");
      DeleteLocalInt(oWidget, "ItemCount");
      SetDescription(oWidget, sDescription);
   }
   else
   {
      SendMessageToPC(oPC, "<cþ  >This storage item is empty.</c>");
      return;
   }

   SetLocalInt(oWidget, "ItemCount", nNewItemCount);
   SetDescription( oWidget, "Number of stored items: "+IntToString(nNewItemCount) +"\n\n"+sDescription);

   CreateItemOnObject(sStoredResRef, oPC, nBatch);
}