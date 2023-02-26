// Revision History
// Date       Name             Description
// ---------- ---------------- ------------------------------------------------
// 05/10/2008 Terra            Initial release.
// 2009/02/23 disco            Updated racial/class/area effects refresher
// 2019/10/1  Mav              Updated so it doesn't allow resting while mounting
// 2019/10/4 Mav               Fixed so it reapplies two handed and class specific buffs


//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_rest
//description: Library delicated to rest functions
//used as: Library
//date:    05/10/2008
//author:  Terra
// 2009/02/23 disco            Updated racial/class/area effects refresher

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------

#include "x0_i0_position"
#include "inc_ds_spawns"
#include "inc_ds_records"
#include "inc_runtime_api"
#include "inc_module_vars"

//-----------------------------------------------------------------------------
// Constant Variables
//-----------------------------------------------------------------------------

//void main (){}

//Colours is always nice, cheers up.
const string REST_SYSTEM_COLOUR_TAG          = "";

//The amount of hours you have to wait before next rest
const int    REST_BLOCK                      = 15;

//Range which no enemies is allowed
const float  HOSTILE_RANGE                   = 20.0;

//This is tested against a D100
//It may not be set less then 0 or more then 100
const int    AMBUSH_RATE_PROCENT             = 5;

//Minumum allowed % rate
const int    AMBUSH_RATE_PROCENT_CAP         = 1;

//Variable used to determine if its camp gear
//Used in "i_ds_campingtool"
const string PLC_VAR_NAME                    = "ds_cg";

//Cap GetCampPLCsWithinRange() each PLC it
//returns lowers the % on ambush
//may not be lower then AMBUSH_RATE_PROCENT
const int    MAX_PLCS_TAKEN_INTO_ACCOUNT     = 4;

//The range the camp gear has to be within
const float  CAMP_GEAR_MAX_RANGE             = 10.0;

//The range within a creature may spawn to the rester
const float  SPAWN_RANGE                     = 10.0;

//If this is set to TRUE the rester will be blinded
//during the rest
const int    ALLOW_BLINDING                  = TRUE;

//The pc will be blocked from more ambushes
//for the amount of minutes specified here
//Default: Same as the rest dalay
const int    MINUTES_BETWEEN_POSSIBLE_AMBUSH = REST_BLOCK;

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------

//On rest finished action function.
void OnRestFinished( object oPC );

//On rest started action function.
void OnRestStarted( object oPC );

//On rest cancelled action function.
void OnRestCancelled(object oPC);

//This runs on OnRestStarted()
//Returns TRUE if anything is spawned.
void RestAmbush( object oPC );

//-----------------------------------------------------------------------------
// Sub

//Checks if another "rest delay" exists on the module
//and returns that amount or if not the default one.
int GetDefaultModuleInt(string sVarName, int iDefault);

//Message server reset time.
void ShowResetTime( object oPC);

//Returns the amount of camp PLC's within fRange of the PC
int GetCampPLCsWithinRange( object oPC );

//Spawns the critters for the rest system
void DoAmbush(object oPC, object oArea );

//nAdd = TRUE adds the blind effect
//nAdd = FALSE Removes the blindness
void RestEffects(object oPC, int nAdd);

//Returns oArea 's center location
location GetCenterInArea( object oArea );

//void main(){}

//-----------------------------------------------------------------------------
// main functions
//-----------------------------------------------------------------------------

