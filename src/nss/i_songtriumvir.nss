// Song of Triumvir
//
// Makes changes to the area's music, creates several sound objects, and
// spawns black fog.  A second use returns the area to how it was before.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/3/2012  Mathias          Initial Release.
//
#include "amia_include"
#include "x2_inc_switches"

void SFXLoop( object oArea, object oPC, string sSFX, float fDelay ) {

    // Check that the song is still active
    if( GetLocalInt( oArea, "nVodakSong" ) ) {

        // Play the SFX
        AssignCommand( oPC, PlaySound( sSFX ) );

        // Schedule another check next round
        DelayCommand( fDelay, SFXLoop( oArea, oPC, sSFX, fDelay ) );
    }
}

void ActivateItem( ) {

    // Variables
    int     nVodakAmbient   = 16;                   // New ambient sounds
    int     nVodakAmbVol    = 80;                   // New ambient volume
    int     nVodakFog       = FOG_COLOR_BLACK;      // New fog color
    int     nVodakFogAmount = 60;                   // New fog amount
    int     nVodakTrack     = 95;                   // New music track number
    string  sVodakLights    = "plc_magicblue";      // Magic sparks on user
    string  sVodakSFX       = "as_hr_x2ghost6";     // Sound effect to play
    float   fSFXDelay       = 18.00;                 // Delay between loops
    object  oPC             = GetItemActivator();
    object  oWidget         = GetItemActivated();
    object  oArea           = GetArea( oPC );
    int     nSunFogColor    = GetFogColor( FOG_TYPE_SUN, oArea );
    int     nSunFogAmount   = GetFogAmount( FOG_TYPE_SUN, oArea );
    int     nMoonFogColor   = GetFogColor( FOG_TYPE_MOON, oArea );
    int     nMoonFogAmount  = GetFogAmount( FOG_TYPE_MOON, oArea );
    int     nDayMusic       = MusicBackgroundGetDayTrack( oArea );
    int     nNightMusic     = MusicBackgroundGetNightTrack( oArea );
    int     nVodakSong      = GetLocalInt( oArea, "nVodakSong" );
    object  oVodakLights;
    string  sVodakLightStr  = "VODAK_LIGHTS";
    int     bDebug          = FALSE;                 // set to TRUE to see debug messages

    // Check if song is already active.
    if ( nVodakSong ) {

        // Load the default fog and backgroud music ints.
        nSunFogColor    = GetLocalInt( oArea, "nDefaultSunFogColor" );
        nSunFogAmount   = GetLocalInt( oArea, "nDefaultSunFogAmount" );
        nMoonFogColor   = GetLocalInt( oArea, "nDefaultMoonFogColor" );
        nMoonFogAmount  = GetLocalInt( oArea, "nDefaultMoonFogAmount" );
        nDayMusic       = GetLocalInt( oArea, "nDefaultDayMusic" );
        nNightMusic     = GetLocalInt( oArea, "nDefaultNightMusic" );

        // Set fog and background music back to normal.
        SetFogColor( FOG_TYPE_SUN, nSunFogColor, oArea );
        SetFogAmount( FOG_TYPE_SUN, nSunFogAmount, oArea );
        SetFogColor( FOG_TYPE_MOON, nMoonFogColor, oArea );
        SetFogAmount( FOG_TYPE_MOON, nMoonFogAmount, oArea );
        MusicBackgroundChangeDay( oArea, nDayMusic );
        MusicBackgroundChangeNight( oArea, nNightMusic );

        // Stop the ambient sounds.
        AmbientSoundStop( oArea );

        // Find and destroy the magic sparks.
        oVodakLights = GetNearestObjectByTag( sVodakLightStr, oPC );
        DestroyObject( oVodakLights );

        // Tell the area that the song is off.
        SetLocalInt( oArea, "nVodakSong", 0 );

    // If song isn't active, fire it up.
    } else {

        // Exit if PC has no more bard song uses.
        if ( !GetHasFeat( FEAT_BARD_SONGS, oPC ) ) {
            FloatingTextStringOnCreature( "- You do not have any remaining uses for this ability! -", oPC, FALSE );
            return;
        }

        // Tell the area that the song is on.
        SetLocalInt( oArea, "nVodakSong", 1 );

        // Record the default fog and background music ints.
        SetLocalInt( oArea, "nDefaultSunFogColor", nSunFogColor );
        SetLocalInt( oArea, "nDefaultSunFogAmount", nSunFogAmount );
        SetLocalInt( oArea, "nDefaultMoonFogColor", nSunFogColor );
        SetLocalInt( oArea, "nDefaultMoonFogAmount", nSunFogAmount );
        SetLocalInt( oArea, "nDefaultDayMusic", nDayMusic );
        SetLocalInt( oArea, "nDefaultNightMusic", nNightMusic );

        // Set new fog and background music.
        SetFogColor( FOG_TYPE_SUN, nVodakFog, oArea );
        SetFogAmount( FOG_TYPE_SUN, nVodakFogAmount, oArea );
        SetFogColor( FOG_TYPE_MOON, nVodakFog, oArea );
        SetFogAmount( FOG_TYPE_MOON, nVodakFogAmount, oArea );
        MusicBackgroundChangeDay( oArea, nVodakTrack );
        MusicBackgroundChangeNight( oArea, nVodakTrack );

        // Set and start the new ambient sounds
        AmbientSoundChangeDay( oArea, nVodakAmbient );
        AmbientSoundChangeNight( oArea, nVodakAmbient );
        AmbientSoundSetDayVolume( oArea, nVodakAmbVol );
        AmbientSoundSetNightVolume( oArea, nVodakAmbVol );
        AmbientSoundPlay( oArea );

        // Loop the sound effect until the song is over.
        SFXLoop( oArea, oPC, sVodakSFX, fSFXDelay );

        // Create the magic sparks.
        oVodakLights = CreateObject( OBJECT_TYPE_PLACEABLE, sVodakLights, GetLocation( oPC ), FALSE, sVodakLightStr );

        // !!DEBUG!!
        if ( bDebug ) { SendMessageToPC( oPC, "Song activated." ); }

        // Decrement a feat usage.
        DecrementRemainingFeatUses( oPC, FEAT_BARD_SONGS );
    }
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
