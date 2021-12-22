// OnOpen event of Guantlet of Terror chest.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/14/2003 jpavelch         Initial Release.
//

// Casts Wail of the Banshee over self.
//
void main(){

    object oPC   = GetLastUsedBy( );
    string sName = GetName( OBJECT_SELF );

    if ( sName == "Magic Ball" ){

        if ( !GetLocalInt( OBJECT_SELF, "active" ) ){

            SetLocalInt( OBJECT_SELF, "active", 1 );

            ActionPlayAnimation (ANIMATION_PLACEABLE_ACTIVATE);

            ActionCastSpellAtLocation(
                SPELL_WAIL_OF_THE_BANSHEE,
                GetLocation(OBJECT_SELF),
                METAMAGIC_ANY,
                TRUE,
                PROJECTILE_PATH_TYPE_DEFAULT,
                TRUE
            );
        }
        else{

            ActionPlayAnimation (ANIMATION_PLACEABLE_DEACTIVATE);

            SetLocalInt( OBJECT_SELF, "active", 0 );
        }
    }
    else if ( sName == "Lever" ){

        if ( !GetIsPC(oPC) ) return;

        object oBall1 = GetObjectByTag( "fw_ball_1" );
        object oBall2 = GetObjectByTag( "fw_ball_2" );
        object oBall3 = GetObjectByTag( "fw_ball_3" );

        int nState1 = GetLocalInt( oBall1, "active" );
        int nState2 = GetLocalInt( oBall2, "active" );
        int nState3 = GetLocalInt( oBall3, "active" );

        if ( nState1 == 1 && nState2 == 1 && nState3 == 1 ) {

            FloatingTextStringOnCreature( "The lever works!", oPC );

            PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );

            DelayCommand( 0.5, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );

            object oDoor = GetObjectByTag( "GauntletExit" );

            AssignCommand( oDoor, ActionOpenDoor( oDoor ) );

            SetLocalInt( oBall1, "active", 0 );
            SetLocalInt( oBall2, "active", 0 );
            SetLocalInt( oBall3, "active", 0 );

            AssignCommand( oBall1, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
            AssignCommand( oBall2, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
            AssignCommand( oBall3, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
        }
        else {

            FloatingTextStringOnCreature( "This lever doesn't work. Maybe you need to do unlock it?", oPC );
        }
    }
}

