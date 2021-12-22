// Item event script for custom potion brewer request.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/27/2013 PaladinOfSune    Initial Release
// 08/25/2015 Anatida          Updated for Red Label Potion spawner

/* Includes */
#include "x2_inc_switches"
#include "amia_include"
#include "x2_inc_itemprop"

void Hablo( object oPC ){

    SetLocalString( oPC, "ds_action", "i_cus_potion_b3" );
    AssignCommand( oPC, ActionStartConversation( oPC, "c_cus_pot3", TRUE, FALSE ) );
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

    if( sScript == "i_cus_potion_b3" )
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
                    oPotion     = CreateItemOnObject( "dc_rl_potion", oPC, 1, "dc_rl_potion2" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Red Label: Spellbane" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Red Label Potions,\nThe Worst of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, often priced at extortionate rates and brewed with the utmost spite. Red Label potions are a bastardized offshoot from the more well-known Black Labels, but while they share the same potency the Red Labels have an immensely discomforting sensation when consumed. Each bottle is tinted black, obscuring the substance within that is only vaguely visible through its unusual purple-green glow.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This particular potion will empower the user as if casting a Spell Mantle spell of the thirteenth level. It tastes and smells like something akin to spoilt milk that was left out in the sun.", TRUE ) );
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
                    oPotion     = CreateItemOnObject( "dc_rl_potion", oPC, 1, "dc_rl_potion3" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Red Label: Spellbreaker" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Red Label Potions,\nThe Worst of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, often priced at extortionate rates and brewed with the utmost spite. Red Label potions are a bastardized offshoot from the more well-known Black Labels, but while they share the same potency the Red Labels have an immensely discomforting sensation when consumed. Each bottle is tinted black, obscuring the substance within that is only vaguely visible through its unusual purple-green glow.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This particular potion will empower the user as if casting a Protection from Spells of the thirteenth level. It has a strong smell and unpleasant taste that would be quite fishy. Nec'peryan drow on the other hand will likely describe it as 'Skummy.'", TRUE ) );
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
                    oPotion     = CreateItemOnObject( "dc_rl_potion", oPC, 1, "dc_rl_potion4" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Red Label: Devourer" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Red Label Potions,\nThe Worst of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, often priced at extortionate rates and brewed with the utmost spite. Red Label potions are a bastardized offshoot from the more well-known Black Labels, but while they share the same potency the Red Labels have an immensely discomforting sensation when consumed. Each bottle is tinted black, obscuring the substance within that is only vaguely visible through its unusual purple-green glow.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This particular potion will empower the user as if casting a Blackstaff spell of the fifteenth level. It is eerily reminiscent of blood in both smell and taste, which sadly makes this one of the more palatable Red Label potions.", TRUE ) );
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
                    oPotion     = CreateItemOnObject( "dc_rl_potion", oPC, 1, "dc_rl_potion5" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Red Label: Foresight" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Red Label Potions,\nThe Worst of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, often priced at extortionate rates and brewed with the utmost spite. Red Label potions are a bastardized offshoot from the more well-known Black Labels, but while they share the same potency the Red Labels have an immensely discomforting sensation when consumed. Each bottle is tinted black, obscuring the substance within that is only vaguely visible through its unusual purple-green glow.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This particular potion will empower the user as if casting a Premonition spell of the fifteenth level. While it lacks the Red Label's usual foul taste and smell, it gives the sensation of hundreds of spiders crawling around in your skin as the spell takes effect.", TRUE ) );
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
                    oPotion     = CreateItemOnObject( "dc_rl_potion", oPC, 1, "dc_rl_potion6" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Red Label: Reaver" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Red Label Potions,\nThe Worst of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, often priced at extortionate rates and brewed with the utmost spite. Red Label potions are a bastardized offshoot from the more well-known Black Labels, but while they share the same potency the Red Labels have an immensely discomforting sensation when consumed. Each bottle is tinted black, obscuring the substance within that is only vaguely visible through its unusual purple-green glow.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This particular potion will empower the user as if casting a Keen Edge spell of the seventeenth level. It has a prickly sensation on the tongue, and a heavy metallic flavor.", TRUE ) );
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
                    oPotion     = CreateItemOnObject( "dc_rl_potion", oPC, 1, "dc_rl_potion7" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Red Label: Hawkeye" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Red Label Potions,\nThe Worst of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, often priced at extortionate rates and brewed with the utmost spite. Red Label potions are a bastardized offshoot from the more well-known Black Labels, but while they share the same potency the Red Labels have an immensely discomforting sensation when consumed. Each bottle is tinted black, obscuring the substance within that is only vaguely visible through its unusual purple-green glow.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This potion will empower the user as if casting a True Seeing spell of the ninth level. It gives the sensation of a greasy coating of the tongue and throat.", TRUE ) );
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
                    oPotion     = CreateItemOnObject( "dc_rl_potion", oPC, 1, "dc_rl_potion8" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Red Label: Vanish" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Red Label Potions,\nThe Worst of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, often priced at extortionate rates and brewed with the utmost spite. Red Label potions are a bastardized offshoot from the more well-known Black Labels, but while they share the same potency the Red Labels have an immensely discomforting sensation when consumed. Each bottle is tinted black, obscuring the substance within that is only vaguely visible through its unusual purple-green glow.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This potion will empower the user as if casting an Improved Invisibility spell of the seventh level. You think you've escaped unscathed since it has no flavor; then the sharp pain hits your guts as the potion settles.", TRUE ) );
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
                    oPotion     = CreateItemOnObject( "dc_rl_potion", oPC, 1, "dc_rl_potion9" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oPotion );
                    DelayCommand( 0.4, SetName( oPotion, "Red Label: Elemental Warding" ) );
                    DelayCommand( 0.5, SetDescription( oPotion, "Red Label Potions,\nThe Worst of the Best.\n\n", TRUE ) );
                    DelayCommand( 0.6, SetDescription( oPotion, GetDescription( oPotion ) + "Powerful, often priced at extortionate rates and brewed with the utmost spite. Red Label potions are a bastardized offshoot from the more well-known Black Labels, but while they share the same potency the Red Labels have an immensely discomforting sensation when consumed. Each bottle is tinted black, obscuring the substance within that is only vaguely visible through its unusual purple-green glow.\n\n", TRUE ) );
                    DelayCommand( 0.7, SetDescription( oPotion, GetDescription( oPotion ) + "This particular potion will empower the user as if casting an Energy Buffer spell of the eleventh level. The potion smells like sulfur with an indiscernible taste given its spiciness, leaving your mouth feeling like it has been coated with ashes along with a sulfuric aftertaste!", TRUE ) );
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
        SetLocalString( oPC, "ds_action", "i_cus_potion_b3" );
        AssignCommand( oPC, ActionStartConversation( oPC, "c_cus_pot3", TRUE, FALSE ) );
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


