/*  Generic on use script

    Date              Name        Reason
    ------------------------------------------------------------------
    2007-11-16        disco       start of header
    ------------------------------------------------------------------
*/

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "nw_o2_coninclude"
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC      = GetLastUsedBy();
    string sTag     = GetTag( OBJECT_SELF );

    if ( sTag == "levelup" ){

        //set to level 20
        SetXP( oPC, 435000 );

        //give lotsa gold
        GiveGoldToCreature( oPC, 1000000 );
    }
    else if ( sTag == "storeshaft" ){

        string sStore   = GetLocalString( OBJECT_SELF, "Store" );
        object oStore   = GetLocalObject( OBJECT_SELF, "MyStore" );

        if ( GetObjectType( oStore ) != OBJECT_TYPE_STORE ) {

            oStore = CreateObject( OBJECT_TYPE_STORE, sStore, GetLocation( OBJECT_SELF ) );

            //store store on object for future use
            SetLocalObject( OBJECT_SELF, "MyStore", oStore );
        }

        if ( GetObjectType( oStore ) == OBJECT_TYPE_STORE ){

            //open the store
            OpenStore( oStore, oPC, 0, 0 );
        }
        else{

            //error
            ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
            return;
        }
    }
    else if ( sTag == "khm_stash" && !GetLocalInt( OBJECT_SELF, "blocked" ) ){

        SetLocalInt( OBJECT_SELF, "blocked", 1 );

        if ( d10() > 3 ){

            int nLevel = GetHitDice( oPC );

            int nGold = 317 * ( nLevel / 2 ) + ( d100( nLevel ) );

            CreateItemOnObject( "nw_it_gold001", OBJECT_SELF, nGold );

            CreateGem( OBJECT_SELF, oPC, d2(), d2() );
            CreateGem( OBJECT_SELF, oPC, d2(), d2() );
        }
        else{

            SpeakString( "This chest only contains sand and the promise of a rich loot." );
        }

        DelayCommand( 120.0, SafeDestroyObject( OBJECT_SELF ) );
    }



}