void OnRestStarted( object oPC ){

    //Vars
    object  oArea   = GetArea( oPC );
    int     nBlock  = GetIsBlocked( oPC, "AR_LastRestHour" );

    //Its returned in seconds, lets change
    //Avoid devide by zero error
    if ( nBlock >= 1 ){

        nBlock = nBlock / 60;
    }

    ShowResetTime( oPC );

    // A hack just to ensure DM healing doesn't screw over PCs
    if( !GetIsDead( oPC ) )
    {
        DeletePCKEYValue( oPC, "dead_in" );
    }

    if ( GetIsDM( oPC ) ) {

        AssignCommand( oPC, ClearAllActions() );

        AssignCommand( oPC, ActionStartConversation(oPC, "dmrest", TRUE, FALSE) );

        return;
    }

    // Horse check -  Make sure they are dismounted before allowing them to rest
    if( GetLocalInt(oPC,"mounted") == 1)
    {
        SendMessageToPC( oPC , REST_SYSTEM_COLOUR_TAG+"You must dismount before resting!" );
        AssignCommand( oPC, ClearAllActions() );
        return;
    }


    // Check if the area is marked "NO_REST" and abort if so
    if ( GetLocalInt( oArea, "NO_REST" ) == TRUE )
    {
        // unless PC standing in safe rest trigger, with nearest door closed
        object oDoor = GetNearestObject( OBJECT_TYPE_DOOR, oPC );
        if( GetIsInsideTrigger( oPC, "X0_SAFEREST" ) && !GetIsOpen( oDoor ) )
        {
            //continue
        }
        else
        {
            SendMessageToPC( oPC , REST_SYSTEM_COLOUR_TAG+"It is far too dangerous to rest in this area. You'll have to find a secure place to rest." );
            AssignCommand( oPC, ClearAllActions() );
            return;
        }
    }

    // Player resting invokes a dialog; rest or save...
    if ( GetLocalInt(oPC, "AR_RestChoice") == 0 ){

        AssignCommand( oPC, ClearAllActions() );

        AssignCommand( oPC, ActionStartConversation(oPC, "playerrest", TRUE, FALSE) );

        return;
    }

    else {

        DeleteLocalInt(oPC, "AR_RestChoice");
    }

    // Check if a free resting area.
    if ( GetLocalInt( oArea, "FreeRest" ) ){

        return;
    }

    // Check if sufficiant time has passed
    if( nBlock >= 1 ){

        SendMessageToPC( oPC , REST_SYSTEM_COLOUR_TAG+"You must wait up to " +
        IntToString( nBlock ) + ( ( nBlock > 1 ) ? " minutes" : " minute")+
        " before resting again." );

        AssignCommand( oPC, ClearAllActions() );

        return;
    }

    // Check for hostile creatures
    object oCreature = GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY );

    float fDistance = GetDistanceToObject( oCreature );

    if ( fDistance > 0.0 && fDistance <= HOSTILE_RANGE ){

        SendMessageToPC( oPC, REST_SYSTEM_COLOUR_TAG+
        "You cannot rest while enemies are near." );

        AssignCommand( oPC, ClearAllActions() );
        return;
    }

    if( ALLOW_BLINDING ){

        RestEffects( oPC, TRUE );
    }

    //counter ECL bug
    GetECL( oPC );

    //Rest is started, CHECKY!
    RestAmbush( oPC );

    //Save time
    SetLocalInt( oPC, "rest_start", GetCurrentSecond( TRUE ) );


}

//-----------------------------------------------------------------------------

void OnRestFinished( object oPC ){

    // Variables.

    object  oArea        = GetArea( oPC );

    object oWidget = GetItemPossessedBy(oPC, "ds_pckey");

    if(ALLOW_BLINDING) RestEffects( oPC, FALSE );

    // Re-initialize Racial Traits.
    ApplyAreaAndRaceEffects( oPC, 1 );

    AR_ExportPlayer    ( oPC );    // persist me please!

    DeleteLocalInt(oPC, "cs_vampirefang1");
    DeleteLocalInt(oPC, "cs_kravenbook1");
    DeleteLocalInt(oPC, "TwistOfFate");
    DeleteLocalInt(oPC, "cus_feat_use_act");
    DeleteLocalInt(oPC, "cus_feat_use_ins");

    SetBlockTime( oPC , REST_BLOCK, 0 , "AR_LastRestHour" );

    SendMessageToPC( oPC ,REST_SYSTEM_COLOUR_TAG + "You rested 100% You have to wait "
    + IntToString( REST_BLOCK ) + ((REST_BLOCK > 1) ? " minutes" : " minute")
    + " before you can rest again." );

    DeleteLocalInt( oPC, "rest_start" );

    // Remove the monk activatable
    DeleteLocalInt(oWidget,"monkprc");



}

