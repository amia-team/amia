//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_use
//group:   Jobs & crafting
//used as: OnUse event of a PLC
//date:    december 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "inc_ds_j_lib"

void ds_j_CheckCrop( object oPC, object oCrop, int nJob );
void ds_j_CheckTrap( object oPC, object oTrap );
void ds_j_CheckSource( object oPC, object oSource );
void ds_j_Teach( object oPC, object oPLC );
void ds_j_FisherCatch( object oPC, object oPLC, object oRod );
void ds_j_FisherSit( object oPC, object oPLC );
void ds_j_CreateKnowledge( object oPC, object oSource );

void ds_j_CheckCrop( object oPC, object oCrop, int nJob ){

    string sKey = GetLocalString( oCrop, DS_J_USER );
    int nBlockTime = DS_J_SOURCEDELAY;

    if ( sKey != GetPCPublicCDKey( oPC, TRUE ) ){

        SendMessageToPC( oPC, CLR_ORANGE+"Not your crop!"+CLR_END );
        return;
    }

    int nTime = GetServerRunTime() - GetLocalInt( oCrop, DS_J_TIME );

    if ( nTime > nBlockTime ){

        //check if the find is succesful and deal with XP
        int nResult     = ds_j_StandardRoll( oPC, nJob );
        int nCrop       = GetLocalInt( oCrop, DS_J_CROP );
        string sCrop    = GetLocalString( oCrop, DS_J_CROP );

        ds_j_GiveStandardXP( oPC, nJob, nResult, 0.7 );



        if ( nResult > 0 ){

            //string sTag  = DS_J_RESOURCE_PREFIX + IntToString( nCrop );

            if ( nCrop == 418 ){

                ds_j_CreateItemOnPC( oPC, "ds_j_small", nCrop, sCrop, "", 3 );
            }
            else{

                ds_j_CreateItemOnPC( oPC, "ds_j_medium", nCrop, sCrop, "", 108 );
            }

            SendMessageToPC( oPC, CLR_ORANGE+"You harvest your crops."+CLR_END );

            SetLocalInt( oCrop, DS_J_TIME, GetServerRunTime() );
        }
        else{

            SendMessageToPC( oPC, CLR_ORANGE+"Your crops are ruined."+CLR_END );

            SetLocalInt( oPC, DS_J_CROP, ( GetLocalInt( oPC, DS_J_CROP ) - 1 ) );

            DestroyObject( oCrop );
        }
    }
    else{

        string sCropTimer = IntToString( nBlockTime - nTime );
        SendMessageToPC( oPC, CLR_ORANGE+"Your crops will be ready in "+sCropTimer+" seconds."+CLR_END );
    }
}


void ds_j_CheckTrap( object oPC, object oTrap ){

    string sKey = GetLocalString( oTrap, DS_J_USER );

    if ( sKey != GetPCPublicCDKey( oPC, TRUE ) ){

        SendMessageToPC( oPC, CLR_ORANGE+"Not your trap!"+CLR_END );
        return;
    }

    int nTime = GetServerRunTime() - GetLocalInt( oTrap, DS_J_TIME );

    if ( nTime > DS_J_SOURCEDELAY ){

        //check if the find is succesful and deal with XP
        int nResult     = ds_j_StandardRoll( oPC, 5 );
        int nRank       = ds_j_GiveStandardXP( oPC, 5, nResult );

        if ( nResult > 0 ){

            ds_j_CreateItemOnPC( oPC, "ds_j_medium",  34, "Hide","", 6 );
            ds_j_CreateItemOnPC( oPC, "ds_j_medium",  35, "Meat", "", 3 );

            SendMessageToPC( oPC, CLR_ORANGE+"You trapped some game and pocket its meat and pelt."+CLR_END );

            DestroyObject( oTrap );
        }
        else{

            SendMessageToPC( oPC, CLR_ORANGE+"You retrieve an empty trap."+CLR_END );
        }

        SetLocalInt( oPC, DS_J_TRAP, ( GetLocalInt( oPC, DS_J_TRAP ) - 1 ) );

        DestroyObject( oTrap );
    }
    else{

        SendMessageToPC( oPC, CLR_ORANGE+"Your trap isn't ready yet."+CLR_END );
    }
}

