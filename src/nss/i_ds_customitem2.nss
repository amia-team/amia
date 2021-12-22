/*  i_ds_customitem2

--------
Verbatim
--------
Pools custom item request scripts

---------
Changelog
---------

Date    Name        Reason
------------------------------------------------------------------
061406  Disco       Start of header
061706  Disco       Bugfix
100106  Disco       Added some new items
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "aps_include"
#include "amia_include"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
//main functions
void MorphPC( object oPC, object oItem, int nAltAppearance, string sAltAppearanceName );


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);
            location lTarget = GetItemActivatedTargetLocation();


            if ( sItemName == "Them Bones" ){

                MorphPC ( oPC, oItem, APPEARANCE_TYPE_SKELETON_COMMON, "bonemachine" );

            }

            else if ( sItemName == "Claws" ){

                MorphPC( oPC, oItem, APPEARANCE_TYPE_CAT_JAGUAR, "jaguar" );

            }

            else if ( sItemName == "Flute" ){

                AssignCommand( oPC,ActionSpeakString("*"+GetName(oPC)+" plays a short song.*",TALKVOLUME_TALK));
                AssignCommand( oPC, PlaySound( "as_cv_flute1" ) );
                effect sSong = EffectVisualEffect( VFX_DUR_BARD_SONG );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, sSong, oPC, 10.0 );

            }

            else if ( sItemName == "Pierroriser" ){

                SetName( oTarget, "Pierre the " + GetName( oTarget ) );

            }

            else if ( sItemName == "Bolt of Cloth" ){

                object oSuit = CreateItemOnObject( "nw_mcloth006", oPC );
                SetName( oSuit, GetName( oTarget ) + "'s Robe" );

                //take gold
                TakeGoldFromCreature( 150, oPC );

            }

            else if ( sItemName == "DM Jumper Tool" ){

                object oJumper = GetLocalObject( oPC, "Jumper" );

                if ( oJumper == OBJECT_INVALID ) {

                    SetLocalObject( oPC, "Jumper", oTarget );
                    SendMessageToPC( oPC, GetName( oTarget ) + " selected for transportation!");

                }
                else if ( oTarget != oJumper) {

                    effect eFly = EffectDisappearAppear( lTarget );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFly, oJumper, 2.0 );
                    SendMessageToPC( oPC, GetName( oTarget ) + " transported!" );
                    DeleteLocalObject( oPC, "Jumper" );

                }
                else {

                    SendMessageToPC( oPC, GetName( oTarget ) + " deselected!");
                    DeleteLocalObject( oPC, "Jumper" );

                }

            }

            else if ( sItemName == "Polymorph Reset Tool" ){

                //delete variables on poly item
                SetLocalInt( oTarget, "ds_OriginalAppearance", 0);
                SetLocalInt( oTarget, "ds_AppearanceSwitch", 0 );
                SetLocalInt( oTarget, "PHE_AppearType", 0 );
                SetLocalInt( oTarget, "cs_original_appearance", 0 );
                SendMessageToPC( oPC, "Morph Item Flushed");

            }
            else if ( sItemName == "Casper's Autograph Book" ){

                //Casper's Autograph Book

                if ( GetIsPC( oTarget ) == TRUE ){

                    if ( GetLocalInt( oTarget, "ds_autograph" ) != 1 ){

                        //create autograph on target and block from further tries this session.
                        CreateItemOnObject( "ds_autograph", oTarget );
                        SetLocalInt( oTarget, "ds_autograph", 1 );
                        SendMessageToPC( oPC, "You force your autograph upon "+GetName( oTarget )+"." );

                    }
                    else {

                        SendMessageToPC( oPC, "You already abused this person." );

                    }
                }
                else {

                    SendMessageToPC( oPC, "You can only annoy real people, hellbard." );

                }
            }

            else if ( sItemName == "Kui's wooden plate" ){


                object oPlate = GetObjectByTag( "kui_cup" );

                if ( oPlate == OBJECT_INVALID ){

                    CreateObject( OBJECT_TYPE_PLACEABLE, "x0_plate", lTarget, FALSE, "kui_cup" );

                }
                else{

                    DestroyObject( oPlate, 0.0 );

                }
            }
            else if ( sItemName == "Sign Kit" ){


                object oSign = GetObjectByTag( "defendersign" );

                if ( oSign == OBJECT_INVALID ){

                    CreateObject( OBJECT_TYPE_PLACEABLE, "defendersign", lTarget );

                }
                else{

                    DestroyObject( oSign, 0.0 );

                }
            }
            else if ( sItemName == "Cage Kit" ){

                SendMessageToPC( oPC, "I updated your cage. Ask a DM to give you the one in Special 5. Cheers, Disco." );
            }
            else if ( sItemName == "Brognar's Bench" ){

                object oBench = GetObjectByTag( "ds_brog_bench" );

                if ( oBench == OBJECT_INVALID ){

                    CreateObject( OBJECT_TYPE_PLACEABLE, "ds_brog_bench", lTarget );

                }
                else{

                    DestroyObject( oBench, 0.0 );

                }
            }
            else if ( sItemName == "Hagger" ){

                MorphPC( oPC, oItem, APPEARANCE_TYPE_SEA_HAG, "n Annis Hag" );

            }
            else if ( sItemName == "DM Clock" ){

                int nRunTime = GetRunTime();
                int nLogTime = nRunTime - GetLocalInt( oTarget, "session_start" );

                SendMessageToPC( oPC, "Server run time: " + IntToString( (nRunTime/60) ) + " minutes." );
                SendMessageToPC( oPC, "Time to reset: " + IntToString( 232 - (nRunTime/60) ) + " minutes." );
                SendMessageToPC( oPC, "Your login time: " + IntToString( (nLogTime/60) ) + " minutes." );

            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------

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
        szMessage += "into a " + sAltAppearanceName + "! *";
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
