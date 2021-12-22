// User-defined events for gauntlet shocker spawn trigger.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050130   jking            Hook into standard handler (end)

#include "area_constants"


void InitArea( )
{
    effect eVis = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );
           eVis = SupernaturalEffect( eVis );

    object oObject = GetFirstObjectInArea( OBJECT_SELF );
    while ( GetIsObjectValid(oObject) ) {
        ApplyEffectToObject(
            DURATION_TYPE_PERMANENT,
            eVis,
            oObject);
        oObject = GetNextObjectInArea( OBJECT_SELF );
    }
}

void main()
{
    int nEvent = GetUserDefinedEventNumber( );
    switch ( nEvent ) {
        case INITIALIZE:    InitArea( );  break;
        default:            AreaHandleUserDefinedEventDefault(nEvent); break;
    }
}
