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

string DLIGHT_REF = "am_dlight";
int APPEARANCE_DLIGHT_WHITE = APPEARANCE_TYPE_WILL_O_WISP;
int APPEARANCE_DLIGHT_ORANGE = 1068;
int APPEARANCE_DLIGHT_GREEN = 1069;
int APPEARANCE_DLIGHT_PINK = 1065;
int APPEARANCE_DLIGHT_PURPLE = 1067;
int APPEARANCE_DLIGHT_YELLOW = 1066;
string DLIGHT_DESCRIPTION = "A little ball of light made by a Dancing Lights spell.";

void ColorizeLight(object oCreature) {
    int     nRandom = Random( 6 );
    // Get a random creature resref.
    switch( nRandom ) {
        case 0:
            SetCreatureAppearanceType(oCreature, APPEARANCE_DLIGHT_WHITE);
            break;
        case 1:
            SetCreatureAppearanceType(oCreature, APPEARANCE_DLIGHT_PINK);
            break;
        case 2:
            SetCreatureAppearanceType(oCreature, APPEARANCE_DLIGHT_YELLOW);
            break;
        case 3:
            SetCreatureAppearanceType(oCreature, APPEARANCE_DLIGHT_PURPLE);
            break;
        case 4:
            SetCreatureAppearanceType(oCreature, APPEARANCE_DLIGHT_ORANGE);
            break;
        case 5:
            SetCreatureAppearanceType(oCreature, APPEARANCE_DLIGHT_GREEN);
            break;
    }
    return;
}

void ActivateItem( ) {

    // Variables.
    //object      oPC             = GetPCSpeaker( );
    object      oPC             = GetItemActivator( );
    string      sPCMessage      = "Dancing Lights begin to manifest around the area.";
    string      sCallTag        = "DLIGHTS_CREATURE";
    float       fStartDistance  = 12.0;
    float       fStopDistance   = 4.0;
    float       fExitDistance   = 15.0;
    float       fDestroyDelay   = 6.0;
    float       fStartDelay     = GetRandomDelay( 0.5, 2.0 );
    //effect      eSongVFX        = EffectVisualEffect( VFX_DUR_BARD_SONG );
    location    lPCLocation     = GetLocation( oPC );
    object      oNearbyPC       = GetNearestCreatureToLocation( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, lPCLocation );
    int         nActive         = GetLocalInt( oPC, "DLIGHTS_ACTIVE" );
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
        /*
        while( GetIsEffectValid( eEffects ) ) {

            // Find bard song effect.
            if ( GetEffectSubType( eEffects ) == SUBTYPE_EXTRAORDINARY ) {

                // And remove it.
                RemoveEffect( oPC, eEffects );

                // !!DEBUG!!
                if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oPC) + "'s effect #" + IntToString( GetEffectType( eEffects ) ) + " was removed."); }
            }
            eEffects = GetNextEffect( oPC );
        } */

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
        SetLocalInt( oPC, "DLIGHTS_ACTIVE", FALSE );

    // If ability is not active, start the effects.
    } else {

        // DEBUG
        if (bDebug) { SendMessageToPC( oPC, "Starting effects." ); }

        // Create initial VFX
        //eSongVFX = ExtraordinaryEffect( eSongVFX );
        //ApplyEffectToObject( DURATION_TYPE_PERMANENT, eSongVFX, oPC );

        // Create creatures.
        for ( x = 0; x < 6; x++ ) {

            sCallResRef = DLIGHT_REF;

            // Set starting and destination locations.
            lStart          = GenerateNewLocationFromLocation( lPCLocation, fStartDistance, fAngle, 0.0 );
            lStop           = GenerateNewLocationFromLocation( lPCLocation, fStopDistance, fAngle, 0.0 );

            // Create the creature.
            oCallCreature = CreateObject( OBJECT_TYPE_CREATURE, sCallResRef, lStart, FALSE, sCallTag );

            // Make creature not hostile.
            ChangeToStandardFaction( oCallCreature, STANDARD_FACTION_COMMONER );
            SetPCLike( oPC, oCallCreature );

            ColorizeLight(oCallCreature);

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
            //SendMessageToPC( oNearbyPC, sPCMessage );

            // Find the next nearby PC.
            ++x;
            oNearbyPC = GetNearestCreatureToLocation( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, lPCLocation, x );
        }

        // Indicate that the effect is active.
        SetLocalInt( oPC, "DLIGHTS_ACTIVE", TRUE );
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

