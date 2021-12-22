//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_searcher_act2
//group:   PC searcher widget
//used as: action script on second node
//date:    jan 10 2007
//author:  disco

//-----------------------------------------------------------------------------
// changes
//-----------------------------------------------------------------------------
//2007-05-14    disco   Rewrote the recommendation routines

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

// fires when you select a character
void JumpToDM( object oPC, int nNode );

// fires when you select a character
void JumpToCharacter( object oPC, int nNode );

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main(){

     object oPC         = GetPCSpeaker();
     int nNode          = GetLocalInt( oPC, "ds_node" );
     string sItemName   = GetLocalString( oPC, "ds_item" );

    //fire convo
    if ( sItemName == "Jump DM to Player" || sItemName == "DCrod" ){

        JumpToCharacter( oPC, nNode );
    }
    else{

        JumpToDM( oPC, nNode );
    }
}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------

// fires when you select a character
void JumpToDM( object oPC, int nNode ){

    //retrieve correct PC
    object oTarget = GetLocalObject( oPC, "ds_pc_"+IntToString( nNode ) );

    //set return point
    SetLocalLocation( oTarget, "ds_back", GetLocation( oTarget ) );

    //jump jump jump!
    AssignCommand( oTarget, JumpToObject( oPC ) );

}

// fires when you select a character
void JumpToCharacter( object oPC, int nNode ){

    //retrieve correct PC
    object oTarget = GetLocalObject( oPC, "ds_pc_"+IntToString( nNode ) );

    //set return point
    SetLocalLocation( oPC, "ds_back", GetLocation( oPC ) );

    //jump jump jump!
    AssignCommand( oPC, JumpToObject( oTarget ) );

    //tell about recommendations
    string sSuggested = GetLocalString( oTarget, "dc_recomm_pc" );

    if ( sSuggested != "" ){

        int nTime = ( GetRunTime() - GetLocalInt( oTarget, "dc_recomm_time" ) ) / 60;

        SendMessageToPC( oPC, GetName( oTarget )+" has been recommended by "+sSuggested+" "+IntToString( nTime )+" minutes ago." );
    }


}
