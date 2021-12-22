//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_td_draconbook
//description: Initilazation script for the draconomicon book
//used as: item activation script
//date:    08/16/08
//author:  Terra

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "inc_ds_actions"

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main()
{

    // Get our bookman!
    object oPC          = GetItemActivator();

    // Clean all action, nodes and checks!
    clean_vars( oPC, 4 );

    // Set action script
    SetLocalString( oPC, "ds_action", "td_dragonbook" );

    // Does oPC have dragonshape ready?
    SetLocalInt( oPC , "ds_check_1", GetHasFeat( 873 , oPC ) );

    // Will you stay put just a second? Thanks!
    AssignCommand( oPC , ClearAllActions( ) );

    // And now start talking with the book, creepy!
    AssignCommand( oPC ,ActionStartConversation( oPC , "td_draconomicon", TRUE , FALSE ) );

    // Report what the PC has overriden
    string sRed     = GetLocalString( oPC ,"td_dragon_override_red_color" );
    string sGreen   = GetLocalString( oPC ,"td_dragon_override_green_color" );
    string sBlue    = GetLocalString( oPC ,"td_dragon_override_blue_color" );

    if( sRed != "" )SendMessageToPC(oPC, "Red dragonshape is currently overriden with: "+sRed+" dragon");
    if( sBlue != "" )SendMessageToPC(oPC, "Blue dragonshape is currently overriden with: "+sBlue+" dragon");
    if( sGreen != "" )SendMessageToPC(oPC, "Green dragonshape is currently overriden with: "+sGreen+" dragon");

}
