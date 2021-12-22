//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"



void check_area( object oPC, object oArea ){

    object oObject           = GetFirstObjectInArea( oArea );
    int nCreatures           = 0;
    int nPlotCreatures       = 0;
    int nPlaceables          = 0;
    int nUsePlaceables       = 0;
    int nLockPlaceables      = 0;
    int nItems               = 0;
    int nShops               = 0;
    string sShops            = "";

    while ( GetIsObjectValid( oObject ) ){

        if ( GetObjectType( oObject ) == OBJECT_TYPE_CREATURE && !GetIsPC( oObject ) ){

            ++nCreatures;

            if ( GetPlotFlag( oObject ) == TRUE || GetImmortal( oObject ) ){

                ++nPlotCreatures;
            }
        }
        else if ( GetObjectType( oObject ) == OBJECT_TYPE_PLACEABLE ){

            ++nPlaceables;

            if ( GetUseableFlag( oObject ) == TRUE ){

                ++nUsePlaceables;
            }
            if ( GetUseableFlag( oObject ) == TRUE && GetLockLockable( oObject ) == TRUE ){

                ++nLockPlaceables;
            }
        }
        else if ( GetObjectType( oObject ) == OBJECT_TYPE_ITEM ){

            ++nItems;
        }
        else if ( GetObjectType( oObject ) == OBJECT_TYPE_STORE ){

            ++nShops;
            sShops = sShops+","+GetTag( oObject );
        }

        oObject = GetNextObjectInArea( oArea );
    }

    PrintString( GetName( oArea )+";"+GetResRef(oArea)+";"
                                     +IntToString(GetAreaSize(AREA_WIDTH,oArea) )+";"
                                     +IntToString(GetAreaSize(AREA_HEIGHT,oArea) )+";"
                                     +IntToString(nCreatures)+";"
                                     +IntToString(nPlotCreatures)+";"
                                     +IntToString(nPlaceables)+";"
                                     +IntToString(nUsePlaceables)+";"
                                     +IntToString(nLockPlaceables)+";"
                                     +IntToString(nItems)+";"
                                     +IntToString(nShops)+";"
                                     +sShops );
}


void main(){

    object oAreaList = GetCache( "ds_area_storage" );
    object oPC = GetPCSpeaker();
    object oArea;
    float fDelay;
    int nAreas = GetLocalInt( oAreaList, "ds_count" );
    int i=0;

    SendMessageToPC( oPC, "Starting area check..." );

    PrintString( "Area;ResRef;Width;Height;NPCs;(plot);PLCs;(usable);(lockable);Items;Shops" );

    for ( i=1; i<=nAreas; ++i ){

        oArea   = GetNthArea( i, oAreaList );

        fDelay = 3.0 + i/10.0;

        DelayCommand( fDelay, check_area( oPC, oArea ) );
    }

    SendMessageToPC( oPC, "Areas checked = "+IntToString( i ) );
}
