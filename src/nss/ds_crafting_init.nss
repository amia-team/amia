//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_crafting_init
//group: armour crafting
//used as: init script at start of craft convo
//date:  2008-06-06
//author: Disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_crafting"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
int StartingConditional(){

    object oPC = GetPCSpeaker();

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
    SendMessageToPC( oPC, "[Applying crafting effects.]" );

    return TRUE;
}
