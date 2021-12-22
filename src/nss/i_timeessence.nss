/* Cleansed Temporal Essence - Item Imbuement - Phane Encounter Quest Reward

Imbued a 10% Decreased Damage property to Divine Damage onto one item permanently.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
11/16/12 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"

void ActivateItem()
{
    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    string sOldName = GetName( oTarget );
    string sNewName = "<c þþ>Temporal </c>"+sOldName;

    effect eShield1 = EffectVisualEffect( VFX_DUR_PROT_EPIC_ARMOR );
    effect eShield2 = EffectVisualEffect( VFX_DUR_PROT_EPIC_ARMOR_2 );
    effect eBurst = EffectVisualEffect( VFX_FNF_TIME_STOP );

    object oArms = GetItemInSlot( INVENTORY_SLOT_ARMS, oPC );
    object oBelt = GetItemInSlot( INVENTORY_SLOT_BELT, oPC );
    object oBoots = GetItemInSlot( INVENTORY_SLOT_BOOTS, oPC );
    object oChest = GetItemInSlot( INVENTORY_SLOT_CHEST, oPC );
    object oCloak = GetItemInSlot( INVENTORY_SLOT_CLOAK, oPC );
    object oHead = GetItemInSlot( INVENTORY_SLOT_HEAD, oPC );
    object oLHand = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC );
    object oLRing = GetItemInSlot( INVENTORY_SLOT_LEFTRING, oPC );
    object oNeck = GetItemInSlot( INVENTORY_SLOT_NECK, oPC );
    object oRHand = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    object oRRing = GetItemInSlot( INVENTORY_SLOT_RIGHTRING, oPC );

    itemproperty ipLore = ItemPropertySkillBonus( SKILL_LORE, 5 );
    if( oTarget == oArms )
    {
        SendMessageToPC( oPC, "You imbue your "+sOldName+" with the cleansed essence of the Phane, granting the ability to further your understanding." );
        IPSafeAddItemProperty( oTarget, ipLore, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        SetName( oTarget, sNewName );
        DestroyObject( OBJECT_SELF, 5.5 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBurst, oPC );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield2, oPC, 7.0 ) );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield1, oPC, 2.0 ) );
    }
    else if( oTarget == oBelt )
    {
        SendMessageToPC( oPC, "You imbue your "+sOldName+" with the cleansed essence of the Phane, granting the ability to further your understanding." );
        IPSafeAddItemProperty( oTarget, ipLore, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        SetName( oTarget, sNewName );
        DestroyObject( OBJECT_SELF, 5.5 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBurst, oPC );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield2, oPC, 7.0 ) );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield1, oPC, 2.0 ) );
    }
    else if( oTarget == oBoots )
    {
        SendMessageToPC( oPC, "You imbue your "+sOldName+" with the cleansed essence of the Phane, granting the ability to further your understanding." );
        IPSafeAddItemProperty( oTarget, ipLore, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        SetName( oTarget, sNewName );
        DestroyObject( OBJECT_SELF, 5.5 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBurst, oPC );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield2, oPC, 7.0 ) );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield1, oPC, 2.0 ) );
    }
    else if( oTarget == oChest )
    {
        SendMessageToPC( oPC, "You imbue your "+sOldName+" with the cleansed essence of the Phane, granting the ability to further your understanding." );
        IPSafeAddItemProperty( oTarget, ipLore, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        SetName( oTarget, sNewName );
        DestroyObject( OBJECT_SELF, 5.5 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBurst, oPC );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield2, oPC, 7.0 ) );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield1, oPC, 2.0 ) );
    }
    else if( oTarget == oCloak )
    {
        SendMessageToPC( oPC, "You imbue your "+sOldName+" with the cleansed essence of the Phane, granting the ability to further your understanding." );
        IPSafeAddItemProperty( oTarget, ipLore, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        SetName( oTarget, sNewName );
        DestroyObject( OBJECT_SELF, 5.5 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBurst, oPC );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield2, oPC, 7.0 ) );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield1, oPC, 2.0 ) );
    }
    else if( oTarget == oHead )
    {
        SendMessageToPC( oPC, "You imbue your "+sOldName+" with the cleansed essence of the Phane, granting the ability to further your understanding." );
        IPSafeAddItemProperty( oTarget, ipLore, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        SetName( oTarget, sNewName );
        DestroyObject( OBJECT_SELF, 5.5 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBurst, oPC );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield2, oPC, 7.0 ) );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield1, oPC, 2.0 ) );
    }
    else if( oTarget == oLHand )
    {
        SendMessageToPC( oPC, "You imbue your "+sOldName+" with the cleansed essence of the Phane, granting the ability to further your understanding." );
        IPSafeAddItemProperty( oTarget, ipLore, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        SetName( oTarget, sNewName );
        DestroyObject( OBJECT_SELF, 5.5 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBurst, oPC );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield2, oPC, 7.0 ) );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield1, oPC, 2.0 ) );
    }
    else if( oTarget == oLRing )
    {
        SendMessageToPC( oPC, "You imbue your "+sOldName+" with the cleansed essence of the Phane, granting the ability to further your understanding." );
        IPSafeAddItemProperty( oTarget, ipLore, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        SetName( oTarget, sNewName );
        DestroyObject( OBJECT_SELF, 5.5 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBurst, oPC );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield2, oPC, 7.0 ) );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield1, oPC, 2.0 ) );
    }
    else if( oTarget == oNeck )
    {
        SendMessageToPC( oPC, "You imbue your "+sOldName+" with the cleansed essence of the Phane, granting the ability to further your understanding." );
        IPSafeAddItemProperty( oTarget, ipLore, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        SetName( oTarget, sNewName );
        DestroyObject( OBJECT_SELF, 5.5 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBurst, oPC );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield2, oPC, 7.0 ) );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield1, oPC, 2.0 ) );
    }
    else if( oTarget == oRHand )
    {
        SendMessageToPC( oPC, "You imbue your "+sOldName+" with the cleansed essence of the Phane, granting the ability to further your understanding." );
        IPSafeAddItemProperty( oTarget, ipLore, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        SetName( oTarget, sNewName );
        DestroyObject( OBJECT_SELF, 5.5 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBurst, oPC );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield2, oPC, 7.0 ) );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield1, oPC, 2.0 ) );
    }
    else if( oTarget == oRRing )
    {
        SendMessageToPC( oPC, "You imbue your "+sOldName+" with the cleansed essence of the Phane, granting the ability to further your understanding." );
        IPSafeAddItemProperty( oTarget, ipLore, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        SetName( oTarget, sNewName );
        DestroyObject( OBJECT_SELF, 5.5 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBurst, oPC );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield2, oPC, 7.0 ) );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield1, oPC, 2.0 ) );
    }
    else
    {
        SendMessageToPC( oPC, "That is not a valid item to imbue. Please choose an item that is equipped in one of your inventory slots, excluding ammunition." );
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
