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
    05-23-2006        disco       start of header
    09-10-2006        disco      expansion with rings and amulets
    10-21-2006        disco      nerfed skills

    ------------------------------------------------------------------
*/

#include "x2_inc_itemprop"
#include "ds_inc_randstore"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    int nDelay = GetLocalInt( GetModule(), "randstore_ftime" );

    int nInterval;

    if ( nDelay != 0 ) nInterval = ( GetRunTime()/ nDelay ) + 1;
    else nInterval = 1;

    //this script fires once during each interval
    if( GetLocalInt( OBJECT_SELF, "SetBlock" ) != nInterval ){

        //block the creation process until next interval
        SetLocalInt( OBJECT_SELF, "SetBlock", nInterval );



        //these vars come from the store npc
        int nWeapons        = GetLocalInt( OBJECT_SELF, "Weapons" );
        int nArmour         = GetLocalInt( OBJECT_SELF, "Armour" );
        int nJewelry        = GetLocalInt( OBJECT_SELF, "Jewelry" );
        int nLevelBottom    = GetLocalInt( OBJECT_SELF, "LevelBottom" );
        int nLevelTop       = GetLocalInt( OBJECT_SELF, "LevelTop" );
        int nUnique         = GetLocalInt( OBJECT_SELF, "Unique" );
        string sWeaponType  = GetLocalString( OBJECT_SELF, "WeaponType" );
        string sArmourType  = GetLocalString( OBJECT_SELF, "ArmourType" );

        //variables
        int i;
        float fDelay;
        int nLevel;

        //get store
        object oStore    = GetNearestObjectByTag( "ds_random_store" );

        //create store if it isn't available yet or too far away
        //the latter allows for multiple stores in one area
        if ( oStore == OBJECT_INVALID || GetDistanceToObject( oStore ) > 1.0 ){

            oStore = CreateObject( OBJECT_TYPE_STORE, "ds_random_store",
                                   GetLocation(OBJECT_SELF), FALSE, "ds_random_store" );
        }

        //Clear out inventory from previous intervals
        object oClean;

        oClean = GetFirstItemInInventory( oStore );
        while ( GetIsObjectValid( oClean ) ){

            if ( GetLocalInt( oClean, "RSCln" ) ){

                DestroyObject( oClean );

            }


            oClean = GetNextItemInInventory( oStore );
        }


        for ( i=0; i<nWeapons; ++i ){

            fDelay = i/1.2;
            nLevel = nLevelBottom + RandomNumber( nLevelTop-nLevelBottom, 1 );
            DelayCommand( fDelay, CreateWeapon( oStore, nLevel, sWeaponType, nUnique ) );

        }
        for ( i=0; i<nArmour; ++i ){

            fDelay = i/2.1;
            nLevel = nLevelBottom + RandomNumber( nLevelTop-nLevelBottom, 1 );
            DelayCommand( fDelay, CreateArmour( oStore, nLevel, sArmourType, nUnique ) );

        }
        for ( i=0; i<nJewelry; ++i ){

            fDelay = i/1.7;
            nLevel = nLevelBottom + RandomNumber( nLevelTop-nLevelBottom, 1 );
            DelayCommand( fDelay, CreateJewelry( oStore, nLevel, nUnique ) );

        }
    }
}
