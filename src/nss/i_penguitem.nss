// Swamp Witch Flower (Pengu's Thing) item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/20/2004 jpavelch         Initial Release
// 10/16/2004 jpavelch         Removed admin requirement to use item.
// 05/05/2006 disco            Bugfix.
// 06/24/2006 disco            Tracer.

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "aps_include"
#include "amia_include"

//Toggles appearance between default and morph.
void MorphPC( object oPC, object oItem, int nAltAppearance, string sAltAppearanceName ){

    int nAppearanceSwitch = GetLocalInt(oItem,"ds_AppearanceSwitch");
    int nAppearance       = nAltAppearance;
    string szMessage      = "* Your body morphs ";

    if( nAppearanceSwitch == 0 ){

        //first time only  with a save to make sure the variables are stored
        szMessage += "into a " + sAltAppearanceName + "! *";
        SetLocalInt( oItem, "ds_OriginalAppearance", GetAppearanceType( oPC ) );
        SetLocalInt( oItem, "ds_AppearanceSwitch", 2 );
        ExportSingleCharacter(oPC);

    }
    else if( nAppearanceSwitch == 1 ){

        // disabled, enable form
        szMessage += "into a graceful " + sAltAppearanceName + "! *";
        SetLocalInt( oItem, "ds_AppearanceSwitch", 2 );

    }
    else if( nAppearanceSwitch == 2 ){

        // enabled, disable form
        szMessage += "back to your original form. *";
        nAppearance = GetLocalInt( oItem, "ds_OriginalAppearance" );
        SetLocalInt( oItem, "ds_AppearanceSwitch", 1 );

    }

    // notify the player
    FloatingTextStringOnCreature(szMessage,oPC,FALSE);

    //morph effect
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_POLYMORPH ), oPC );

    // morph
    SetCreatureAppearanceType(oPC,nAppearance);
}

//-------------------------------------------------------------------------------
// helper functions
//-------------------------------------------------------------------------------

void ActivateItem( ){
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    MorphPC(oPC, oItem, APPEARANCE_TYPE_PENGUIN, "penguin");
    TrackItems( oPC, oPC, "Swamp Witch Flower", "Use" );
}

void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}


