// Item event script for custom herb creator request.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/09/2013 PaladinOfSune    Initial Release

/* Includes */
#include "x2_inc_switches"
#include "amia_include"
#include "x2_inc_itemprop"


void CopyItemAndModifyFixedDelayed( object oItem, int nNewAppearance )
{
    CopyItemAndModifyFixed( oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nNewAppearance );
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
    object oHerb;

    itemproperty ipProp;

    if( sScript == "i_cus_plant_cre" )
    {
        switch( iNode )
        {
            case 1:

                if( nGold >= 5 )  // Marijuana Smoke
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 5, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Marijuana Smoke." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oHerb       = CreateItemOnObject( "dc_cus_temp_s3", oPC, 1, "pipeherbs" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oHerb );
                    DelayCommand( 0.5, SetDescription( oHerb, "Long, dried leaves, carefully rolled up into a form which can be smoked. When lit, this special cigarette-like smoke emits a fairly sweet scent. The effects are soothing and slightly sense altering.", TRUE ) );
                    DelayCommand( 0.4, SetName( oHerb, "Marijuana Smoke" ) );
                    DelayCommand( 1.0, CopyItemAndModifyFixedDelayed( oHerb, 69 ) );
                    DestroyObject( oHerb, 1.5 );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    DeleteLocalInt( oPC, "ds_node" );
                    DeleteLocalString( oPC, "ds_action" );
                    return;
                }

                break;

            case 2: // Ritual Incense

                if( nGold >= 15 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 15, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Ritual Incense." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_UNIQUE_POWER, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oHerb       = CreateItemOnObject( "dc_cus_temp_t", oPC, 1, "dc_cus_herb" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oHerb );
                    DelayCommand( 0.5, SetDescription( oHerb, "When lit, this incense immediately emits a rich, herbal smell with a slightly sweet node to it.", TRUE ) );
                    DelayCommand( 0.4, SetName( oHerb, "Ritual Incense" ) );
                    DelayCommand( 1.0, CopyItemAndModifyFixedDelayed( oHerb, 32 ) );
                    DestroyObject( oHerb, 1.5 );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    DeleteLocalInt( oPC, "ds_node" );
                    DeleteLocalString( oPC, "ds_action" );
                    return;
                }

                break;

            case 3: // Potion of Altered Senses

                if( nGold >= 1000 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 1000, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Potion of Altered Senses." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oHerb       = CreateItemOnObject( "dc_cus_potion", oPC, 1, "dc_cus_herb3" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oHerb );
                    DelayCommand( 0.5, SetDescription( oHerb, "This dark, oily liquid has a very earthy and herbal smell to it. The taste is very similar as the smell and it affects the senses rather quickly, opening them to the spiritual world.", TRUE ) );
                    DelayCommand( 0.4, SetName( oHerb, "Potion of Altered Senses" ) );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    DeleteLocalInt( oPC, "ds_node" );
                    DeleteLocalString( oPC, "ds_action" );
                    return;
                }

                break;

            case 4: // Herbal Oil

                if( nGold >= 20 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 20, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created Herbal Oil." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_VIRTUE_1, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oHerb       = CreateItemOnObject( "dc_cus_temp_t", oPC, 1, "dc_cus_herb4" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oHerb );
                    DelayCommand( 0.5, SetDescription( oHerb, "A herbal oil with a greenish coloration. It allows the skin pores to open and to take in the special properties of the herbs used in its creation.", TRUE ) );
                    DelayCommand( 0.4, SetName( oHerb, "Herbal Oil" ) );
                    DelayCommand( 1.0, CopyItemAndModifyFixedDelayed( oHerb, 71 ) );
                    DestroyObject( oHerb, 1.5 );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    DeleteLocalInt( oPC, "ds_node" );
                    DeleteLocalString( oPC, "ds_action" );
                    return;
                }

                break;

            case 5: // Giant Scorpion Poison

                if( nGold >= 500 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 500, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created Giant Scorpion Poison." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_UNIQUE_POWER, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oHerb       = CreateItemOnObject( "dc_cus_temp_s", oPC, 1, "dc_cus_herb" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oHerb );
                    DelayCommand( 0.5, SetDescription( oHerb, "A flask of poison, collected from a giant scorpion.", TRUE ) );
                    DelayCommand( 0.4, SetName( oHerb, "Giant Scorpion Poison" ) );
                    DelayCommand( 1.0, CopyItemAndModifyFixedDelayed( oHerb, 247 ) );
                    DestroyObject( oHerb, 1.5 );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    DeleteLocalInt( oPC, "ds_node" );
                    DeleteLocalString( oPC, "ds_action" );
                    return;
                }

                break;

            case 6:  //  Curare

                if( nGold >= 500 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 500, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created Curare." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_UNIQUE_POWER, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oHerb       = CreateItemOnObject( "dc_cus_temp_s", oPC, 1, "dc_cus_herb" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oHerb );
                    DelayCommand( 0.5, SetDescription( oHerb, "A flask of several strong poisons mixed together, aiming to weaken one's foe and drain their strength.", TRUE ) );
                    DelayCommand( 0.4, SetName( oHerb, "Curare" ) );
                    DelayCommand( 1.0, CopyItemAndModifyFixedDelayed( oHerb, 244 ) );
                    DestroyObject( oHerb, 1.5 );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    DeleteLocalInt( oPC, "ds_node" );
                    DeleteLocalString( oPC, "ds_action" );
                    return;
                }

                break;

            case 7:  //  Box of Maggots

                if( nGold >= 150 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 150, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully crafted a Box of Maggots." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_LESSER_RESTORATION_3, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oHerb       = CreateItemOnObject( "dc_cus_temp_s3", oPC, 1, "dc_cus_herb7" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oHerb );
                    DelayCommand( 0.5, SetDescription( oHerb, "These maggots live in a small wooden box. They look to be very clean and healthy, used by the Great Druid to clean wounds, especially to debride a necrotic wound. They also prevent inflammation.", TRUE ) );
                    DelayCommand( 0.4, SetName( oHerb, "Box of Maggots" ) );
                    DelayCommand( 1.0, CopyItemAndModifyFixedDelayed( oHerb, 100 ) );
                    DestroyObject( oHerb, 1.5 );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    DeleteLocalInt( oPC, "ds_node" );
                    DeleteLocalString( oPC, "ds_action" );
                    return;
                }

                break;

            case 8:  //  Wild Wormwood plant

                if( nGold >= 300 )
                {
                    AssignCommand( oPC, TakeGoldFromCreature( 300, oPC, TRUE ) );
                    DelayCommand( 0.2, SendMessageToPC(oPC, "You have successfully created a Wild Wormwood Plant." ));
                    ipProp      = ItemPropertyCastSpell( IP_CONST_CASTSPELL_REMOVE_DISEASE_5, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
                    oHerb       = CreateItemOnObject( "dc_cus_temp_s", oPC, 1, "dc_cus_herb8" );
                    AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oHerb );
                    DelayCommand( 0.5, SetDescription( oHerb, "This herbal plant plays an important role in the traditional healing. Its uses range from reducing fever, coughs, colds, headaches, loss of appetite, intestinal worms, all the way to malaria. All parts of the plant can be used for medical treatment, from the roots to the grey-green feather-like leaves with a pungent aromatic smell.", TRUE ) );
                    DelayCommand( 0.4, SetName( oHerb, "Wild Wormwood Plant" ) );
                    DelayCommand( 1.0, CopyItemAndModifyFixedDelayed( oHerb, 154 ) );
                    DestroyObject( oHerb, 1.5 );
                }
                else
                {
                    FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
                    DeleteLocalInt( oPC, "ds_node" );
                    DeleteLocalString( oPC, "ds_action" );
                    return;
                }

                break;

            default:
                SendMessageToPC( oPC, "Error: something is broken!" );
                break;
        }

        DeleteLocalInt( oPC, "ds_node" );
        DeleteLocalString( oPC, "ds_action" );
    }
    else
    {
        // Initialize ds_nodes.
        SetLocalString( oPC, "ds_action", "i_cus_plant_cre" );
        AssignCommand( oPC, ActionStartConversation( oPC, "c_cus_plant", TRUE, FALSE ) );
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