void ds_j_CheckSource( object oPC, object oSource ){

    //setup variables from database
    string sKey    = GetPCPublicCDKey( oPC, TRUE );
    int nCheck     = ds_j_InitialiseSource( oSource );
    int nQuantity  = GetLocalInt( oSource, DS_J_QUANTITY );
    int nBlockTime = DS_J_SOURCEDELAY;

    location nodeLoc = GetLocation(oSource);
    string sNodeAreaResRef = GetResRef(GetAreaFromLocation(nodeLoc));
    vector vNodePosition = GetPositionFromLocation(nodeLoc);
    string sNodePosition = FloatToString(vNodePosition.x)+"_"+FloatToString(vNodePosition.y)+"_"+FloatToString(vNodePosition.z);
    string sNodeId = sNodeAreaResRef+sNodePosition;

    SetLuaKeyValueTable("job_sources_"+sKey);
    string sTaken = GetLuaKeyValue(sNodeId+"_TAKEN");
    int nTaken    = sTaken==""?0:StringToInt(sTaken);


    if ( nCheck == FALSE ){

        SendMessageToPC( oPC, "["+CLR_RED+"Error: This object hasn't been initialised."+CLR_END+"]" );
        return;
    }

    if ( nTaken >= nQuantity ){

        //this source is exhaused
        AssignCommand( oPC, PlayAnimation( ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD ) );

        SpeakString( CLR_ORANGE+"Sorry, there's nothing left for you to collect."+CLR_END );

        return;
    }

    string sLastUse = GetLuaKeyValue(sNodeId+"_TIME");
    int iLastUse = sLastUse == ""?0:StringToInt(sLastUse);

    int nTime = GetServerRunTime() - iLastUse;

    if ( nTime < nBlockTime && iLastUse > 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can't gather from this resource right now."+CLR_END );
        SendMessageToPC( oPC, CLR_ORANGE+"You have to wait "+IntToString( nBlockTime - nTime )+" seconds."+CLR_END );
        return;
    }

    string sProduct = GetLocalString( oSource, DS_J_RESREF );
    string sMessage;

    if ( sProduct != "" ){

        //check if the find is succesful
        int nJob        = GetLocalInt( oSource, DS_J_JOB );
        int nResult     = ds_j_StandardRoll( oPC, nJob );

        ds_j_GiveStandardXP( oPC, nJob, nResult, 0.9 );

        //block for DS_J_SOURCEDELAY seconds
        SetLuaKeyValue(sNodeId+"_TIME", IntToString(GetServerRunTime()));


        ++nTaken;

        SetLuaKeyValue(sNodeId+"_TAKEN", IntToString(nTaken));

        SendMessageToPC( oPC, CLR_ORANGE+"This object has "+IntToString(nQuantity-nTaken)+" resources left."+CLR_END );

        if ( nResult <= 0 ){

            sMessage        = "Alas, you find nothing";
        }
        else {

            int nResource   = GetLocalInt( oSource, DS_J_RESOURCE );
            int nIcon       = GetLocalInt( oSource, DS_J_ICON );

            ds_j_CreateItemOnPC( oPC, sProduct, nResource, "", "", nIcon );

            //some candy
            AssignCommand( oPC, PlayAnimation( ANIMATION_LOOPING_GET_LOW, 1.0, 2.0 ) );

            FloatingTextStringOnCreature( "*gathers some resources*", oPC );
        }
    }
    else{

        SendMessageToPC( oPC, "["+CLR_RED+"Error: Can't find proper resref"+CLR_END+"]" );
    }
}

