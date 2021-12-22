//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  udb_corridor_act
//group:   travel
//used as: action script for convo
//date:    jan 17 2009
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void JumpPartyMembers( object oPC, object oTarget, object oJumpTo, int nKill=0 ){

    object oPartyMember = GetFirstFactionMember( oPC, FALSE );
    effect eDamage = EffectDamage( 1000, DAMAGE_TYPE_BLUDGEONING );
    object oArea = GetArea( oPC );

    while ( GetIsObjectValid( oPartyMember ) ){

        if ( GetDistanceBetween( oTarget, oPartyMember ) < 10.0 && oArea == GetArea( oPartyMember ) ){

            AssignCommand( oPartyMember, ClearAllActions() );
            AssignCommand( oPartyMember, JumpToObject( oJumpTo ) );

            if ( nKill == 1 ){

                DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPartyMember ) );

                DelayCommand( 1.0, FloatingTextStringOnCreature( "The crane operator drops the cage when you are halfway the shaft. The result is both predictable and messy.", oPartyMember, FALSE ) );
            }
        }

        oPartyMember = GetNextFactionMember( oPC, FALSE );
    }
}


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oTarget   = GetLocalObject( oPC, "ds_target" );
    object oJumpTo   = GetLocalObject( oTarget, "wp" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    string sWP       = GetLocalString( oTarget, "wp" );

    if ( !GetIsObjectValid( oJumpTo ) ){

        oJumpTo = GetWaypointByTag( sWP );

        SetLocalObject( oTarget, "wp", oJumpTo );
    }

    if ( !GetIsObjectValid( oJumpTo ) ){

        SendMessageToPC( oPC, "Error: Can't find waypoint!" );
        return;
    }

    if ( nNode == 1 ){

        JumpPartyMembers( oPC, oTarget, oJumpTo );
    }
    else if ( nNode == 2 ){

        JumpPartyMembers( oPC, oTarget, oJumpTo, 1 );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


