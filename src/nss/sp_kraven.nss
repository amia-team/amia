// OnSpawn event of Kraven the Master.  Creates his phylactery and makes
// him plot to start.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/02/2004 jpavelch         Initial release.
//

#include "logger"

void main( )
{
    object oKraven = OBJECT_SELF;

    // Execute default OnSpawn script.
    ExecuteScript("ds_ai2_spawn", OBJECT_SELF);

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD),
        GetLocation(oKraven)
    );

    object oSacrophagus = GetNearestObjectByTag( "KravenSacrophagus" );
    if ( GetIsObjectValid(oSacrophagus) ) {
        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION),
            GetLocation(oSacrophagus)
        );
        DestroyObject( oSacrophagus );
    }

    object oWaypoint = GetNearestObjectByTag( "wp_kravensacrophagus" );
    if ( !GetIsObjectValid(oWaypoint) ) {
        LogError( "sp_kraven", "Could not find waypoint for Kraven's sacrophagus!" );
        return;
    }

    oSacrophagus = CreateObject(
                      OBJECT_TYPE_PLACEABLE,
                      "kravesacrophagus",
                      GetLocation(oWaypoint)
                  );
    if ( !GetIsObjectValid(oSacrophagus) ) {
        LogError( "sp_kraven", "Could not create Kraven's sacrophagus!" );
        return;
    }

    SetLocalObject( oSacrophagus, "Kraven", oKraven );
    SetPlotFlag( oKraven, TRUE );
}
