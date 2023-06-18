// Alter Self widget. Changes skin, hair, tattoo, wings and tail on use.
// The variables are intended to be set via console commands.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/27/2011 PaladinOfSune    Initial Release
// 04/13/2013 PaladinOfSune    Added functionality for heads
// 04/27/2015 PaladinOfSune    Added optional checks, removed VFX
// 03/04/2016 PaladinOfSune    Added support for portrait, torso, arms and legs
// 06/18/2023 Frozen           Added Z axis function
//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_switches"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------
void AlterSelf( object oPC, object oItem );
void AlterSelfRevert( object oPC, object oItem );

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void ActivateItem()
{
    // Major variables.
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();

    int nAlterSet   = GetLocalInt( oItem, "alter_set" );

    // Alter the PC or revert to their original appearance.
    if( nAlterSet == 0 ) {
        AlterSelf( oPC, oItem );
    }
    else {
        AlterSelfRevert( oPC, oItem );
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

void AlterSelf( object oPC, object oItem )
{
    // Get the new appearance.
    int nSkin           = GetLocalInt( oItem, "alter_skin" );
    int nHair           = GetLocalInt( oItem, "alter_hair" );
    int nTattoo1        = GetLocalInt( oItem, "alter_tattoo1" );
    int nTattoo2        = GetLocalInt( oItem, "alter_tattoo2" );
    int nWings          = GetLocalInt( oItem, "alter_wings" );
    int nTail           = GetLocalInt( oItem, "alter_tail" );
    int nHead           = GetLocalInt( oItem, "alter_head" );
    int nTorso          = GetLocalInt( oItem, "alter_torso" );
    int nModel          = GetLocalInt( oItem, "alter_model" );

    int nLBicep         = GetLocalInt( oItem, "alter_lbicep" );
    int nLForearm       = GetLocalInt( oItem, "alter_lforearm" );
    int nLHand          = GetLocalInt( oItem, "alter_lhand" );
    int nRBicep         = GetLocalInt( oItem, "alter_rbicep" );
    int nRForearm       = GetLocalInt( oItem, "alter_rforearm" );
    int nRHand          = GetLocalInt( oItem, "alter_rhand" );

    int nLThigh         = GetLocalInt( oItem, "alter_lthigh" );
    int nLShin          = GetLocalInt( oItem, "alter_lshin" );
    int nLFoot          = GetLocalInt( oItem, "alter_lfoot" );
    int nRThigh         = GetLocalInt( oItem, "alter_rthigh" );
    int nRShin          = GetLocalInt( oItem, "alter_rshin" );
    int nRFoot          = GetLocalInt( oItem, "alter_rfoot" );

    float fZaxis        = GetLocalFloat( oItem, "alter_zaxis");

    string sPortrait    = GetLocalString( oItem, "alter_portrait" );

    // Get the original PC appearance and save on the widget.
    SetLocalInt( oItem, "revert_skin", GetColor( oPC, COLOR_CHANNEL_SKIN ) );
    SetLocalInt( oItem, "revert_hair", GetColor( oPC, COLOR_CHANNEL_HAIR ) );
    SetLocalInt( oItem, "revert_tattoo1", GetColor( oPC, COLOR_CHANNEL_TATTOO_1 ) );
    SetLocalInt( oItem, "revert_tattoo2", GetColor( oPC, COLOR_CHANNEL_TATTOO_2 ) );

    SetLocalInt( oItem, "revert_head", GetCreatureBodyPart( CREATURE_PART_HEAD, oPC ) );
    SetLocalInt( oItem, "revert_torso", GetCreatureBodyPart( CREATURE_PART_TORSO, oPC ) );

    SetLocalInt( oItem, "revert_lbicep", GetCreatureBodyPart( CREATURE_PART_LEFT_BICEP, oPC ) );
    SetLocalInt( oItem, "revert_lforearm", GetCreatureBodyPart( CREATURE_PART_LEFT_FOREARM, oPC ) );
    SetLocalInt( oItem, "revert_lhand", GetCreatureBodyPart( CREATURE_PART_LEFT_HAND, oPC ) );
    SetLocalInt( oItem, "revert_rbicep", GetCreatureBodyPart( CREATURE_PART_RIGHT_BICEP, oPC ) );
    SetLocalInt( oItem, "revert_rforearm", GetCreatureBodyPart( CREATURE_PART_RIGHT_FOREARM, oPC ) );
    SetLocalInt( oItem, "revert_rhand", GetCreatureBodyPart( CREATURE_PART_RIGHT_HAND, oPC ) );

    SetLocalInt( oItem, "revert_lthigh", GetCreatureBodyPart( CREATURE_PART_LEFT_THIGH, oPC ) );
    SetLocalInt( oItem, "revert_lshin", GetCreatureBodyPart( CREATURE_PART_LEFT_SHIN, oPC ) );
    SetLocalInt( oItem, "revert_lfoot", GetCreatureBodyPart( CREATURE_PART_LEFT_FOOT, oPC ) );
    SetLocalInt( oItem, "revert_rthigh", GetCreatureBodyPart( CREATURE_PART_RIGHT_THIGH, oPC ) );
    SetLocalInt( oItem, "revert_rshin", GetCreatureBodyPart( CREATURE_PART_RIGHT_SHIN, oPC ) );
    SetLocalInt( oItem, "revert_rfoot", GetCreatureBodyPart( CREATURE_PART_RIGHT_FOOT, oPC ) );

    SetLocalString( oItem, "revert_portrait", GetPortraitResRef( oPC ) );
    SetLocalFloat( oItem, "revert_zaxis", GetObjectVisualTransform(oPC, 23) );

    SetLocalInt( oItem, "revert_wings", GetCreatureWingType( oPC ) );
    SetLocalInt( oItem, "revert_tail", GetCreatureTailType( oPC ) );
    SetLocalInt( oItem, "revert_model", GetAppearanceType( oPC ) );
    SetLocalInt( oItem, "alter_set", 1 );

    // Set the PC to the new appearance.
    SetCreatureWingType( nWings, oPC );
    SetCreatureTailType( nTail, oPC );

    if( nHead != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_HEAD, nHead, oPC );
    }

    if( nTorso != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_TORSO, nTorso, oPC );
    }

    if( nLBicep != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_BICEP, nLBicep, oPC );
    }

    if( nLForearm != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_FOREARM, nLForearm, oPC );
    }

    if( nLHand != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_HAND, nLHand, oPC );
    }

    if( nRBicep != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_BICEP, nRBicep, oPC );
    }

    if( nRForearm != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_FOREARM, nRForearm, oPC );
    }

    if( nRHand != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_HAND, nRHand, oPC );
    }

    if( nLThigh != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_THIGH, nLThigh, oPC );
    }

    if( nLShin != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_SHIN, nLShin, oPC );
    }

    if( nLFoot != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_FOOT, nLFoot, oPC );
    }

    if( nRThigh != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_THIGH, nRThigh, oPC );
    }

    if( nRShin != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_SHIN, nRShin, oPC );
    }

    if( nRFoot != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_FOOT, nRFoot, oPC );
    }

    if( nSkin != 0 ) {
        SetColor( oPC, COLOR_CHANNEL_SKIN, nSkin );
    }

    if( nHair != 0 ) {
        SetColor( oPC, COLOR_CHANNEL_HAIR, nHair );
    }

    if( nTattoo1 != 0 ) {
        SetColor( oPC, COLOR_CHANNEL_TATTOO_1, nTattoo1 );
    }

    if( nTattoo2 != 0 ) {
        SetColor( oPC, COLOR_CHANNEL_TATTOO_2, nTattoo2 );
    }

    if( nModel != 0 ) {
        SetCreatureAppearanceType( oPC, nModel );
    }

    if( sPortrait != "" ) {
        SetPortraitResRef( oPC, sPortrait );
    }

    if ( fZaxis > 0.0) {
        SetObjectVisualTransform( oPC, 23, fZaxis);
    }
}

