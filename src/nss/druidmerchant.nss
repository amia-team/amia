//::///////////////////////////////////////////////
//:: FileName druidmerchant
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/01/2005 01:19:37
//:://////////////////////////////////////////////
// 2007/08/12 disco       Now works for PLCs too, use in OnUsed. Removed GetNearestObhect calls.

#include "nw_i0_plot"
#include "inc_ds_records"
#include "ds_inc_randstore"
//#include "logger"

void main( ){

    //check if there's a valid PC

    object oPC      = GetLastSpeaker();

    if ( oPC == OBJECT_INVALID ){

        oPC = GetLastUsedBy();
    }

    if ( oPC == OBJECT_INVALID ){

        return;
    }

    string sStore   = GetLocalString( OBJECT_SELF, "MyOtherStore" );
    object oStore   = GetLocalObject( OBJECT_SELF, "MyOtherStore" );

    if ( GetObjectType( oStore ) != OBJECT_TYPE_STORE ) {

        oStore = CreateObject( OBJECT_TYPE_STORE, sStore, GetLocation( OBJECT_SELF ) );

        //store store on object for future use
        SetLocalObject( OBJECT_SELF, "MyOtherStore", oStore );
    }

    if( GetObjectType( oStore ) == OBJECT_TYPE_STORE ){

        //open the store
        gplotAppraiseOpenStore( oStore, GetPCSpeaker() );

        //trace store use
        db_trace_shop( oPC, oStore, OBJECT_SELF );

        //inject random items, if any are set
        InjectIntoStore( oStore );

    }
    else{

        //error
        ActionSpeakStringByStrRef( 53090, TALKVOLUME_TALK );
    }
}
