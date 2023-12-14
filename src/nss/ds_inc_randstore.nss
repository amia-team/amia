/*  Random merchant script

    --------
    Verbatim
    --------
    Fills the inventory of a  merchant with dynamically generated armour and weapons.

    --------
    Use
    --------
    Open the variable tab of the NPC and change the settings to your taste.
        int Weapons     - number of weapons spawned in shop
        int Armour      - number of suits/armour spawned in shop
        int Jewelry     - number of amulets/rings spawned in shop
        int LevelBottom - Lowest AC/AD enhancement
        int LevelTop    - Highest AC/AD enhancement
        int Unique      - % chance on unique item

    ---------
    Changelog
    ---------
    Date              Name        Reason
    ------------------------------------------------------------------
    05-23-2006        disco      start of header
    09-10-2006        disco      expansion with rings and amulets
    10-21-2006        disco      nerfed skills
    04-21-2007        disco      libbed
    2007-11-12        disco      Tuned
    2007-12-12        disco      Added a few functions
    2009-09-19        disco      Big update
    2011-11-08        Selmak     Random stores: can refresh their inventories
                                                moved bastard sword to exotic,
                                                halberd to martial
                                                can add skill Craft Weapon
    ------------------------------------------------------------------
*/

#include "x2_inc_itemprop"
#include "amia_include"

//-------------------------------------------------------------------------------
// structs
//-------------------------------------------------------------------------------

struct tDamageType {
    int nDamageType;
    int nDamageVisual;
    string sDamageType;
};


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

// Add randomly generated items to a merchant
void InjectIntoStore( object oStore);
//DO NOT USE FOR STANDARD LOOT! BE CAREFUL! Use inc_ds_ondeath include instead
void InjectIntoChest( object oChest, int nLevelBottom, int nLevelTop, int nUnique=5 );
void CreateWeapon( object oStore, int nLevel, string sType="", int nUnique=5 );
void SetWeapon( object oWeapon, int nLevel, int nUnique );
string SetUniqueWeapon( object oWeapon, string sCategory1, int nLevel);
void CreateArmour( object oStore, int nLevel, string sType="", int nUnique=5);
void SetArmour( object oArmour, int nLevel, int nType, int nUnique);
string SetUniqueArmour( object oArmour, string sCategory1, int nLevel, int nType);
void CreateJewelry( object oStore, int nLevel, int nUnique=5);
void SetJewelry( object oJewelry, int nLevel, int nType, int nUnique);
void CreateClothing(object oStore, int nLevel, int nUnique=5);
void CreateMagicSupplies( object oStore, int nLevel, int nUnique=5 );

string GetSimpleWeapon();
string GetMartialWeapon();
string GetExoticWeapon();
string GetRangedWeapon( int nLevel );
string GetAmmo();
string GetThrownWeapon();
string GetBlade();
string GetCloth();
string GetLightArmor( int nLevel );
string GetMediumArmor( int nLevel );
string GetHeavyArmor( int nLevel );
struct tDamageType GetDamageType();
string CreateName( object oItem, string sType, int nLevel, string sCategory1, string sCategory2);
itemproperty CreateRanged (int nLevel );
int RandomNumber(int nNumber, int nAdd);
string GetBaseItemName( int ItemType );

//Returns resrefs of base items in groups
// 1-17: armour
//20-49: melee weapons
//60-65: bows
//70-72: arrows, bolts, bullets
//80-82: thrown weapons
string GetBaseItemResRef( int nIndex );

//creates a random tag for an item
string CreateRandomTag( );

//adds a spell of nLevel to oItem
//never add the same level and same table to the same item, you may get teh same spell twice.
//nTable = 0 looks into a mix of self and targetted spells. Don't use for potions
//nTable = 1 only has self spells. Use for potions.
//nTable = 2 only has targetted spells.
string AddSpellToItem( object oItem, int nLevel, int nTable=0, int nUses=IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE );

//creates and modifies item in container and copies the result to oStore
object CreateObjectFromTemplate( object oStore, string sItem, int nIndex, int nModel, int nMaxValue, int nSetValue=0 );

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void InjectIntoStore( object oStore ){
    object oModule = GetModule();

    int nDelay = GetLocalInt( oModule, "randstore_ftime" );

    int nInterval;

    if ( nDelay != 0 ){

        nInterval = ( GetRunTime()/nDelay ) + 1;
    }
    else{

        nInterval = 1;

    }

    //this script fires once during each interval
    if( GetLocalInt( oStore, "RSBlock" ) != nInterval ){

        //block the creation process until next interval
        SetLocalInt( oStore, "RSBlock", nInterval );


        //Clear out inventory from previous intervals
        object oClean;

        oClean = GetFirstItemInInventory( oStore );
        while ( GetIsObjectValid( oClean ) ){

            if ( GetLocalInt( oClean, "RSCln" ) ){

                DestroyObject( oClean );

            }


            oClean = GetNextItemInInventory( oStore );
        }

        //these vars come from the store npc
        int nWeapons        = GetLocalInt( OBJECT_SELF, "Weapons" );
        int nArmour         = GetLocalInt( OBJECT_SELF, "Armour" );
        int nJewelry        = GetLocalInt( OBJECT_SELF, "Jewelry" );
        int nClothing       = GetLocalInt( OBJECT_SELF, "Clothing" );
        int nMagic          = GetLocalInt( OBJECT_SELF, "Magic" );

        if ( nWeapons == 0 && nArmour == 0 && nJewelry == 0 && nClothing == 0 && nMagic == 0 ){

            return;
        }

        int nLevelBottom    = GetLocalInt( OBJECT_SELF, "LevelBottom" );
        int nLevelTop       = GetLocalInt( OBJECT_SELF, "LevelTop" );
        int nUnique         = GetLocalInt( OBJECT_SELF, "Unique" );
        string sWeaponType  = GetLocalString( OBJECT_SELF, "WeaponType" );
        string sArmourType  = GetLocalString( OBJECT_SELF, "ArmourType" );

        //variables
        int i;
        float fDelay;
        int nLevel;

        for ( i=0; i<nWeapons; ++i ){

            fDelay = i/7.0;
            nLevel = nLevelBottom + RandomNumber( nLevelTop-nLevelBottom, 1 );
            DelayCommand( fDelay, CreateWeapon( oStore, nLevel, sWeaponType, nUnique  ) );

        }

        for ( i=0; i<nArmour; ++i ){

            fDelay = i/8.0;
            nLevel = nLevelBottom + RandomNumber( nLevelTop-nLevelBottom, 1 );
            DelayCommand( fDelay, CreateArmour( oStore, nLevel, sArmourType, nUnique ) );

        }

        for ( i=0; i<nJewelry; ++i ){

            fDelay = i/9.0;
            nLevel = nLevelBottom + RandomNumber( nLevelTop-nLevelBottom, 1 );
            DelayCommand( fDelay, CreateJewelry( oStore, nLevel, nUnique ) );
        }

        for ( i=0; i<nClothing; ++i ){

            fDelay = i/9.0;
            nLevel = nLevelBottom + RandomNumber( nLevelTop-nLevelBottom, 1 );
            DelayCommand( fDelay, CreateClothing( oStore, nLevel, nUnique ) );
        }

        for ( i=0; i<nMagic; ++i ){

            fDelay = i/9.0;
            nLevel = nLevelBottom + RandomNumber( nLevelTop-nLevelBottom, 1 );
            DelayCommand( fDelay, CreateMagicSupplies( oStore, nLevel, nUnique ) );
        }
    }
}


void InjectIntoChest( object oChest, int nLevelBottom, int nLevelTop, int nUnique=5 ){

    int nLevel = nLevelBottom + RandomNumber( nLevelTop-nLevelBottom, 1 );
    int nDie   = RandomNumber( 5, 1 );

    nDie = d6();

    if ( nDie == 1 ){

        CreateWeapon( oChest, nLevel, "", nUnique );
    }
    else if ( nDie == 2 ){

        CreateArmour( oChest, nLevel, "", nUnique );
    }
    else if ( nDie == 3 ){

        CreateJewelry( oChest, nLevel, nUnique );
    }
    else if ( nDie == 4 ){

        CreateClothing( oChest, nLevel, nUnique );
    }
    else{

        CreateMagicSupplies( oChest, nLevel, nUnique );
    }
}

