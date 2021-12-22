/*  Random loot script

    --------
    Verbatim
    --------
    Fills the inventory of a chest with dynamically generated armour and weapons.
    Spawns loot at waypoints ds_treasure and creates traps

    ---------
    Changelog
    ---------
    Date              Name        Reason
    ------------------------------------------------------------------
    10-02-2006        disco       start of header
    ------------------------------------------------------------------
*/
#include "nw_o2_coninclude"
#include "nw_i0_generic"
#include "ds_inc_randstore"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void CreateStandardLoot( object oChest, object oPC );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oChest    = GetNearestObjectByTag( "ds_treasure_chest", OBJECT_SELF, 1 );

    //spawn new loot if there's no more than two chests in the maze
    if ( oChest == OBJECT_INVALID ){

        object oWaypoint    = GetNearestObjectByTag( "ds_treasure", OBJECT_SELF, d10() );
        location lWaypoint  = GenerateNewLocationFromLocation( GetLocation( oWaypoint ), 1.0, IntToFloat( Random( 360 ) ), IntToFloat( Random( 360 ) ));
        string sTreasure    = "ds_treasure_" + IntToString( d3() );
        oChest              = CreateObject( OBJECT_TYPE_PLACEABLE, sTreasure, lWaypoint );

        InjectIntoChest( oChest, 2, 2 );
        CreateStandardLoot( oChest, GetEnteringObject() );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------



void CreateStandardLoot( object oChest, object oPC){

    int i;
    int nRandom;

    for ( i=0; i<d3(); ++i ){

        nRandom = d6();

        switch ( nRandom ){

            case 1: CreateGem( oChest, oPC, 1, 1 );     break;
            case 2: CreateGold( oChest, oPC, 1, 1 );    break;
            case 3: CreateBook( oChest );               break;
            case 4: CreateLockPick( oChest, oPC, 1 );   break;
            case 5: CreateTrapKit( oChest, oPC, 1 );    break;
            case 6: CreateJunk( oChest );               break;
        }
    }
}


