/////////////////////////////////////////////////////////////////////////////////////////////////
//This script it to add the wolf lycan feat to the player and set variables from a conversation//
//                                                                                             //
//created by Frozen-ass                                                                        //
//date: 28-06-2022                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////

#include "inc_ds_records"
#include "nwnx_creature"


void main( )
{
    object oPC     = GetPCSpeaker( );
    object oTarget = GetObjectByTag("ds_pckey");

    DelayCommand( 1.0, NWNX_Creature_AddFeat( oPC, 1249) );
    SetLocalInt(oTarget, "lycanapproved", 1);
    SetLocalInt(oPC, "Prereq_Lycan", 1);
    SendMessageToPC( oPC, "Werewolf affliction has been added to your feat list." );
}