//-----------------------------------------------------------------------------

void OnRestCancelled(object oPC){

    object oArea        = GetArea( oPC );

    if(ALLOW_BLINDING) RestEffects( oPC, FALSE );

    float fDistance = GetDistanceToObject( GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY ) );

    //Assume the rest was cancaled by a hostile; ambush. No blocking partial rests then
    if ( ( fDistance > 0.0 && fDistance <= HOSTILE_RANGE ) || GetLocalInt( oPC, "rest_start" ) <=0 ){
        DeleteLocalInt( oPC, "rest_start" );

        return;

    }
    //If not, check!
    else{

    int nNormal     = ( GetHitDice( oPC ) /2 ) + 10;
    int nCurrent    = GetCurrentSecond( TRUE ) - GetLocalInt( oPC, "rest_start" );

    float fRested   = IntToFloat( nCurrent ) / IntToFloat( nNormal );

    int nBlock =  FloatToInt( IntToFloat( REST_BLOCK ) * fRested );

    SendMessageToPC( oPC, REST_SYSTEM_COLOUR_TAG + "You rested "+IntToString( FloatToInt( fRested * 100.0 ) )
    + "% You have to wait " + IntToString( nBlock ) + ((nBlock > 1) ? " minutes" : " minute")
    + " before you can rest again." );

    DeleteLocalInt( oPC, "rest_start" );

    SetBlockTime( oPC , nBlock, 0 , "AR_LastRestHour" );

    }

}

//-----------------------------------------------------------------------------

void RestAmbush( object oPC ){

    //The area does not have any critter.
    //or the PC has already had a ambush
    //Possibility for a spawn is thereby 0
    //to prevent spamming

    //Its still blocked, no do anything.
    if( GetIsBlocked( oPC, "Ambush_block" ) > 0 ){

        SendMessageToPC( oPC ,"Possibility : "+REST_SYSTEM_COLOUR_TAG+"0%" );
        return;
    }
    //If resting on a safe rest trigger, don't ambush.
    if( GetIsInsideTrigger( oPC, "X0_SAFEREST" ) )
    {
        return;
    }

    object   oArea             = GetArea( oPC );
    int      nHasCritter       = AreaHasCritters( oArea );

    //DEBUG!
    //SendMessageToPC(oPC, "Debug: Has Critter = "+IntToString(nHasCritter));


    //The area doesnt even have critter, don't do anything
    if(!nHasCritter){

        SendMessageToPC( oPC ,"Possibility : "+REST_SYSTEM_COLOUR_TAG+"0%" );
        return;
    }


    float    nCloseToSpawn     = IsCloseToSpawnpoint( oPC );

    //DEBUG!
    //SendMessageToPC(oPC, "Debug: Close to spawn = "+IntToString(FloatToInt(nCloseToSpawn)));

    //Invalid range values, don't do anything
    if ( nCloseToSpawn == 0.0 || nCloseToSpawn > 15.0 || nHasCritter == FALSE ){

        SendMessageToPC( oPC ,"Possibility : "+REST_SYSTEM_COLOUR_TAG+"0%" );
        return;
    }


    int      iPlcsInRange      = GetCampPLCsWithinRange( oPC );
    location lCenter           = GetCenterInArea( oArea );
    location lPCLoc            = GetLocation( oPC );
    int      iTilesBetween     = FloatToInt(GetDistanceBetweenLocations(lPCLoc, lCenter)/10);

    //DEBUG!
    //SendMessageToPC(oPC, "Debug: Camp gear in range = "+IntToString(iPlcsInRange));
    //SendMessageToPC(oPC, "Debug: Tiles between you and area center point = "+IntToString(iTilesBetween));

    //Calculate
    int nAmbush = GetLocalInt ( oArea, "ambush" );
    int iPossibility;
    if ( nAmbush > 0 ){
        iPossibility = nAmbush - iPlcsInRange - iTilesBetween;
    }
    else
        iPossibility = AMBUSH_RATE_PROCENT - iPlcsInRange - iTilesBetween;

    //Y'know them cappy caps.
    if ( iPossibility <= 0 ) iPossibility = AMBUSH_RATE_PROCENT_CAP;

    //Whoops! Close to a spawn juice it up!
    if( nCloseToSpawn != 0.0 )iPossibility += FloatToInt(15 - nCloseToSpawn);


    int     iD100           = d100();
    int     iD8             = d8();
    SendMessageToPC( oPC ,"Possibility : "+REST_SYSTEM_COLOUR_TAG+IntToString(iPossibility)+"%" );

    DelayCommand( IntToFloat( iD8 ),SendMessageToPC( oPC ,"Ambush Roll : "+REST_SYSTEM_COLOUR_TAG+IntToString(iD100) ) );

    //Test against d100
    if( iD100 > iPossibility )return;

    DelayCommand( IntToFloat( iD8 ), DoAmbush( oPC, oArea ) );

    return;
}

