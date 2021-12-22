// Script Name:     ms_tavernmu_int
// Use:             OnConversation
// Created by:      msheeler
// Created:         1/8/2016
// Edited:          2/24/2016 - called action script - msheeler

// includes
#include "inc_ds_actions"

// main

void main(){

    object oPC = GetLastSpeaker();

    //cleans out any nNode values left over
    clean_vars( oPC, 4, "ms_musician_act" );

    //SendMessageToPC ( oPC, "All Clean" );

    //run the convo
    ActionStartConversation( oPC, "", TRUE, FALSE );
}
