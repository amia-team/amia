#include "amia_include"

void main(){

    object oPC      = GetLastClosedBy();
    object oItem;
    string sTag     = GetTag( OBJECT_SELF );

    if ( sTag == "oc_right_socket" ){

        oItem = GetItemPossessedBy( OBJECT_SELF, "oc_right_eye" );

        if ( GetIsObjectValid( oItem ) && GetIsBlocked() < 1 ){

            FloatingTextStringOnCreature( "The eye smoothly slips into the socket.", oPC );

            location lWaypoint = GetLocation( GetWaypointByTag( "oc_spawn_ghost" ) );

            ds_spawn_critter( oPC, "oc_ds_ghost", lWaypoint, TRUE );

            SetBlockTime();
        }
        else{

            FloatingTextStringOnCreature( "You can add an eye once every 5 minutes.", oPC );
        }
    }
    else if ( sTag == "oc_left_socket" ){

        oItem = GetItemPossessedBy( OBJECT_SELF, "oc_left_eye" );

        if ( GetIsObjectValid( oItem ) ){

            FloatingTextStringOnCreature( "The eye smoothly slips into the socket.", oPC );
        }
    }
    else if ( sTag == "ds_shisha" ){

        oItem = GetItemPossessedBy( OBJECT_SELF, "ds_tobacco" );

        if ( GetIsObjectValid( oItem ) ){

            FloatingTextStringOnCreature( "*fills the shisha with "+GetName( oItem )+"*", oPC );
            DestroyObject( oItem );

            effect eSmoke = EffectVisualEffect( VFX_DUR_GHOST_SMOKE );
            effect eBubbles = EffectVisualEffect( VFX_DUR_BUBBLES );

            DelayCommand( 10.0, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSmoke, GetLocation( OBJECT_SELF ), 60.0 ) );
            DelayCommand( 10.0, FloatingTextStringOnCreature( "*starts smoking*", oPC ) );
        }
    }
}
