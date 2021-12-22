// Custom skinchanger widget. Changes skin color, wings type and appearance on use.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/27/2011 PaladinOfSune    Initial Release
//
//
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

    effect eVis     = EffectVisualEffect( VFX_IMP_POLYMORPH );
    int nAlterSet   = GetLocalInt( oItem, "alter_set" );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

    // Alter the PC or revert to their original appearance.
    if( nAlterSet == 0 ) {
        DelayCommand( 1.0, AlterSelf( oPC, oItem ) );
    }
    else {
        DelayCommand( 1.0, AlterSelfRevert( oPC, oItem ) );
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
    int nSkin       = 60;
    int nAppearance = 3;
    int nWings      = 14;
    int nHair       = 60;

    // Get the original PC appearance and save on the widget.
    SetLocalInt( oItem, "revert_hair", GetColor( oPC, COLOR_CHANNEL_HAIR ) );
    SetLocalInt( oItem, "revert_skin", GetColor( oPC, COLOR_CHANNEL_SKIN ) );
    SetLocalInt( oItem, "revert_wings", GetCreatureWingType( oPC ) );
    SetLocalInt( oItem, "revert_appearance", GetAppearanceType( oPC ) );
    SetLocalInt( oItem, "alter_set", 1 );

    // Set the PC to the new appearance.
    SetColor( oPC, COLOR_CHANNEL_SKIN, nSkin );
    SetColor( oPC, COLOR_CHANNEL_HAIR, nHair );
    SetCreatureWingType( nWings, oPC );
    SetCreatureAppearanceType( oPC, nAppearance );
}

void AlterSelfRevert( object oPC, object oItem )
{
    // Get the original appearance.
    int nSkin       = GetLocalInt( oItem, "revert_skin" );
    int nWings      = GetLocalInt( oItem, "revert_wings" );
    int nAppearance = GetLocalInt( oItem, "revert_appearance" );
    int nHair       = GetLocalInt( oItem, "revert_hair" );

    SetLocalInt( oItem, "alter_set", 0 );

    // Set the PC to the original appearance.
    SetColor( oPC, COLOR_CHANNEL_SKIN, nSkin );
    SetColor( oPC, COLOR_CHANNEL_HAIR, nHair );
    SetCreatureWingType( nWings, oPC );
    SetCreatureAppearanceType( oPC, nAppearance );
}