void CreateWeapon( object oStore, int nLevel, string sType="", int nUnique=5 ){

    object oWeapon;
    int nRandom = RandomNumber( 12, 1 );
    string sItem;

    if ( sType == "Simple" ){

        sItem = GetSimpleWeapon();
    }
    else if ( sType == "Martial" ){

        sItem = GetMartialWeapon();
    }
    else if ( sType == "Exotic" ){

        sItem = GetExoticWeapon();
    }
    else if ( sType == "Ammo" ){

        sItem = GetAmmo();
    }
    else if ( sType == "Ranged" ){

        sItem = GetRangedWeapon( nLevel );
    }
    else if ( sType == "Thrown" ){

        sItem = GetThrownWeapon();
    }
    else if ( sType == "Blades" ){

        sItem = GetBlade();
    }
    else{

        switch ( nRandom ){

            case  1: sItem = GetSimpleWeapon();             break;
            case  2: sItem = GetSimpleWeapon();             break;
            case  3: sItem = GetMartialWeapon();            break;
            case  4: sItem = GetMartialWeapon();            break;
            case  5: sItem = GetAmmo();                     break;
            case  6: sItem = GetRangedWeapon( nLevel );     break;
            case  7: sItem = GetRangedWeapon( nLevel );     break;
            case  8: sItem = GetThrownWeapon();             break;
            case  9: sItem = GetExoticWeapon();             break;
            case  10: sItem = GetSimpleWeapon();            break;
            case  11: sItem = GetSimpleWeapon();            break;
            case  12: sItem = GetMartialWeapon();           break;
        }
    }

    if( nRandom == 5 || nRandom == 8 || sType == "Thrown" || sType == "Ammo" ){

        string sNewTag = CreateRandomTag( );

        //create 25 arrows or thrown weapons
        oWeapon = CreateItemOnObject( sItem, oStore, 25, sNewTag );
    }

    else{

        if ( sItem == "x2_it_wpwhip" ){

            //create 1 weapon
            oWeapon = CreateItemOnObject( sItem, oStore );
        }
        else if ( d3() == 1 ){

            oWeapon = CreateObjectFromTemplate( oStore, sItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP, 4 );
        }
        else{

            oWeapon = CreateObjectFromTemplate( oStore, sItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP, 4 );
        }
    }

    //adapt weapon
    SetWeapon( oWeapon, nLevel, nUnique );

    if ( GetObjectType( oStore ) != OBJECT_TYPE_STORE ){

        SetIdentified( oWeapon, FALSE );
    }
    else{

        SetLocalInt( oWeapon, "RSCln", 1 );

    }
}

void SetWeapon( object oWeapon, int nLevel, int nUnique ){

    if ( !GetIsObjectValid( oWeapon ) ) return; //stop if no weapon

    //variables
    int nBooster = 0;
    int nRandom;
    int nDamageBonus;
    string sName;
    string sCategory1;
    itemproperty ipAddBonus1;
    itemproperty ipAddBonus2;
    itemproperty ipVisual;
    struct tDamageType DamageType;

    //determine elemental damage amount
    nRandom = nLevel + d2();

    switch ( nRandom ){

        case 1: nDamageBonus = IP_CONST_DAMAGEBONUS_2; break;
        case 2: nDamageBonus = IP_CONST_DAMAGEBONUS_1d4; break;
        case 3: nDamageBonus = IP_CONST_DAMAGEBONUS_1d4; break;
        case 4: nDamageBonus = IP_CONST_DAMAGEBONUS_3;   break;
        case 5: nDamageBonus = IP_CONST_DAMAGEBONUS_1d6;   break;
        case 6: nDamageBonus = IP_CONST_DAMAGEBONUS_4;   break;
        case 7: nDamageBonus = IP_CONST_DAMAGEBONUS_1d8;   break;
    }

    //get elemental damage type
    DamageType = GetDamageType();
    sCategory1 = DamageType.sDamageType;

    if ( RandomNumber( 100,1 ) <= nUnique ){

        //set unique booster
        nBooster = 1;
    }

    //Create name & properties
    if ( IPGetIsProjectile( oWeapon ) ){

        //set elemental damage & damage bonus and mighty for ammo
        ipAddBonus1 = ItemPropertyDamageBonus(DamageType.nDamageType, nDamageBonus);
        ipAddBonus2 = ItemPropertyDamageBonus(DAMAGE_TYPE_PIERCING, nLevel+nBooster);

    }
    else if ( GetWeaponRanged( oWeapon ) && GetItemStackSize( oWeapon ) == 1 ){

        //set attack bonus and mighty for bows
        ipAddBonus1 = CreateRanged( nLevel );
        ipAddBonus2 = ItemPropertyAttackBonus( nLevel+nBooster );
        sCategory1  = "Ranged";
    }
    else{

        //set elemental damage & enhancement for other weapons
        ipAddBonus1 = ItemPropertyDamageBonus(DamageType.nDamageType, nDamageBonus);
        ipAddBonus2 = ItemPropertyEnhancementBonus(nLevel+nBooster);

        //visual effects only work on melee weapons
        ipVisual = ItemPropertyVisualEffect(DamageType.nDamageVisual);
        IPSafeAddItemProperty(oWeapon, ipVisual);
    }

    //set item properties& name
    IPSafeAddItemProperty(oWeapon, ipAddBonus1);
    IPSafeAddItemProperty(oWeapon, ipAddBonus2);

    //create 'normal' random weapon or unique weapon
    if ( !IPGetIsProjectile( oWeapon ) && nBooster == 1 ){

        sName = SetUniqueWeapon(oWeapon, sCategory1, nLevel);
    }
    else{

        sName = CreateName(oWeapon, "", nLevel, sCategory1, "");
    }

    SetName( oWeapon, sName );
}

string SetUniqueWeapon( object oWeapon, string sCategory1, int nLevel ){

    string sCategory2;
    string sName;
    int nRandom;
    itemproperty ipBonus;

    //create rest of name
    if( IPGetIsBludgeoningWeapon( oWeapon ) ){

        sCategory2 = "BluntSuffix";
    }
    else{

        sCategory2 = "SharpSuffix";
    }

    nRandom = RandomNumber( 10, 1 );

    switch ( nRandom ){

        case 01: ipBonus = ItemPropertyAbilityBonus( Random(6), 1+(nLevel/2) ); break;
        case 02: ipBonus = ItemPropertyKeen(); break;
        case 03: ipBonus = ItemPropertyRegeneration( 1+(nLevel/3) ); break;
        case 04: ipBonus = ItemPropertyAttackBonusVsRace( RandomNumber( 24,0 ), 2+nLevel ); break;
        case 05: ipBonus = ItemPropertyAttackBonusVsSAlign( RandomNumber( 9,0 ), 2+nLevel ); break;
        case 06: ipBonus = ItemPropertyVampiricRegeneration( 1+( nLevel/2 ) ); break;
        case 07: ipBonus = ItemPropertyBonusSavingThrowVsX( 2+d6(), 1+nLevel ); break;
        case 08: ipBonus = ItemPropertyBonusSavingThrowVsX( 11+d4(), 1+nLevel ); break;
        case 09: ipBonus = ItemPropertyBonusSavingThrow( d3(), 1+nLevel ); break;
        case 10: ipBonus = ItemPropertyMassiveCritical( 6+(nLevel/2) ); break;
    }

    //no keen on ranged weapons, so we substitute with unlimited ammo
    if( sCategory1 == "Ranged" ){

        sCategory2 = "BowSuffix";

        if( nRandom == 2 ){

            ipBonus = ItemPropertyUnlimitedAmmo( 11 + ( nLevel/2 ) );
        }
    }

    IPSafeAddItemProperty( oWeapon, ipBonus );

    return CreateName( oWeapon, "weapon", nLevel, sCategory1, sCategory2 );
}

