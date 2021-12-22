//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_music_act
//group:   dc requests
//used as: action script
//date:    nov 22 2009
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_bank"


void main()
{


    object oPC       = OBJECT_SELF;
    object oArea     = GetArea( OBJECT_SELF );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    int nSection     = GetLocalInt( oPC, "ds_section" );
    int nIsSet       = GetLocalInt( oArea, "music_set" );
    int nOrgDay      = GetLocalInt( oArea, "music_day" );
    int nOrgNight    = GetLocalInt( oArea, "music_night" );
    int nTrack;

    if ( nNode >= 1 && nNode <= 39 ){

        if ( nSection == 1 ){

            switch ( nNode ) {

                case 01:     nTrack = TRACK_THEME_ARIBETH1;    break;
                case 02:     nTrack = TRACK_THEME_ARIBETH2;    break;
                case 03:     nTrack = TRACK_BATTLE_CITYBOSS;    break;
                case 04:     nTrack = TRACK_CITYMARKET;    break;
                case 05:     nTrack = TRACK_BATTLE_DESERT;    break;
                case 06:     nTrack = TRACK_DESERT_DAY;    break;
                case 07:     nTrack = TRACK_DESERT_NIGHT;    break;
                case 08:     nTrack = TRACK_TEMPLEEVIL;    break;
                case 09:     nTrack = TRACK_FORESTDAY1;    break;
                case 10:     nTrack = TRACK_RICHHOUSE;    break;
                case 11:     nTrack = TRACK_TEMPLEGOOD;    break;
                case 12:     nTrack = TRACK_TEMPLEGOOD2;    break;
                case 13:     nTrack = 81;    break;
                case 14:     nTrack = 93;    break;
                case 15:     nTrack = 82;    break;
                case 16:     nTrack = 94;    break;
                case 17:     nTrack = 86;    break;
                case 18:     nTrack = 87;    break;
                case 19:     nTrack = TRACK_TAVERN3;    break;
                case 20:     nTrack = TRACK_HOTU_THEME;    break;
            }
        }

        if ( nTrack > 0 ){

            if ( !nIsSet ){

                nOrgDay   = MusicBackgroundGetDayTrack( oArea );
                nOrgNight = MusicBackgroundGetNightTrack( oArea );

                SetLocalInt( oArea, "music_set", TRUE );
                SetLocalInt( oArea, "music_day", nOrgDay );
                SetLocalInt( oArea, "music_night", nOrgNight );
            }

            MusicBackgroundStop( oArea );
            MusicBackgroundChangeDay( oArea, nTrack );
            MusicBackgroundChangeNight( oArea, nTrack );
            MusicBackgroundPlay( oArea );
        }
    }
    else if ( nNode == 40 ){

        MusicBackgroundChangeDay( oArea, nOrgDay );
        MusicBackgroundChangeNight( oArea, nOrgNight );
    }
}
