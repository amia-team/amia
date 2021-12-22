// OnClose event for a custom drop container.  Reinitializes the container
// in case something has been added and/or removed.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 08/29/2003 jpavelch         Initial Release.
//

#include "inc_ds_records"
#include "inc_ds_ondeath"


void main( )
{
    InitialiseLootBin( OBJECT_SELF, TRUE );

    object oDM = GetLastOpenedBy( );
    int nItems = GetLocalInt( OBJECT_SELF, LOOTBIN_COUNT );
    FloatingTextStringOnCreature(
        "Contains " + IntToString(nItems+1) + " items",
        oDM
    );

    if ( oDM != OBJECT_INVALID ){

        log_to_exploits( oDM, "opened lootbin", GetTag(OBJECT_SELF), nItems+1 );
    }

}
