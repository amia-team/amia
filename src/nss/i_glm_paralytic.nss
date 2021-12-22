/* Crawler Enzyme Custom Power

Applies a temporary OnHit Slow effect to a weapon.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
04/06/13 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"

void ActivateItem()
{
    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();

    if( IPGetIsMeleeWeapon( oTarget ) || IPGetIsProjectile( oTarget ) )
    {
        itemproperty ipSlow = ItemPropertyOnHitProps( IP_CONST_ONHIT_SLOW, IP_CONST_ONHIT_SAVEDC_14, IP_CONST_ONHIT_DURATION_75_PERCENT_1_ROUND );
        IPSafeAddItemProperty( oTarget, ipSlow, 60.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
        IPSafeAddItemProperty( oTarget, ItemPropertyVisualEffect( ITEM_VISUAL_ACID ), 60.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE );
    }
    else
    {
        SendMessageToPC( oPC, "This effect can only be applied to melee weapons or ammo." );
    }
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
