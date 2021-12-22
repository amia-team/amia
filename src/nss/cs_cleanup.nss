// OpenStore event to clean-up the store every sixth time it has been
// closed.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/01/2004 jpavelch         Initial release.
//

//#include "logger"

void main( )
{
    object oStore = OBJECT_SELF;

    int nCloseCount = GetLocalInt( oStore, "clc" ) + 1;

    if ( nCloseCount > 6 ) {
        //LogInfo( "cs_cleanup", "Cleaning store: " + GetTag(oStore) );

        int nItems      = 0;
        object oItem    = GetFirstItemInInventory( oStore );

        while ( GetIsObjectValid(oItem) && nItems < 6 ) {

            if ( GetLocalInt(oItem, "cln") ) {

                //LogInfo( "cs_cleanup", "  Destroying: " + GetName(oItem) );
                DestroyObject( oItem );
                ++nItems;
            }

            oItem = GetNextItemInInventory( oStore );
        }

        //LogInfo( "cln", "Done cleaning store" );
        nCloseCount = 0;
    }

    SetLocalInt( oStore, "clc", nCloseCount );
}

