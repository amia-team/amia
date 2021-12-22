//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_crtrap_init
//group: trap crafting
//used as: init script at start of craft convo (traps only)
//date:  2011-May-03
//author: Selmak

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_crafting"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

// Checks to see if crafting is allowed in this area
// Exterior areas in Cordor and Wiltun are barred
// Market hall and Temple of Waukeen are barred
// Entry areas are barred
// If TRUE, a reduced selection of crafting options are presented
int GetIsCraftingRestricted( object oArea );

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int GetIsCraftingRestricted( object oArea ){

    string sResRef = GetResRef( oArea );
    string sSubString;

    // If this area is above ground AND exterior
    if ( GetIsAreaAboveGround( oArea ) && !GetIsAreaInterior( oArea ) ){

        sSubString = GetSubString( sResRef, 0, 6 );
        if ( sSubString == "cordor" ) return TRUE;
        if ( sSubString == "rua_wi" ) return TRUE;

    }

    // Other places not covered by the above rules
    if ( sResRef == "cordor_market" ) return TRUE; // Market hall
    if ( sResRef == "cordor_temple" ) return TRUE; // Temple of Waukeen
    if ( sResRef == "rht_ds_wiltun" ) return TRUE; // Fortess Wiltun
    if ( sResRef == "entry002" ) return TRUE; // Domaintencance
    if ( sResRef == "maintenance_sa" ) return TRUE; // Subrace Activator
    if ( sResRef == "maintanence_ta" ) return TRUE; // Travel Agency

    // re-using string variable
    sSubString = GetTag( oArea );
    if ( sSubString == "amia_entry" ) return TRUE; // Entry area

    return FALSE;


}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
int StartingConditional(){

    object oPC = GetPCSpeaker();

    object oArea = GetArea( oPC );

    if ( !GetIsCraftingRestricted( oArea ) ) return FALSE;


    clean_vars( oPC, 4 );

    SetLocalString( oPC, "ds_action", "ds_crafting_act" );

    DeleteLocalInt( oPC, "crft_it_type" );
    DeleteLocalInt( oPC, "crft_it_model" );
    SetLocalInt( oPC, "is_crafting", 1 );

    //applies the unconsciousness visual effect
    effect eUltravision = EffectUltravision( );
    effect eFreeze      = EffectCutsceneImmobilize();
    effect eLinked      = ExtraordinaryEffect( EffectLinkEffects( eUltravision, eFreeze ) );

    //apply the effect
    AssignCommand( oPC, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLinked, oPC ) );

    //feedback
    SendMessageToPC( oPC, "[Applying crafting effects]" );

    return TRUE;
}
