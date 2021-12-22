/*
You can have 2 + 2,4,6 or 8 slots.

The first 2 slots are prefilled with your start and race point for each server
You can mix and match the rest as you see fit

1: start point
2: faction point
3-10: bindpoints

*/
//-------------------------------------------------------------------------------
// changes
//-------------------------------------------------------------------------------
//2008-10-08   disco     Putting people on randomised counter portal location from now on


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"
#include "amia_include"
#include "inc_ds_actions"
#include "nw_i0_generic"



//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


//starts the convo for a direct port
//oPC must be a DM and no portal is formed
void port_init_transport( object oPC, object oTarget );

//starts the transport part of the ds_porting convo
//this is called if a PC uses the wand
void port_init_porting( object oPC  );

//handles the porting of oPC and calls port_create_gate()
void port_porting( object oPC, int nSlot );

//creates the two gates and saves opposite locations on them
void port_create_gate( object oPC, object oBindpoint, string sBindpoint, location lGate2 );

//moves oPC to the opposite location of oGate
void port_use_gate( object oPC, object oGate );

//does the actual jumping if lWP is valid.
void JumpToPortal( object oPC, location lWP, location lOrigin );

//starts binding part of the ds_porting convo
void port_init_binding( object oPC, object oObject );

//handles binding to oObject in nSlot
void port_binding( object oPC, object oObject, int nSlot );

//starts Mythal part of the ds_porting convo
//set nForge to 1 if a forge is near (ie: wand can be upgraded)
void port_mythal_init( object oPC, object oWand, object oMythal, object oForge );

//handles mythal recharging of oWand with oMythal reagent
void port_mythal_charge( object oPC, object oWand, object oMythal );

//handles mythal upgrading of oWand with oMythal reagent
void port_mythal_upgrade( object oPC, object oWand, object oMythal );

//ports back to the place you came from before
//only works if you port back within 10 minutes
//if nIsCheck == 1 it only returns if a player can jump
int port_back( object oPC, int nIsCheck=0 );

//Jumps player to server and resolves variables
void server_jump( object oPC, string sWaypoint, int nGold );

//sets home slot
void port_set_home( object oPC, int nSlot, int nServer );


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void port_init_transport( object oPC, object oTarget ){

    int nDMstatus = GetLocalInt( oPC, "is_DM" );
    int i;

    if ( nDMstatus > 0 ){

        SetCustomToken( 4400, "Back to "+GetName( GetAreaFromLocation( GetLocalLocation( oTarget, "ds_origin" ) ) ) );
        SetLocalObject( oPC, "force_pc", oTarget );
    }
    else {

        DeleteLocalObject( oPC, "force_pc" );
        SendMessageToPC( oPC, "You cannot target a creature with this item." );
        return;
    }

    SetLocalObject( oPC, "ds_target", oTarget );

    for ( i=1; i<11; ++i ){

        if ( i != 2 ){

            SetLocalInt( oPC, "ds_check_"+IntToString( i ), 1 );
        }
    }

    AssignCommand( oPC, ActionStartConversation( oPC, "ds_porting", TRUE, FALSE ) );
}


