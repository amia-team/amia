//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: mod_unequ_item
//group: module events
//used as: OnUnEquipItem
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)

// 2010/02/20   disco       Added some exploit counters
// 2011/05/23   PoS         Another exploit counter
// 2012/02/24   Selmak      Supports Shadowdancers with polymorph
// 2019/04/21   Maverick00053 Added in 2hander buff support
// 2019/06/17   Maverick00053 Added in Cav bow check and Two Weapon Fighter Check
// 2019/10/10   Maverick00053 Added in the rest of the custom class stuff

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "class_effects"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main( ){

    // Variables
    object oSource                  = OBJECT_SELF;
    object oPC                      = GetPCItemLastUnequippedBy( );
    object oItem                    = GetPCItemLastUnequipped( );
    string szItemScript             = "";
    object oOffHand                 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
    object oPrimaryHand             = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    int    oPrimaryType             = GetBaseItemType(oPrimaryHand);
    int    oItemType                = GetBaseItemType(oItem);
    int    oOffItemType             = GetBaseItemType(oOffHand);
    int    strMod                   = GetAbilityModifier(ABILITY_STRENGTH,oPC);
    effect eLoop                    = GetFirstEffect(oPC);
    effect eDamage;
    effect eAB;
    effect eLink;
    effect eAC;
    int    eLoopSpellID;
    int    nClass                   = GetLevelByClass(46, oPC);
    int    nClassCross              = GetLevelByClass(51, oPC);
    int    nClassDuel               = GetLevelByClass(52, oPC);

   // *********NOTE BELOW************
   // mod_unequ_item acts before the item itself is removed. So checking for items in hand is a bit weird. The removing weapon
   // is still in the hand. Ex, you have a sword in your first hand, a dagger in your second. You remove the dagger and this script
   // activates but if you check the left and right hand both weapons will still be present.
   //*****************************

    // Cursed Item Script
    if((GetResRef(oItem) == "shroudarmor") || (GetResRef(oItem) == "shroudhelm")  || (GetResRef(oItem) == "shroudcloak"))
    {
       if(!GetIsImmune(oPC,IMMUNITY_TYPE_DEATH))
       {
        if(!MySavingThrow(SAVING_THROW_WILL, oPC, 45, SAVING_THROW_TYPE_DEATH))
        {
           FloatingTextStringOnCreature("*Removing the cursed item tears the soul from the you*",oPC);
           ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),oPC);
        }
        else
        {
           FloatingTextStringOnCreature("*Removing the cursed item does not tears the soul from the you*",oPC);
        }
       }
       else
       {
           FloatingTextStringOnCreature("*Removing the cursed item does not tears the soul from the you*",oPC);
       }
    }

    // Two hander bonus removal for small races
    if(GetCreatureSize(oPC) == CREATURE_SIZE_SMALL)
    {


    if((oItemType == BASE_ITEM_BASTARDSWORD) || (oItemType == BASE_ITEM_BATTLEAXE) ||
    (oItemType == BASE_ITEM_SCIMITAR) || (oItemType == BASE_ITEM_LONGSWORD) || (oItemType == BASE_ITEM_KATANA)
    || (oItemType == BASE_ITEM_DWARVENWARAXE) || (oItemType == BASE_ITEM_MAGICSTAFF) || (oItemType == BASE_ITEM_CLUB)
    || (oItemType == BASE_ITEM_LIGHTFLAIL) || (oItemType == BASE_ITEM_WARHAMMER) || (oItemType == BASE_ITEM_MORNINGSTAR)
    || (oItemType == BASE_ITEM_RAPIER))
    {

         while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((GetEffectTag(eLoop) == "twohanderbuff"))
            {
                 RemoveEffect(oPC, eLoop);
            }

                eLoop=GetNextEffect(oPC);
         }


    }

    }
    else
    {


    // Two hander bonus removal for medium races
    if(((oItemType == BASE_ITEM_GREATAXE) || (oItemType == BASE_ITEM_GREATSWORD) ||
    (oItemType == BASE_ITEM_HALBERD) || (oItemType == BASE_ITEM_SCYTHE) || (oItemType == BASE_ITEM_HEAVYFLAIL)
     || (oItemType == BASE_ITEM_SHORTSPEAR)))  // Slashing
    {

         while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((GetEffectTag(eLoop) == "twohanderbuff"))
            {
                 RemoveEffect(oPC, eLoop);
            }

                eLoop=GetNextEffect(oPC);
         }

    }

    }




   // Crossbow PRC check - If crossbow is removed while feat is active strip effect
   if(((GetBaseItemType(oItem)== BASE_ITEM_HEAVYCROSSBOW) ||(GetBaseItemType(oItem)== BASE_ITEM_LIGHTCROSSBOW)) && (nClassCross >= 1))
   {


    // Checks for and removes the feat buff and the normal class bonus
         while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((GetEffectType(eLoop)== EFFECT_TYPE_DAMAGE_INCREASE) && (eLoopSpellID == 950))
            {
                 RemoveEffect(oPC, eLoop);
            }
            else if ((GetEffectTag(eLoop) == "crossbowbuff"))
            {
                 RemoveEffect(oPC, eLoop);
            }


                eLoop=GetNextEffect(oPC);
         }

     if(GetLocalInt(oPC,"PiercingShotToggled") == 1){
       SendMessageToPC(oPC,"Piercing Shot Deactivated!");
     }
       DeleteLocalInt(oPC,"PiercingShotToggled");

    }


    // Two Weapon Fighter bonus removal
    if(nClass >= 1 && (oItemType == BASE_ITEM_DOUBLEAXE || oItemType == BASE_ITEM_DIREMACE || oItemType == BASE_ITEM_DIREMACE ||
    BASE_ITEM_TWOBLADEDSWORD || oItemType == BASE_ITEM_BASTARDSWORD || oItemType == BASE_ITEM_CLUB || oItemType == BASE_ITEM_DAGGER ||
    oItemType == BASE_ITEM_DWARVENWARAXE || oItemType == BASE_ITEM_HANDAXE || oItemType == BASE_ITEM_KAMA || oItemType == BASE_ITEM_KATANA ||
    oItemType == BASE_ITEM_KUKRI || oItemType == BASE_ITEM_LIGHTFLAIL || oItemType == BASE_ITEM_LIGHTHAMMER || oItemType == BASE_ITEM_LIGHTMACE
    || oItemType == BASE_ITEM_LONGSWORD || oItemType == BASE_ITEM_MORNINGSTAR || oItemType == BASE_ITEM_RAPIER || oItemType == BASE_ITEM_SCIMITAR
    || oItemType == BASE_ITEM_SICKLE || oItemType == BASE_ITEM_TORCH|| oItemType == BASE_ITEM_TRIDENT|| oItemType == BASE_ITEM_WARHAMMER||
    oItemType == BASE_ITEM_WHIP ))
    {

       while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((GetEffectTag(eLoop) == "twfbuff"))
            {
                 RemoveEffect(oPC, eLoop);
            }

                eLoop=GetNextEffect(oPC);
         }

    }




   // PRC Duelist Buffs Below

  // This launches when they only have a shield or torch in hand, after removing the first weapon. If this isnt the case it will run the rest of the normal script
  if((nClassDuel >= 1) && ((GetBaseItemType(oOffHand) == BASE_ITEM_SMALLSHIELD) || (GetBaseItemType(oOffHand) == BASE_ITEM_LARGESHIELD) || (GetBaseItemType(oOffHand) == BASE_ITEM_TOWERSHIELD) || (GetBaseItemType(oOffHand) == BASE_ITEM_TORCH))
  && !((GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD) || (GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD) || (GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) || (GetBaseItemType(oItem) == BASE_ITEM_TORCH)))
  {
       // This is a ghetto fix
  }
  else
  {


  if(GetIsObjectValid(oPrimaryHand) && GetIsObjectValid(oOffHand) && (nClassDuel >= 1))  // Launches when they have one weapon in hand
  {
    //
    if(GetCreatureSize(oPC) == CREATURE_SIZE_SMALL)       // Small PCs
  {


    if((nClassDuel >= 1) && ((GetBaseItemType(oPrimaryHand)== BASE_ITEM_LIGHTMACE) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_SICKLE)
    || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_HANDAXE) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_LIGHTHAMMER) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_SHORTBOW)
    || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_KAMA) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_WHIP) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_DAGGER)
    || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_KUKRI)))
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
   else if(GetCreatureSize(oPC) == CREATURE_SIZE_MEDIUM)       // Medium PCs
   {



    if((nClassDuel >= 1) && ((GetBaseItemType(oPrimaryHand)== BASE_ITEM_BASTARDSWORD) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_DAGGER) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_DWARVENWARAXE)
    || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_HANDAXE) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_KAMA) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_KATANA) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_KUKRI)
    || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_LIGHTFLAIL) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_LIGHTHAMMER)  || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_LONGSWORD)
    || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_LIGHTMACE) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_MORNINGSTAR) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_RAPIER) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_SCIMITAR)
    || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_SHORTSWORD) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_SICKLE) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_TRIDENT) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_WARHAMMER)
    || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_WHIP) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_BATTLEAXE) || (GetBaseItemType(oPrimaryHand)== BASE_ITEM_CLUB)))
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
    //
  }
 }

  // This launches when they are unarmed
  if(GetIsObjectValid(oPrimaryHand) && (nClassDuel >= 1) && !GetIsObjectValid(oOffHand))
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

  // When you remove the first weapon, the second is unequiped and then equiped into the first slot. So it will fire equ, and
  // unequ scripts. This script acts as a catch to make sure only one bonus goes onto the PC.
    if((nClassDuel >= 1) && (!GetIsObjectValid(oPrimaryHand)))
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

    // End of Duelist PRC Scripts






    // If an SD is unequipping a creature hide, tell the OnEquip routine
    // to copy HiPS onto the new hide.
    // Note that this also runs when polymorph is ended, restoring HiPS to the
    // standard SD hide if it was on cooldown when polymorphing.
    if ( GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC ) >= 6 ){

        if ( GetItemInSlot( INVENTORY_SLOT_CARMOUR, oPC ) == oItem ){

            SetLocalInt( oPC, "copy_HIPS_to_poly", 1 );

        }

    }

    // If it's a weapon, cancel the PC's action queue to prevent weapon change exploit.
 //   if ( GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC ) == oItem ||
   //      GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC ) == oItem ){

    //    if ( GetLocalInt( oPC, "is_crafting" ) != 1  &&
     //        GetLocalInt( oPC, "rest_start" ) == 0 ) {

      //       AssignCommand( oPC, ClearAllActions() );

     //   }

   // }

    //Get the first itemproperty on the helmet
    itemproperty ipLoop = GetFirstItemProperty( oItem );
    int nResult;

    SetLocalInt( oItem, "ds_uneq", 1 );

    if ( GetStringLeft( GetTag( oItem ), 9 ) == "ds_j_res_"  ){

        // job system needs unique tags for pricing etc
        SetUserDefinedItemEventNumber( X2_ITEM_EVENT_UNEQUIP );

        ExecuteScriptAndReturnInt( "i_ds_j_activate", oSource );

        return;
    }

    // Set the Item Event : Item Unequip
    SetUserDefinedItemEventNumber( X2_ITEM_EVENT_UNEQUIP );

    // Set the Item Event Scriptname
    szItemScript = GetUserDefinedItemEventScriptName( oItem );

    // Run the designated Item Event script
    if( (szItemScript != "") && (GetResRef(oItem) != "shroudhelm")){

        ExecuteScript( szItemScript, oSource );
    }

    return;
}
