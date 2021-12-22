//http://www.amiaworld.net/phpBB3/viewtopic.php?f=8&t=72315
//Transmute iron to steel

#include "nwnx_effects"
#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "inc_ds_j_lib"

object CreateResourceFromName( string sName, object oPC ){

    SQLExecDirect( "SELECT id,resref,icon FROM ds_j_resources WHERE name='"+sName+"'" );
    if( SQLFetch( ) ){

        return ds_j_CreateItemOnPC( oPC, SQLGetData( 2 ), StringToInt( SQLGetData( 1 ) ), sName, "", StringToInt( SQLGetData( 3 ) ) );
    }

    return OBJECT_INVALID;
}

string GetResourceTagFromName( string sName ){

    SQLExecDirect( "SELECT id FROM ds_j_resources WHERE name='"+sName+"'" );
    if( SQLFetch( ) ){

        //SendMessageToPC( OBJECT_SELF, "Test: "+DS_J_RESOURCE_PREFIX + SQLGetData( 1 ) );
        return DS_J_RESOURCE_PREFIX + SQLGetData( 1 );
    }

    return "";
}

void main(){

    object oTarget = GetSpellTargetObject( );

    if( GetObjectType( oTarget ) == OBJECT_TYPE_ITEM && GetTag( oTarget ) == GetResourceTagFromName( "Iron Ingot" ) ){

        object oNew = CreateResourceFromName( "Steel Ingot", OBJECT_SELF );

        if( GetItemPossessor( oTarget ) == OBJECT_SELF ){
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SMOKE_PUFF ), OBJECT_SELF );
        }
        else{

            CopyObject( oNew, GetLocation( oTarget ), OBJECT_INVALID, GetTag( oNew ) );
            DestroyObject( oNew );
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SMOKE_PUFF ), GetLocation( oTarget ) );
        }

        DestroyObject( oTarget );
    }
    else
        SendMessageToPC( OBJECT_SELF, "Target cannot be transmuted into steel!" );

}