void ds_j_Teach( object oPC, object oPLC ){

    int nJob = GetPCKEYValue( oPC, DS_J_RANK3 );

    if ( nJob < 1 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You need 3 ranks in a job to be able to teach." );
        return;
    }

    location lAnchor = GetLocation( oPC );
    effect eVis;
    int nRank;
    int nResult;
    int nBusy = GetLocalInt( oPC, DS_J_BUSY );

    if ( GetIsBlocked() > 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You need to lecture for at least 5 minutes." );
        return;
    }
    else if ( nBusy == 1 ){

        SendMessageToPC( oPC, CLR_ORANGE+"Lecture ended." );

        DeleteLocalInt( oPC, DS_J_BUSY);
    }
    else{

        SendMessageToPC( oPC, CLR_ORANGE+"Lecture started. Use lecturn again to end it. You must lecture at least 5 minutes." );

        SpeakString( CLR_ORANGE+"Silence! The lecture has started! Silence!" );

        SetLocalInt( oPC, DS_J_BUSY, 1 );

        SetBlockTime( oPLC, 0, 20 );

        return;
    }

    object oTrigger  = GetNearestObjectByTag( "ds_j_area" );
    object oAudience = GetFirstInPersistentObject( oTrigger );

    while( GetIsObjectValid( oAudience ) ){

        if ( GetIsPC( oAudience ) && oAudience != oPC ){

            if ( GetLocalInt( oAudience, DS_J_TAUGHT_PREFIX+IntToString( nJob ) ) == 1 ){

                SendMessageToPC( oAudience, CLR_ORANGE+"You only count as an XP worthy student for each job once a reset." );
                SendMessageToPC( oPC, CLR_ORANGE+GetName( oAudience )+" already learned about your job." );
            }
            else{

                //check if succesful and deal with XP
                nResult = ds_j_StandardRoll( oPC, nJob );
                nRank   = ds_j_GiveStandardXP( oPC, nJob, nResult, 1.0 );

                //candy
                if ( nResult > 0 ){

                    eVis = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR );
                }
                else{

                    eVis = EffectVisualEffect( VFX_DUR_PROTECTION_EVIL_MINOR );
                }

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oAudience, 3.0 );

                //give fee
                GiveGoldToCreature( oPC, d100( nResult ) );

                //give audience a bit of XP
                GiveCorrectedXP( oAudience, 25, "Job", 0 );

                //block oAudience this session
                SetLocalInt( oAudience, DS_J_TAUGHT_PREFIX+IntToString( nJob ), 1 );
            }
        }

        oAudience = GetNextInPersistentObject( oTrigger );
    }
}

void ds_j_FisherCatch( object oPC, object oPLC, object oRod ){

    if ( GetSittingCreature( oPLC ) != oPC ){

        DeleteLocalInt( oPLC, DS_J_BUSY );

        DestroyObject( oRod );

        return;
    }

    int nResult     = ds_j_StandardRoll( oPC, 93 );
    int nRank       = ds_j_GiveStandardXP( oPC, 93, nResult );
    object oFish;

    if ( nResult == 1 ){

        if ( d2() == 1 ){

            oFish = CreateItemOnObject( "ds_j_fish_1", oPC, 1, DS_J_RESOURCE_PREFIX+"400" );
        }
        else{

            oFish = CreateItemOnObject( "ds_j_fish_3", oPC, 1, DS_J_RESOURCE_PREFIX+"430" );
        }
    }
    else if ( nResult == 2 ){

        oFish = CreateItemOnObject( "ds_j_fish_2", oPC, 1, DS_J_RESOURCE_PREFIX+"401" );
    }

    if ( nResult ){

        SetLocalInt( oPC, DS_J_FAILBONUS, 0 );

        SetName( oFish, CLR_ORANGE+GetName( oFish )+CLR_END );

        AssignCommand( oPC, PlayAnimation( ANIMATION_FIREFORGET_VICTORY2 ) );

        DeleteLocalInt( oPLC, DS_J_BUSY );

        DestroyObject( oRod );
    }
    else{

        //if failure occurs, give an incremented chance of success next time
        if ( nResult == 0 && nRank > 0 ){

            int nFailBonus   = GetLocalInt( oPC, DS_J_FAILBONUS );
            int nLastJob     = GetLocalInt( oPC, DS_J_LASTJOB );
            //Only increment bonus when doing the same job again
            if ( nLastJob == 93 )       nFailBonus += 4+nRank;
            else                        nFailBonus  = 4+nRank;

            SetLocalInt( oPC, DS_J_FAILBONUS, nFailBonus );
        }

        DelayCommand( 120.0, ds_j_FisherCatch( oPC, oPLC, oRod ) );
    }
}

void ds_j_FisherSit( object oPC, object oPLC ){

    location lLocation = GetLocation( oPC );

    object oRod = CreateObject( OBJECT_TYPE_ITEM, "ds_j_fishrod", lLocation );

    SendMessageToPC( oPC, CLR_ORANGE+"As long as you remain on this seat you'll have a chance to catch a fish every 2 minutes." );

    SetLocalInt( oPLC, DS_J_BUSY, 1 );

    DelayCommand( 120.0, ds_j_FisherCatch( oPC, oPLC, oRod ) );
}

