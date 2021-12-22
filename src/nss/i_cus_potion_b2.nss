// Item event script for custom potion brewer request.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/27/2013 PaladinOfSune    Initial Release

/* Includes */
#include "x2_inc_switches"
#include "amia_include"
#include "x2_inc_itemprop"

void Hablo( object oPC ){

    SetLocalString( oPC, "ds_action", "i_cus_potion_b2" );
    AssignCommand( oPC, ActionStartConversation( oPC, "c_cus_pot2", TRUE, FALSE ) );
}

void ActivateItem( object oSelf )
{
    // Variables
    object oItem        = GetItemActivated( );
    object oPC;

    // If the script is being run the first time, then GetItemActivator. If it's being run through ds_action_x, however,
    // then we can't use GetItemActivator anymore so instead we check who ran the script (ds_action_x assigns it to the PC).
    if( GetObjectType( oSelf ) == OBJECT_TYPE_CREATURE )
    {
        oPC = oSelf;
    }
    else
    {
        oPC = GetItemActivator( );
    }

    int iNode           = GetLocalInt( oPC, "ds_node" );
    int nStack;
    int nGold           = GetGold( oPC );
    string sScript      = GetLocalString( oPC, "ds_action" );
    object oBottle1     = GetItemPossessedBy( oPC, "x2_it_cfm_pbottl" );
    object oPotion;

    itemproperty ipProp;

    if( sScript == "i_cus_potion_b2" )
    {

        SendMessageToPC( oPC, "Terrah: menu selection" );

        //Keep them ontop
        SetLocalInt( oPC, "ds_node", 0 );
        SetLocalString( oPC, "ds_action", "" );

        if( GetIsObjectValid( oBottle1 ) )
        {
            nStack = GetItemStackSize( oBottle1 );
            if ( nStack == 1 )
            {
                DestroyObject( oBottle1 );
            }
            else
            {
                SetItemStackSize( oBottle1, nStack - 1 );
            }
        }
        else
        {
            FloatingTextStringOnCreature( "<cþ>- You must possess an empty bottle to brew this mixture. -</c>", oPC, FALSE );
            return;
        }

        switch( iNode )
        {
            case 1:

                if( nGold >= 1300 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 1300, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Spellbane Potion." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_SPELL_MANTLE_13, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oPotion     = CreateItemOnObject( "dc_cus_potion", oPC, 1, "dc_cus_potion7" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Black Label: Spellbane" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Black Label Potions,\nThe Best of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, expensive, and exquisitely crafted, Black Label potions are the top-of-the-line potions for any adventurer. Unlike most potions, Black Labels are known for both their unusual potency and surprisingly pleasant taste.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This particular potion will empower the user as if casting a Spell Mantle spell of the thirteenth level. It tastes like an effervescent coconut and lime mix and is often considered one of the most palatable of the Black Label line.", TRUE ) );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    return;
                }

                break;

            case 2:

                if( nGold >= 1310 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 1310, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Spellbreaker Potion." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_13, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oPotion     = CreateItemOnObject( "dc_cus_potion", oPC, 1, "dc_cus_potion8" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Black Label: Spellbreaker" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Black Label Potions,\nThe Best of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, expensive, and exquisitely crafted, Black Label potions are the top-of-the-line potions for any adventurer. Unlike most potions, Black Labels are known for both their unusual potency and surprisingly pleasant taste.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This particular potion will empower the user as if casting Protection From Spells at the thirteenth level. It tastes refreshingly minty, though you're not sure exactly which kind.", TRUE ) );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    return;
                }

                break;

            case 3:

                if( nGold >= 1500 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 1500, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Devourer Potion." ));
                    ipProp      = ItemPropertyCastSpell( 476, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oPotion     = CreateItemOnObject( "dc_cus_potion", oPC, 1, "dc_cus_potion9" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Black Label: Devourer" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Black Label Potions,\nThe Best of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, expensive, and exquisitely crafted, Black Label potions are the top-of-the-line potions for any adventurer. Unlike most potions, Black Labels are known for both their unusual potency and surprisingly pleasant taste.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This particular potion will empower the user as if casting a Blackstaff spell of the fifteenth level. It has a thick, distinctive flavor of smoke and exotic spices.", TRUE ) );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    return;
                }

                break;

            case 4:

                if( nGold >= 1500 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 1500, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Foresight Potion." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_PREMONITION_15, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oPotion     = CreateItemOnObject( "dc_cus_potion", oPC, 1, "dc_cus_potion10" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Black Label: Foresight" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Black Label Potions,\nThe Best of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, expensive, and exquisitely crafted, Black Label potions are the top-of-the-line potions for any adventurer. Unlike most potions, Black Labels are known for both their unusual potency and surprisingly pleasant taste.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This particular potion will empower the user as if casting a Premonition spell of the fifteenth level. Its taste fluctuates from sweet to tart to spicy and back again at random.", TRUE ) );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    return;
                }

                break;

            case 5:

                if( nGold >= 560 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 560, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Reaver Potion." ));
                    ipProp      = ItemPropertyCastSpell( 520, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oPotion     = CreateItemOnObject( "dc_cus_potion", oPC, 1, "dc_cus_potion11" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Black Label: Reaver" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Black Label Potions,\nThe Best of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, expensive, and exquisitely crafted, Black Label potions are the top-of-the-line potions for any adventurer. Unlike most potions, Black Labels are known for both their unusual potency and surprisingly pleasant taste.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This particular potion will empower the user as if casting a Keen Edge spell of the seventeenth level. It's almost too sweet in taste, really.", TRUE ) );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    return;
                }

                break;

            case 6:

                if( nGold >= 562 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 562, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Hawkeye Potion." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_TRUE_SEEING_9, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oPotion     = CreateItemOnObject( "dc_cus_potion", oPC, 1, "dc_cus_potion12" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Black Label: Hawkeye" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Black Label Potions,\nThe Best of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, expensive, and exquisitely crafted, Black Label potions are the top-of-the-line potions for any adventurer. Unlike most potions, Black Labels are known for both their unusual potency and surprisingly pleasant taste.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This potion will empower the user as if casting a True Seeing spell of the ninth level. Its flavour is delightfully tart and tinged with hints of wild berries.", TRUE ) );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    return;
                }

                break;

            case 7:

                if( nGold >= 350 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 350, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Vanish Potion." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oPotion     = CreateItemOnObject( "dc_cus_potion", oPC, 1, "dc_cus_potion13" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Black Label: Vanish" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Black Label Potions,\nThe Best of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, expensive, and exquisitely crafted, Black Label potions are the top-of-the-line potions for any adventurer. Unlike most potions, Black Labels are known for both their unusual potency and surprisingly pleasant taste.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This potion will empower the user as if casting an Improved Invisibility spell of the seventh level. Its taste is sweet and salty, with pleasant hints of lime and vanilla.", TRUE ) );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    return;
                }

                break;

            case 8:

                if( nGold >= 687 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 687, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Elemental Warding Potion." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_ENERGY_BUFFER_11, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oPotion     = CreateItemOnObject( "dc_cus_potion", oPC, 1, "dc_cus_potion14" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Black Label: Elemental Warding" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Black Label Potions,\nThe Best of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, expensive, and exquisitely crafted, Black Label potions are the top-of-the-line potions for any adventurer. Unlike most potions, Black Labels are known for both their unusual potency and surprisingly pleasant taste.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This potion carries a suspended Energy Buffer spell of the eleventh level. The light from within it glistens a soft blue-white in your palm. It carries flavors of ginger and mint, though is unusually tart.", TRUE ) );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    return;
                }

                break;

            default:
                SendMessageToPC( oPC, "Error: something is broken!" );
                break;
        }

        DelayCommand( 0.1, Hablo( oPC ) );
    }
    else
    {

        SendMessageToPC( oPC, "Terrah: item activate" );

        // Initialize ds_nodes.
        SetLocalString( oPC, "ds_action", "i_cus_potion_b2" );
        AssignCommand( oPC, ActionStartConversation( oPC, "c_cus_pot2", TRUE, FALSE ) );
    }
}

void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( OBJECT_SELF );
            break;

        case X2_ITEM_EVENT_EQUIP:

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
    }
}


