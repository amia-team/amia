/* Tarkuul: Key of the Damned

Tarkuul Councilor's key, usable for various things.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
11/01/12 Glim             Initial Release - Activates Cynosure triggers

*/
#include "amia_include"
#include "x2_inc_switches"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------
void DoCynosure( string sCardinal, string sName );


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void ActivateItem()
{
    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();

    string sCardinal = GetLocalString( oTarget, "Cardinal" );
    string sName = GetName( oPC );

    if( GetTag( oTarget ) == sCardinal+"trigger" )
    {
        AssignCommand( oTarget, DoCynosure( sCardinal, sName ) );
    }
    else
    {
        SendMessageToPC( oPC, "Using your mirror on this object does nothing." );
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

void DoCynosure( string sCardinal, string sName )
{
    string sActive = "Activating "+sCardinal+" Cynosure...";

    object oControl = GetNearestObjectByTag( sCardinal+"control" );

    object oBlack = GetNearestObjectByTag( sCardinal+"black" );
    object oPurple = GetNearestObjectByTag( sCardinal+"purple" );
    object oBlue = GetNearestObjectByTag( sCardinal+"blue" );

    object o1L = GetNearestObjectByTag( sCardinal+"left1" );
    object o2L = GetNearestObjectByTag( sCardinal+"left2" );
    object o3L = GetNearestObjectByTag( sCardinal+"left3" );
    object o4L = GetNearestObjectByTag( sCardinal+"left4" );
    object o5L = GetNearestObjectByTag( sCardinal+"left5" );
    object o6L = GetNearestObjectByTag( sCardinal+"left6" );
    object o7L = GetNearestObjectByTag( sCardinal+"left7" );
    object o8L = GetNearestObjectByTag( sCardinal+"left8" );
    object o9L = GetNearestObjectByTag( sCardinal+"left9" );
    object o10L = GetNearestObjectByTag( sCardinal+"left10" );
    object o1R = GetNearestObjectByTag( sCardinal+"right1" );
    object o2R = GetNearestObjectByTag( sCardinal+"right2" );
    object o3R = GetNearestObjectByTag( sCardinal+"right3" );
    object o4R = GetNearestObjectByTag( sCardinal+"right4" );
    object o5R = GetNearestObjectByTag( sCardinal+"right5" );
    object o6R = GetNearestObjectByTag( sCardinal+"right6" );
    object o7R = GetNearestObjectByTag( sCardinal+"right7" );
    object o8R = GetNearestObjectByTag( sCardinal+"right8" );
    object o9R = GetNearestObjectByTag( sCardinal+"right9" );
    object o10R = GetNearestObjectByTag( sCardinal+"right10" );

    // * note that nActive == 1 does  not necessarily mean the placeable is active
    // * that depends on the initial state of the object
    int nActive = GetLocalInt ( OBJECT_SELF, "X2_L_PLC_ACTIVATED_STATE" );
    // * Play Appropriate Animation
    if (!nActive)
    {
        AssignCommand( OBJECT_SELF, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE ) );

        //Flavor text
        AssignCommand( OBJECT_SELF, ActionSpeakString( sActive, TALKVOLUME_TALK ) );

        //Load up visual effects
        effect eCtoBlack = EffectBeam( VFX_BEAM_EVIL, oControl, BODY_NODE_CHEST, FALSE );
        effect eCtoPurple = EffectBeam( VFX_BEAM_MIND, oControl, BODY_NODE_CHEST, FALSE );
        effect eCtoBlue = EffectBeam( VFX_BEAM_COLD, oControl, BODY_NODE_CHEST, FALSE );

        effect eCto1L = EffectBeam( VFX_BEAM_DISINTEGRATE, oControl, BODY_NODE_CHEST, FALSE );
        effect e1Lto2L = EffectBeam( VFX_BEAM_DISINTEGRATE, o1L, BODY_NODE_CHEST, FALSE );
        effect e2Lto3L = EffectBeam( VFX_BEAM_DISINTEGRATE, o2L, BODY_NODE_CHEST, FALSE );
        effect e3Lto4L = EffectBeam( VFX_BEAM_DISINTEGRATE, o3L, BODY_NODE_CHEST, FALSE );
        effect e4Lto5L = EffectBeam( VFX_BEAM_DISINTEGRATE, o4L, BODY_NODE_CHEST, FALSE );
        effect e5Lto6L = EffectBeam( VFX_BEAM_DISINTEGRATE, o5L, BODY_NODE_CHEST, FALSE );
        effect e6Lto10L = EffectBeam( VFX_BEAM_DISINTEGRATE, o6L, BODY_NODE_CHEST, FALSE );
        effect e7Lto10L = EffectBeam( VFX_BEAM_DISINTEGRATE, o10L, BODY_NODE_CHEST, FALSE );
        effect e8Lto10L = EffectBeam( VFX_BEAM_DISINTEGRATE, o10L, BODY_NODE_CHEST, FALSE );
        effect e9Lto10L = EffectBeam( VFX_BEAM_DISINTEGRATE, o10L, BODY_NODE_CHEST, FALSE );

        effect eCto1R = EffectBeam( VFX_BEAM_DISINTEGRATE, oControl, BODY_NODE_CHEST, FALSE );
        effect e1Rto2R = EffectBeam( VFX_BEAM_DISINTEGRATE, o1R, BODY_NODE_CHEST, FALSE );
        effect e2Rto3R = EffectBeam( VFX_BEAM_DISINTEGRATE, o2R, BODY_NODE_CHEST, FALSE );
        effect e3Rto4R = EffectBeam( VFX_BEAM_DISINTEGRATE, o3R, BODY_NODE_CHEST, FALSE );
        effect e4Rto5R = EffectBeam( VFX_BEAM_DISINTEGRATE, o4R, BODY_NODE_CHEST, FALSE );
        effect e5Rto6R = EffectBeam( VFX_BEAM_DISINTEGRATE, o5R, BODY_NODE_CHEST, FALSE );
        effect e6Rto10R = EffectBeam( VFX_BEAM_DISINTEGRATE, o6R, BODY_NODE_CHEST, FALSE );
        effect e7Rto10R = EffectBeam( VFX_BEAM_DISINTEGRATE, o10R, BODY_NODE_CHEST, FALSE );
        effect e8Rto10R = EffectBeam( VFX_BEAM_DISINTEGRATE, o10R, BODY_NODE_CHEST, FALSE );
        effect e9Rto10R = EffectBeam( VFX_BEAM_DISINTEGRATE, o10R, BODY_NODE_CHEST, FALSE );

        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCtoBlack, oBlack ) );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCtoPurple, oPurple ) );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCtoBlue, oBlue ) );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCto1L, o1L ) );
        DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCto1R, o1R ) );
        DelayCommand( 8.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e1Lto2L, o2L ) );
        DelayCommand( 8.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e1Rto2R, o2R ) );
        DelayCommand( 14.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e2Lto3L, o3L ) );
        DelayCommand( 14.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e2Rto3R, o3R ) );
        DelayCommand( 20.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e3Lto4L, o4L ) );
        DelayCommand( 20.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e3Rto4R, o4R ) );
        DelayCommand( 26.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e4Lto5L, o5L ) );
        DelayCommand( 26.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e4Rto5R, o5R ) );
        DelayCommand( 32.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e5Lto6L, o6L ) );
        DelayCommand( 32.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e5Rto6R, o6R ) );
        DelayCommand( 38.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e6Lto10L, o10L ) );
        DelayCommand( 38.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e6Rto10R, o10R ) );
        DelayCommand( 40.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e7Lto10L, o7L ) );
        DelayCommand( 40.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e7Rto10R, o7R ) );
        DelayCommand( 41.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e8Lto10L, o8L ) );
        DelayCommand( 41.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e8Rto10R, o8R ) );
        DelayCommand( 42.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e9Lto10L, o9L ) );
        DelayCommand( 42.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, e9Rto10R, o9R ) );
        DelayCommand( 43.0, SendMessageToAllDMs( sName+" activated the "+sCardinal+" Cynosure in Tarkuul." ) );
    }
    else
    {
        return;
    }
    // * Store New State
    SetLocalInt( OBJECT_SELF, "X2_L_PLC_ACTIVATED_STATE", !nActive );
}
