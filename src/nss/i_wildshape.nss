/*
  Made 4/28/19 by Maverick00053

  Wildshape script  for a widget so players can use the other forms once they get epic

*/

#include "x2_inc_itemprop"
#include "amia_include"
#include "x2_inc_switches"
#include "inc_ds_porting"
#include "inc_ds_actions"

void Polymorph( object oPC, int nNode);
void LaunchConvo( object oPC);

void LaunchConvo( object oPC){
    SetLocalString(oPC,"ds_action","i_wildshape");
    AssignCommand(oPC, ActionStartConversation(oPC, "c_wildshape", TRUE, FALSE));
}

// Checks to see if anything from the convo has been picked yet, if not it will start the convo
// Let the player pick
void main()
{

    object oPC          = GetItemActivator();
    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");

    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "i_wildshape")
    {
       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       LaunchConvo(oPC);
    }
    else if(nNode > 0)
    {



    if( 10 >= nNode >= 1)
    {
       Polymorph( oPC, nNode);
       return;
    }

}
}


// Polymorphs Druid/shifter into preepic form selection
void Polymorph( object oPC, int nNode){

    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nDruid      = GetLevelByClass(CLASS_TYPE_DRUID, oPC);
    int nShifter    = GetLevelByClass(CLASS_TYPE_SHIFTER, oPC);
    int nDuration   = nDruid;
    effect eSpeed = ExtraordinaryEffect(EffectMovementSpeedIncrease(20));

    if( nShifter > nDruid ){

        nDuration = nShifter;
    }

    if(nNode == 1)
    {
       nPoly = 232; // Brown Bear
    }
    else if(nNode == 2)
    {
       nPoly = 227; // Grizzly
    }
    else if(nNode == 3)
    {
       nPoly = 234;    // Dog
    }
    else if(nNode == 4)
    {
       nPoly = 229;// Wolf
    }
    else if(nNode == 5)
    {
       nPoly = 235;  // Pig
    }
    else if(nNode == 6)
    {
       nPoly = 230;  // Boar
    }
    else if(nNode == 7)
    {
       nPoly = 233; // Lynx
    }
    else if(nNode == 8)
    {
       nPoly = 228;  // Cougar
    }
    else if(nNode == 9)
    {
       nPoly = 236;   // Skunk
    }
    else if(nNode == 10)
    {
       nPoly = 231;  // Badger
    }

    ePoly = EffectPolymorph(nPoly);
    ePoly = ExtraordinaryEffect(ePoly);

    //Fire cast spell at event for the specified target
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELLABILITY_WILD_SHAPE, FALSE));

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    if (GetIsObjectValid(oShield)){

        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    int nCannotDrown = ds_check_uw_items( oPC );

    if(nPoly == 223)
    {
      ePoly = EffectLinkEffects(ePoly,eSpeed);
    }


    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, NewHoursToSeconds(nDuration));

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);

    SetLocalInt( oPC, "CannotDrown", nCannotDrown );

    if (bWeapon)
    {
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }

     SetLocalInt( oPC, "ds_node", 0 );
     SetLocalString( oPC, "ds_action", "" );

}
