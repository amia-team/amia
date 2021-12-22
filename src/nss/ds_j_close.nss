//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_close
//group:   Jobs & crafting
//used as: OnClose event of a PLC
//date:    december 2008
//author:  disco

//-------------------------------------------------------------------------------
// changelog
//-------------------------------------------------------------------------------
// 08 March 2011 - Selmak added support for specific options at leatherworker's
//                 bench (ds_j_leatherbench) so that if leather is added to the
//                 bench then only leather goods will show in conversation, and
//                 if hide is added to the bench only hide options will be shown
// 18 June  2011 - Selmak added support for cloned job system placeables.


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "inc_ds_j_lib"


//gambler's mat
void ds_j_CloseDiceMat( object oPC ){

    object oMat    = OBJECT_SELF;
    object oOwner  = GetLocalObject( oMat, DS_J_USER );
    int nGold      = GetGold( oMat );
    int nJob       = 90;
    int nRank      = ds_j_GetJobRank( oOwner, nJob );

    //SendMessageToPC( oPC, CLR_RED+"Debug: Bank="+GetName( oOwner ) );
    //SendMessageToPC( oPC, CLR_RED+"Debug: Player="+GetName( oPC ) );
    //SendMessageToPC( oPC, CLR_RED+"Debug: Gold="+IntToString( nGold ) );
    //SendMessageToPC( oPC, CLR_RED+"Debug: nRank="+IntToString( nRank ) );

    if ( oOwner == oPC ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can't play with yourself." + CLR_END );
    }
    else if ( nGold == 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You need to put some money in this mat." + CLR_END );
        SendMessageToPC( oOwner, CLR_ORANGE+GetName( oPC )+" didn't put money in your mat." + CLR_END );
    }
    else if ( GetDistanceBetween( oPC, oOwner ) > 10.0 || !GetIsPC( oOwner ) ){

        SendMessageToPC( oPC, CLR_ORANGE+"Can't find the owner of this mat. Mat removed." + CLR_END );

        DestroyObject( oMat );
    }
    else if ( nGold > nRank * 5000 ){

        SendMessageToPC( oPC, CLR_ORANGE+"Maximum stake is "+IntToString( nRank * 5000 )+" GP. Lower your stake." + CLR_END );
        SendMessageToPC( oOwner, CLR_ORANGE+GetName( oPC )+" put too much money in your mat." + CLR_END );
    }
    else if ( nGold > GetGold( oOwner ) ){

        SendMessageToPC( oPC, CLR_ORANGE+"The bank doesn't have enough money. Lower your stake." + CLR_END );
        SendMessageToPC( oOwner, CLR_ORANGE+GetName( oPC )+" put too much money in your mat." + CLR_END );
    }
    else{

        int nTime = GetServerRunTime() - GetLocalInt( oMat, DS_J_TIME );

        if ( nTime > DS_J_SOURCEDELAY ){

            //block for DS_J_SOURCEDELAY seconds
            SetLocalInt( oMat, DS_J_TIME, GetServerRunTime() );

            int nResult = ds_j_StandardRoll( oOwner, nJob );
            nRank       = ds_j_GiveStandardXP( oOwner, nJob, nResult );

            if ( nResult > 1 ){

                SendMessageToPC( oOwner, CLR_ORANGE+"You manage to pocket a small part of the stake without anyone noticing." + CLR_END );
                GiveGoldToCreature( oOwner, 1 + FloatToInt( nGold * 0.05 ) );
            }

            GiveCorrectedXP( oPC, ( 10 * nRank ), "Job", 0 );
        }
        else{

            SendMessageToPC( oPC, CLR_ORANGE+"This object has a cooldown time of 2 minutes. No XP granted." + CLR_END );
            SendMessageToPC( oOwner, CLR_ORANGE+"This object has a cooldown time of 2 minutes. No XP granted." + CLR_END );
        }

        ds_take_item( oMat, "NW_IT_GOLD001" );

        int nDie1 = d12();
        int nDie2 = d12();

        if ( nDie1 == nDie2 ){

            SpeakString( CLR_ORANGE+IntToString( nDie1 )+" vs "+IntToString( nDie2 )+". Tie, bank wins!"+CLR_END );
            GiveGoldToCreature( oOwner, nGold );
        }
        else if ( nDie1 > nDie2 ){

            SpeakString( CLR_ORANGE+IntToString( nDie1 )+" vs "+IntToString( nDie2 )+". Bank wins!"+CLR_END );
            GiveGoldToCreature( oOwner, nGold );
        }
        else{

            SpeakString( CLR_ORANGE+IntToString( nDie1 )+" vs "+IntToString( nDie2 )+". Player wins!"+CLR_END );
            GiveGoldToCreature( oPC, nGold * 2 );
            TakeGoldFromCreature( nGold, oOwner, TRUE );
        }
    }
}

