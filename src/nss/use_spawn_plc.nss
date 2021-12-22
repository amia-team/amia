//also works for setting buried treasure

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "amia_include"



void main(){

    object oPLC;
    string sTarget      = GetLocalString( OBJECT_SELF, "target" );
    string sSpawnpoint  = GetLocalString( OBJECT_SELF, "spawnpoint" );
    string sResref      = GetLocalString( OBJECT_SELF, "resref" );

    oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResref, GetLocation( GetWaypointByTag( sSpawnpoint ) ), FALSE, sTarget );

            DestroyObject( oPLC, 60.0 );
    }
