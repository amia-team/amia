/*  i_ds_customitem4

--------
Verbatim
--------
Pools custom item request scripts

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void CallOFTheSuccubus( object oPC );
void GetSpareHead( object oPC, object oItem );
void SetSpareHead( object oPC, object oItem );
void SharessanBox( object oPC, object oTarget, location lTarget );
void CreateItem( object oPC, object oTarget, location lTarget, string sResRef, string sName="" );
void TheRisen( object oPC );
void Visage( object oPC, location lTarget );
int GetIsModuleEffect( effect eEffect );
void PolyToFairyDragon( object oPC );
void SignWidget( object oPC, object oItem, location lTarget );

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

            if ( GetResRef( oItem ) == "ds_sign" ){

                SignWidget( oPC, oItem, lTarget );
            }
            else if ( sItemName == "Sucky Shape" ){

                CallOFTheSuccubus( oPC );
            }
            else if ( sItemName == "Where's My Head?" ){

                GetSpareHead( oPC, oItem );
            }
            else if ( sItemName == "Spare Head" ){

                SetSpareHead( oPC, oItem );
            }
            else if ( sItemName == "Sharessan Kit" ){

                SharessanBox( oPC, oTarget, lTarget );
            }
            else if ( sItemName == "Module #1" ){

                CreateItem( oPC, oTarget, lTarget, "rt_energydrink", "Coffee" );
                AssignCommand( oPC, SpeakString( ">INIT MODULE #1" ) );
                AssignCommand( oPC, SpeakString( ">CREATE: COFFEE" ) );
            }
            else if ( sItemName == "Module #2" ){

                CreateItem( oPC, oTarget, lTarget, "rt_steak001", "Roastbeef" );
                AssignCommand( oPC, SpeakString( ">INIT MODULE #2" ) );
                AssignCommand( oPC, SpeakString( ">CREATE: ROASTBEEF" ) );
            }
            else if ( sItemName == "Vesz'fein's Virulent Visage" ){

                Visage( oPC, lTarget );
            }
            else if ( sItemName == "Thighbone" ){

                TheRisen( oPC );
            }
            else if ( sItemName == "Dice" ){

                SetLocalString( oPC, "ds_action", "dg_dice_call" );
                AssignCommand( oPC, ActionStartConversation( oPC, "dg_dicebag", TRUE, FALSE ) );
            }
            else if ( sItemName == "Fairy Dragon Form" ){

                PolyToFairyDragon( oPC );
            }


        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
void CallOFTheSuccubus( object oPC ){

    // Check to make sure wings not made permanent from crash or logging.

    if( GetCreatureWingType( oPC ) != CREATURE_WING_TYPE_NONE ){

        SetCreatureWingType( CREATURE_WING_TYPE_NONE, oPC );
        return;
    }

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_LOS_EVIL_20 ), oPC );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HARM ), oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_EYES_RED_FLAME_HUMAN_FEMALE ), oPC, 180.0 );
    SetCreatureWingType( CREATURE_WING_TYPE_DEMON, oPC );

    DelayCommand( 180.0, SetCreatureWingType( CREATURE_WING_TYPE_NONE, oPC ) );
    DelayCommand( 180.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_LOS_EVIL_20 ), oPC ) );
    DelayCommand( 180.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HARM ), oPC ) );
}


void GetSpareHead( object oPC, object oItem ){

    int nHead = GetCreatureBodyPart( CREATURE_PART_HEAD, oPC );

    SetLocalInt( oItem, "Head", nHead );

    SetName( oItem, "Spare Head" );

    ExportSingleCharacter( oPC );

    AssignCommand( oPC, SpeakString( "[[[Deheader Initialised]]]" ) );
}

void SetSpareHead( object oPC, object oItem ){

    int nHead = GetLocalInt( oItem, "Head" );

    SetCreatureBodyPart( CREATURE_PART_HEAD, nHead, oPC );

    SendMessageToPC( oPC, "[[[Where's your head at?]]]" );
}


void SharessanBox( object oPC, object oTarget, location lTarget ){

    if ( oTarget == oPC ){

        //cycle through options
        int nOption     = GetLocalInt( oPC, "nShBox" );
        string sMessage = "Pouch will give ";

        if ( nOption == 0 ){

            ++nOption;
            sMessage = sMessage + "Skin Lotion.";
        }
        else if ( nOption == 1 ){

            ++nOption;
            sMessage = sMessage + "Minty Sticks.";
        }
        else if ( nOption == 2 ){

            ++nOption;
            sMessage = sMessage + "Pomade.";
        }
        else{

            nOption = 0;
            sMessage = sMessage + "Soothing Balm.";
        }

        SetLocalInt( oPC, "nShBox", nOption );
        SendMessageToPC( oPC, sMessage );
    }
    else if ( GetIsObjectValid( GetAreaFromLocation( lTarget ) ) ){

        int nOption = GetLocalInt( oPC, "nShBox" );
        string sMessage = "*Places a ";
        string sResRef  = "ds_shitem_" + IntToString( nOption );

        if ( nOption == 1 ){

            ++nOption;
            sMessage = sMessage + "Skin Lotion";
        }
        else if ( nOption == 2 ){

            ++nOption;
            sMessage = sMessage + "Minty Sticks";
        }
        else if ( nOption == 3 ){

            ++nOption;
            sMessage = sMessage + "Pomade";
        }
        else{

            nOption = 0;
            sMessage = sMessage + "Soothing Balm";
        }

        sMessage = sMessage + " on the ground*";

        CreateObject( OBJECT_TYPE_ITEM, sResRef, lTarget );

        AssignCommand( oPC, TakeGoldFromCreature( 50, oPC, TRUE ) );

        AssignCommand( oPC, SpeakString( sMessage ) );
    }
}


void CreateItem( object oPC, object oTarget, location lTarget, string sResRef, string sName="" ){

    object oItem;

    if ( oTarget == oPC ){

        oItem = CreateItemOnObject( sResRef, oTarget );
    }
    else{

        oItem = CreateObject( OBJECT_TYPE_ITEM, sResRef, lTarget );
    }

    if ( sName != "" ){

        SetName( oItem, sName );
    }
}

void TheRisen( object oPC ){

    DelayCommand( 1.0, ExecuteScript( "ds_animatedead", oPC ) );
}

void Visage( object oPC, location lTarget ){

    string sTag    = "ds_doriangay";
    object oVisage = GetObjectByTag( sTag );

    if ( GetIsObjectValid( oVisage ) ){

        DestroyObject( oVisage );

        effect eLoop=GetFirstEffect(oPC);

        while ( GetIsEffectValid( eLoop ) ){

            if ( GetEffectType( eLoop ) == EFFECT_TYPE_VISUALEFFECT && GetIsModuleEffect( eLoop ) ){

                RemoveEffect(oPC, eLoop);
            }

            if ( GetEffectType( eLoop ) == EFFECT_TYPE_SKILL_INCREASE && GetIsModuleEffect( eLoop ) ){

                RemoveEffect(oPC, eLoop);
            }

            if ( GetEffectType( eLoop ) == EFFECT_TYPE_ABILITY_DECREASE && GetIsModuleEffect( eLoop ) ){

                RemoveEffect(oPC, eLoop);
            }

            eLoop=GetNextEffect(oPC);
        }
    }
    else{

        CreateObject( OBJECT_TYPE_PLACEABLE, sTag, lTarget );

        effect eEffect  = EffectVisualEffect( VFX_DUR_PROTECTION_EVIL_MAJOR );
        eEffect         = EffectLinkEffects( EffectSkillIncrease( SKILL_BLUFF, 10 ), eEffect );
        eEffect         = EffectLinkEffects( EffectAbilityDecrease( ABILITY_WISDOM, 6 ), eEffect );
        eEffect         = ExtraordinaryEffect( eEffect );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEffect, oPC );
    }
}

int GetIsModuleEffect( effect eEffect ){

    if ( GetEffectCreator( eEffect ) != GetModule() ){

        return 0;
    }

    if ( GetEffectDurationType( eEffect ) != DURATION_TYPE_PERMANENT ){

        return 0;
    }

    if ( GetEffectSubType( eEffect ) != SUBTYPE_EXTRAORDINARY ){

        return 0;
    }

    return 1;
}

void PolyToFairyDragon( object oPC ){

    effect ePoly = EffectPolymorph( POLYMORPH_TYPE_WYRMLING_WHITE );

    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

    // Apply the visual effect to the target
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

    // Apply the effect to the object
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC);
}


void  SignWidget( object oPC, object oItem, location lTarget ){

    string sTag  = "ds_sign_"+GetPCPublicCDKey( oPC );
    object oSign = GetObjectByTag( sTag );

    if ( GetIsObjectValid( oSign ) ){

        DestroyObject( oSign );
    }
    else{

        oSign = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_placard4", lTarget, FALSE, sTag );
        SetUseableFlag( oSign, TRUE );
        SetPlotFlag( oSign, FALSE );
        SetName( oSign, GetName( oPC )+"'s "+GetName( oItem ) );
    }
}