void ds_j_CreateKnowledge( object oPC, object oSource ){

    //setup variables from database
    int nCheck     = ds_j_InitialiseSource( oSource );
    int nQuantity  = GetLocalInt( oSource, DS_J_QUANTITY );

    if ( nCheck == FALSE ){

        SendMessageToPC( oPC, "["+CLR_RED+"Error: This object hasn't been initialised."+CLR_END+"]" );
        return;
    }

    int nTime = GetServerRunTime() - GetLocalInt( oSource, DS_J_TIME );

    if ( nTime < DS_J_SOURCEDELAY ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can't use this object right now."+CLR_END );
        return;
    }

    object oPaper = GetItemByName( oPC, CLR_ORANGE + "Empty Pages" + CLR_END );

    if ( !GetIsObjectValid( oPaper ) ){

        //no paper
        SendMessageToPC( oPC, CLR_ORANGE+"You don't have any paper to write on!"+CLR_END );
        return;
    }

    DestroyObject( oPaper );

    string sProduct = GetLocalString( oSource, DS_J_RESREF );
    string sMessage;

    if ( sProduct != "" ){

        //check if the find is succesful
        int nJob        = GetLocalInt( oSource, DS_J_JOB );
        int nResult     = ds_j_StandardRoll( oPC, nJob );
        int nRank       = ds_j_GiveStandardXP( oPC, nJob, nResult );

        //block for DS_J_SOURCEDELAY seconds
        SetLocalInt( oSource, DS_J_TIME, GetServerRunTime() );

        if ( nResult <= 0 ){

            sMessage        = "Alas, you discover nothing";
        }
        else {

            int nResource   = GetLocalInt( oSource, DS_J_RESOURCE );
            //string sName    = ds_j_GetResourceName( nResource );
            //string sTag     = DS_J_RESOURCE_PREFIX+IntToString( nResource );
            int nIcon       = GetLocalInt( oSource, DS_J_ICON );

            ds_j_CreateItemOnPC( oPC, sProduct, nResource, "", "", nIcon );

            sMessage        = "You gather some knowledge.";
        }

        //feedback
        SendMessageToPC( oPC, CLR_ORANGE+sMessage );
    }
    else{

        SendMessageToPC( oPC, "["+CLR_RED+"Error: Can't find proper resref"+CLR_END+"]" );
    }
}


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPLC    = OBJECT_SELF;
    object oPC     = GetLastUsedBy();
    string sTag    = GetTag( oPLC );
    string sResRef = GetResRef( oPLC );

    //if ( GetStringLeft( GetResRef( GetArea( oPC ) ), 5 ) != "ds_j_" ){

        //SendMessageToPC( oPC, "Sorry, the job system isn't ready yet." );
        //return;
    //}


    if ( sTag == DS_J_TRAP ){

        ds_j_CheckTrap( oPC, oPLC );
    }
    else if ( sResRef == DS_J_CROP ){

        ds_j_CheckCrop( oPC, oPLC, 8 );
    }
    else if ( sResRef == DS_J_CROP+"_2" ){

        ds_j_CheckCrop( oPC, oPLC, 94 );
    }
    else if ( sResRef == DS_J_ALTAR ){

        ds_j_UseAltar( oPC, oPLC );
    }
    else if ( sTag == "ds_j_lecturn" ){

        ds_j_Teach( oPC, oPLC );
    }
    else if ( sTag == "ds_j_astronomy" || sTag == "ds_j_globe" || sTag == "ds_j_sundial" ){

        ds_j_CreateKnowledge( oPC, oPLC );
    }
    else if ( sTag == "ds_j_easel_"+GetPCPublicCDKey( oPC, TRUE ) ){

        DestroyObject( oPLC );
    }
    else if ( sTag == "ds_j_fisher" ){

        if ( !GetLocalInt( oPLC, DS_J_BUSY ) ){

            ExecuteScript( "x2_plc_used_sit", oPLC );

            DelayCommand( 2.0, ds_j_FisherSit( oPC, oPLC ) );
        }
    }
    else {

        ds_j_CheckSource( oPC, oPLC );
    }
}



