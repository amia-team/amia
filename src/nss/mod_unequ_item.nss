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
// 2022/09/11   Oputsus     Fixed TWF buff stacking
// 2025/06/17   Jes         Removed 2H bonus references

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
    effect eLoop                    = GetFirstEffect(oPC);
    effect eDamage;
    effect eAB;
    effect eLink;
    effect eAC;
    int    eLoopSpellID;
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


    //Get the first itemproperty on the helmet
    itemproperty ipLoop = GetFirstItemProperty( oItem );
    int nResult;

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
