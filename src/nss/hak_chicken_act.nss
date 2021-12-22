//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

void main()
{
    object oPC = GetPCSpeaker();

    GetHasUpdated( oPC, GetPCPublicCDKey( oPC, TRUE ), TRUE );
}
