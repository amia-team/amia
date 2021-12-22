#include "x2_inc_switches"
#include "inc_nwnx_events"
#include "inc_ds_records"
#include "nwnx_data"
#include "inc_td_sysdata"
#include "inc_lua"
#include "inc_ds_actions"
void main (){}
/*const string PATH = "G:/External/DM/";

int InsertObject( object oTarget, object oSaver, object oKeyItem );
string GetKey( object oKeyItem );
void DeleteStuff( object oKeyItem );
void Clean( object oPC, object oItem );
object SpawnStuff( object oKeyItem, object oPC, object oTarget, location lTarget );
void SetEverythingUndroppable( object oTarget, int noAI );
int GetHostile( object oKeyItem );
int GetHasAI( object oKeyItem );

//Main
void main(){

    object oPC;
    object oTarget;
    object oItem;
    location lTarget;
    int nEvent = GetUserDefinedItemEventNumber();

    //Vars
    if( nEvent == X2_ITEM_EVENT_ACTIVATE ){

        oPC     = GetItemActivator();
        oTarget = GetItemActivatedTarget();
        oItem   = GetItemActivated();
        lTarget = GetItemActivatedTargetLocation();
    }
    else if( nEvent == X2_ITEM_EVENT_INSTANT ){

        oPC     = OBJECT_SELF;
        oTarget = EVENTS_GetTarget(1);
        oItem   = EVENTS_GetTarget(0);
        lTarget = GetIsObjectValid( oTarget ) ? GetLocation( oTarget ) : EVENTS_GetTargetLocation(0);
        EVENTS_Bypass();
    }
    else
        return;

    //Auth
    if( GetDMStatus( GetPCPlayerName( oPC ), GetPCPublicCDKey( oPC ) ) <= 0 &&
        GetPCPlayerName( oPC ) != "Terra_777" ){

        DestroyObject( oItem );
        return;
    }

    if( oTarget == oItem ){
        DeleteStuff( oItem );
        SendMessageToPC( oPC, "Database record deleted, widget has been reset!" );
    }
    else if( GetKey( oItem ) == "" ){

        if( !GetIsObjectValid( oTarget ) || InsertObject( oTarget, oPC, oItem) == 0 ){

            SendMessageToPC( oPC, "Can't save this. You can only save items or creatures!" );
            return;
        }
    }
    else if( oTarget == oPC ){
        clean_vars( oPC, 4 );
        SetLocalString( oPC, "ds_action", "npc_save_action" );
        SetLocalObject( oPC, "ds_target", oItem );
        AssignCommand( oPC, ActionStartConversation( oPC, "npc_saver", TRUE, FALSE ) );
    }
    else{
        oTarget = SpawnStuff( oItem, oPC, oTarget, lTarget );
        if( GetIsObjectValid( oTarget ) ){
            SetEverythingUndroppable( oTarget, GetHasAI(oItem) );

            if(GetHostile(oItem)){

                SendMessageToPC( oPC, "Spawned hostile: " + PATH + GetKey( oItem ) );
                ChangeToStandardFaction(oTarget,STANDARD_FACTION_HOSTILE);
            }
            else{
                SendMessageToPC( oPC, "Spawned friendly: " + PATH + GetKey( oItem ) );
                ChangeToStandardFaction(oTarget,STANDARD_FACTION_COMMONER);
            }
        }
        else{
            SendMessageToPC( oPC, "Unable to open file: " + PATH + GetKey( oItem ) );
            DeleteStuff( oItem );
        }
    }
}

//object SpawnStuff( object oKeyItem, object oPC, object oTarget, location lTarget ){

    //string sKey = GetKey( oKeyItem );

    //string sFile = PATH + sKey;

    //object obj = DATA_GetFromFile( sFile, oTarget, lTarget );

    //return obj;
//}


void DeleteStuff( object oKeyItem ){

    string sKey = GetKey( oKeyItem );
    NWNX_DeleteFile( PATH + sKey );
    SetDescription( oKeyItem, "%", FALSE );
    SetDescription( oKeyItem );
    SetName( oKeyItem );
}

int GetHasAI( object oKeyItem ){

    string sDesc = GetDescription( oKeyItem, FALSE, TRUE );

    if( FindSubString( sDesc, "AI: " ) != -1 ){

        int nStart = FindSubString( sDesc, "AI: " )+4;
        int nEnd =  FindSubString( sDesc, "\n", nStart );
        sDesc = GetSubString( sDesc, nStart, nEnd-nStart );
        return sDesc=="YES";
    }

    return TRUE;
}

int GetHostile( object oKeyItem ){

    string sDesc = GetDescription( oKeyItem, FALSE, TRUE );

    if( FindSubString( sDesc, "HOSTILE: " ) != -1 ){

        int nStart = FindSubString( sDesc, "HOSTILE: " )+9;
        int nEnd =  FindSubString( sDesc, "\n", nStart );
        sDesc = GetSubString( sDesc, nStart, nEnd-nStart );
        return sDesc=="YES";
    }

    return TRUE;
}

string GetKey( object oKeyItem ){

    string sDesc = GetDescription( oKeyItem, FALSE, TRUE );

    if( FindSubString( sDesc, "KEY: " ) != -1 ){

        int nStart = FindSubString( sDesc, "KEY: " )+5;
        int nEnd =  FindSubString( sDesc, "\n", nStart );
        sDesc = GetSubString( sDesc, nStart, nEnd-nStart );
        return sDesc;
    }

    return "";
}

int InsertObject( object oTarget, object oSaver, object oKeyItem ){

    if( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE && GetObjectType( oTarget ) != OBJECT_TYPE_ITEM )
        return 0;

    string sPlayer = GetPCPlayerName( oSaver );
    string sName = "NPC_SAVER";
    string sResRef = GetResRef( oTarget );

    if( sResRef == "" )
        sResRef = "PC";


    string sTag = sResRef + "_" +  ObjectToString( oSaver ) + "_" + IntToString( NWNX_GetCurrentSecond( FALSE ) );
           sTag += ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ? ".bic" : ".uti" );

    //DATA_SaveToFile( oTarget, PATH+sTag );

    SetDescription( oKeyItem, sTag, FALSE );

    string sDesc = "Name: "+GetName( oTarget ) + "\n";
           sDesc += "Tag: "+GetTag( oTarget ) + "\n";
           sDesc += "ResRef: "+sResRef + "\n";
           sDesc += "Owner: "+GetPCPlayerName( oSaver ) + "\n";
           sDesc += "Type: "+ ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ? "Creature" : "Item" ) + "\n";
           sDesc += "HOSTILE: YES\n";
           sDesc += "AI: YES\n";
           sDesc += "KEY: "+ sTag;

    SetDescription( oKeyItem, sDesc );
    SendMessageToPC( oSaver, sDesc );
    SetName( oKeyItem, ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ? "Creature" : "Item" )+": "+GetName( oTarget ) );
    return 1;
}

void SetEverythingUndroppable( object oTarget, int noAI ){

    if(GetObjectType(oTarget)!=OBJECT_TYPE_CREATURE)
        return;

    object oItem = GetFirstItemInInventory( oTarget );
    while( GetIsObjectValid( oItem ) ){

        SetDroppableFlag( oItem, FALSE );

        if( GetBaseItemType( oItem ) == BASE_ITEM_BOOK || GetPlotFlag( oItem ) || GetItemCursedFlag( oItem ) )
            DestroyObject( oItem );


        oItem = GetNextItemInInventory( oTarget );
    }


    int n;
    for( n=0;n<NUM_INVENTORY_SLOTS;n++ ){

        oItem = GetItemInSlot( n, oTarget );
        SetDroppableFlag( oItem, FALSE );
    }

    TakeGoldFromCreature( GetGold( oTarget ), oTarget, TRUE );

    if( noAI )
        ExecuteLuaString( oTarget, "nwn.SetAI(OBJECT_SELF, nwn.no_ai)" );
    else
        ExecuteLuaString( oTarget, "nwn.SetAI(OBJECT_SELF, nwn.d_ai)" );

    DelayCommand( 0.1, ExecuteScript( GetLocalString( oTarget, "spawn_script" ), oTarget ) );
}*/