void CreateArmour( object oStore, int nLevel, string sType="", int nUnique=5 ){

    int nRandom;
    object oArmour;
    string sItem;
    int nColorIndex;
    int nModel;
    nRandom = RandomNumber(6,1);

    if ( sType == "Cloth" ){

        sItem = GetCloth();
        nColorIndex = 1 + d2();
    }
    else if ( sType == "Light" ){

        sItem = GetLightArmor( nLevel );
        nColorIndex = 1 + d2();
    }
    else if ( sType == "Medium" ){

        sItem = GetMediumArmor( nLevel );
        nColorIndex = RandomNumber( 1, 0 );
    }
    else if ( sType == "Heavy" ){

        sItem = GetHeavyArmor( nLevel );
        nColorIndex = 3 + d2();
    }
    else if ( sType == "Shield" ){

        nColorIndex = -1;
    }
    else if ( sType == "Helmet" ){

        nColorIndex = -2;
    }
    else{

        switch ( nRandom ){

            case 1: sItem = GetCloth();               nColorIndex = 1 + d2();  break;
            case 2: sItem = GetLightArmor( nLevel );  nColorIndex = 1 + d2();  break;
            case 3: sItem = GetMediumArmor( nLevel ); nColorIndex = RandomNumber( 1, 0 );  break;
            case 4: sItem = GetHeavyArmor( nLevel );  nColorIndex = 3 + d2();  break;
            case 5: nColorIndex = -1;  break;
            case 6: nColorIndex = -2;  break;
        }
    }

    if (  nColorIndex > -1 ){

        oArmour = CreateObjectFromTemplate( oStore, sItem, ITEM_APPR_TYPE_ARMOR_COLOR, nColorIndex, 175 );
    }
    else if (  nColorIndex == -1 ){

        switch ( d6() ){

            case 1: sItem = "nw_ashsw001"; nModel=(( d4()*10 ) + d3()); break;
            case 2: sItem = "nw_ashlw001"; nModel=(( d4()*10 ) + d3()); break;
            case 3: sItem = "nw_ashlw001"; nModel=50+d6(); break;
            case 4: sItem = "nw_ashlw001"; nModel=60+d12(); break;
            case 5: sItem = "nw_ashto001"; nModel=(( d4()*10 ) + d3()); break;
            case 6: sItem = "nw_ashto001"; nModel=(( d4()*10 ) + d3()); break;
        }

        WriteTimestampedLogEntry( "sItem="+sItem+", nModel="+IntToString( nModel ) );

        oArmour = CreateObjectFromTemplate( oStore, sItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, 0, nModel );
    }
    else if (  nColorIndex == -2 ){

        switch ( d8() ){

            case 1: sItem = "nw_arhe001"; break;
            case 2: sItem = "nw_arhe002"; break;
            case 3: sItem = "nw_arhe003"; break;
            case 4: sItem = "nw_arhe004"; break;
            case 5: sItem = "nw_arhe005"; break;
            case 6: sItem = "x2_it_arhelm01"; break;
            case 7: sItem = "x2_ardrowhe002"; break;
            case 8: sItem = "x2_arduerhe003"; break;
        }

        oArmour = CreateObjectFromTemplate( oStore, sItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, 0, RandomNumber( 33, 1 ) );
    }

    if ( GetObjectType( oStore ) != OBJECT_TYPE_STORE ){

        SetIdentified( oArmour, FALSE );
    }
    else{

        SetLocalInt( oArmour, "RSCln", 1 );

    }

    //adapt armour
    SetArmour( oArmour, nLevel, nRandom, nUnique );

}

void SetArmour( object oArmour, int nLevel, int nType, int nUnique ){

    if (!GetIsObjectValid(oArmour)) return; //stop if no armour

    int nRandom;
    int nDamageResist;
    int nEnhancement;
    string sName;
    string sCategory1;
    string sCategory2;
    itemproperty ipAddBonus1;
    itemproperty ipAddBonus2;
    struct tDamageType DamageType;

    //determine elemental damage resist amount
    nRandom         = RandomNumber(2,1) + (nLevel/2);

    switch ( nRandom ){

        case 1: nDamageResist = IP_CONST_DAMAGERESIST_5;  break;
        case 2: nDamageResist = IP_CONST_DAMAGERESIST_5; break;
        case 3: nDamageResist = IP_CONST_DAMAGERESIST_10; break;
        case 4: nDamageResist = IP_CONST_DAMAGERESIST_10; break;
        case 5: nDamageResist = IP_CONST_DAMAGERESIST_15; break;
    }

    //determine elemental damage type
    DamageType      = GetDamageType();

    //Create properties
    ipAddBonus1     = ItemPropertyDamageResistance( DamageType.nDamageType, nDamageResist );

    //create elemental name part
    sCategory1      = DamageType.sDamageType;

    //create name and unique item
    if ( RandomNumber( 100,1 ) <= nUnique ){

        sName       = SetUniqueArmour(oArmour, sCategory1, nLevel, nType);
        ipAddBonus2 = ItemPropertyACBonus( nLevel+1 );
    }
    else{

        sName       = CreateName(oArmour, "", nLevel, sCategory1, "");
        ipAddBonus2 = ItemPropertyACBonus( nLevel );
    }

    //set item properties& name
    IPSafeAddItemProperty( oArmour, ipAddBonus1 );
    IPSafeAddItemProperty( oArmour, ipAddBonus2 );

    SetName( oArmour, sName );
}

string SetUniqueArmour( object oArmour, string sCategory1, int nLevel, int nType ){

    string sCategory2;
    string sName;
    int nRandom;
    itemproperty ipBonus;

    //create armour name part
    if( nType < 5 ){
        sCategory2 = "ArmourSuffix";
    }
    if( nType == 5 ){
        sCategory2 = "ShieldSuffix";
    }
    else if( nType == 6 ){
        sCategory2 = "HelmetSuffix";
    }

    nRandom = RandomNumber(7, 1);

    switch ( nRandom ){

        case 1: ipBonus = ItemPropertyAbilityBonus( Random(6), 1+( nLevel/2) ); break;
        case 2: ipBonus = ItemPropertyDarkvision(); break;
        case 3: ipBonus = ItemPropertyBonusSpellResistance( nLevel+RandomNumber( 2,0 ) ); break;
        case 4: ipBonus = ItemPropertyBonusSavingThrow( RandomNumber( 3, 1 ), 1+( nLevel/3 ) ); break;
        case 5: ipBonus = ItemPropertyBonusSavingThrowVsX( RandomNumber( 7, 3 ), 1+( nLevel/2 ) ); break;
        case 6: ipBonus = ItemPropertySkillBonus( RandomNumber( 27,0 ),nLevel+RandomNumber( 3,0 ) ); break;
        case 7: ipBonus = ItemPropertyACBonusVsRace( RandomNumber( 24, 0 ), 2+nLevel ); break;
    }

    IPSafeAddItemProperty( oArmour, ipBonus );

    return CreateName( oArmour, "armour", nLevel, sCategory1, sCategory2 );
}

void CreateJewelry( object oStore, int nLevel, int nUnique=5 ){

    int nRandom = d6();
    object oJewelry;
    string sItem;

    if ( nRandom <= 3 ){

        oJewelry = CreateObjectFromTemplate( oStore, "nw_it_mring021", ITEM_APPR_TYPE_SIMPLE_MODEL, 0, 101 );
    }
    else{

        oJewelry = CreateObjectFromTemplate( oStore, "nw_it_mneck020", ITEM_APPR_TYPE_SIMPLE_MODEL, 0, 64 );
    }

    //adapt jewelry
    SetJewelry( oJewelry, nLevel, nRandom, nUnique );

    if ( GetObjectType( oStore ) != OBJECT_TYPE_STORE ){

        SetIdentified( oJewelry, FALSE );
    }
    else{

        SetLocalInt( oJewelry, "RSCln", 1 );

    }

}

