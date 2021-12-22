// OnAreaTransitionClick event of a door/trigger.  Restricts access to only
// the DM staff and DM 'helper' staff.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/01/2004 jpavelch         Initial Release.
//2007/09/29  disco            Caching system implemented
//

#include "inc_ds_records"

void main(){

    object oPC                  = GetClickingObject( );
    string szPublicCDKey        = GetPCPublicCDKey( oPC );
    string szAccount            = GetPCPlayerName( oPC );
    int nDMstatus               = GetDMStatus( szAccount, szPublicCDKey );

    if ( !GetIsPC( oPC ) ) {

        return;
    }

    if ( nDMstatus > 0 ) {

        object oDest = GetTransitionTarget( OBJECT_SELF );
        AssignCommand( oPC, ClearAllActions() );
        AssignCommand( oPC, JumpToObject(oDest) );
    }
    else {

        FloatingTextStringOnCreature( "An invisible force prevents you from entering.", oPC );
    }
}