void AlterSelfRevert( object oPC, object oItem )
{
    // Get the original appearance.
    int nSkin       = GetLocalInt( oItem, "revert_skin" );
    int nHair       = GetLocalInt( oItem, "revert_hair" );
    int nTattoo1    = GetLocalInt( oItem, "revert_tattoo1" );
    int nTattoo2    = GetLocalInt( oItem, "revert_tattoo2" );
    int nWings      = GetLocalInt( oItem, "revert_wings" );
    int nTail       = GetLocalInt( oItem, "revert_tail" );
    int nHead       = GetLocalInt( oItem, "revert_head" );
    int nModel      = GetLocalInt( oItem, "revert_model" );

    int nTorso      = GetLocalInt( oItem, "revert_torso" );

    int nLBicep     = GetLocalInt( oItem, "revert_lbicep" );
    int nLForearm   = GetLocalInt( oItem, "revert_lforearm" );
    int nLHand      = GetLocalInt( oItem, "revert_lhand" );
    int nRBicep     = GetLocalInt( oItem, "revert_rbicep" );
    int nRForearm   = GetLocalInt( oItem, "revert_rforearm" );
    int nRHand      = GetLocalInt( oItem, "revert_rhand" );

    int nLThigh     = GetLocalInt( oItem, "revert_lthigh" );
    int nLShin      = GetLocalInt( oItem, "revert_lshin" );
    int nLFoot      = GetLocalInt( oItem, "revert_lfoot" );
    int nRThigh     = GetLocalInt( oItem, "revert_rthigh" );
    int nRShin      = GetLocalInt( oItem, "revert_rshin" );
    int nRFoot      = GetLocalInt( oItem, "revert_rfoot" );

    string sPortrait = GetLocalString( oItem, "revert_portrait" );
    float fZaxis    = GetLocalFloat( oItem, "revert_zaxis");

    SetLocalInt( oItem, "alter_set", 0 );

    // Set the PC to the original appearance.
    SetCreatureWingType( nWings, oPC );
    SetCreatureTailType( nTail, oPC );

    if( nHead != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_HEAD, nHead, oPC );
    }

    if( nTorso != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_TORSO, nTorso, oPC );
    }

    if( nLBicep != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_BICEP, nLBicep, oPC );
    }

    if( nLForearm != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_FOREARM, nLForearm, oPC );
    }

    if( nLHand != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_HAND, nLHand, oPC );
    }

    if( nRBicep != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_BICEP, nRBicep, oPC );
    }

    if( nRForearm != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_FOREARM, nRForearm, oPC );
    }

    if( nRHand != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_HAND, nRHand, oPC );
    }

    if( nLThigh != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_THIGH, nLThigh, oPC );
    }

    if( nLShin != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_SHIN, nLShin, oPC );
    }

    if( nLFoot != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_LEFT_FOOT, nLFoot, oPC );
    }

    if( nRThigh != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_THIGH, nRThigh, oPC );
    }

    if( nRShin != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_SHIN, nRShin, oPC );
    }

    if( nRFoot != 0 ) {
        SetCreatureBodyPart( CREATURE_PART_RIGHT_FOOT, nRFoot, oPC );
    }

    if( nSkin != 0 ) {
        SetColor( oPC, COLOR_CHANNEL_SKIN, nSkin );
    }

    if( nHair != 0 ) {
        SetColor( oPC, COLOR_CHANNEL_HAIR, nHair );
    }

    if( nTattoo1 != 0 ) {
        SetColor( oPC, COLOR_CHANNEL_TATTOO_1, nTattoo1 );
    }

    if( nTattoo2 != 0 ) {
        SetColor( oPC, COLOR_CHANNEL_TATTOO_2, nTattoo2 );
    }

    if( nModel != 0 ) {
        SetCreatureAppearanceType( oPC, nModel );
    }

    if( sPortrait != "" ) {
        SetPortraitResRef( oPC, sPortrait );
    }

    if ( fZaxis > 0.0) {
        SetObjectVisualTransform( oPC, 23, fZaxis);
    }
}