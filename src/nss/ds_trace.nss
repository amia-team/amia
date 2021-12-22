//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"



void main()
{

    object oPC = GetEnteringObject();

    log_exploit( oPC, GetArea( oPC ), "Enters area" );
}
