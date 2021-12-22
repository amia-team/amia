/*  ds_activate_door

--------
Verbatim
--------
Activates door PLC and jumps PC to WP with the same tag as the PLC

---------
Changelog
---------

Date        Name        Reason
------------------------------------------------------------------
2007-07-07  Disco       Start of header
2007-07-30  Disco       Added lock option
2015-07-14  Faded Wings Changed for instancing
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
#include "fw_include"

void EnterDoor(object oPC, object oDoor);

void main(){

    object oPC = GetLastUsedBy();
    object oDoor = OBJECT_SELF;

    if ( GetIsOpen( oDoor ) == FALSE ){

        if ( GetLocked( oDoor ) == TRUE ){

            return;
        }
        else{

            PlayAnimation(  ANIMATION_PLACEABLE_OPEN );

            DelayCommand( 12.0, PlayAnimation(  ANIMATION_PLACEABLE_CLOSE ) );

            if ( GetLockKeyTag( oDoor ) != "" ){

                DelayCommand( 13.0, SetLocked( oDoor, TRUE ) );
            }
        }
    }
    else{

        object oTarget = GetWaypointByTag( GetTag( oDoor ) );
        if(oTarget == OBJECT_INVALID)
        {
            fw_spawnInstance(oDoor);
            DelayCommand(1.0, EnterDoor(oPC, oDoor));
        }
        else
        {
            AssignCommand( oPC, JumpToObject( oTarget, 0 ) );
        }
    }

}

void EnterDoor(object oPC, object oDoor)
{
    object oTarget = GetWaypointByTag( GetTag( oDoor ) );
    AssignCommand( oPC, JumpToObject( oTarget, 0 ) );
}
