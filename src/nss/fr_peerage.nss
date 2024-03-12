/////////////////////////////////////////////////////////////////////////////////////////////////
//This script it to add the peerage feat to the player                                         //
//                                                                                             //
//created by Frozen-ass                                                                        //
//date: 28-06-2022                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////

#include "inc_ds_records"
#include "nwnx_creature"


void main( )
{
    object oPC     = GetPCSpeaker( );

    DelayCommand( 1.0, NWNX_Creature_AddFeat( oPC, 1255) );
    SendMessageToPC( oPC, "Peer has been added to your feat list." );
}
