/*
    OnDamaged script for Wall of Ice custom spell PLCs.
*/

#include "inc_dc_spells"

void main()
{
    object oWall = OBJECT_SELF;
    location lWall = GetLocation( oWall );
    int nCL = GetLocalInt( oWall, "CasterLevel" );
    float fDur = TurnsToSeconds( nCL / 5 );

    int nFire = GetDamageDealtByType( DAMAGE_TYPE_FIRE );

    //if dealt fire damage, deal double that damage instead (as magical so it doesn't re-trigger)
    if( nFire != -1 )
    {
        effect eDoubleDmg = EffectDamage( nFire, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDoubleDmg, oWall );

        //if it was killed when fire damage was dealt, generate mist
        int nHP = GetCurrentHitPoints( oWall );
        if( nHP <= 0 )
        {
            //if one Sphere PLC dies, they all do, but no aura from the others
            if( GetResRef( oWall ) == "pc_ice_sphere" )
            {
                string sSphereTag = GetTag( oWall );
                string sSphere = IntToString( GetLocalInt( oWall, "SphereNumber" ) );

                DestroyObject( GetNearestObjectByTag( "SphereFR_"+sSphere ), 1.0 );
                DestroyObject( GetNearestObjectByTag( "SphereBL_"+sSphere ), 1.0 );
                DestroyObject( GetNearestObjectByTag( "SphereFL_"+sSphere ), 1.0 );
                DestroyObject( GetNearestObjectByTag( "SphereBR_"+sSphere ), 1.0 );
            }
            CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "x3_plc_mist", lWall, FALSE, "", 600.0 );
            DelayCommand( 0.1, SetPlotFlag( GetNearestObjectByTag( "x3_plc_mist" ), TRUE ) );
        }
    }
    //otherwise leave a cold aura behind with the mist
    else
    {
        int nHP = GetCurrentHitPoints( oWall );
        if( nHP <= 0 )
        {
            //if one Sphere PLC dies, they all do, but no aura from the others
            if( GetResRef( oWall ) == "pc_ice_sphere" )
            {
                string sSphereTag = GetTag( oWall );
                string sSphere = IntToString( GetLocalInt( oWall, "SphereNumber" ) );

                DestroyObject( GetNearestObjectByTag( "SphereFR_"+sSphere ), 1.0 );
                DestroyObject( GetNearestObjectByTag( "SphereBL_"+sSphere ), 1.0 );
                DestroyObject( GetNearestObjectByTag( "SphereFL_"+sSphere ), 1.0 );
                DestroyObject( GetNearestObjectByTag( "SphereBR_"+sSphere ), 1.0 );
            }

            effect eCold = EffectAreaOfEffect( AOE_MOB_FROST, "glm_icewall_aura", "****", "****" );

            CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "x3_plc_mist", lWall, FALSE, "", fDur );
            DelayCommand( 0.1, SetPlotFlag( GetNearestObjectByTag( "x3_plc_mist" ), TRUE ) );
            DelayCommand( 0.2, SetLocalInt( GetNearestObjectByTag( "x3_plc_mist" ), "CasterLevel", nCL ) );
            DelayCommand( 0.3, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eCold, GetLocation( GetNearestObjectByTag( "x3_plc_mist" ) ), fDur ) );
        }
    }
}