//beggar's / performer's bowl
void ds_j_CloseBowl( object oPC ){

    object oBowl  = OBJECT_SELF;
    object oOwner = GetLocalObject( oBowl, DS_J_USER );
    string sKey   = GetPCPublicCDKey( oPC, TRUE );
    int nGold     = GetGold( oBowl );
    int nJob      = GetLocalInt( oBowl, DS_J_JOB );

    if ( oOwner == oPC ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can't donate to yourself." + CLR_END );
    }
    else if ( nGold == 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You need to put some money in this bowl." );
    }
    else if ( GetDistanceBetween( oPC, oOwner ) > 10.0 || !GetIsPC( oOwner ) ){

        SendMessageToPC( oPC, CLR_ORANGE+"Can't find the owner of this bowl. Bowl removed." );
        DestroyObject( oBowl );
    }
    else{

        int nTime = GetServerRunTime() - GetLocalInt( oBowl, DS_J_TIME );

        if ( nTime > DS_J_SOURCEDELAY ){

            //block for DS_J_SOURCEDELAY seconds
            SetLocalInt( oBowl, DS_J_TIME, GetServerRunTime() );

            int nResult     = ds_j_StandardRoll( oOwner, nJob );
            int nRank       = ds_j_GiveStandardXP( oOwner, nJob, nResult );

            GiveCorrectedXP( oPC, ( 10 * nRank ), "Job", 0 );
        }
        else{

            SendMessageToPC( oPC, CLR_ORANGE+"This object has a cooldown time of 2 minutes. No XP granted." + CLR_END );
            SendMessageToPC( oOwner, CLR_ORANGE+"This object has a cooldown time of 2 minutes. No XP granted." + CLR_END );
        }

        ds_take_item( oBowl, "NW_IT_GOLD001" );

        GiveGoldToCreature( oOwner, nGold );
    }
}

