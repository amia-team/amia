#include "inc_ds_records"

void main()
{
    object oPC     = OBJECT_SELF;
    string sArea    = GetResRef( GetArea( oPC ) );
    string sFactionID = sArea+"faction";


    string sQuery = "DELETE FROM faction_furniture WHERE faction_id='"+sFactionID+"'";

    SQLExecDirect( sQuery );


    string sQuery2 = "DELETE FROM faction_house WHERE faction_id='"+sFactionID+"'";

    SQLExecDirect( sQuery2 );
}
