// On demand script for starting the dm effects convo.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/24/2004 jpavelch         Initial release.
//


void main( )
{
    object oDM = OBJECT_SELF;

    SetLocalInt( oDM, "DME_Offset", 0 );
    SetLocalObject( oDM, "DME_Manager", GetObjectByTag("dme_effectsmanager") );
}