void SetJewelry( object oJewelry, int nLevel, int nType, int nUnique ){

    if ( !GetIsObjectValid( oJewelry ) ) return; //stop if no jewelry

    int nRandom;
    int nDamageResist;
    string sName;
    string sCategory1;
    string sCategory2;
    itemproperty ipAddBonus1;
    itemproperty ipAddBonus2;
    struct tDamageType DamageType;

    if ( d100() <= nUnique ){

        nUnique = 1;
    }
    else{

        nUnique = 0;
    }


    //determine elemental damage resist amount
    nRandom = RandomNumber( 2, 1 ) + ( nLevel/2 ) + nUnique;
    switch ( nRandom ){

        case 1: nDamageResist = IP_CONST_DAMAGERESIST_5;  break;
        case 2: nDamageResist = IP_CONST_DAMAGERESIST_5; break;
        case 3: nDamageResist = IP_CONST_DAMAGERESIST_10; break;
        case 4: nDamageResist = IP_CONST_DAMAGERESIST_10; break;
        case 5: nDamageResist = IP_CONST_DAMAGERESIST_15; break;
    }

    //determine elemental damage type
    DamageType = GetDamageType();

    //Create properties
    ipAddBonus1 = ItemPropertySkillBonus( RandomNumber( 27, 0 ), nLevel + nUnique + RandomNumber( 3, 0 ) );

    //create elemental name part
    sCategory1 = DamageType.sDamageType;

    //create name and unique item
    if ( nUnique ){

        SetUniqueArmour( oJewelry, sCategory1, nLevel, nType );
        sName       = CreateName( oJewelry, "jewelry", nLevel, sCategory1, "JewelrySuffix");

        if ( d2() == 2 ){

            ipAddBonus2 = ItemPropertyDamageResistance( DamageType.nDamageType, nDamageResist );
        }
        else{

            ipAddBonus2 = ItemPropertyACBonus( nLevel + nUnique );
        }
    }
    else{

        if ( nType > 3 ){

            switch ( d10() ){

                case  1: sName = "Choker"; break;
                case  2: sName = "Pendant"; break;
                case  3: sName = "Beads"; break;
                case  4: sName = "Amulet"; break;
                case  5: sName = "Necklet"; break;
                case  6: sName = "Necklace"; break;
                case  7: sName = "Locket"; break;
                case  8: sName = "Chain"; break;
                case  9: sName = "Rosary"; break;
                case 10: sName = "Strand"; break;
            }
        }
        else{

            switch ( d10() ){

                case  1: sName = "Ring"; break;
                case  2: sName = "Band"; break;
                case  3: sName = "Wreath"; break;
                case  4: sName = "Coil"; break;
                case  5: sName = "Ring"; break;
                case  6: sName = "Wedding Band"; break;
                case  7: sName = "Sleeve Ring"; break;
                case  8: sName = "Thumb Ring"; break;
                case  9: sName = "Signet Ring"; break;
                case 10: sName = "Ring"; break;
            }
        }

        if ( d2() == 2 ){

            ipAddBonus2 = ItemPropertyDamageResistance( DamageType.nDamageType, nDamageResist );
            sName = Get2DAString( "ds_itemnames", sCategory1, RandomNumber( 3, 0 ) )+" "+sName;
        }
        else{

            ipAddBonus2 = ItemPropertyACBonus( nLevel );

            switch ( d6() ){

                case 1: sName = sName + " of Safety"; break;
                case 2: sName = sName + " of Protection"; break;
                case 3: sName = sName + " of Shielding"; break;
                case 4: sName = sName + " of Insurance"; break;
                case 5: sName = "Blessed "+sName; break;
                case 6: sName = "Coward's "+sName; break;
            }
        }
    }

    //set item properties& name
    IPSafeAddItemProperty( oJewelry, ipAddBonus1 );
    IPSafeAddItemProperty( oJewelry, ipAddBonus2 );

    SetName( oJewelry, sName );
}

void CreateClothing( object oStore, int nLevel, int nUnique=5 ){

    int nRandom;
    object oClothing;
    string sItem;
    int nType;
    int nModel;
    int nMax;
    string sName;
    //object oTemplates = GetLocalObject( GetModule(), "ds_j_templates" );

    nRandom = RandomNumber( 13, 1 );

    switch ( nRandom ){

        case 1: sItem = "ds_base_cloak_1"; nType=1; nMax=16; sName = " Cape"; break;
        case 2: sItem = "ds_base_cloak_2"; nType=1; nMax=16; sName = " Cloak"; break;
        case 3: sItem = "ds_base_cloak_3"; nType=1; nMax=16; sName = " Mantle"; break;
        case 4: sItem = "ds_base_belt"; nType=2; nMax=50; sName = " Belt"; break;
        case 5: sItem = "ds_base_belt"; nType=2; nMax=50; sName = " Sash"; break;
        case 6: sItem = "ds_base_belt"; nType=2; nMax=50; sName = " Girdle"; break;
        case 7: sItem = "ds_base_bracer"; nType=3; nMax=48; sName = " Bracer"; break;
        case 8: sItem = "ds_base_bracer"; nType=3; nMax=48; sName = " Band"; break;
        case 9: sItem = "ds_base_gauntlet"; nType=4; nMax=60; sName = " Glove"; break;
        case 10: sItem = "ds_base_gauntlet"; nType=4; nMax=60;sName = " Gauntlet"; break;
        case 11: sItem = "ds_base_boots_1"; nType=5; nMax=9; sName = " Boots"; break;
        case 12: sItem = "ds_base_boots_2"; nType=5; nMax=9; sName = " Shoes"; break;
        case 13: sItem = "ds_base_boots_3"; nType=5; nMax=9; sName = " Waders"; break;
    }

    if ( nType == 5 ){

        oClothing = CreateObjectFromTemplate( oStore, sItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_COLOR_BOTTOM, nMax );
    }
    else{

        oClothing = CreateObjectFromTemplate( oStore, sItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nMax );
    }

    if ( !GetIsObjectValid( oClothing ) ) {

        return;
    }

    int nDamageResist;
    string sCategory1;
    string sCategory2;
    itemproperty ipAddBonus1;
    itemproperty ipAddBonus2;
    itemproperty ipAddBonus3;
    struct tDamageType DamageType;

    if ( d100() <= nUnique ){

        nUnique = 1;
    }
    else{

        nUnique = 0;
    }

    //determine elemental damage resist amount
    nRandom = RandomNumber(2,1) + (nLevel/2) + nUnique;

    switch ( nRandom ){

        case 1: nDamageResist = IP_CONST_DAMAGERESIST_5;  break;
        case 2: nDamageResist = IP_CONST_DAMAGERESIST_5; break;
        case 3: nDamageResist = IP_CONST_DAMAGERESIST_10; break;
        case 4: nDamageResist = IP_CONST_DAMAGERESIST_10; break;
        case 5: nDamageResist = IP_CONST_DAMAGERESIST_15; break;
    }

    //determine elemental damage type
    DamageType = GetDamageType();

    //Create properties
    ipAddBonus1 = ItemPropertySkillBonus( RandomNumber( 26, 0 ), nLevel + nUnique + RandomNumber( 3, 1 ) );

    //create elemental name part
    sCategory1 = DamageType.sDamageType;


    //create name and unique item
    if ( nUnique ){

        ipAddBonus2 = ItemPropertyDamageResistance( DamageType.nDamageType, nDamageResist );

        sName  = " "+Get2DAString( "ds_itemnames", sCategory1, RandomNumber( 3,0 ) ) + sName;
        sName  = " "+Get2DAString( "ds_itemnames", "Unique", RandomNumber( 28 , 0 ) ) + sName;

        if ( nType != 4 ){

            SetUniqueArmour( oClothing, sCategory1, nLevel, 0 );
        }
        else{

            switch ( d8() ){

                case 01: ipAddBonus3 = ItemPropertyAbilityBonus( Random( 6 ), 1+(nLevel/2) ); break;
                case 02: ipAddBonus3 = ItemPropertyRegeneration( 1+(nLevel/3) ); break;
                case 03: ipAddBonus3 = ItemPropertyAttackBonusVsRace( RandomNumber( 24,0 ), 2+nLevel ); break;
                case 04: ipAddBonus3 = ItemPropertyAttackBonusVsSAlign( RandomNumber( 9,0 ), 2+nLevel ); break;
                case 05: ipAddBonus3 = ItemPropertyVampiricRegeneration( 1+( nLevel/2 ) ); break;
                case 06: ipAddBonus3 = ItemPropertyBonusSavingThrowVsX( 2+d6(), 1+nLevel ); break;
                case 07: ipAddBonus3 = ItemPropertyBonusSavingThrowVsX( 11+d4(), 1+nLevel ); break;
                case 08: ipAddBonus3 = ItemPropertyBonusSavingThrow( d3(), 1+nLevel ); break;
            }

            IPSafeAddItemProperty( oClothing, ipAddBonus3 );
        }

        SetName( oClothing, "<cþþ >"+RandomName( -1 + Random( 24 ) )+"'s"+sName+"</c>" );
    }
    else{

        if ( d2() == 2 ){

            ipAddBonus2 = ItemPropertyDamageResistance( DamageType.nDamageType, nDamageResist );
            sName       = " "+Get2DAString( "ds_itemnames", sCategory1, RandomNumber( 3,0 ) ) + sName;
        }
        else{

            ipAddBonus2 = ItemPropertyACBonus( nLevel );
        }

        sName  = Get2DAString( "ds_itemnames", "Clothing", RandomNumber( 21 , 0 ) ) + sName;
        SetName( oClothing, sName );
    }

    //set item properties& name
    IPSafeAddItemProperty( oClothing, ipAddBonus1 );
    IPSafeAddItemProperty( oClothing, ipAddBonus2 );

    if ( GetObjectType( oStore ) != OBJECT_TYPE_STORE ){

        SetIdentified( oClothing, FALSE );
    }
    else{

        SetLocalInt( oClothing, "RSCln", 1 );

    }

}

