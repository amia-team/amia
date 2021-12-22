//::///////////////////////////////////////////////
//:: Default: On Conversation
//:://////////////////////////////////////////////

// 2008-07-29 rerouted to ds_ai2

void main(){

    //just start normal convo if plot NPC
    if ( GetPlotFlag() ){

        ActionStartConversation( GetLastSpeaker() );
    }

    // reroute
    ExecuteScript( "ds_ai2_convo", OBJECT_SELF );

    return;

}
