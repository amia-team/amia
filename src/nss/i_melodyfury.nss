// Item event script for melodic fury - adds charisma bonus to damage equal
// to rounds of charisma modifier, reduces bard song each usage.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/20/2006  bbillington      Initial release.
//

#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "inc_ds_records"


void ActivateItem( )
{
    // Declare major variables.

    object oPC         = GetItemActivator( );
    object oItem       = GetItemActivatedTarget();
    int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);


   // If oPC does not have any bard songs remaining and has not targetted
   // a melee weapon, the script ends.

    if ( !GetIsObjectValid(oItem) || (GetObjectType(oItem) != OBJECT_TYPE_ITEM) ) {
        SendMessageToPC( oPC, "You must target an item!" );
        return;
    }

    if ( GetItemPossessor(oItem) != oPC ) {
        SendMessageToPC( oPC, "You may only target your own items!" );
        return;
    }

    if ( !IPGetIsMeleeWeapon(oItem) ) {
        SendMessageToPC( oPC, "This ability may only target melee weapons!" );
        return;
    }

    if ( !GetHasFeat(FEAT_BARD_SONGS, oPC) ) {
         SendMessageToPCByStrRef( oPC, 40063 );
         return;
         }

   // Variables for the item properties.

   itemproperty ipGlow  =

   ItemPropertyVisualEffect(
      ITEM_VISUAL_HOLY);


   itemproperty ipDamage =


       ItemPropertyDamageBonus(
           IP_CONST_DAMAGETYPE_MAGICAL, nCharismaBonus);


   // Duration is equal to Charisma bonus, in rounds.

   float fDuration = RoundsToSeconds(nCharismaBonus);


   // Add the weapon damage and visuals.

   IPSafeAddItemProperty(
       oItem,
       ipGlow,
       fDuration,
       X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,
       FALSE,
       FALSE);

   IPSafeAddItemProperty(
       oItem,
       ipDamage,
       fDuration,
       X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,
       FALSE,
       FALSE);

   // VFX candy.

   ApplyEffectToObject(
       DURATION_TYPE_INSTANT,
       EffectVisualEffect(VFX_IMP_SUPER_HEROISM),
       oPC,
       0.0);

   ApplyEffectToObject(
       DURATION_TYPE_INSTANT,
       EffectVisualEffect(VFX_DUR_BARD_SONG),
       oPC,
       0.0);

   // Decrement the remaining uses of bard song.

   DecrementRemainingFeatUses(
      oPC,
      FEAT_BARD_SONGS);


  }




void main( ){

    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;

        case X2_ITEM_EVENT_EQUIP:

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
   }
}