//-----------------------------------------------------------------------------
// sub functions
//-----------------------------------------------------------------------------
void ShowResetTime( object oPC){

    // int nRunTime = GetRunTime();
    // int nReload  = GetAutoReload() + nRunTime;

    // int resetTime = ((nReload - nRunTime) - (GetRunTime() - GetStartTime())) / 60;

    // SendMessageToPC( oPC, REST_SYSTEM_COLOUR_TAG+"Estimated reset time: " + IntToString(resetTime) + " minutes." );
}

//-----------------------------------------------------------------------------
int GetCampPLCsWithinRange( object oPC ){

    int     iLoop   = 1;
    int     iReturn = 0;
    object  oPLC    = GetNearestObject( OBJECT_TYPE_PLACEABLE, oPC, iLoop );

    while( GetIsObjectValid( oPLC ) ){

        float fDistance = GetDistanceBetween( oPC, oPLC );

        //We have looped to the cap no need looping more
        if ( fDistance > CAMP_GEAR_MAX_RANGE ){

            break;
        }

        //We have looped to the cap no need looping more
        if ( iReturn == MAX_PLCS_TAKEN_INTO_ACCOUNT ){

            break;
        }

        if ( GetLocalInt( oPLC , PLC_VAR_NAME ) == 1 ){

            iReturn++;
        }

        iLoop++;

        oPLC    = GetNearestObject( OBJECT_TYPE_PLACEABLE , oPC , iLoop );
    }

    return iReturn;
}
//-----------------------------------------------------------------------------
void DoAmbush(object oPC, object oArea ){

    int nSpawn = 0; //SpawnAreaCritters( oPC, oArea  );

    if ( nSpawn ){

        FloatingTextStringOnCreature(REST_SYSTEM_COLOUR_TAG+"*Ambush!*", oPC );

        SetBlockTime( oPC, MINUTES_BETWEEN_POSSIBLE_AMBUSH, 0, "Ambush_block" );

        AssignCommand( oPC, ClearAllActions() );

    }
    else {

        SendMessageToPC( oPC ,"ERROR: "+REST_SYSTEM_COLOUR_TAG+"spawning failed!" );
    }
}

//-----------------------------------------------------------------------------
void RestEffects(object oPC, int nAdd){

    effect eEffect = SupernaturalEffect(EffectBlindness());

    if( nAdd ) {

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 60.0);
    }

    else  {

        eEffect = GetFirstEffect( oPC );

        while( GetIsEffectValid( eEffect ) )  {

            if ( GetEffectType( eEffect  ) == EFFECT_TYPE_BLINDNESS
              && GetEffectSubType( eEffect ) == SUBTYPE_SUPERNATURAL ) {

                RemoveEffect( oPC, eEffect );

                break;
            }

            eEffect = GetNextEffect( oPC );
        }
    }
}

//-----------------------------------------------------------------------------
location GetCenterInArea( object oArea ){

    int iY = GetAreaSize(AREA_HEIGHT, oArea)*10;
    int iX = GetAreaSize(AREA_WIDTH, oArea)*10;

    vector V;

    V.y = IntToFloat(iY)/2;
    V.x = IntToFloat(iX)/2;

    return Location(oArea, V, 0.0);

}
//-----------------------------------------------