void CreateMagicSupplies( object oStore, int nLevel, int nUnique=5 ){

    int nRandom;
    object oItem;
    string sItem;
    int nType;
    int nModel;
    int nMax;
    string sName;
    string sCategory;
    int nSwitch = d20();

    switch ( nSwitch ){

        case 1: sItem = "ds_base_potion_1"; nType=1; sName = " Potion"; break;
        case 2: sItem = "ds_base_potion_2"; nType=1; sName = " Brew"; break;
        case 3: sItem = "ds_base_potion_3"; nType=1; sName = " Elixir"; break;
        case 4: sItem = "ds_base_potion_4"; nType=1; sName = " Tonic"; break;
        case 5: sItem = "ds_base_wand_1"; nType=2; sName = " Wand"; break;
        case 6: sItem = "ds_base_wand_2"; nType=2; sName = " Scepter"; break;
        case 7: sItem = "ds_base_wand_3"; nType=2; sName = " Stick"; break;
        case 8: sItem = "ds_base_wand_4"; nType=2; sName = " Baton"; break;
        case 9: sItem = "ds_base_book"; nType=3; sName = " Compendium"; break;
        case 10: sItem = "ds_base_book"; nType=3; sName = " Tome"; break;
        case 11: sItem = "ds_base_book"; nType=3; sName = " Portfolio"; break;
        case 12: sItem = "ds_base_book"; nType=3; sName = " Codex"; break;
        case 13: sItem = "ds_base_book"; nType=3; sName = " Book"; break;
        case 14: sItem = "ds_base_book"; nType=3; sName = " Manual"; break;
        case 15: sItem = "ds_base_potion_1"; nType=1; sName = " Mixture"; break;
        case 16: sItem = "ds_base_potion_2"; nType=1; sName = " Bottle"; break;
        case 17: sItem = "ds_base_potion_3"; nType=1; sName = " Concoction"; break;
        case 18: sItem = "ds_base_wand_1"; nType=2; sName = " Caduceus"; break;
        case 19: sItem = "ds_base_wand_2"; nType=2; sName = " Rod"; break;
        case 20: sItem = "ds_base_wand_3"; nType=2; sName = " Sprig"; break;
    }

    if ( d100() <= nUnique ){

        nUnique = 1;
    }
    else{

        nUnique = 0;
    }

    if ( nType == 1 ){

        sCategory = "Potion";

        oItem = CreateObjectFromTemplate( oStore, sItem, d2(), 0, RandomNumber(9,1) );

        SetItemStackSize( oItem, 2 + d4(1+nUnique) );

        sName = sName + " of " + AddSpellToItem( oItem, nLevel + nUnique, 1, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE );
    }
    else if ( nType == 2 ){

        sCategory = "Wand";

        oItem = CreateObjectFromTemplate( oStore, sItem,ITEM_APPR_TYPE_WEAPON_MODEL, d2(), d6() );

        SetItemCharges( oItem, ( 1 + 3 * ( 5 - nLevel + nUnique ) ) );

        sName = sName + " of " + AddSpellToItem( oItem, nLevel + nUnique, d2() );
    }
    else {

        sCategory = "Book";

        oItem = CreateObjectFromTemplate( oStore, sItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, ( 1 + Random( 36 ) ) );

        SetItemCharges( oItem, ( 5 + 3 * ( 5 - nLevel + nUnique ) ) );

        sName = sName + " of " + AddSpellToItem( oItem, ( nLevel + nUnique ) );

        if ( nUnique ){

            sName = sName + " and " + AddSpellToItem( oItem, ( nLevel + nUnique ), d2() );
        }
    }

    if ( !GetIsObjectValid( oItem ) ) {

        return;
    }

    //create name and unique item
    if ( nUnique ){

        sName  = " "+Get2DAString( "ds_itemnames", "Unique", RandomNumber( 28 , 0 ) ) + sName;
        SetName( oItem, "<cþþ >"+RandomName( -1 + Random( 24 ) )+"'s"+sName+"</c>" );
    }
    else{

        sName  = Get2DAString( "ds_itemnames", sCategory, RandomNumber( 21 , 0 ) ) + sName;
        SetName( oItem, sName );
    }

    IPSafeAddItemProperty( oItem, ItemPropertyQuality( 6+nLevel+nUnique ) );

    if ( GetObjectType( oStore ) != OBJECT_TYPE_STORE ){

        SetIdentified( oItem , FALSE );
    }
    else{

        SetLocalInt( oItem, "RSCln", 1 );

    }

}

string GetSimpleWeapon(){

    string sItem = "";
    int nRandom  = RandomNumber(7, 1);

    switch (nRandom){
        case 1: sItem = "nw_wblms001"; break;
        case 2: sItem = "nw_wblcl001"; break;
        case 3: sItem = "nw_wplss001"; break;
        case 4: sItem = "nw_wdbqs001"; break;
        case 5: sItem = "nw_wswdg001"; break;
        case 6: sItem = "nw_wblml001"; break;
        case 7: sItem = "nw_wspsc001"; break;
    }

    return sItem;
}

string GetMartialWeapon(){

    string sItem = "";
    int nRandom = RandomNumber(14, 1);

    switch (nRandom){
        case  1: sItem = "nw_wswgs001"; break;
        case  2: sItem = "nw_wblhl001"; break;
        case  3: sItem = "nw_waxhn001"; break;
        case  4: sItem = "nw_wblfl001"; break;
        case  5: sItem = "nw_waxbt001"; break;
        case  6: sItem = "nw_wswrp001"; break;
        case  7: sItem = "nw_wswss001"; break;
        case  8: sItem = "nw_wblhw001"; break;
        case  9: sItem = "nw_wblfh001"; break;
        case 10: sItem = "nw_wswls001"; break;
        case 11: sItem = "nw_wswsc001"; break;
        case 12: sItem = "nw_waxgr001"; break;
        case 13: sItem = "nw_wpltr001"; break;
        case 14: sItem = "nw_wplhb001"; break;
    }

    return sItem;
}

string GetExoticWeapon(){

    string sItem = "";
    int nRandom = RandomNumber(10, 1);

    switch (nRandom){
        case 1: sItem = "nw_wdbsw001"; break;
        case 2: sItem = "nw_wspka001"; break;
        case 3: sItem = "nw_wspku001"; break;
        case 4: sItem = "nw_wplsc001"; break;
        case 5: sItem = "nw_wdbax001"; break;
        case 6: sItem = "nw_wdbma001"; break;
        case 7: sItem = "nw_wswka001"; break;
        case 8: sItem = "x2_wdwraxe001"; break;
        case 9: sItem = "x2_it_wpwhip"; break;
        case 10: sItem = "nw_wswbs001"; break;

    }

    return sItem;
}

string GetRangedWeapon( int nLevel ){

    string sItem = "";
    int nRandom = RandomNumber(6, 1);

    if (  nLevel > 0 ){

        nRandom = RandomNumber(10, 1);
    }

    switch (nRandom){

        case 1: sItem = "nw_wbwln001"; break;
        case 2: sItem = "nw_wbwsh001"; break;
        case 3: sItem = "nw_wbwxh001"; break;
        case 4: sItem = "nw_wbwxl001"; break;
        case 5: sItem = "nw_wbwsl001"; break;
        case 6: sItem = "nw_wbwln001"; break;
        case 7: sItem = "nw_wbwmln002"; break;
        case 8: sItem = "nw_wbwmsh002"; break;
        case 9: sItem = "nw_wbwmxh002"; break;
        case 10: sItem = "nw_wbwmxl002"; break;
    }

    return sItem;
}

string GetAmmo(){

    string sItem = "";
    int nRandom = RandomNumber(3, 1);

    switch (nRandom){
        case 1: sItem = "nw_wamar001"; break;
        case 2: sItem = "nw_wambo001"; break;
        case 3: sItem = "nw_wambu001"; break;
    }

    return sItem;
}

