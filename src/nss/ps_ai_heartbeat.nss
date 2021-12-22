//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ps_ai_heartbeat
//used as: AI
//date:    jan 16 2014
//author:  terra


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

void main(){

    //Uncomment and call the default heartbeat scrip here.
    ExecuteScript( "ds_ai2_heartbeat", OBJECT_SELF );

    //Already angry, we're done here.
    if( GetLocalInt( OBJECT_SELF, "ReallyMad" ) )
        return;

    //Get closest PC.
    object oPC = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC );

    //No PCs in the area!
    if( !GetIsObjectValid( oPC ) )
        return;

    //We see you and you're close enough, set to hostile and go nuts.
    if( GetDistanceToObject( oPC ) <= 15.0 ){

        ActionSpeakString( "*Looks up suddenly and sniffs the air.*");
        AdjustReputation( oPC, OBJECT_SELF, -80);
        SignalEvent( OBJECT_SELF, EventSpellCastAt( OBJECT_SELF, -1 ) );
        SetLocalInt( OBJECT_SELF, "ReallyMad", TRUE );
    }
}
