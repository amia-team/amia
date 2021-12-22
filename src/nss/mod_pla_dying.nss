//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: mod_pla_dying
//group: module events
//used as: OnPlayerDying
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//resolves the bleeding routine
void Bleed( object oPC, int nAmount, int nRound );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main( ){

    // Variables.
    object oPC              = GetLastPlayerDying( );
    object oAttacker        = GetLastHostileActor( oPC );

    // Track through summons if necessary.
    if( !GetIsPC( oAttacker ) ){

        oAttacker           = GetMaster( oAttacker );
    }

    // Victim was Pk'ed, apply death effect immediately.
    if ( GetIsPC( oAttacker ) ){

        AssignCommand( oAttacker, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath( TRUE ), oPC ) );
        return;
    }

    // Resolve recovery status.
    Bleed( oPC, 1, 1 );

    return;
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void Bleed( object oPC, int nAmount, int nRound ){

    int nHitPoints = GetCurrentHitPoints( oPC );

    // Characters stop bleeding if they have more than zero hit points
    // or are dead.
    if ( nHitPoints > 0 || nHitPoints <= -10 ){

        return;
    }

    //if rounds > 0 update nRounds ( 0 rounds means stabilised )
    if ( nRound > 0 ){

        ++nRound;
    }

    //if rounds > 11 kill the poor sod.
    if ( nRound > 20 ){

        PlayVoiceChat( VOICE_CHAT_DEATH );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath( TRUE ), oPC );

        return;
    }

    effect eBleedEff;

    // Positive bleeding amount means damage, otherwise heal the character.
    if ( nAmount > 0 ){

        eBleedEff = EffectDamage( nAmount, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY );
    }
    else{

        eBleedEff = EffectHeal( -nAmount ); // Note the negative sign
    }

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eBleedEff, oPC );

    // -10 hit points is the death threshold: at or beyond it the
    // character dies.
    if ( GetCurrentHitPoints() <= -11 ){

        PlayVoiceChat( VOICE_CHAT_DEATH );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath( TRUE ), oPC );
    }
    else if ( nAmount > 0 ) {

        // Only check if character has not stablized
        int nStableRoll = d100( ) + GetAbilityModifier( ABILITY_CONSTITUTION, oPC );

        if ( nStableRoll >= 90 ) {

            nAmount = -nAmount; // Reverse the bleeding process.
            PlayVoiceChat( VOICE_CHAT_LAUGH );
            SendMessageToPC( oPC, "You have stabilized." );

            //set rounds to 0
            nRound = 0;
        }
        else {

            switch ( d6() ) {

                case 1: PlayVoiceChat( VOICE_CHAT_PAIN1 );      break;
                case 2: PlayVoiceChat( VOICE_CHAT_PAIN2 );      break;
                case 3: PlayVoiceChat( VOICE_CHAT_PAIN3 );      break;
                case 4: PlayVoiceChat( VOICE_CHAT_HEALME );     break;
                case 5: PlayVoiceChat( VOICE_CHAT_NEARDEATH );  break;
                case 6: PlayVoiceChat( VOICE_CHAT_HELP );
            }
        }
    }

    if ( GetCurrentHitPoints() <= 0 ) {

        DelayCommand( 6.0, Bleed( oPC, nAmount, nRound ) );    // Do this again next round
    }
}
