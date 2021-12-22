// User-defined events of lootable corpse.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/01/2003 jpavelch         Initial Release.
// 20050214   jking            Refactored into inc_loopcorpse
//

#include "inc_lootcorpse"

void main()
{
    int nEvent = GetUserDefinedEventNumber( );
    switch ( nEvent ) {
        case CORPSE_DESTROY:
            DestroyLootableCorpse( );
            break;
    }
}