void port_init_porting( object oPC ){

    string sBindpoint;
    string sTitle;
    object oCache = GetCache( "ds_bindpoint_storage" );
    object oWand  = GetLocalObject( oPC, "p_wand" );
    int i;
    int nToken;
    int nCustom1   = GetPCKEYValue( oPC, "bp_home1" );
    int nCustom2   = GetPCKEYValue( oPC, "bp_home2" );

    SendMessageToPC( oPC, "Your porting wand has "+IntToString( GetItemCharges( oWand ) - 1 )+" uses left." );

    SetLocalInt( oPC, "ds_check_1", 1 );
    SetLocalString( oPC, "ds_action", "ds_porting_act" );

    for ( i=11; i<21; ++i ){

        sBindpoint = "b_" + IntToString( GetPCKEYValue( oPC, "bp_"+IntToString( i-10 ) ) );
        sTitle     = GetLocalString( oCache, sBindpoint );
        nToken     = 4400+i;

        //custom home slot
        if ( ( i-10 ) == nCustom1 ){

            SetCustomToken( ( nToken + 10 ), "*" );
        }
        else if ( ( i-10 ) == nCustom2 ){

            SetCustomToken( ( nToken + 10 ), "**" );
        }
        else{

            SetCustomToken( ( nToken + 10 ), "" );
        }

        if ( sBindpoint == "b_0" || sBindpoint == "" ){

            SetCustomToken( nToken, "..." );
        }
        else if ( GetIsObjectValid( GetLocalObject( oCache, sBindpoint ) ) ){

            SetLocalInt( oPC, "ds_check_"+IntToString( i ), 1 );
            SetCustomToken( nToken, "<c þ >"+sTitle+"</c>" );
        }
        else{

            SetLocalInt( oPC, "ds_check_"+IntToString( i ), 1 );
            SetCustomToken( nToken, "<cþ  >"+sTitle+"</c>" );
        }
    }

    //standard home waypoint override
    sBindpoint = GetStartWaypoint( oPC );
    sTitle     = GetLocalString( oCache, sBindpoint );
    SetCustomToken( 4411, sTitle );
    SetLocalInt( oPC, "ds_check_11", 1 );


    if ( port_back( oPC, 1 ) == 1 ){

        SetLocalInt( oPC, "ds_check_10", 1 );
    }

    AssignCommand( oPC, ActionStartConversation( oPC, "ds_porting", TRUE, FALSE ) );
}

void port_porting( object oPC, int nSlot ){

    //deal with the charges
    object oWand        = GetLocalObject( oPC, "p_wand" );
    int nWandCharges    = GetItemCharges( oWand );

    if ( nWandCharges == 1 && !GetLocalInt( oPC, "jj_portal_domain" ) ){

        SendMessageToPC( oPC, "Your porting wand is out of power." );
        return;
    }

    //check for hostiles
    object oEnemy = GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC );

    if ( GetIsObjectValid( oEnemy ) && GetDistanceBetween( oPC, oEnemy ) < 20.0 ){

        SendMessageToPC( oPC, "Your cowardly portal fails to materialise because hostiles are nearby." );
        return;
    }

    if( !GetLocalInt( oPC, "jj_portal_domain" ) )
    {
        SetItemCharges( oWand, ( nWandCharges - 1 ) );
    }
    else
    {
        SendMessageToPC( oPC, "Your porting wand takes zero energy to function, thanks to the power of the Portal domain." );
    }

    string sBindpoint = "";

    if ( nSlot > 1 ){

        sBindpoint = "b_" + IntToString( GetPCKEYValue( oPC, "bp_"+IntToString( nSlot ) ) );
    }
    else{

        sBindpoint = GetStartWaypoint( oPC );
    }

    effect eFreeze    = EffectCutsceneImmobilize();
    effect eVis       = EffectVisualEffect( VFX_DUR_GLYPH_OF_WARDING );

    if ( GetGender( oPC ) != GENDER_FEMALE ){

        AssignCommand( oPC, PlaySound( "vs_chant_conj_lm" ) );
    }
    else{

        AssignCommand( oPC, PlaySound( "vs_chant_conj_lf" ) );
    }

    AssignCommand( oPC, ActionPlayAnimation( ANIMATION_LOOPING_CONJURE1, 1.0, 2.0 ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFreeze, oPC, 9.0 );
    DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oPC, 8.0 ) );

    object oCache     = GetCache( "ds_bindpoint_storage" );
    object oBindpoint = GetLocalObject( oCache, sBindpoint );
    location lGate2;

    //need to do this before calling port_create_gate
    if ( GetIsObjectValid( oBindpoint ) ){

        lGate2 = GenerateNewLocationFromLocation( GetLocation( oBindpoint ), ( 1.00 + ( d20()/10.0 ) ), IntToFloat( Random( 360 ) ), GetFacing( oBindpoint ) );
    }

    DelayCommand( 5.0, port_create_gate( oPC, oBindpoint, sBindpoint, lGate2 ) );
}

