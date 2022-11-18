// OnOpen event of Mechanized Lever and OnFailToOpen event of Mechanized Door
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/07/2022 Lord-Jyssev      Initial Release.
//

// Part of a trigger, door, and placeable set. This script goes on both the door
// and the lever to allow for levers to open the door.
//
void main(){

    if ( GetObjectType( OBJECT_SELF) == OBJECT_TYPE_PLACEABLE)
    {
    object oPC   = GetLastUsedBy( );

        if ( !GetLocalInt( OBJECT_SELF, "active" ) )
        {
            SetLocalInt( OBJECT_SELF, "active", 1 );
            ActionPlayAnimation (ANIMATION_PLACEABLE_ACTIVATE);
            FloatingTextStringOnCreature("The lever creates a mechanized grinding sound.", oPC);
            SendMessageToPC(oPC, "active="+IntToString(GetLocalInt( OBJECT_SELF, "active" )));
        }
        else
        {
            ActionPlayAnimation (ANIMATION_PLACEABLE_DEACTIVATE);
            SetLocalInt( OBJECT_SELF, "active", 0 );
            FloatingTextStringOnCreature("A mechanized grinding sound stops.", oPC);
            SendMessageToPC(oPC, "active="+IntToString(GetLocalInt( OBJECT_SELF, "active" )));
        }

    }

    else if ( GetObjectType( OBJECT_SELF) == OBJECT_TYPE_DOOR )
    {
    object oPC   = GetClickingObject( );

        SendMessageToPC(oPC, "Door found. Initializing.");
        if ( !GetIsPC(oPC) ){ return; }

        object oLever1 = GetObjectByTag( "lj_doorlever_1" );
        object oLever2 = GetObjectByTag( "lj_doorlever_2" );

        int nState1 = GetLocalInt( oLever1, "active" );
        int nState2 = GetLocalInt( oLever2, "active" );

        SendMessageToPC(oPC, "Lever 1 active="+IntToString(GetLocalInt( oLever1, "active" )));
        SendMessageToPC(oPC, "Lever 2 active="+IntToString(GetLocalInt( oLever2, "active" )));

        if ( nState1 == 1 && nState2 == 1 ) {

            FloatingTextStringOnCreature( "The door's mechanism clicks as it opens freely.", oPC );

            //PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );

            //DelayCommand( 0.5, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );

            object oDoor = GetObjectByTag( "lj_leverdoor" );

            AssignCommand( oDoor, ActionOpenDoor( oDoor ) );

            SetLocalInt( oLever1, "active", 0 );
            SetLocalInt( oLever2, "active", 0 );

            AssignCommand( oLever1, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
            AssignCommand( oLever2, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
        }
        else if( nState1 == 1 || nState2 == 1)
        {
            FloatingTextStringOnCreature( "A faint grinding sound is heard near this door. Maybe you need to find another lever to unlock it?", oPC );
        }
        else
        {
            FloatingTextStringOnCreature( "This door seems to be controlled by some manner of hidden mechanism. Maybe you need to unlock it?", oPC );
        }
    }
}

