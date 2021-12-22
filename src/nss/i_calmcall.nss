// Calming Call
//
// The widget would spawn 2d6 regular forest animals, and a 50% chance to spawn
// a white stag, all of which spawn 10-20 meters away from the user and make
// their way slowly up to nearby to listen.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/11/2012 Mathias          Initial Release.
//
#include "amia_include"
#include "x2_inc_switches"
#include "nw_i0_spells"

string GetRandomCreature( ) {

    string  sReturn;
    int     nRandom = Random( 8 );

    // Get a random creature resref.
    switch( nRandom ) {
        case 0:
            sReturn = "nw_bearbrwn";
            break;

        case 1:
            sReturn = "nw_raptor001";
            break;

        case 2:
            sReturn = "nw_boar";
            break;

        case 3:
            sReturn = "nw_badger";
            break;

        case 4:
            sReturn = "nw_deer";
            break;

        case 5:
            sReturn = "nw_wolf";
            break;

        case 6:
            sReturn = "nw_deer";
            break;

        case 7:
            sReturn = "ar_cow";
            break;

    }
    return sReturn;
}

void ActivateItem( ) {

    // Variables.
    object      oPC             = GetItemActivator( );
    string      sPCMessage      = "A rustling sound is heard around the area.";
    string      sCallTag        = "CALMCALL_CREATURE";
    float       fStartDistance  = 12.0;
    float       fStopDistance   = 4.0;
    float       fExitDistance   = 15.0;
    float       fDestroyDelay   = 6.0;
    float       fStartDelay     = GetRandomDelay( 0.5, 2.0 );
    effect      eSongVFX        = EffectVisualEffect( VFX_DUR_BARD_SONG );
    location    lPCLocation     = GetLocation( oPC );
    object      oNearbyPC       = GetNearestCreatureToLocation( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, lPCLocation );
    int         nActive         = GetLocalInt( oPC, "CALMCALL_ACTIVE" );
    int         bCallStag       = Random( 5 );
    string      sCallResRef;
    int         nRandomInt;
    effect      eEffects        = GetFirstEffect( oPC );
    object      oCallCreature;
    location    lStart;
    location    lStop;
    float       fAngle;
    int         x;
    int         bDebug          = FALSE; // Set to TRUE to see debug information


    // If ability is active already, end the effects.
    if ( nActive ) {

        // DEBUG
        if (bDebug) { SendMessageToPC( oPC, "Removing effects." ); }

        // Cycle through effects on PC.
        while( GetIsEffectValid( eEffects ) ) {

            // Find bard song effect.
            if ( GetEffectSubType( eEffects ) == SUBTYPE_EXTRAORDINARY ) {

                // And remove it.
                RemoveEffect( oPC, eEffects );

                // !!DEBUG!!
                if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oPC) + "'s effect #" + IntToString( GetEffectType( eEffects ) ) + " was removed."); }
            }
            eEffects = GetNextEffect( oPC );
        }

        // Find created creatures and make them go away.
        x               = 1;
        oCallCreature   = GetNearestObjectByTag( sCallTag, oPC);
        while( GetIsObjectValid( oCallCreature ) ) {

            // Make the creature walk off.
            DelayCommand( fStartDelay, AssignCommand( oCallCreature, ActionMoveAwayFromLocation( lPCLocation, FALSE, fExitDistance ) ) );

            // Destroy the creature.
            DestroyObject( oCallCreature, fDestroyDelay );

            // Get the next creature.
            fStartDelay = GetRandomDelay( 0.5, 2.0 );
            ++x;
            oCallCreature = GetNearestObjectByTag( sCallTag, oPC, x );
        }

        // Indicate that the effect is no longer active.
        SetLocalInt( oPC, "CALMCALL_ACTIVE", FALSE );

    // If ability is not active, start the effects.
    } else {

        // DEBUG
        if (bDebug) { SendMessageToPC( oPC, "Starting effects." ); }

        // Create initial VFX
        eSongVFX = ExtraordinaryEffect( eSongVFX );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eSongVFX, oPC );

        // Create creatures.
        for ( x = 0; x < 6; x++ ) {

            // 20% chance of white stag
            if( bCallStag == 1 ) {

                sCallResRef = "nw_deerstag";
                bCallStag   = 0;

            } else {

                // Get a random creature.
                sCallResRef     = GetRandomCreature( );
            }

            // Set starting and destination locations.
            lStart          = GenerateNewLocationFromLocation( lPCLocation, fStartDistance, fAngle, 0.0 );
            lStop           = GenerateNewLocationFromLocation( lPCLocation, fStopDistance, fAngle, 0.0 );

            // Create the creature.
            oCallCreature = CreateObject( OBJECT_TYPE_CREATURE, sCallResRef, lStart, FALSE, sCallTag );

            // Make creature not hostile.
            ChangeToStandardFaction( oCallCreature, STANDARD_FACTION_COMMONER );
            SetPCLike( oPC, oCallCreature );

            // Make creature walk to the PC.
            DelayCommand( fStartDelay, AssignCommand( oCallCreature, ActionMoveToLocation( lStop, FALSE ) ) );

            // Get new random delay and set new angle.
            fStartDelay = GetRandomDelay( 0.5, 2.0 );
            fAngle      = fAngle + 60;
        }

        // Cycle through nearby PCs.
        x = 1;
        while( ( GetIsObjectValid( oNearbyPC ) ) && ( GetDistanceBetween( oNearbyPC, oPC ) < fExitDistance ) ) {

            // Send the PC the message.
            SendMessageToPC( oNearbyPC, sPCMessage );

            // Find the next nearby PC.
            ++x;
            oNearbyPC = GetNearestCreatureToLocation( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, lPCLocation, x );
        }

        // Indicate that the effect is active.
        SetLocalInt( oPC, "CALMCALL_ACTIVE", TRUE );
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
