// Cleans-up local variables used during a generic conversation between a
// PC and a placeable object.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/22/2004 jpavelch         Initial release.
//

void main( )
{
    DeleteLocalObject( GetPCSpeaker(), "AR_Target" );
}

