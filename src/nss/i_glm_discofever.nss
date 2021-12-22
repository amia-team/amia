/* Pirouette - Custom Animation Toggle - Tairisrade Athradi (LollipopSpider)

Triggers a Whirlwind attack if there are no hostile contacts within perception
range of the PC. Does not include a battlecry as the actual Feat does.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
07/18/12 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"
#include "tcs_include"


void ActivateItem()
{
    object oPC = GetItemActivator();
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    itemproperty ipDance = ItemPropertyBonusFeat(IP_CONST_FEAT_WHIRLWIND);

    //check for hostiles
    object oEnemy = GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC );

    if ( GetIsObjectValid( oEnemy ) && GetDistanceBetween( oPC, oEnemy ) < 20.0 ){

        SendMessageToPC( oPC, "Dancing while enemies are near is not recommended!" );
        return;
    }

    IPSafeAddItemProperty(oItem, ipDance, 7.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);

    AssignCommand(oPC, ActionUseFeat(FEAT_WHIRLWIND_ATTACK, oPC));
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
