//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_harp_act
//group:   Harper stuff
//used as: action script
//date:    may 15 2008
//author:  disco

//-----------------------------------------------------------------------------
// changes
//-----------------------------------------------------------------------------
//2007-05-14    disco   Rewrote the recommendation routines
//2007-05-17    disco   XP compensation for ECL
//2007-12-02    disco   Using inc_ds_records now

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "inc_ds_actions"
#include "amia_include"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//Create Harper item
void CreateHarperItem( object oPC, string sResRef, int nGold=0, int nXP=0, int nAmount=1, string sNeeded="" );

//enchantments
void ResearchAttention( object oPC );
void EnchantWeaponry( object oPC );
void EnchantBody( object oPC );

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main( ){

    //variables
    object oPC      = OBJECT_SELF;
    int nSection    = GetLocalInt( oPC, "ds_section" );
    int nNode       = GetLocalInt( oPC, "ds_node" );
    int nItem       = 0;

    clean_vars( oPC, 3 );

    if ( ( nSection > 0 && nSection < 5 ) && nNode > 10 ){

        //second menu choice, continue to create item
        nItem = ( 100 * nSection ) + nNode;
        SendMessageToPC( oPC, "[Harper Crafting: Creating Item "+IntToString( nItem )+"]" );
    }
    else if ( nSection == 0 && ( nNode > 0 && nNode < 5 ) ){

        //first menu choice
        SetLocalInt( oPC, "ds_section", nNode );
        return;
    }
    else{

        //error, clean up
        //this can also be nNode == 9, which cleans up after convo exit
        DeleteLocalInt( oPC, "ds_section" );
        return;
    }

    switch ( nItem ) {

        //Instruments
        case 111: CreateHarperItem( oPC, "X0_IT_MTHNMISC04", 2000 );    break;
        case 112: CreateHarperItem( oPC, "NW_IT_MMIDMISC01", 20000 );    break;
        case 113: CreateHarperItem( oPC, "NW_IT_MMIDMISC02", 6000 );    break;
        case 114: CreateHarperItem( oPC, "NW_IT_MMIDMISC03", 4500 );    break;
        case 115: CreateHarperItem( oPC, "X0_IT_MTHNMISC08", 1250 );    break;
        case 116: CreateHarperItem( oPC, "X0_IT_MTHNMISC09", 3250 );    break;
        case 117: CreateHarperItem( oPC, "cs_hrp_chimi1", 4200 );    break;
        case 118: CreateHarperItem( oPC, "neus_i_iotwinds", 10000 );    break;
        case 119: CreateHarperItem( oPC, "neus_i_iotwinds", 10000 );    break;   //why double?

        //Items
        case 211: CreateHarperItem( oPC, "nw_it_picks004", 400 );    break;
        case 212: CreateHarperItem( oPC, "cs_gharper_pin1", 10000 );    break;
        case 213: CreateHarperItem( oPC, "cs_harp_rres3", 7500 );    break;
        case 214: CreateHarperItem( oPC, "cs_harp_scprot1", 20000 );    break;
        case 215: CreateHarperItem( oPC, "nw_it_msmlmisc23", 100, 0, 10 );    break;
        case 216: CreateHarperItem( oPC, "nw_it_msmlmisc24", 25, 0, 5 );    break;
        case 217: CreateHarperItem( oPC, "x0_it_mthnmisc05", 600 );    break;
        case 218: CreateHarperItem( oPC, "x0_it_mthnmisc06", 800 );    break;
        case 219: CreateHarperItem( oPC, "x0_it_msmlmisc04", 10000, 0, 1, "NW_IT_GEM005" );    break;
        case 220: CreateHarperItem( oPC, "cs_hitem_rring", 50000, 0, 1, "NW_IT_MSMLMISC11" );    break;
        case 221: CreateHarperItem( oPC, "cs_hitem_prope", 10000, 0, 1, "rope" );    break;
        case 222: CreateHarperItem( oPC, "cs_hitem_mlens", 50000, 0, 1, "NW_IT_GEM010" );    break;
        case 223: CreateHarperItem( oPC, "shadcloak", 50000 );    break;
        case 224: CreateHarperItem( oPC, "cs_hitem_trick1", 250 );
                  CreateHarperItem( oPC, "cs_hitem_trick2", 250 );
                  CreateHarperItem( oPC, "cs_hitem_trick3", 250 );
                  CreateHarperItem( oPC, "cs_hitem_trick4", 250 );     break;
        case 225: CreateHarperItem( oPC, "cs_hitem_glyph1", 5000 );    break;
        case 226: CreateHarperItem( oPC, "cs_hitem_glyph2", 5000 );    break;
        case 227: CreateHarperItem( oPC, "cs_hitem_glyph3", 5000 );    break;

        //Potions
        case 311: CreateHarperItem( oPC, "cs_harp_pot1", 600 );    break;
        case 312: CreateHarperItem( oPC, "cs_harp_pot2", 600 );    break;
        case 313: CreateHarperItem( oPC, "cs_harp_pot3", 600 );    break;
        case 314: CreateHarperItem( oPC, "cs_harp_pot4", 600 );    break;
        case 315: CreateHarperItem( oPC, "cs_harp_pot5", 600 );    break;
        case 316: CreateHarperItem( oPC, "cs_harp_pot6", 600 );    break;

        //Enchantments
        case 411: ResearchAttention( oPC );    break;
        case 412: EnchantWeaponry( oPC );    break;
        case 413: EnchantBody( oPC );    break;
    }
}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------