string GetThrownWeapon(){

    string sItem = "";
    int nRandom = RandomNumber(3, 1);

    switch (nRandom){

        case 1: sItem = "nw_wthdt001"; break;
        case 2: sItem = "nw_wthsh001"; break;
        case 3: sItem = "nw_wthax001"; break;
    }

    return sItem;
}

string GetBlade(){

    string sItem = "";
    int nRandom  = RandomNumber(12, 1);

    switch (nRandom){

        case 1: sItem = "nw_wswgs001"; break;
        case 2: sItem = "nw_wswka001"; break;
        case 3: sItem = "nw_wswss001"; break;
        case 4: sItem = "nw_wswrp001"; break;
        case 5: sItem = "nw_wswdg001"; break;
        case 6: sItem = "nw_wswsc001"; break;
        case 7: sItem = "nw_wswbs001"; break;
        case 8: sItem = "nw_wspku001"; break;
        case 9: sItem = "nw_wdbsw001"; break;
        case 10: sItem = "nw_wswls001"; break;
        case 11: sItem = "nw_wswls001"; break;
        case 12: sItem = "nw_wswbs001"; break;
    }

    return sItem;
}


string GetCloth(){

    string sItem = "";
    int nRandom  = RandomNumber(20, 1);

    switch ( nRandom ){

        case  1: sItem = "nw_cloth027"; break;
        case  2: sItem = "nw_cloth017"; break;
        case  3: sItem = "nw_cloth012"; break;
        case  4: sItem = "nw_cloth015"; break;
        case  5: sItem = "nw_cloth010"; break;
        case  6: sItem = "nw_cloth028"; break;
        case  7: sItem = "nw_cloth005"; break;
        case  8: sItem = "nw_cloth008"; break;
        case  9: sItem = "nw_cloth013"; break;
        case 10: sItem = "nw_cloth007"; break;
        case 11: sItem = "nw_cloth029"; break;
        case 12: sItem = "nw_it_creitem146"; break;
        case 13: sItem = "nw_it_creitem144"; break;
        case 14: sItem = "x2_djinni_robe"; break;
        case 15: sItem = "nw_cloth019"; break;
        case 16: sItem = "nw_cloth021"; break;
        case 17: sItem = "nw_cloth009"; break;
        case 18: sItem = "nw_cloth023"; break;
        case 19: sItem = "nw_cloth025"; break;
        case 20: sItem = "nw_cloth026"; break;
    }

    return sItem;
}

string GetLightArmor( int nLevel ){

    string sItem = "";
    int nRandom = RandomNumber(4, 1);

    if (  nLevel > 0 ){

        nRandom = RandomNumber(8, 1);
    }

    switch ( nRandom ){

        case  1: sItem = "nw_aarcl001"; break;
        case  2: sItem = "nw_aarcl002"; break;
        case  3: sItem = "nw_aarcl009"; break;
        case  4: sItem = "nw_aarcl012"; break;
        case  5: sItem = "x2_mdrowar001"; break;
        case  6: sItem = "x2_mdrowar008"; break;
        case  7: sItem = "nw_maarcl045"; break;
        case  8: sItem = "nw_aarcl012"; break;
    }

    return sItem;
}
string GetMediumArmor( int nLevel ){

    string sItem = "";
    int nRandom = RandomNumber(4, 1);

    if (  nLevel > 0 ){

        nRandom = RandomNumber(8, 1);
    }

    switch ( nRandom ){

        case  1: sItem = "nw_aarcl003"; break;
        case  2: sItem = "nw_aarcl004"; break;
        case  3: sItem = "nw_aarcl008"; break;
        case  4: sItem = "nw_aarcl010"; break;
        case  5: sItem = "x2_mdrowar022"; break;
        case  6: sItem = "x2_mdrowar015"; break;
        case  7: sItem = "nw_maarcl035"; break;
        case  8: sItem = "nw_aarcl003"; break;
    }

    return sItem;
}
string GetHeavyArmor( int nLevel ){

    string sItem = "";
    int nRandom = RandomNumber(4, 1);

    if (  nLevel > 0 ){

        nRandom = RandomNumber(8, 1);
    }

    switch ( nRandom ){

        case  1: sItem = "nw_aarcl005"; break;
        case  2: sItem = "nw_aarcl006"; break;
        case  3: sItem = "nw_aarcl007"; break;
        case  4: sItem = "nw_aarcl011"; break;
        case  5: sItem = "x2_mdrowar036"; break;
        case  6: sItem = "x2_mdrowar029"; break;
        case  7: sItem = "nw_maarcl053"; break;
        case  8: sItem = "nw_maarcl052"; break;    }

    return sItem;
}

struct tDamageType GetDamageType(){

    int nRandom;
    int nDamageType;
    int nDamageVisual;
    string sDamageType;
    struct tDamageType DamageType;

    //determine elemental damage type
    nRandom = RandomNumber(6, 1);
    switch (nRandom){

        case 1:
            DamageType.sDamageType   = "Acid";
            DamageType.nDamageType   = IP_CONST_DAMAGETYPE_ACID;
            DamageType.nDamageVisual = ITEM_VISUAL_ACID;
        break;
        case 2:
            DamageType.sDamageType   = "Cold";
            DamageType.nDamageType   = IP_CONST_DAMAGETYPE_COLD;
            DamageType.nDamageVisual = ITEM_VISUAL_COLD;
        break;
        case 3:
            DamageType.sDamageType   = "Electric";
            DamageType.nDamageType   = IP_CONST_DAMAGETYPE_ELECTRICAL;
            DamageType.nDamageVisual = ITEM_VISUAL_ELECTRICAL;
        break;
        case 4:
            DamageType.sDamageType   = "Fire";
            DamageType.nDamageType   = IP_CONST_DAMAGETYPE_FIRE;
            DamageType.nDamageVisual = ITEM_VISUAL_FIRE;
        break;
        case 5:
            DamageType.sDamageType   = "Sonic";
            DamageType.nDamageType   = IP_CONST_DAMAGETYPE_SONIC;
            DamageType.nDamageVisual = ITEM_VISUAL_SONIC;
        break;
        case 6:
            DamageType.sDamageType   = "Negative";
            DamageType.nDamageType   = IP_CONST_DAMAGETYPE_NEGATIVE;
            DamageType.nDamageVisual = ITEM_VISUAL_EVIL;
        break;
    }

    return DamageType;

}

string CreateName( object oItem, string sType, int nLevel, string sCategory1, string sCategory2){

    string sName;

    if( sType ==  "weapon" ){

        sName = Get2DAString( "ds_itemnames", sCategory1, 4 + Random(7) );
        sName = sName + Get2DAString( "ds_itemnames", sCategory2, Random(27) );

        //stacked items get an -s to the end of their name
        if ( GetNumStackedItems( oItem ) == 25 ){
            sName = sName + "s";
        }

        sName = "<cþþ >" + sName  + "</c>";
    }
    else if( sType == "armour" || sType == "jewelry" ){

        sName = Get2DAString( "ds_itemnames", sCategory1, 4 + Random(7) );
        sName = sName + Get2DAString( "ds_itemnames", sCategory2, Random(16) );

        sName = "<cþþ >" + sName + "</c>";
    }
    else{

        string sRandomName = RandomName( d10() );

        if ( ( d4() == 1 && sRandomName != "" ) || sType == "armour" ){

            sName = sRandomName + "'s " + GetBaseItemName( GetBaseItemType( oItem ) );

        }
        else{

            sName = Get2DAString( "ds_itemnames", sCategory1, d4() - 1 );
            sName = sName + " " + GetBaseItemName( GetBaseItemType( oItem ) );

            //stacked items get an -s to the end of their name
            if ( GetNumStackedItems( oItem ) == 25 ){

                sName = sName + "s";
            }
        }
    }

    //add enhancement suffix
    if ( nLevel && sType ==  "" ){

        //sName = sName + " +" + IntToString( nLevel );
    }
    return sName;
}

