/*  ds_pirate_fire

--------
Verbatim
--------
Ignites grain sack on impact, opens gate and removes fire after 60 secs.

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
09-4-06  Disco       Start of header
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main() {

    //block status
    int nBlock = GetLocalInt( OBJECT_SELF, "nBlock");

    if (nBlock == 0) {

        if(GetDamageDealtByType(DAMAGE_TYPE_FIRE) >= 1) {

            //variables
            object oDoor         = GetObjectByTag("ds_pirate_gate");
            object oSpawnpoint   = GetObjectByTag("ds_spawn_pirates1");
            object oFire;
            location lSpawnpoint = GetLocation( oSpawnpoint );

            //apply block
            SetLocalInt( OBJECT_SELF, "nBlock", 1);

            //ignite sack
            oFire = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_flamelarge", GetLocation(OBJECT_SELF), TRUE, "ds_pirate_fire" );

            //spawn pirates
            object oFirstMate = CreateObject(OBJECT_TYPE_CREATURE, "al_dpfirstmate", lSpawnpoint, TRUE );
            CreateObject(OBJECT_TYPE_CREATURE, "al_dpduelist", lSpawnpoint, TRUE );
            CreateObject(OBJECT_TYPE_CREATURE, "al_dpfirestarter", lSpawnpoint, TRUE );
            CreateItemOnObject( "hor_p_island_key", oFirstMate );

            //open gate in 10 secs
            DelayCommand( 9.0, AssignCommand( oDoor, ActionUnlockObject( oDoor ) ) );
            DelayCommand( 10.0, AssignCommand( oDoor, ActionOpenDoor( oDoor ) ) );

            //delete fire in 40 secs
            DelayCommand( 40.0,DestroyObject( oFire, 0.0 ) );

            //close & lock gate in 180 secs
            DelayCommand( 120.0, AssignCommand( oDoor, ActionCloseDoor( oDoor ) ) );
            DelayCommand( 180.0, AssignCommand( oDoor, ActionLockObject( oDoor ) ) );

            //unblock bags
            DelayCommand( 200.0, SetLocalInt( OBJECT_SELF, "nBlock", 0) );

        }
    }
    else{

        return;

    }

}

