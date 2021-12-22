//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai2_convo
//group:   ds_ai2
//used as: OnConversation
//date:    jan 20 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter = OBJECT_SELF;
    object oSpeaker = GetLastSpeaker();
    int nShout      = GetListenPatternNumber();
    int nResult;


    if ( nShout == 1001 && !GetIsInCombat( OBJECT_SELF ) ){

        //SpeakString( "*looks around for the attacker*" );

        nResult = PerformAction( OBJECT_SELF, "ds_ai2_convo" );

        if ( nResult == -1 ){

            ActionMoveToObject( GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC ), TRUE, 10.0 );
        }

        return;
    }

    //undead summon stuff
    if ( GetMaster( oCritter ) == oSpeaker && GetLocalInt( oCritter, "is_undead" ) == 1 ){

        if ( GetLastAssociateCommand( oCritter ) == ASSOCIATE_COMMAND_FOLLOWMASTER ) {

            SpeakString( "Hurghhh hhuh..." );
            ClearAllActions();
            ActionForceFollowObject( oSpeaker );
            return;
        }
        else if ( GetLastAssociateCommand( oCritter ) == ASSOCIATE_COMMAND_STANDGROUND ) {

            SpeakString( "Buhrhh ghaarg..." );
            ClearAllActions();
            return;
        }
    }
}