void port_create_gate( object oPC, object oBindpoint, string sBindpoint, location lGate2 ){

    object oGate1;
    object oGate2;
    location lGate1   = GetLocation( oPC );

    if ( GetIsObjectValid( oBindpoint ) ){

        DelayCommand( 5.0, JumpToPortal( oPC, lGate2, lGate1 ) );

        oGate1 = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_porting", lGate1 );
        oGate2 = CreateObject( OBJECT_TYPE_PLACEABLE, "solblue", lGate2 );

        SetLocalLocation( oGate1, "ds_origin", lGate2 );
        SetLocalLocation( oGate2, "ds_origin", lGate1 );

        //destroy opposite gate
        DestroyObject( oGate2, 20.0 );
    }
    else{

        //cleanup
        DeleteLocalLocation( oPC, "ds_origin" );
        DeleteLocalInt( oPC, "ds_origin" );

        //create server portal
        DelayCommand( 5.0, ActivatePortal( oPC, GetLocalString( GetModule(), "SisterServer" ), "n.a.", "", TRUE ) );

        //store info on PCKEY
        object oPCKEY = GetPCKEY( oPC );
        SetLocalString( oPC, "p_target", sBindpoint );
        SetLocalInt( oPC, "p_gold", 0 );

        //create gate circle
        oGate1 = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_porting2", lGate1 );
        SetLocalString( oGate1, "ds_target", sBindpoint );
    }

    //destroy gate
    DestroyObject( oGate1, 20.0 );
}

void port_use_gate( object oPC, object oGate ){

    //make sure people 'use' the gate only once
    string sKey = GetPCPublicCDKey( oPC, TRUE );

    if ( GetLocalInt( oGate, sKey ) == 1 ){

        return;
    }

    SetLocalInt( oGate, sKey, 1 );

    //freeze the pc
    effect eFreeze  = EffectCutsceneImmobilize();

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFreeze, oPC, 4.0 );

    //check if it's a server portal or not
    if ( GetResRef( oGate ) == "ds_porting" || GetResRef( oGate ) == "ds_porting3" ){

        location lWP    = GetLocalLocation( oGate, "ds_origin" );

        DelayCommand( 5.0, JumpToPortal( oPC, lWP, GetLocation( oPC ) ) );
    }
    else{

        string sBindpoint = GetLocalString( oGate, "ds_target" );

        //cleanup
        DeleteLocalLocation( oPC, "ds_origin" );
        DeleteLocalInt( oPC, "ds_origin" );

        //create server portal
        DelayCommand( 5.0, ActivatePortal( oPC, GetLocalString( GetModule(), "SisterServer" ), "n.a.", "", TRUE ) );

        //store info on PCKEY
        object oPCKEY = GetPCKEY( oPC );
        SetLocalString( oPC, "p_target", sBindpoint );
        SetLocalInt( oPC, "p_gold", 0 );
    }
}

void JumpToPortal( object oPC, location lWP, location lOrigin ){

    //make sure you only jump if there's a place to jump to
    if ( GetIsObjectValid( GetAreaFromLocation( lWP ) ) ){

        SetLocalLocation( oPC, "ds_origin", lOrigin );
        SetLocalInt( oPC, "ds_origin", GetRunTime() );

        AssignCommand( oPC, ClearAllActions() );
        AssignCommand( oPC, JumpToLocation( lWP ) );
    }
}

void port_init_binding( object oPC, object oObject ){

    string sBindpoint;
    string sTitle;
    object oCache = GetCache( "ds_bindpoint_storage" );
    object oWand  = GetItemPossessedBy( oPC, "ds_porting" );
    int nWandType = StringToInt( GetStringRight( GetResRef( oWand ), 1 ) );
    int nDMstatus = GetLocalInt( oPC, "is_DM" );
    int i;
    int nToken;

    SetLocalInt( oPC, "ds_check_2", 1 );
    SetLocalObject( oPC, "ds_target", oObject );
    SetLocalString( oPC, "ds_action", "ds_porting_act" );

    for ( i=13; i<21; ++i ){

        sBindpoint = "b_" + IntToString( GetPCKEYValue( oPC, "bp_"+IntToString( i-10 ) ) );
        sTitle     = GetLocalString( oCache, sBindpoint );
        nToken     = 4410+i;

        if ( ( i-12 ) > ( 2 * nWandType ) ){

            break;
        }

        SetLocalInt( oPC, "ds_check_"+IntToString( 10+i ), 1 );

        if ( sBindpoint == "b_0" || sBindpoint == "" ){

            SetCustomToken( nToken, "..." );
        }
        else if ( GetIsObjectValid( GetLocalObject( oCache, sBindpoint ) ) ){

            SetCustomToken( nToken, "<c þ >"+sTitle+"</c>" );
        }
        else{

            SetCustomToken( nToken, "<cþ  >"+sTitle+"</c>" );
        }
    }

    AssignCommand( oPC, ActionStartConversation( oPC, "ds_porting", TRUE, FALSE ) );
}

