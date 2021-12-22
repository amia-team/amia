void main(){

    object oSpeaker = GetLastSpeaker();
    object oPC;

    if ( GetIsDM( oSpeaker ) ){

        //DM takes over
        oPC = oSpeaker;
        SetLocalObject( OBJECT_SELF, "ds_master", oPC );
    }
    else{

        oPC = GetLocalObject( OBJECT_SELF, "ds_master" );
    }

    //make sure the speaker is the NPC's master
    if ( oSpeaker == oPC ){

        ClearAllActions( TRUE );

        //make convo available
        SetLocalInt( oPC, "ds_check_1", 1 );

        //make clothing options available
        if ( GetLocalInt( OBJECT_SELF, "ds_type" ) == 1 ){

            SetLocalInt( oPC, "ds_check_2", 1 );
        }
        else{

            SetLocalInt( oPC, "ds_check_2", 0 );
        }

        //set action script
        SetLocalString( oPC, "ds_action", "ds_npc_actions" );

        //set action target
        SetLocalObject( oPC, "ds_target", OBJECT_SELF );

        //run silent convo
        ActionStartConversation( oPC, "ds_npc_convo", TRUE, FALSE );
    }

}
