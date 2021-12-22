// Default user-defined events of an area.  Handles PC count.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/10/2004 jpavelch         Initial Release.
// 20050130   jking            Made easier to hook.
//

#include "area_constants"

void main( )
{
    // If you make your own User Defined events then be sure
    // to call this next function at the end of your script so
    // it can handle the basic player counting and despawning
    // mechanism.

    AreaHandleUserDefinedEventDefault(GetUserDefinedEventNumber());
}


