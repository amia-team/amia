#include "inc_ds_records"

void main()
{
    // Get the PC who is in this conversation.
    object oPC = GetPCSpeaker();

    // Set the PC's subrace.
    SetSubRace(oPC, "Shapechanger");
}

void SetReport( object oTarget, string sSubRace ){

    object oTarget = GetPCSpeaker();
    SetSubRace( oTarget, sSubRace );

    SetLocalInt( oTarget, "ds_subrace_activated", 0 );
    SetPCKEYValue( oTarget, "ds_subrace_activated", 0 );

    SendMessageToPC( oTarget, " - Subrace set to: "+sSubRace+" - " );
}

