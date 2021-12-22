/*  i_ds_summ_change

--------
Verbatim
--------
Makes list of people looking for a party

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2007-05-02   Disco       Start of header
2007-05-04   Disco       Reconfigured to use PC objects
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "amia_include"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void add_to_list( object oPC, object oStorage );
void get_from_list( object oPC, object oStorage );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            object oStorage  = GetObjectByTag( "ds_party_pole" );

            if ( GetName( oItem ) == "Disco's Party Ball" ){

                DestroyObject( oItem, 0.5 );
                SendMessageToPC( oPC, "This was an old version of the Party Advertiser." );
                return;
            }

            if ( oPC == oTarget ){

                add_to_list( oPC, oStorage );
            }
            else{

                get_from_list( oPC, oStorage );
            }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
void add_to_list( object oPC, object oStorage ){

    object oSoLonely;
    int i                = 0;
    int nSelectedSlot    = -1;
    int nStalestTime     = -1;
    int nStalestSlot     = -1;
    int nAddTime         = -1;

    for ( i=1; i<11; ++i ){

        oSoLonely     = GetLocalObject( oStorage, "ds_lonely_pc_"+IntToString( i ) );

        if ( oSoLonely == oPC ){

            SendMessageToPC( oPC, "You have been removed from the party people list!" );
            DeleteLocalObject( oStorage, "ds_lonely_pc_"+IntToString( i ) );
            return;
        }

        if ( !GetIsPC( oSoLonely ) ){

            DeleteLocalObject( oStorage, "ds_lonely_pc_"+IntToString( i ) );
            nSelectedSlot = i;
        }

        int sAddTime = GetLocalInt( oStorage, "ds_lonely_time_"+IntToString( i ) );

        if ( nStalestSlot == -1 || nAddTime < nStalestTime ){

            nStalestTime = nAddTime;
            nStalestSlot = i;
        }
    }

    if ( nSelectedSlot == -1 ){

        nSelectedSlot = nStalestSlot;
    }

    SetLocalObject( oStorage, "ds_lonely_pc_"+IntToString( nSelectedSlot ), oPC );
    SetLocalInt( oStorage, "ds_lonely_time_"+IntToString( nSelectedSlot ), GetRunTime( ) );
    SendMessageToPC( oPC, "You have been added to the party people list!" );
}

void get_from_list( object oPC, object oStorage ){

    object oSoLonely;
    string sSoLonely    = "";
    int nAddTime        = -1;
    int i               = 0;

    SendMessageToPC( oPC, "--------------------------" );
    SendMessageToPC( oPC, "People looking for a party" );

    for ( i=1; i<11; ++i ){

        oSoLonely     = GetLocalObject( oStorage, "ds_lonely_pc_"+IntToString( i ) );

        if ( GetIsPC( oSoLonely ) ){

            struct _ECL_STATISTICS strECL = GetECL( oSoLonely );
            int nECL                      = FloatToInt( strECL.fECL );

            sSoLonely = " * "+GetName( oSoLonely )+" (ECL "+IntToString( nECL )+")";
            nAddTime  = GetRunTime() - GetLocalInt( oStorage, "ds_lonely_time_"+IntToString( i ) );
            SendMessageToPC( oPC, sSoLonely+" - "+IntToString( nAddTime/60 )+" mins." );
        }
        else{

            DeleteLocalObject( oStorage, "ds_lonely_pc_"+IntToString( i ) );
        }
    }

    if ( nAddTime == -1 ){

        SendMessageToPC( oPC, " * Nobody is looking for a party!" );

    }
    SendMessageToPC( oPC, "--------------------------" );
}