itemproperty CreateRanged (int nLevel ){

    itemproperty ipBonus;
    int nRandom    = d12();

    switch (nRandom){

        case 01: ipBonus = ItemPropertySkillBonus( SKILL_HIDE,nLevel+RandomNumber(3, 1 ) ); break;
        case 02: ipBonus = ItemPropertySkillBonus( SKILL_LISTEN,nLevel+RandomNumber(3, 1 ) ); break;
        case 03: ipBonus = ItemPropertySkillBonus( SKILL_MOVE_SILENTLY,nLevel+RandomNumber(3, 1 ) ); break;
        case 04: ipBonus = ItemPropertySkillBonus( SKILL_SEARCH,nLevel+RandomNumber(3, 1 ) ); break;
        case 05: ipBonus = ItemPropertySkillBonus( SKILL_SPOT,nLevel+RandomNumber(3, 1 ) ); break;
        case 06: ipBonus = ItemPropertyDarkvision(); break;
        case 07: ipBonus = ItemPropertyWeightReduction( 5-nLevel ); break;
        case 08: ipBonus = ItemPropertyLight( d4(), d6( ) ); break;
        case 09: ipBonus = ItemPropertyMaxRangeStrengthMod(( nLevel/3)+1); break;
        case 10: ipBonus = ItemPropertyMaxRangeStrengthMod(( nLevel/2)+1); break;
        case 11: ipBonus = ItemPropertyMaxRangeStrengthMod( nLevel); break;
        case 12: ipBonus = ItemPropertySkillBonus( SKILL_TUMBLE,nLevel+RandomNumber(2,0 ) ); break;

    }

    return ipBonus;
}

int RandomNumber(int nNumber, int nAdd){

    if ( nNumber == 0 ){

        return 0;
    }
    else{

        int nRandom = Random(nNumber) + nAdd;

        return nRandom;
    }
}



string GetBaseItemName( int ItemType ){

    string sItem;

    switch ( ItemType ){

        case  0: sItem = "Short Sword"; break;
        case  1: sItem = "Longsword"; break;
        case  2: sItem = "Battleaxe"; break;
        case  3: sItem = "Bastard Sword"; break;
        case  4: sItem = "Light Flail"; break;
        case  5: sItem = "Warhammer"; break;
        case  6: sItem = "Heavy Crossbow"; break;
        case  7: sItem = "Light Crossbow"; break;
        case  8: sItem = "Longbow"; break;
        case  9: sItem = "Mace"; break;
        case  10: sItem = "Halberd"; break;
        case  11: sItem = "Shortbow"; break;
        case  12: sItem = "Two-Bladed Sword"; break;
        case  13: sItem = "Greatsword"; break;
        case  14: sItem = "Small Shield"; break;
        case  15: sItem = "Torch"; break;
        case  16: sItem = "Armor"; break;
        case  17: sItem = "Helmet"; break;
        case  18: sItem = "Greataxe"; break;
        case  19: sItem = "Amulet"; break;
        case  20: sItem = "Arrow"; break;
        case  21: sItem = "Belt"; break;
        case  22: sItem = "Dagger"; break;
        case  25: sItem = "Bolt"; break;
        case  26: sItem = "Boots"; break;
        case  27: sItem = "Bullet"; break;
        case  28: sItem = "Club"; break;
        case  31: sItem = "Dart"; break;
        case  32: sItem = "Dire Mace"; break;
        case  33: sItem = "Double Axe"; break;
        case  35: sItem = "Heavy Flail"; break;
        case  36: sItem = "Gloves"; break;
        case  37: sItem = "Light Hammer"; break;
        case  38: sItem = "Handaxe"; break;
        case  40: sItem = "Kama"; break;
        case  41: sItem = "Katana"; break;
        case  42: sItem = "Kukri"; break;
        case  44: sItem = "Rod"; break;
        case  45: sItem = "Staff"; break;
        case  46: sItem = "Wand"; break;
        case  47: sItem = "Morningstar"; break;
        case  50: sItem = "Quarterstaff"; break;
        case  51: sItem = "Rapier"; break;
        case  52: sItem = "Ring"; break;
        case  53: sItem = "Scimitar"; break;
        case  55: sItem = "Scythe"; break;
        case  56: sItem = "Large Shield"; break;
        case  57: sItem = "Tower Shield"; break;
        case  58: sItem = "Spear"; break;
        case  59: sItem = "Shuriken"; break;
        case  60: sItem = "Sickle"; break;
        case  61: sItem = "Sling"; break;
        case  63: sItem = "Throwing axe"; break;
        case  77: sItem = "Gem"; break;
        case  78: sItem = "Bracer"; break;
        case  80: sItem = "Cloak"; break;
        case  95: sItem = "Trident"; break;
        case  108: sItem = "Waraxe"; break;
        case  111: sItem = "Whip"; break;
    }

    return sItem;
}


string GetBaseItemResRef( int nIndex ){

    switch ( nIndex ) {

        case    1: return "nw_cloth022"; break;
        case    2: return "nw_aarcl001"; break;
        case    3: return "nw_aarcl002"; break;
        case    4: return "nw_aarcl003"; break;
        case    5: return "nw_aarcl004"; break;
        case    6: return "nw_aarcl005"; break;
        case    7: return "nw_aarcl006"; break;
        case    8: return "nw_aarcl007"; break;
        case    9: return "nw_aarcl008"; break;
        case   10: return "nw_aarcl009"; break;
        case   11: return "nw_aarcl010"; break;
        case   12: return "nw_aarcl011"; break;
        case   13: return "nw_aarcl012"; break;
        case   14: return "nw_arhe002"; break;
        case   15: return "nw_ashlw001"; break;
        case   16: return "nw_ashsw001"; break;
        case   17: return "nw_ashto001"; break;
        case   18: return ""; break;
        case   19: return ""; break;
        case   20: return "nw_waxbt001"; break;
        case   21: return "nw_waxgr001"; break;
        case   22: return "nw_waxhn001"; break;
        case   23: return "nw_wblcl001"; break;
        case   24: return "nw_wblfh001"; break;
        case   25: return "nw_wblfl001"; break;
        case   26: return "nw_wblhl001"; break;
        case   27: return "nw_wblhw001"; break;
        case   28: return "nw_wblml001"; break;
        case   29: return "nw_wblms001"; break;
        case   30: return "nw_wdbax001"; break;
        case   31: return "nw_wdbma001"; break;
        case   32: return "nw_wdbqs001"; break;
        case   33: return "nw_wdbsw001"; break;
        case   34: return "nw_wplhb001"; break;
        case   35: return "nw_wplsc001"; break;
        case   36: return "nw_wplss001"; break;
        case   37: return "nw_wspka001"; break;
        case   38: return "nw_wspku001"; break;
        case   39: return "nw_wspsc001"; break;
        case   40: return "nw_wswbs001"; break;
        case   41: return "nw_wswdg001"; break;
        case   42: return "nw_wswgs001"; break;
        case   43: return "nw_wswka001"; break;
        case   44: return "nw_wswls001"; break;
        case   45: return "nw_wswrp001"; break;
        case   46: return "nw_wswsc001"; break;
        case   47: return "nw_wswss001"; break;
        case   48: return "x2_it_wpwhip"; break;
        case   49: return "x2_wdwraxe001"; break;
        case   50: return ""; break;
        case   51: return ""; break;
        case   52: return ""; break;
        case   53: return ""; break;
        case   54: return ""; break;
        case   55: return ""; break;
        case   56: return ""; break;
        case   57: return ""; break;
        case   58: return ""; break;
        case   59: return ""; break;
        case   60: return "nw_wbwxl001"; break;
        case   61: return "nw_wbwxh001"; break;
        case   62: return "nw_wbwln001"; break;
        case   63: return "nw_wbwsh001"; break;
        case   64: return "nw_wbwsl001"; break;
        case   65: return "nw_wbwxr001"; break;
        case   66: return ""; break;
        case   67: return ""; break;
        case   68: return ""; break;
        case   69: return ""; break;
        case   70: return "nw_wamar001"; break;
        case   71: return "nw_wambo001"; break;
        case   72: return "nw_wambu001"; break;
        case   73: return ""; break;
        case   74: return ""; break;
        case   75: return ""; break;
        case   76: return ""; break;
        case   77: return ""; break;
        case   78: return ""; break;
        case   79: return ""; break;
        case   80: return "nw_wthax001"; break;
        case   81: return "nw_wthdt001"; break;
        case   82: return "nw_wthsh001"; break;
        case   83: return ""; break;
        case   84: return ""; break;
        case   85: return ""; break;
        case   86: return ""; break;
        case   87: return ""; break;
        case   88: return ""; break;
        case   89: return ""; break;
        case   90: return ""; break;
        case   91: return ""; break;
        case   92: return ""; break;
        case   93: return ""; break;
        case   94: return ""; break;
        case   95: return "nw_wpltr001"; break;
        case   96: return ""; break;
        case   97: return ""; break;
        case   98: return ""; break;
        case   99: return ""; break;
        case  100: return ""; break;
    }

    return "";
}

