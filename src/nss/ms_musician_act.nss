// Script Name:     ms_musician_act
// Use:             conversation action
// Created by:      msheeler
// Created:         1/8/2016

// Includes
#include "inc_ds_actions"

// Prototype
void resetToDefault( object oArea );

// Main
void main( )
{
    object oPC = GetLastSpeaker ();
    object oArea = GetArea( oPC );
    float fDelay = 120.0;
    int nNode = GetLocalInt ( oPC, "ds_node" );

    int nDayTrack = MusicBackgroundGetDayTrack( oArea );
    int nNightTrack = MusicBackgroundGetNightTrack( oArea );

    if( !GetLocalInt( oArea, "nDayTrack" ) && !GetLocalInt( oArea, "nNightTrack" ) ) {
        SetLocalInt( oArea, "nDayTrack", nDayTrack );
        SetLocalInt( oArea, "nNightTrack", nNightTrack );
    }


    int nTrack;

    switch ( nNode ) {

        case 1:nTrack = 159;break;
        case 2:nTrack = 109;break;
        case 3:nTrack = 108;break;
        case 4:nTrack = 157;break;
        case 5:nTrack = 122;break;
        case 6:nTrack = 123;break;
        case 7:nTrack = 124;break;
        case 8:nTrack = 141;break;
        case 9:nTrack = 22;break;
        case 10:nTrack = 23;break;
        case 11:nTrack = 24;break;
        case 12:nTrack = 56;break;
    }


    MusicBackgroundChangeDay( oArea, nTrack );
    MusicBackgroundChangeNight( oArea, nTrack );

    // resets area music after 2 minutes
    DelayCommand( fDelay, resetToDefault( oArea ) );
}

void resetToDefault( object oArea ) {
    if( !GetIsObjectValid( oArea ) ) return;

    int nDayTrack = GetLocalInt( oArea, "nDayTrack" );
    int nNightTrack = GetLocalInt( oArea, "nNightTrack" );

    MusicBackgroundChangeDay( oArea, nDayTrack );
    MusicBackgroundChangeNight( oArea, nNightTrack );
}