void port_binding( object oPC, object oObject, int nSlot ){

    int nBP         = GetLocalInt( oObject, "ds_bindpoint" );
    int nAlign      = GetLocalInt( oObject, "ds_align" );
    int nClass      = GetLocalInt( oObject, "ds_class_1" );
    int nRace       = GetLocalInt( oObject, "ds_race_1" );
    int nPcRace     = GetRaceInteger( GetRacialType( oPC ), GetSubRace( oPC ) );
    int i           = 1;
    int nResult     = 0;
    string sSlot    = "bp_"+IntToString( nSlot );

    if ( nAlign ){

        if ( nAlign == 1 && GetAlignmentGoodEvil( oPC ) != ALIGNMENT_GOOD ){

            nResult = -1;
        }
        else if ( nAlign == 2 && GetAlignmentGoodEvil( oPC ) != ALIGNMENT_NEUTRAL ){

            nResult = -1;
        }
        else if ( nAlign == 3 && GetAlignmentGoodEvil( oPC ) != ALIGNMENT_EVIL ){

            nResult = -1;
        }
        else if ( nAlign == 4 && GetAlignmentGoodEvil( oPC ) == ALIGNMENT_EVIL ){

            nResult = -1;
        }
        else if ( nAlign == 5 && GetAlignmentGoodEvil( oPC ) == ALIGNMENT_GOOD ){

            nResult = -1;
        }

        if ( nResult == -1 ){

            SendMessageToPC( oPC, "[<cþ  >You don't have the right alignment for this bindpoint.</c>]" );
            return;
        }
    }

    if ( nClass ){

        nResult = -1;

        while ( nClass > 0 ){

            if ( GetLevelByClass( nClass, oPC ) > 0 ){

                nResult = 1;
            }

            ++i;
            nClass      = GetLocalInt( oObject, "ds_class_"+IntToString( i ) );
        }

        if ( nResult == -1 ){

            SendMessageToPC( oPC, "[<cþ  >You don't have the right class(es) for this bindpoint.</c>]" );
            return;
        }
    }

    if ( nRace ){

        nResult = 0;
        i       = 1;

        while ( nRace > 0 ){

            if ( nPcRace == nRace ){

                nResult = 1;
                break;
            }

            ++i;
            nResult     = -1;
            nRace      = GetLocalInt( oObject, "ds_race_"+IntToString( i ) );
        }

        if ( nResult == -1 ){

            SendMessageToPC( oPC, "[<cþ  >You don't have the right race for this bindpoint.</c>]" );
            return;
        }
    }

    SetPCKEYValue( oPC, sSlot, nBP );

    effect eVis     = EffectVisualEffect( VFX_DUR_SPELLTURNING );
    DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oPC, 6.0 ) );
}

void port_mythal_init( object oPC, object oWand, object oMythal, object oForge ){

    clean_vars( oPC, 4 );

    int nWandType   = StringToInt( GetStringRight( GetResRef( oWand ), 1 ) );
    int nMythalType = StringToInt( GetStringRight( GetResRef( oMythal ), 1 ) );
    int nCharges    = GetItemCharges( oWand );
    int nBoost      = 10 * nMythalType;
    int nMax        = ( 10 * nWandType ) + 10;

    if ( nBoost + nCharges > nMax ){

        nBoost = nMax-nCharges;
    }

    SetLocalObject( oPC, "ds_target", oWand );
    SetLocalObject( oPC, "ds_mythal", oMythal );
    SetLocalString( oPC, "ds_action", "ds_porting_act" );
    SetLocalInt( oPC, "ds_check_3", 1 );

    if ( nMythalType < 5 && nMythalType > nWandType && GetIsObjectValid( oForge )  ){

        SetLocalInt( oPC, "ds_check_4", 1 );
        SetCustomToken( 4431, IntToString( ( 2*nMythalType ) ) );
        SetCustomToken( 4432, IntToString( ( 10*nMythalType ) ) );
    }

    if ( nMythalType < 5 && nCharges < nMax ){

        SetLocalInt( oPC, "ds_check_5", 1 );
        SetCustomToken( 4433, IntToString( nBoost ) );
    }

    AssignCommand( oPC, ActionStartConversation( oPC, "ds_porting", TRUE, FALSE ) );
}