void ds_j_TraderConvo( object oPC, object oPLC ){

    object oUser = GetLocalObject( oPLC, DS_J_USER );

    SetLocalString( oPC, "ds_action", "ds_j_storage_act" );
    SetLocalObject( oPC, "ds_target", oPLC );

    if ( oUser == oPC ){

        SetLocalInt( oPC, "ds_check_1", 1 );
    }
    else{

        SetLocalInt( oPC, "ds_check_2", 1 );
    }

    AssignCommand( oPC, ActionStartConversation( oPC, "ds_j_storage", TRUE, FALSE ) );
}



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oSource   = OBJECT_SELF;
    object oPC       = GetLastClosedBy();
    string sTag      = GetTag( oSource );
    //Gets the cloned placeable tag if available
    string sCloneTag = GetLocalString( oSource, "clone_tag" );
    string sResRef   = GetResRef( oSource );
    int    nResource = 0;

    //This line allows the use of the clone tag instead of the object tag
    if ( sCloneTag != "" ) sTag = sCloneTag;

    //if ( GetStringLeft( GetResRef( GetArea( oPC ) ), 5 ) != "ds_j_" ){

        //SendMessageToPC( oPC, "Sorry, the job system isn't ready yet." );
        //return;
    //}

    clean_vars( oPC, 4 );

    if ( sResRef == "ds_j_trader" ){

        ds_j_TraderConvo( oPC, oSource );
        return;
    }

    SetLocalString( oPC, "ds_action", "ds_j_plc_act" );
    SetLocalObject( oPC, "ds_target", OBJECT_SELF );

    //initialise source
    ds_j_InitialiseSource( oSource );

    if ( sTag == "ds_j_smelting_oven" ){

        SetLocalInt( oPC, "ds_check_1", 1 );
    }
    else if ( sTag == "ds_j_sawhorse" ){

        SetLocalInt( oPC, "ds_check_2", 1 );
    }
    else if ( sTag == "ds_j_curing" ){

        SetLocalInt( oPC, "ds_check_3", 1 );
    }
    else if ( sTag == "ds_j_leatherbench" ){

        SetLocalInt( oPC, "ds_check_4", 1 );

        nResource = ds_j_GetResourceID( oPC, GetFirstItemInInventory( oSource ) );
        // SendMessageToPC( oPC, "First item on the bench is resource ID " +IntToString( nResource ) );
        // If first resource is leather or wyvern leather
        if ( nResource == 36 || nResource == 228 ){

            SetLocalInt( oPC, "ds_check_36", 1);
        }
        // If first resource is hide or wyvern hide
        if ( nResource == 34 || nResource == 476 || nResource == 218 ){

            SetLocalInt( oPC, "ds_check_37", 1);
        }
    }
    else if ( sTag == "ds_j_butcherslab" ){

        SetLocalInt( oPC, "ds_check_5", 1 );
    }
    else if ( sTag == "ds_j_windmill" ){

        SetLocalInt( oPC, "ds_check_6", 1 );
    }
    else if ( sTag == "ds_j_cookingpot" ){

        SetLocalInt( oPC, "ds_check_7", 1 );
    }
    else if ( sTag == "ds_j_bakeroven" ){

        SetLocalInt( oPC, "ds_check_8", 1 );
    }
    else if ( sTag == "ds_j_butterchurn" ){

        SetLocalInt( oPC, "ds_check_9", 1 );
    }
    else if ( sTag == "ds_j_cheesevat" ){

        SetLocalInt( oPC, "ds_check_10", 1 );
    }
    else if ( sTag == "ds_j_brewingkettle" ){

        SetLocalInt( oPC, "ds_check_11", 1 );
    }
    else if ( sTag == "ds_j_armouranvil" ){

        if ( ds_j_CopyCheck( oPC, oSource, sTag, 53 ) ){

            return;
        }

        SetLocalInt( oPC, "ds_check_12", 1 );
    }
    else if ( sTag == "ds_j_weaponanvil" ){

        if ( ds_j_CopyCheck( oPC, oSource, sTag, 54 ) ){

            return;
        }

        SetLocalInt( oPC, "ds_check_13", 1 );
    }
    else if ( sTag == "ds_j_fletcherbench" ){

        SetLocalInt( oPC, "ds_check_14", 1 );
    }
    else if ( sTag == "ds_j_loom" ){

        SetLocalInt( oPC, "ds_check_15", 1 );
    }
    else if ( sTag == "ds_j_tailorbench" ){

        if ( ds_j_CopyCheck( oPC, oSource, sTag, 56 ) ){

            return;
        }

        SetLocalInt( oPC, "ds_check_16", 1 );
    }
    else if ( sTag == "ds_j_bowyersbench" ){

        SetLocalInt( oPC, "ds_check_17", 1 );
    }
    else if ( sTag == "ds_j_jeweler" ){

        if ( ds_j_CopyCheck( oPC, oSource, sTag, 57 ) ){

            return;
         }

        SetLocalInt( oPC, "ds_check_18", 1 );
    }
    else if ( sTag == "ds_j_gembench" ){

        SetLocalInt( oPC, "ds_check_19", 1 );
    }
    else if ( sTag != DS_J_CHEST && sResRef == DS_J_CHEST ){

        SetLocalInt( oPC, "ds_check_20", 1 );
    }
    else if ( sTag == "ds_j_inventorlab" ){

        SetLocalInt( oPC, "ds_check_21", 1 );
    }
    else if ( sTag == "ds_j_headstone" ){

        SetLocalInt( oPC, "ds_check_22", 1 );
    }
    else if ( sTag == "ds_j_herbpot" ){

        SetLocalInt( oPC, "ds_check_23", 1 );
    }
    else if ( sTag == "ds_j_alchemist" ){

        SetLocalInt( oPC, "ds_check_24", 1 );
    }
    else if ( sTag == "ds_j_slab" ){

        SetLocalInt( oPC, "ds_check_25", 1 );
    }
    else if ( sTag == "ds_j_shroomcook" ){

        SetLocalInt( oPC, "ds_check_26", 1 );
    }
    else if ( sTag == "ds_j_shroombrew" ){

        SetLocalInt( oPC, "ds_check_27", 1 );
    }
    else if ( sTag == "ds_j_research" ){

        SetLocalInt( oPC, "ds_check_28", 1 );
    }
    else if ( sTag == "ds_j_lab" ){

        SetLocalInt( oPC, "ds_check_29", 1 );
    }
    else if ( sTag == "ds_j_carpenterbench" ){

        SetLocalInt( oPC, "ds_check_30", 1 );
    }
    else if ( sTag == "ds_j_candlepot" ){

        SetLocalInt( oPC, "ds_check_31", 1 );
    }
    else if ( sTag == "ds_j_juicepress" ){

        SetLocalInt( oPC, "ds_check_32", 1 );
    }
    else if ( sTag == "ds_j_tredmill" ){

        SetLocalInt( oPC, "ds_check_33", 1 );
    }
    else if ( sTag == "ds_j_desk" ){

        SetLocalInt( oPC, "ds_check_34", 1 );
    }
    else if ( sTag == "ds_j_stonemason" ){

        SetLocalInt( oPC, "ds_check_35", 1 );
    }
    else if ( sResRef == "ds_j_beggar" ){

        ds_j_CloseBowl( oPC );
    }
    else if ( sResRef == "ds_j_gambler" ){

        ds_j_CloseDiceMat( oPC );
    }
    else{

        return;
    }

    AssignCommand( oPC, ActionStartConversation( oPC, "ds_j_plc", TRUE, FALSE ) );
}


