//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  td_wildcamp
//description: Does things in the wild barb camp
//used as: differant, see code
//date:    nov 3 2008
//author:  Terra

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "inc_ds_actions"
#include "nw_i0_plot"
#include "inc_ds_qst"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//Sets checks
//check 1 = the racials
//check 2 = female
//check 3 = male
//check 4 = racials and female
//check 5 = racials and male
//and starts object_Selfs convo
void SetChecks( object oPC );

void Do_PH_Barbstore( object oPC );

void SetAreaMusicFromTheBardGuy( int nNode, object oPC );


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main(){

    int     nNode       = GetLocalInt( OBJECT_SELF , "ds_node" );
    object  oSpeaker    = GetLastSpeaker();

    if ( nNode > 0 && nNode < 8 ){

        //route to quest scripts
        //OBJECT_SELF = oPC
        ExecuteScript( "ds_qst_act", OBJECT_SELF );

        return;
    }

    if ( !nNode && GetLocalInt( OBJECT_SELF, "q_id" ) == 29 ){

        //route to quest scripts
        //OBJECT_SELF = oNPC
        //oSpeaker    = oPC
        int nNextState  = qst_check( oSpeaker );

        if ( nNextState > -1 && nNextState < 8 ){

            clean_vars( oSpeaker, 1 );

            if ( nNextState > 0 ){

                SetLocalInt( oSpeaker, "ds_check_"+IntToString( nNextState ), 1 );
                SetLocalString( oSpeaker, "ds_action", "ds_qst_act" );
                SetLocalObject( oSpeaker, "ds_target", OBJECT_SELF );
            }

            ActionStartConversation( oSpeaker );

            return;
        }
    }

    switch( nNode ){

        //Stone the statue dog
        case 31:
        //not used. No stoneskined dogs.
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectPetrify()), OBJECT_SELF);
        return;
        //Cast Resto
        case 32:
        ActionCastSpellAtObject(SPELL_GREATER_RESTORATION, GetLastUsedBy(),METAMAGIC_ANY,TRUE, 60,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
        break;
        //Store
        case 33:
        Do_PH_Barbstore( OBJECT_SELF );
        break;

        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
        case 19:
        case 20:
        case 21:
        SetAreaMusicFromTheBardGuy( nNode, OBJECT_SELF );
        break;

        //Start a convo
        default:
        SetChecks( oSpeaker );
        break;

    }

}
//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------
void SetChecks( object oPC ){

    clean_vars( oPC, 4, "td_wildcamp" );

    string sSub = GetStringLowerCase( GetSubRace( oPC ) );
    int nRace   = GetRacialType( oPC );

    if( nRace   != RACIAL_TYPE_OUTSIDER         &&
        nRace   != RACIAL_TYPE_HALFORC          &&
        nRace   != RACIAL_TYPE_ANIMAL           &&
        nRace   != RACIAL_TYPE_BEAST            &&
        nRace   != RACIAL_TYPE_ABERRATION       &&
        nRace   != RACIAL_TYPE_CONSTRUCT        &&
        nRace   != RACIAL_TYPE_DRAGON           &&
        nRace   != RACIAL_TYPE_ELEMENTAL        &&
        nRace   != RACIAL_TYPE_GIANT            &&
        nRace   != RACIAL_TYPE_MAGICAL_BEAST    &&
        nRace   != RACIAL_TYPE_SHAPECHANGER     &&
        nRace   != RACIAL_TYPE_UNDEAD           &&
        nRace   != RACIAL_TYPE_VERMIN           &&
        sSub    != "drow"                       &&
        sSub    != "duergar"                    &&
        sSub    != "kobold"                     &&
        sSub    != "goblin"                     &&
        sSub    != "halfdrow"                   ){
        SetLocalInt( oPC, "ds_check_31", 1 );

            if( GetGender( oPC ) != GENDER_FEMALE )
            SetLocalInt( oPC, "ds_check_34", 1 );
            else
            SetLocalInt( oPC, "ds_check_35", 1 );

            if( nRace != RACIAL_TYPE_HUMAN &&
                nRace != RACIAL_TYPE_DWARF )
                SetLocalInt( oPC, "ds_check_39", 1 );
        }

    if( GetGender( oPC ) != GENDER_FEMALE )
        SetLocalInt( oPC, "ds_check_32", 1 );
    else
        SetLocalInt( oPC, "ds_check_33", 1 );

    if( nRace == RACIAL_TYPE_HUMAN ||
        nRace == RACIAL_TYPE_DWARF){

        SetLocalInt( oPC, "ds_check_36", 1 );
            if( GetGender( oPC ) != GENDER_FEMALE )
            SetLocalInt( oPC, "ds_check_37", 1 );
            else
            SetLocalInt( oPC, "ds_check_38", 1 );
        }

    //ActionStartConversation( oPC, "", TRUE, FALSE );
    BeginConversation();

    string szSeatTag        = GetLocalString( OBJECT_SELF, "Seating" );
    object oSeat            = GetNearestObjectByTag( szSeatTag );

    // Delayed Action :: Sit
    if( GetIsObjectValid( oSeat ) ){

        DelayCommand( 10.0, AssignCommand( OBJECT_SELF, ActionSit( oSeat ) ) );        // Seat found, sit on it.
    }

}

void Do_PH_Barbstore( object oPC ){

    object oStore = GetNearestObjectByTag("Ph_BarbStore");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
        gplotAppraiseOpenStore(oStore, oPC);
    else
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}

void SetAreaMusicFromTheBardGuy( int nNode, object oPC ){

    int nTrack = 0;

    switch( nNode ){
    case 10:nTrack = 82;break;
    case 11:nTrack = 83;break;
    case 12:nTrack = 84;break;
    case 13:nTrack = 85;break;
    case 14:nTrack = 86;break;
    case 15:nTrack = 87;break;
    case 16:nTrack = 89;break;
    case 17:nTrack = 90;break;
    case 18:nTrack = 92;break;
    case 19:nTrack = 93;break;
    case 21:nTrack = 94;break;
    case 22:nTrack = 95;break;
    }

    MusicBackgroundChangeDay( GetArea( oPC ), nTrack );
    MusicBackgroundChangeNight( GetArea( oPC ), nTrack );
    MusicBackgroundPlay( GetArea( oPC ) );
}