void CreateHarperItem( object oPC, string sResRef, int nGold=0, int nXP=0, int nAmount=1, string sNeeded="" ){

    SendMessageToPC( oPC, "Item sResRef="+sResRef );

    if ( sNeeded != "" ){

        SendMessageToPC( oPC, "Required sResRef="+sNeeded );
    }

    DeleteLocalInt( oPC, "ds_section" );

    if ( sNeeded != "" ){

        object oNeeded = GetItemPossessedBy( oPC, sNeeded );

        if ( GetIsObjectValid( oNeeded ) ){

            int nStack = GetItemStackSize( oNeeded );

            if( nStack > 1 ){

                SetItemStackSize( oNeeded, nStack - 1 );
            }
            else{

                DestroyObject( oNeeded );
            }
        }
        else{

            FloatingTextStringOnCreature( "[Harper Crafting: Failed. Requires item component]", oPC );
            return;
        }
    }

    int nGP = GetGold( oPC );

    // Sufficient gold, subtract it, and issue item (as Stolen), notify.
    if( nGP >= nGold ){

        object oItem;

        if ( nAmount == 1 ){

            // Issue item.
            oItem = CreateItemOnObject( sResRef, oPC );

            // Unset stolen.
            SetItemCursedFlag( oItem, FALSE );
            SetStolenFlag( oItem, TRUE );
        }
        else{

            int nCount = 0;

            for( nCount = 0; nCount < nAmount; nCount++ ){

                oItem = CreateItemOnObject( sResRef, oPC );

                // Stolen.
                SetItemCursedFlag( oItem, FALSE );
                SetStolenFlag( oItem, TRUE );
            }
        }

        if ( GetIsObjectValid( oItem ) ){

            // Subtract gold.
            TakeGoldFromCreature( nGold, oPC, TRUE );

            // Notify.
            FloatingTextStringOnCreature( "[Harper Crafting: Successful!]", oPC );

            //decrement feat uses
            DecrementRemainingFeatUses( oPC, 440 );
        }
        else{

            FloatingTextStringOnCreature( "[Harper Crafting: Error. Item not available!]", oPC );
        }

    }
    // Insufficient gold, abort, notify.
    else{

        FloatingTextStringOnCreature( "[Harper Crafting: Failed. Insufficient gold]", oPC );
    }
}

void ResearchAttention( object oPC ){

    // +3 to Spot, Listen, Lore and Persuade.
    effect eBoost = EffectSkillIncrease( SKILL_SPOT, 3 );
    eBoost = EffectLinkEffects( eBoost, EffectSkillIncrease( SKILL_LISTEN, 3 ) );
    eBoost = EffectLinkEffects( eBoost, EffectSkillIncrease( SKILL_LORE, 3 ) );
    eBoost = EffectLinkEffects( eBoost, EffectSkillIncrease( SKILL_PERSUADE, 3 ) );

    // Apply boost.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ExtraordinaryEffect( eBoost ), oPC, NewHoursToSeconds( 24 ) );

    // Candy.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_MAGICAL_VISION ), oPC );

    //decrement feat uses
    DecrementRemainingFeatUses( oPC, 440 );
}

void EnchantWeaponry( object oPC ){

    object oItem                = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    int nItemType               = GetBaseItemType( oItem );
    // 1d4 Magical.
    itemproperty ipEnch         = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4 );

    // Melee OR Dart OR Shuriken OR Throwing Axe, apply boost to weapon itself.
    if( IPGetIsMeleeWeapon( oItem )         ||
        nItemType == BASE_ITEM_DART         ||
        nItemType == BASE_ITEM_THROWINGAXE  ||
        nItemType == BASE_ITEM_SHURIKEN     )
        IPSafeAddItemProperty( oItem, ipEnch, NewHoursToSeconds( 3 ) );
    // Ranged, apply boost to ammo.
    else{
        // Seek out the ammo.
        oItem = GetItemInSlot( INVENTORY_SLOT_ARROWS, oPC );
        if( !GetIsObjectValid( oItem ) ){
            oItem = GetItemInSlot( INVENTORY_SLOT_BOLTS, oPC );
            if( !GetIsObjectValid( oItem ) )
                oItem = GetItemInSlot( INVENTORY_SLOT_BULLETS, oPC );
        }
        // Valid ammo, buff it.
        if( GetIsObjectValid( oItem ) )
            IPSafeAddItemProperty( oItem, ipEnch, NewHoursToSeconds( 3 ) );
    }

    // Candy.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_HOLY ), oPC );

    //decrement feat uses
    DecrementRemainingFeatUses( oPC, 440 );
}


void EnchantBody( object oPC ){

    effect eEnchant = ExtraordinaryEffect( EffectDamageReduction( 5, DAMAGE_POWER_PLUS_FIVE ) );
    effect eVis     = EffectVisualEffect( VFX_IMP_SUPER_HEROISM );

    // Damage Reduction 5/+1.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEnchant, oPC, NewHoursToSeconds( 3 ) );

    // Candy.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

    //decrement feat uses
    DecrementRemainingFeatUses( oPC, 440 );
}