string CreateRandomTag( ){

    return "rnd_"+IntToString( GetTimeMillisecond() )+"_"+IntToString( Random(10) )+IntToString( Random(10) )+IntToString( Random(10) );
}


string AddSpellToItem( object oItem, int nLevel, int nTable=0, int nUses=IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE ){

    itemproperty ipCastSpell;
    int nIpSpell;
    string sName;

    if ( nTable == 1 ){

        switch( d12() ){

            case  1: nIpSpell= 015; sName = "Strength"; break;
            case  2: nIpSpell= 095; sName = "Endurance"; break;
            case  3: nIpSpell= 025; sName = "Grace"; break;
            case  4: nIpSpell= 291; sName = "Wisdom"; break;
            case  5: nIpSpell= 294; sName = "Cunning"; break;
            case  6: nIpSpell= 288; sName = "Splendor"; break;
            case  7: nIpSpell= 201; sName = "Defense"; break;
            case  8: nIpSpell= 043; sName = "Altered Senses"; break;
            case  9: nIpSpell= 063; sName = "Medication"; break;
            case 10: nIpSpell= 072; sName = "Medication"; break;
            case 11: nIpSpell= 192; sName = "the Ghost"; break;
            case 12: nIpSpell= 005; sName = "Barkskin"; break;
        }

        nIpSpell += ( nLevel / 2 );
    }
    else if ( nTable == 2 ){

        switch( d12() ){

            case  1: nIpSpell= 002; sName = "the Dead"; break;
            case  2: nIpSpell= 110; sName = "Flames"; break;
            case  3: nIpSpell= 184; sName = "Acid"; break;
            case  4: nIpSpell= 172; sName = "Missiles"; break;
            case  5: nIpSpell= 364; sName = "Pain"; break;
            case  6: nIpSpell= 008; sName = "Spiky Things"; break;
            case  7: nIpSpell= 049; sName = "Defense"; break;
            case  8: nIpSpell= 254; sName = "Desperate Measures"; break;
            case  9: nIpSpell= 133; sName = "Retribution"; break;
            case 10: nIpSpell= 115; sName = "Flames"; break;
            case 11: nIpSpell= 151; sName = "Invisibility"; break;
            case 12: nIpSpell= 172; sName = "Missiles"; break;
        }

        nIpSpell += ( nLevel / 2 );
    }
    else{

        if ( nLevel == 0 ){

            switch( d10() ){

                case  1: nIpSpell= 163; sName = "Light"; break;
                case  2: nIpSpell= 068; sName = "Healing"; break;
                case  3: nIpSpell= 236; sName = "Resistance"; break;
                case  4: nIpSpell= 076; sName = "Daze"; break;
                case  5: nIpSpell= 278; sName = "Virtue"; break;
                case  6: nIpSpell= 362; sName = "Pain"; break;
                case  7: nIpSpell= 347; sName = "Flare"; break;
                case  8: nIpSpell= 228; sName = "Frost"; break;
                case  9: nIpSpell= 355; sName = "Acid"; break;
                case 10: nIpSpell= 370; sName = "Shocks"; break;
            }
        }
        else if ( nLevel == 1 ){

            switch( d10() ){

                case  1: nIpSpell= 001; sName = "Aid"; break;
                case  2: nIpSpell= 011; sName = "Bless"; break;
                case  3: nIpSpell= 381; sName = "Faith"; break;
                case  4: nIpSpell= 345; sName = "the Divine"; break;
                case  5: nIpSpell= 252; sName = "Sleep"; break;
                case  6: nIpSpell= 108; sName = "Fire"; break;
                case  7: nIpSpell= 020; sName = "Lightning"; break;
                case  8: nIpSpell= 352; sName = "Camouflage"; break;
                case  9: nIpSpell= 075; sName = "Darkness"; break;
                case 10: nIpSpell= 387; sName = "Fleeing"; break;
            }
        }
        else if ( nLevel == 2 ){

            switch( d10() ){

                case  1: nIpSpell= 266; sName = "Summoning"; break;
                case  2: nIpSpell= 046; sName = "Clarity"; break;
                case  3: nIpSpell= 143; sName = "Holding"; break;
                case  4: nIpSpell= 286; sName = "Protection"; break;
                case  5: nIpSpell= 231; sName = "Curing"; break;
                case  6: nIpSpell= 328; sName = "Cunning"; break;
                case  7: nIpSpell= 514; sName = "Fire"; break;
                case  8: nIpSpell= 348; sName = "Shield"; break;
                case  9: nIpSpell= 208; sName = "Change"; break;
                case 10: nIpSpell= 463; sName = "Regeneration"; break;
            }
        }
        else if ( nLevel == 3 ){

            switch( d10() ){

                case  1: nIpSpell= 260; sName = "Stoneskin"; break;
                case  2: nIpSpell= 373; sName = "Amplify"; break;
                case  3: nIpSpell= 389; sName = "Displacement"; break;
                case  4: nIpSpell= 326; sName = "Lore"; break;
                case  5: nIpSpell= 118; sName = "Freedom"; break;
                case  6: nIpSpell= 539; sName = "Spheres"; break;
                case  7: nIpSpell= 138; sName = "Haste"; break;
                case  8: nIpSpell= 053; sName = "Confusion"; break;
                case  9: nIpSpell= 141; sName = "Healing"; break;
                case 10: nIpSpell= 315; sName = "Bursts"; break;
            }
        }
        else if ( nLevel == 4 ){

            switch( d10() ){

                case  1: nIpSpell= 361; sName = "Banishment"; break;
                case  2: nIpSpell= 157; sName = "Mindblank"; break;
                case  3: nIpSpell= 124; sName = "Dispelling"; break;
                case  4: nIpSpell= 358; sName = "Sunburst"; break;
                case  5: nIpSpell= 357; sName = "Earthquake"; break;
                case  6: nIpSpell= 224; sName = "Protection"; break;
                case  7: nIpSpell= 195; sName = "the Shade"; break;
                case  8: nIpSpell= 311; sName = "Buffing"; break;
                case  9: nIpSpell= 030; sName = "Lightning"; break;
                case 10: nIpSpell= 080; sName = "Fire"; break;
            }
        }
        else if ( nLevel == 5 ){

            switch( d10() ){

                case  1: nIpSpell= 392; sName = "Grasping"; break;
                case  2: nIpSpell= 212; sName = "Premonition"; break;
                case  3: nIpSpell= 161; sName = "Protection"; break;
                case  4: nIpSpell= 309; sName = "Wilting"; break;
                case  5: nIpSpell= 375; sName = "Life"; break;
                case  6: nIpSpell= 182; sName = "Speed"; break;
                case  7: nIpSpell= 139; sName = "Heal"; break;
                case  8: nIpSpell= 247; sName = "Shapes"; break;
                case  9: nIpSpell= 360; sName = "Glory"; break;
                case 10: nIpSpell= 121; sName = "Invulnerability"; break;
            }
        }
    }

    ipCastSpell = ItemPropertyCastSpell( nIpSpell, nUses );

    IPSafeAddItemProperty( oItem, ipCastSpell, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );

    return sName;
}

object CreateObjectFromTemplate( object oStore, string sItem, int nIndex, int nModel, int nMaxValue, int nSetValue=0  ){

    object oTemplates = GetLocalObject( oStore, "ds_j_templates" );
    object oReturn;
    object oDestroy1;
    object oDestroy2;
    int nValue = nSetValue;

    if ( !nValue ){

        nValue = RandomNumber( nMaxValue, 1 );
    }

    if ( !GetIsObjectValid( oTemplates ) ){

        oTemplates = GetObjectByTag( "ds_j_templates" );

        SetLocalObject( oStore, "ds_j_templates", oTemplates );
    }

    oDestroy1 = CreateItemOnObject( sItem, oTemplates );

    oDestroy2 = CopyItemAndModify( oDestroy1, nIndex, nModel, nValue );

    oReturn = CopyItem( oDestroy2, oStore );

    DestroyObject( oDestroy1, 0.3 );
    DestroyObject( oDestroy2, 0.5 );

    return oReturn;
}

