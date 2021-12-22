#include "inc_lua"

void BackToBaseTree( object oPC ){

    object oTarget = GetLocalObject( oPC, "ds_target" );

    SetCustomToken( 64710, GetName( oTarget ) + " [" + ObjectToString( oTarget ) + "] " + GetPCPlayerName( oTarget ) );
    SetLocalInt( oPC, "ds_tree", 0 );
    ActionPauseConversation();
    DelayCommand( 0.1, ActionResumeConversation() );
}

string GetVoicesetName( int nVoice ){

    return GetStringByStrRef( StringToInt( Get2DAString( "soundset", "STRREF", nVoice ) ) );
}

string GetMovementRateStr( object oPC ){

    int nRate = GetLocalInt( oPC, "pcmod_rate" );
    DeleteLocalInt( oPC, "pcmod_rate" );

    switch( nRate ){

        case 0: return "PC Speed";
        case 1: return "Immobile";
        case 2: return "Very Slow";
        case 3: return "Slow";
        case 4: return "Normal";
        case 5: return "Fast";
        case 6: return "Very Fast";
        case 7: return "Default";
        case 8: return "DM Speed";
        default: break;
    }
    return "Invalid";
}

void main(){

    object oPC = OBJECT_SELF;
    object oTarget = GetLocalObject( oPC, "ds_target" );

    int nNode = GetLocalInt( oPC, "ds_node" );
    int nTree = GetLocalInt( oPC, "ds_tree" );

    if( nTree <= 0 ){

        switch( nNode ){

            case 1:{
                SendMessageToPC( oPC, ExecuteLuaString( oPC, "nwn.SetLocalString( OBJECT_SELF, 'pcmod_fname', nwn.SetGetName( '"+ObjectToString( oTarget )+"', 0 ) );nwn.SetLocalString( OBJECT_SELF, 'pcmod_lname', nwn.SetGetName( '"+ObjectToString( oTarget )+"', 1 ) );" ) );
                SetCustomToken( 64711, GetLocalString( oPC, "pcmod_fname" ) );
                SetCustomToken( 64712, GetLocalString( oPC, "pcmod_lname" ) );
                DeleteLocalString( oPC, "pcmod_fname" );
                DeleteLocalString( oPC, "pcmod_lname" );
                SetLocalInt( oPC, "ds_tree", 1 );
                break;
            }

            case 2:{

                SendMessageToPC( oPC, "Desc: "+GetDescription( oTarget, TRUE, TRUE ) );
                SetLocalInt( oPC, "ds_tree", 2 );
                break;
            }

            case 3:{

                SetCustomToken( 64713, GetPortraitResRef( oTarget ) );
                SetLocalInt( oPC, "ds_tree", 3 );
                break;
            }

            case 4:{
                SendMessageToPC( oPC, ExecuteLuaString( oPC, "nwn.SetLocalInt( OBJECT_SELF, 'pcmod_voice', nwn.SetGetVoiceSet( '"+ObjectToString( oTarget )+"' ) );" ) );
                SetCustomToken( 64714, IntToString( GetLocalInt( oPC, "pcmod_voice" ) )+": "+GetVoicesetName( GetLocalInt( oPC, "pcmod_voice" ) ) );
                DeleteLocalInt( oPC, "pcmod_voice" );
                SetLocalInt( oPC, "ds_tree", 4 );
                break;
            }
            case 5:{

                SendMessageToPC( oPC, ExecuteLuaString( oPC, "nwn.SetLocalInt( OBJECT_SELF, 'pcmod_rate', nwn.SetGetMovementRate( '"+ObjectToString( oTarget )+"' ) );" ) );
                SetCustomToken( 64715, GetMovementRateStr( oPC ) );
                SetLocalInt( oPC, "ds_tree", 5 );
                break;
            }
            case 6:{
                SendMessageToPC( oPC, "Turds:" );
                SendMessageToPC( oPC, ExecuteLuaString( oPC, "local acc = string.lower( [=["+GetPCPlayerName( oTarget )+"]=] ); local id,name = nwn.GetFirstNextTURD(1);while id ~= nil do if string.lower( name ) == acc then nwn.SendMSGToPC( OBJECT_SELF, name .. ' - ' .. id ); end id,name = nwn.GetFirstNextTURD(0); end" ) );
                SetLocalInt( oPC, "ds_tree", 6 );
                break;
            }
        }
        ActionPauseConversation();
        DelayCommand( 0.1, ActionResumeConversation() );
    }
    //Name
    else if( nTree == 1 ){

        if( nNode == 1 || nNode == 2){

            SendMessageToPC( oPC, ExecuteLuaString( oPC, "nwn.SetGetName( '"+ObjectToString( oTarget )+"', "+IntToString(nNode-1)+", [=["+GetLocalString( oPC, "last_chat" )+"]=] );" ) );
            if( nNode == 1 )
                SendMessageToPC( oPC, "Changed last name to: " + GetLocalString( oPC, "last_chat" ) );
            else
                SendMessageToPC( oPC, "Changed last name to: " + GetLocalString( oPC, "last_chat" ) );
        }

        BackToBaseTree( oPC );
    }
    //Desc
    else if( nTree == 2 ){

        if( nNode == 1 ){

            SendMessageToPC( oPC, ExecuteLuaString( oPC, "nwn.SetBaseDesc( '"+ObjectToString( oTarget )+"', [=["+GetDescription( oTarget )+"]=] )" ) );
            SendMessageToPC( oPC, "Copied modded desc unto base-desc" );
        }
        else if( nNode == 2 ){

            SendMessageToPC( oPC, ExecuteLuaString( oPC, "nwn.SetBaseDesc( '"+ObjectToString( oTarget )+"', '' )" ) );
            SendMessageToPC( oPC, "Cleared base-desc" );
        }
        else if( nNode == 3 ){

            SetLocalString( oPC, "save_desc_pcmod" ,GetDescription( oTarget ) );
            SendMessageToPC( oPC, "Saved desc: " + GetDescription( oTarget ) );
        }
        else if( nNode == 4 ){

            SendMessageToPC( oPC, ExecuteLuaString( oPC, "nwn.SetBaseDesc( '"+ObjectToString( oTarget )+"', [=["+GetLocalString( oPC, "save_desc_pcmod" )+"]=] )" ) );
            SendMessageToPC( oPC, "Set base-desc: " + GetDescription( oTarget, TRUE ) );
        }
        else if( nNode == 5 ){
            DeleteLocalString( oPC, "save_desc_pcmod" );
            SendMessageToPC( oPC, "Deleted saved desc" );
        }

        BackToBaseTree( oPC );
    }
    //Portrait
    else if( nTree == 3 ){

        if( nNode == 1 ){

            string sPortrait = GetLocalString( oPC, "last_chat" );
            SetPortraitResRef( oTarget, sPortrait );
            SendMessageToPC( oPC, "Changed portrait resref: " + sPortrait );
        }

        BackToBaseTree( oPC );
    }
    //Voiceset
    else if( nTree == 4 ){

        if( nNode == 1 ){

            int nVoice = StringToInt( GetLocalString( oPC, "last_chat" ) );
            SendMessageToPC( oPC, ExecuteLuaString( oPC, "nwn.SetGetVoiceSet( '"+ObjectToString( oTarget )+"', "+IntToString( nVoice )+" )" ) );
            SendMessageToPC( oPC, "Changed voiceset to: " + IntToString( nVoice ) );
        }

        BackToBaseTree( oPC );
    }
    //Speed
    else if( nTree == 5 ){

        BackToBaseTree( oPC );

        if( nNode == 40 ){
            return;
        }

        SendMessageToPC( oPC, ExecuteLuaString( oPC, "nwn.SetGetMovementRate( '"+ObjectToString( oTarget )+"', "+IntToString( nNode-1 )+" )" ) );
        SendMessageToPC( oPC, "Changed movementrate to: " + IntToString( nNode-1 ) );
    }
    //TURD
    else if( nTree == 6 ){

        if( nNode == 1 ){
            SendMessageToPC( oPC, ExecuteLuaString( oPC, "local acc = string.lower( [=["+GetPCPlayerName( oTarget )+"]=] ); local id,name = nwn.GetFirstNextTURD(1); while id ~= nil do if string.lower( name ) == acc then nwn.SendMSGToPC( OBJECT_SELF, name .. ' - ' .. id ); nwn.DeleteTURD( id ); id,name = nwn.GetFirstNextTURD(1);else id,name = nwn.GetFirstNextTURD(0); end end" ) );
            SendMessageToPC( oPC, "Cleared all turds!" );
        }
        BackToBaseTree( oPC );
    }
}
