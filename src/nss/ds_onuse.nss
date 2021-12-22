/*  Generic on use script

    Date              Name        Reason
    ------------------------------------------------------------------
    2007-11-16        disco       start of header
    ------------------------------------------------------------------
*/
#include "nw_o2_coninclude"
#include "nw_i0_generic"
#include "amia_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void CreateStandardLoot( object oChest, object oPC );



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC      = GetLastUsedBy();
    string sTag     = GetTag( OBJECT_SELF );

    //stuff without a time block


    if ( sTag == "oc_beh_chain" ){

        object oDoor = GetObjectByTag( "oc_beh_door" );

        AssignCommand( oDoor, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
    }
    else if ( sTag == "sc_glinscaves_button" ){

        object oDoor = GetObjectByTag( "sc_glinscaves_door" );

        AssignCommand( oDoor, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
        DelayCommand( 10.0, AssignCommand( oDoor, PlayAnimation( ANIMATION_DOOR_CLOSE ) ) );
    }
    else if ( GetIsBlocked( ) > 0 ){

        //SendMessageToPC( oPC, "[This object is blocked for the time being. Try again in a few minutes.]" );
        return;
    }

    //stuff with a timeblock
    if ( sTag == "gong" ){

        PlaySound( "as_cv_gongring2" );
        SetBlockTime( OBJECT_SELF, 1 );
    }
    else if ( sTag == "spawnitem" ){

        ds_create_item( GetLocalString( OBJECT_SELF, "ds_resref" ), OBJECT_SELF );
        SetBlockTime( );
    }
    else if ( sTag == "ds_goods" ){

        CreateStandardLoot( OBJECT_SELF, oPC );

        SetBlockTime( OBJECT_SELF, ( 10 + d20() ) );
    }
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
void CreateStandardLoot( object oChest, object oPC ){

    int i;
    int nRandom;
    int nLevel = GetHitDice( oPC );
    int nGold;

    if ( nLevel < 7 ){

        for ( i=0; i<d3(); ++i ){

            nRandom = d6();

            switch ( nRandom ){

                case 1: CreateGem( oChest, oPC, 1, 0 );     break;
                case 2: CreateGold( oChest, oPC, 1, 0 );    break;
                case 3: CreateBook( oChest );               break;
                case 4: CreateLockPick( oChest, oPC, 0 );   break;
                case 5: CreateTrapKit( oChest, oPC, 0 );    break;
                case 6: CreateJunk( oChest );               break;
            }
        }
    }
    else{

        nGold = 317 * ( nLevel / 2 ) + ( d100( nLevel ) );

        CreateItemOnObject( "nw_it_gold001", oChest, nGold );
    }
}