void port_mythal_charge( object oPC, object oWand, object oMythal ){

    int nWandType   = StringToInt( GetStringRight( GetResRef( oWand ), 1 ) );
    int nMythalType = StringToInt( GetStringRight( GetResRef( oMythal ), 1 ) );
    int nCharges    = GetItemCharges( oWand );
    int nBoost      = ( 10 * nMythalType ) + nCharges;
    int nMax        = ( 10 * nWandType ) + 10;

    if ( nBoost > nMax ){

        nBoost = nMax;
    }

    //testing
    //SendMessageToPC( oPC, "<c¥  >Test: Wand can hold "+IntToString( nMax )+" charges.</c>" );
    //SendMessageToPC( oPC, "<c¥  >Test: Wand has "+IntToString( nCharges )+" charges.</c>" );
    //SendMessageToPC( oPC, "<c¥  >Test: Mythal adds "+IntToString( ( 10 * nMythalType ) )+" charges.</c>" );
    //SendMessageToPC( oPC, "<c¥  >Test: Setting wand to "+IntToString( nBoost )+" charges.</c>" );

    // Candy.
    AssignCommand( oPC, PlaySound( "sim_bonabil" ) );

    SetItemCharges( oWand, nBoost );

    DestroyObject( oMythal, 1.0 );
}

void port_mythal_upgrade( object oPC, object oWand, object oMythal ){

    string sResRef  ="ds_porting_" + GetStringRight( GetResRef( oMythal ), 1 );

    CreateItemOnObject( sResRef, oPC );

    // Candy.
    AssignCommand( oPC, PlaySound( "sff_strkholy" ) );

    DestroyObject( oWand, 0.5 );
    DestroyObject( oMythal, 1.0 );
}


int port_back( object oPC, int nIsCheck=0 ){

    int nPortTime  = GetLocalInt( oPC, "ds_origin" );
    location lBack = GetLocalLocation( oPC, "ds_origin" );

    if ( GetPCPlayerName( oPC ) == "darkhearted777" ){

        SendMessageToPC( oPC, "nPortTime="+IntToString( nPortTime ) );
        SendMessageToPC( oPC, "valid area="+IntToString( GetIsObjectValid( GetAreaFromLocation( lBack ) ) ) );
        SendMessageToPC( oPC, "GetRunTime() - nPortTime="+IntToString( GetRunTime() - nPortTime ) );
        SendMessageToPC( oPC, "nIsCheck="+IntToString( nIsCheck ) );
    }

    if ( GetRunTime() - nPortTime < 600 && GetIsObjectValid( GetAreaFromLocation( lBack ) ) ){

        if ( !nIsCheck ){

            DeleteLocalLocation( oPC, "ds_origin" );
            DeleteLocalInt( oPC, "ds_origin" );

            AssignCommand( oPC, ClearAllActions() );
            AssignCommand( oPC, JumpToLocation( lBack ) );
        }
    }
    else{

        return 0;
    }

    return 1;
}

void server_jump( object oPC, string sWaypoint, int nGold ){

    //create server portal
    object oModule  = GetModule();
    string sIP      = GetLocalString( oModule, "SisterServer" );

    SetLocalString( oPC, "p_target", sWaypoint );

    if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ){

        string sPassword = GetLocalString( oModule, "DM_password" );

        DelayCommand( 1.0, ActivatePortal( oPC, sIP, sPassword, "", TRUE ) );
        return;
    }

    //store info on PCKEY
    SetLocalInt( oPC, "p_gold", nGold );

    DelayCommand( 1.0, ActivatePortal( oPC, sIP, "n.a.", "", TRUE ) );
}

//sets home slot
void port_set_home( object oPC, int nSlot, int nServer ){

    if ( nServer == 1 ){

        SetPCKEYValue( oPC, "bp_home1", nSlot );
    }
    else{

        SetPCKEYValue( oPC, "bp_home2", nSlot );
    }
}

