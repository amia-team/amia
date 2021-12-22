//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trans_actions
//group:   transmutation
//used as: action script
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_car"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void CreateGargoyle( object oPC );



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC  = GetLastUsedBy();
    object oPLC = OBJECT_SELF;
    string sTag = GetTag( oPLC );
    int nGreed = GetLocalInt (oPC, "nGreed");
    int nWrath = GetLocalInt (oPC, "nWrath");
    int nHate = GetLocalInt (oPC, "nHate");
    int nMisery = GetLocalInt (oPC, "nMisery");

    if ( sTag == "rua_candle_1" ||
         sTag == "rua_candle_2" ||
         sTag == "rua_candle_3" ||
         sTag == "rua_candle_4" ||
         sTag == "rua_candle_5" ){


        if (nHate == 1 && nWrath == 1 && nGreed == 1 && nMisery == 1)
        {
            object oTrigger = GetLocalObject( oPLC, "trigger" );

            if ( !GetIsObjectValid( oTrigger ) ){

                oTrigger = GetNearestObjectByTag( "rua_summoning" );

                SetLocalObject( oPLC, "trigger", oTrigger );
            }

            object oCircle = GetLocalObject( oTrigger, "circle" );

            if ( !GetIsObjectValid( oCircle ) ){

                oCircle = GetNearestObjectByTag( "rua_summ_circle" );

                SetLocalObject( oTrigger, "circle", oCircle );
            }

            // * note that nActive == 1 does  not necessarily mean the placeable is active
            // * that depends on the initial state of the object
            int nActive = GetLocalInt( oTrigger, sTag );

            // * Play Appropriate Animation
            if ( !nActive ) {

                ActionPlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );

                SetLocalInt( oTrigger, sTag, !nActive );

                if ( GetLocalInt( oTrigger, "rua_candle_1" ) &&
                     GetLocalInt( oTrigger, "rua_candle_2" ) &&
                     GetLocalInt( oTrigger, "rua_candle_3" ) &&
                     GetLocalInt( oTrigger, "rua_candle_4" ) &&
                     GetLocalInt( oTrigger, "rua_candle_5" ) ){

                    AssignCommand( oCircle, ActionPlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) );

                    object oVictim = GetFirstInPersistentObject( oTrigger );

                    if ( GetIsPC( oVictim ) || GetIsPC( GetMaster( oVictim ) ) ){

                        object oDemon = ds_spawn_critter( oVictim, "rua_demon", GetLocation( oCircle ), TRUE );

                        DelayCommand( 3.0, AssignCommand( oDemon, PlayVoiceChat( VOICE_CHAT_BADIDEA ) ) );
                    }
                }
            }
            else {

                ActionPlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE );

                SetLocalInt( oTrigger, sTag, !nActive );

                AssignCommand( oCircle, ActionPlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
            }
        }
        else
        {
            SendMessageToPC (oPC, "Nothing happens.");
        }
    }
    else if ( sTag == "rua_throne" ){

        int nStatue = GetLocalInt( oPLC, "count" );

        if ( !nStatue ){

            nStatue = 1;
            SetLocalInt( oPLC, "count", 1 );

            SetBlockTime();
        }
        else if ( nStatue == 1 && GetIsBlocked() < 1 ){

            nStatue = 2;

            DestroyObject( oPLC, 1.0 );
        }
        else {

            effect eHarm = EffectDamage( d6( 6 ), DAMAGE_TYPE_ELECTRICAL );
            effect eVis  = EffectVisualEffect( VFX_IMP_LIGHTNING_M  );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eHarm, oPC );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
        }

        if ( nStatue == 1 || nStatue == 2  ){

            object oStatue   = GetNearestObjectByTag( "rua_gargoyle_"+IntToString( nStatue ) );

            AssignCommand( oStatue, CreateGargoyle( oPC ) );
        }
    }
    else if ( sTag == "rua_mirror" ){

        AddInsanity( oPC, 55 );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void CreateGargoyle( object oPC ){

    effect eMind     = EffectVisualEffect( VFX_IMP_HOLY_AID );
    object oGargoyle = ds_spawn_critter( oPC, "rua_gargoyle", GetLocation( OBJECT_SELF ) );
    effect eDam      = EffectDamage( 500 );

    SetPlotFlag( OBJECT_SELF, FALSE );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, OBJECT_SELF );

    DelayCommand( 0.1, AssignCommand( oGargoyle, ActionAttack( oPC ) ) );
}


