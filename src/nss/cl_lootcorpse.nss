// OnClose event of lootable corpse.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/01/2003 jpavelch         Initial Release.
// 20050214   jking            Refactored constants.

#include "inc_userdefconst"


// Destroys self by sending user-defined event if corpse is empty.
//
void main()
{
    // Do not destroy self if someone has it open.
    if ( GetIsOpen(OBJECT_SELF) )
        return;

    // Do not destroy self if it is not empty.
    object oItem = GetFirstItemInInventory( OBJECT_SELF );
    if ( GetIsObjectValid(oItem) )
        return;

    // Destroy self.
    SignalEvent( OBJECT_SELF, EventUserDefined(CORPSE_DESTROY) );
}
