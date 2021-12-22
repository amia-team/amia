//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ff_use
//group:   Frozenfar
//used as: OnUse
//date:    november 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "amia_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPLC = OBJECT_SELF;
    object oPC  = GetLastUsedBy();
    string sTag = GetTag( oPLC );

    if ( sTag == "ff_dw_statue" || sTag == "ff_dw_ancestor" ){

        if ( GetIsBlocked() ){

            SpeakString( "*gives you the granite eye*" );
            return;
        }

        SetBlockTime();

        clean_vars( oPC, 3 );

        SetLocalString( oPC, "ds_action", "ff_dw_statue_act" );
        SetLocalObject( oPC, "ds_target", OBJECT_SELF );

        ActionStartConversation( oPC, "ff_dw_statue" );
    }
    else if ( sTag == "ff_dw_meadlever" ){

        object oDoor = GetObjectByTag( "ff_dw_meaddoor" );

        AssignCommand( oDoor, PlayAnimation( ANIMATION_DOOR_OPEN2 ) );
        AssignCommand( oPLC, PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) );

        DelayCommand( 20.0, AssignCommand( oDoor, PlayAnimation( ANIMATION_DOOR_CLOSE ) ) );
        DelayCommand( 20.0, AssignCommand( oPLC, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) ) );
        DelayCommand( 20.0, SetLocked( oDoor, TRUE ) );

    }
}


