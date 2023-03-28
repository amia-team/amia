/*
---------------------------------------------------------------------------------
NAME: x3_pl_tool1
Description: This is a library of functions for the player tool 1 feat. The feat id is 1106.
LOG:
    Faded Wings [11/12/2015 - Dawn of Time]
    Raven       [5/1/2017 - Fixes + Henchman ]
    Frozen      [24/March/2023 - BC tagging for f_voice command assignment ]
    	Frozen      [25/March/2023 - added functionality for taged bc to sit ]
----------------------------------------------------------------------------------
*/

/* includes */
#include "inc_ds_actions"
#include "amia_include"
#include "NW_I0_GENERIC"
#include "x0_inc_henai"

object oPC;

// Associate tool global variables.
object oCreature; object oAssociate1; object oAssociate2;
object oAssociate3; object oAssociate4; object oAssociate5;
object oAssociate6;

/* constants */
const int cCleanDelay = 5;

/* prototypes */

// Retrieves a list of party members and outputs it
void GetPartyList( object oPC );

// Portals a player to a designated safe area, and returns them where they were to remove a black area
void FixBlackArea( object oPC );

// RP Advertiser List function
void RPAdvertiser( object oPC );

// RP Advertiser prototypes
void ToggleRP( object oPC );
void ToggleECL( object oPC );
void ToggleArea( object oPC );
void ToggleHunt( object oPC );

// Skip cleaning of variables and automatically reset them after a short time
void SkipClean( object oPC );

// Clean quest (ds_node, action, etc) variables properly. Pass TRUE/FALSE to force.
void CleanVar( object oPC, int iForce );

// Evaluate Conversation Checks
void EvaluateConvChecks( object oPC );

// Combat system override
void OverrideHenchmanAI( object oPC );

// Function to force an associate to walk to the target location & stand their ground.
void walkToLocation(object oCreature, location targetLocation) {
    AssignCommand(oCreature, ActionMoveToLocation(targetLocation, TRUE)); // Move to location.
    AssignCommand(oCreature, SetAssociateState(NW_ASC_MODE_STAND_GROUND, TRUE)); // Stand ground.
}

// Function to clear the actions of the target creature.
void clearActionsResetCreature(object oCreature) {
    // Clear actions & reset states.
    AssignCommand(oCreature, ClearAllActions());
    AssignCommand(oCreature, ResetHenchmenState());
    AssignCommand(oCreature, SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE));
    AssignCommand(oCreature, SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE));
}

// Get all associates, clear their actions, and move them to the target location.
void moveAllAssociates(location targetLocation) {
    // CLEAR ASSOCIATE ACTIONS.
    clearActionsResetCreature(oAssociate1);
    clearActionsResetCreature(oAssociate2);
    clearActionsResetCreature(oAssociate3);
    clearActionsResetCreature(oAssociate4);
    clearActionsResetCreature(oAssociate5);
    clearActionsResetCreature(oAssociate6);
    // Walk all associates to target location.
    walkToLocation(oAssociate1, targetLocation);
    walkToLocation(oAssociate2, targetLocation);
    walkToLocation(oAssociate3, targetLocation);
    walkToLocation(oAssociate4, targetLocation);
    walkToLocation(oAssociate5, targetLocation);
    walkToLocation(oAssociate6, targetLocation);
}

// Get all associates, clear their actions, and attack the target.
void attackTarget(object oEnemy) {
    // CLEAR ASSOCIATE ACTIONS.
    clearActionsResetCreature(oAssociate1);
    clearActionsResetCreature(oAssociate2);
    clearActionsResetCreature(oAssociate3);
    clearActionsResetCreature(oAssociate4);
    clearActionsResetCreature(oAssociate5);
    clearActionsResetCreature(oAssociate6);
    // TELL ALL ASSOCIATES TO ATTACK THE TARGET.
    AssignCommand(oAssociate1, ActionAttack(oEnemy));
    AssignCommand(oAssociate2, ActionAttack(oEnemy));
    AssignCommand(oAssociate3, ActionAttack(oEnemy));
    AssignCommand(oAssociate4, ActionAttack(oEnemy));
    AssignCommand(oAssociate5, ActionAttack(oEnemy));
    AssignCommand(oAssociate6, ActionAttack(oEnemy));
}

void main()
{
    oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oMarkedBC;
    string sTag = GetTag (oTarget);
    string sUUUID;
    string sScriptUsed = GetEventScript (oTarget, 9012);
    location lLocation = GetSpellTargetLocation();
    int nNode = GetLocalInt( oPC, "ds_node" );

    // Get the target creature, and target location.
    oCreature = GetSpellTargetObject();
    // GET ASSOCIATES.
    oAssociate1 = GetAssociate(3, oPC, 1); // Familiar
    oAssociate2 = GetAssociate(4, oPC, 1); // Summon
    oAssociate3 = GetAssociate(0, oPC, 1); // Unknown
    oAssociate4 = GetAssociate(2, oPC, 1); // Animal Companion
    oAssociate5 = GetAssociate(5, oPC, 1); // Dominated
    oAssociate6 = GetAssociate(1, oPC, 1); // Henchman

    // This is to mark a target (linked) BC for variuos functions
    if (sTag == "ds_npc_"+GetPCPublicCDKey( oPC )){
        sUUUID = GetObjectUUID (oTarget);
        SetLocalString (oPC, "bc_marked", sUUUID);
        SetLocalInt (oPC, "marked_bc", 1);
        SendMessageToPC ( oPC, "BC marked: "+GetName( oTarget )+"." );

    return;
    }
    // Makes a marked target bc sit on chairs and such
    if (GetLocalInt (oPC, "marked_bc") == 1 && sScriptUsed == "us_sit"){
        sUUUID = GetLocalString (oPC, "bc_marked");
        oMarkedBC = GetObjectByUUID (sUUUID);

        AssignCommand (oMarkedBC, ActionMoveToObject (oTarget, FALSE));
        AssignCommand (oMarkedBC, ActionInteractObject (oTarget));

    return;
    }
    // If target is valid & hostile, command all associates to attack the target.
    if (GetIsObjectValid(oCreature) && GetIsReactionTypeHostile(oCreature, oPC) == TRUE) {
        attackTarget(oCreature);
    }
    // Else, move to the target location.
    else {
        moveAllAssociates(lLocation);
    }

    // conversation function execution engine

    string callingScript = GetLocalString( oPC, "ds_action" );

    if( callingScript != "x3_pl_tool01" || nNode == 0)
    {
        SetLocalString( oPC, "ds_action", "x3_pl_tool01" );
        // remove lingering node
        SetLocalInt( oPC, "ds_node", 0 );
        if(GetIsObjectValid(oTarget))
        {
            SetLocalObject( oPC, "ds_target", oTarget );
            SetLocalLocation( oPC, "ds_location", GetLocation( oTarget ));
        }

        EvaluateConvChecks( oPC );

        DelayCommand( 0.1, ActionStartConversation( oPC, "playertools_one", TRUE, FALSE ) );
    }
    else
    {
        // exec function engine
        if( ( nNode >= 3 && nNode <= 8 ) && !IsInConversation( oPC ) ) {
            CleanVar( oPC, TRUE );
            DelayCommand( 0.5, main( ) );
            nNode = 999;
        }

        // Debugging Line: SendMessageToPC (oPC , "The current nNode = " + IntToString( nNode )) ;

        switch ( nNode )
        {
            case 1: GetPartyList( oPC ); CleanVar( oPC, TRUE ); break;
            case 2: FixBlackArea( oPC ); CleanVar( oPC, TRUE ); break;
            case 3: RPAdvertiser( oPC ); SkipClean( oPC ); break;
            case 4: ToggleRP( oPC ); SkipClean( oPC ); break;
            case 5: ToggleECL( oPC ); SkipClean( oPC ); break;
            case 6: ToggleArea( oPC ); SkipClean( oPC ); break;
            case 7: ToggleHunt( oPC ); SkipClean( oPC ); break;
            case 8: OverrideHenchmanAI( oPC ); SkipClean( oPC ); break;

            case 20:  ActionPlayAnimation( ANIMATION_LOOPING_SIT_CHAIR , 1.0f, 600.0f ); SkipClean( oPC ); break;

            case 999: break;
            default: CleanVar( oPC, TRUE ); break;
        }
    }
}

void GetPartyList( object oPC )
{
    object oArea;
    SendMessageToPC(oPC, "<c¦? > ~ Party current area list ~ </c>");
    object oPartyMember = GetFirstFactionMember(oPC, TRUE);
    while(GetIsObjectValid(oPartyMember))
    {
        oArea = GetArea(oPartyMember);
        if(GetIsObjectValid(oArea))
        {
            SendMessageToPC(oPC, "<c¦¦ >" + GetName(oPartyMember) + "</c>: <c ¦¦>" + GetName(oArea) + "</c>");
        }
        else
        {
            SendMessageToPC(oPC, "<c¦¦ >" + GetName(oPartyMember) + "</c>: <c ¦¦> In Transition* </c>");
        }

        oPartyMember = GetNextFactionMember(oPC, TRUE);
    }
}

void FixBlackArea( object oPC )
{
    object oArea = GetArea( oPC );
    vector v;
    float fFace;
    string sRef;

    if(GetIsObjectValid( oPC ) ){
        if( GetArea( oPC ) == oArea ){

            fFace = GetFacing( oPC );
            v = GetPosition( oPC );
            SetLocalInt(oArea, "transition", 1);
            AssignCommand( oPC, ActionJumpToLocation( GetStartingLocation() ) );
            SetLocalFloat( oPC, "new_area_x", v.x );
            SetLocalFloat( oPC, "new_area_y", v.y );
            SetLocalFloat( oPC, "new_area_z", v.z );
            SetLocalFloat( oPC, "new_area_f", fFace );
            SetLocalInt( oPC, "area_refresh", TRUE );
        }
    }

    location lLoc;

    if( GetLocalInt( oPC, "area_refresh" ) ){
        DeleteLocalInt( oPC, "area_refresh" );

        v.x = GetLocalFloat( oPC, "new_area_x" );
        v.y = GetLocalFloat( oPC, "new_area_y" );
        v.z = GetLocalFloat( oPC, "new_area_z" );
        fFace = GetLocalFloat( oPC, "new_area_f" );

        DeleteLocalFloat( oPC, "new_area_x" );
        DeleteLocalFloat( oPC, "new_area_y" );
        DeleteLocalFloat( oPC, "new_area_z" );

        lLoc = Location( oArea, v, fFace );
        AssignCommand( oPC, ActionJumpToLocation( lLoc ) );
        DeleteLocalInt( oArea, "transition" );
    }
}

void RPAdvertiser( object oPC )
{
    object oArea;
    int showRP;
    int showECL;
    int showCurrentArea;
    int showHunt;
    string output;

    SendMessageToPC( oPC, "<c¦? > ~ RP Advertiser List ~ </c>" );
    SendMessageToPC( oPC, " <c¦? >~</c> <c¦¦ >Name</c> | <c ¦ >ECL</c> | <c ¦¦>Area</c> | <c¦ ¦>Hunt</c> <c¦? >~</c> " );
    object oPlayer = GetFirstPC( );
    while( GetIsObjectValid( oPlayer ) )
    {
        showRP = GetLocalInt( oPlayer, "fw_rp" );
        showECL = GetLocalInt( oPlayer, "fw_rp_ecl" );
        showCurrentArea = GetLocalInt( oPlayer, "fw_rp_area" );
        showHunt = GetLocalInt( oPlayer, "fw_rp_hunt");
        oArea = GetArea( oPlayer );

        if( showRP )
        {
            output = "<c¦¦ >" + GetName(oPlayer);

            if( showECL ) {
                output += "</c> <c ¦ >" + IntToString( FloatToInt( GetLocalFloat( oPlayer, "CS_ECL" ) )  );
            }

            if( showCurrentArea ) {
                if( GetIsObjectValid( oArea ) ) output += "</c> <c ¦¦>" + GetName( oArea ) ;
            }

            if( showHunt ) {
                output += "</c> <c¦ ¦> *";
            }

            SendMessageToPC( oPC , "" + output + "</c>" );
        }

        oPlayer = GetNextPC();

        // continue if player logging out
        if( !GetIsObjectValid( oPlayer ) ) oPlayer = GetNextPC();
    }
}

void ToggleRP ( object oPC )
{
    if( !GetLocalInt( oPC, "fw_rp" ) ) {
        SetLocalInt( oPC, "fw_rp", 1 );
        SendMessageToPC( oPC , "<c¦¦ >You are now on the RP Advertiser list.</c>" );

    }
    else {
        SetLocalInt( oPC, "fw_rp", 0 );
        SendMessageToPC( oPC , "<c¦¦ >You are no longer on the RP Advertiser list.</c>" );
        // reset other variables
        SetLocalInt( oPC, "fw_rp_ecl", 0 );
        SetLocalInt( oPC, "fw_rp_area", 0 );
        SetLocalInt( oPC, "fw_rp_hunt", 0 );
    }
}

void ToggleECL ( object oPC )
{
    if( !GetLocalInt( oPC, "fw_rp_ecl" ) ) {
        SetLocalInt( oPC, "fw_rp_ecl", 1 );
        SendMessageToPC( oPC , "<c ¦ >You are now showing your ECL.</c>" );
    }
    else {
        SetLocalInt( oPC, "fw_rp_ecl", 0 );
        SendMessageToPC( oPC , "<c ¦ >You are no longer showing your ECL.</c>" );
    }
}

void ToggleArea ( object oPC )
{
    if( !GetLocalInt( oPC, "fw_rp_area" ) ) {
        SetLocalInt( oPC, "fw_rp_area", 1 );
        SendMessageToPC( oPC , "<c ¦¦>You are now showing your area.</c>" );
    }
    else {
        SetLocalInt( oPC, "fw_rp_area", 0 );
        SendMessageToPC( oPC , "<c ¦¦>You are no longer showing your area.</c>" );
    }
}

void ToggleHunt ( object oPC )
{
    if( !GetLocalInt( oPC, "fw_rp_hunt" ) ) {
        SetLocalInt( oPC, "fw_rp_hunt", 1 );
        SendMessageToPC( oPC , "<c¦ ¦>You now want to hunt.</c>" );
    }
    else {
        SetLocalInt( oPC, "fw_rp_hunt", 0 );
        SendMessageToPC( oPC , "<c¦ ¦>You no longer want to hunt.</c>" );
    }
}

void SkipClean ( object oPC )
{
    EvaluateConvChecks( oPC );

    int iTime = GetLocalInt( oPC, "fw_clean" );
    iTime = GetRunTime() + cCleanDelay;
    SetLocalInt( oPC, "fw_clean", iTime );
    SetLocalInt( oPC, "fw_clean_tries", 0 );
    DelayCommand( IntToFloat( cCleanDelay + 2 ), CleanVar( oPC, FALSE ) );
}

void CleanVar ( object oPC, int iForce )
{
    // are we wasting cpu cycles?
    if( !GetLocalInt( oPC, "fw_clean" ) && GetLocalString( oPC, "ds_action" ) == "" ) return;

    if( !IsInConversation( oPC ) )
    {
        int iTime = GetLocalInt( oPC, "fw_clean" );
        int iRunTime = GetRunTime();
        if( iRunTime >= iTime || iForce )
        {
            clean_vars ( oPC, 4 );
            DeleteLocalString( oPC, "ds_action" );
            DeleteLocalInt( oPC, "fw_clean" );
            DeleteLocalInt( oPC, "fw_clean_tries" );
        }
    }
    else
    {
        if( GetLocalInt( oPC, "fw_clean_tries" ) < 3 )
        {
            DelayCommand( IntToFloat( cCleanDelay * 2 ) , CleanVar( oPC, FALSE ) );
            SetLocalInt( oPC, "fw_clean_tries", GetLocalInt( oPC, "fw_clean_tries" ) + 1 );
        }
    }
}

void EvaluateConvChecks ( object oPC )
{
    if(GetLocalInt( oPC, "fw_rp" ) ) {
        SetLocalInt( oPC, "ds_check_1", FALSE );
        SetLocalInt( oPC, "ds_check_2", TRUE );
    }
    else {
        SetLocalInt( oPC, "ds_check_1", TRUE );
        SetLocalInt( oPC, "ds_check_2", FALSE );
    }

    if(GetLocalInt( oPC, "fw_rp_ecl" ) ) {
        SetLocalInt( oPC, "ds_check_3", FALSE );
        SetLocalInt( oPC, "ds_check_4", TRUE );
    }
    else {
        SetLocalInt( oPC, "ds_check_3", TRUE );
        SetLocalInt( oPC, "ds_check_4", FALSE );
    }

    if(GetLocalInt( oPC, "fw_rp_area" ) ) {
        SetLocalInt( oPC, "ds_check_5", FALSE );
        SetLocalInt( oPC, "ds_check_6", TRUE );
    }
    else {
        SetLocalInt( oPC, "ds_check_5", TRUE );
        SetLocalInt( oPC, "ds_check_6", FALSE );
    }

    if(GetLocalInt( oPC, "fw_rp_hunt" ) ) {
        SetLocalInt( oPC, "ds_check_7", FALSE );
        SetLocalInt( oPC, "ds_check_8", TRUE );
    }
    else {
        SetLocalInt( oPC, "ds_check_7", TRUE );
        SetLocalInt( oPC, "ds_check_8", FALSE );
    }

    if(GetLocalInt( oPC, "fw_assist" ) ) {
        SetLocalInt( oPC, "ds_check_9", FALSE );
        SetLocalInt( oPC, "ds_check_10", TRUE );
    }
    else {
        SetLocalInt( oPC, "ds_check_9", TRUE );
        SetLocalInt( oPC, "ds_check_10", FALSE );
    }
}

void OverrideHenchmanAI( object oPC )
{
    if( !GetLocalInt( oPC, "fw_assist" ) ) {
        SetLocalInt( oPC, "fw_assist", 1 );
        SendMessageToPC( oPC , "<c¦? >You are now overriding henchmen AI (beta).</c>" );
    }
    else {
        SetLocalInt( oPC, "fw_assist", 0 );
        SendMessageToPC( oPC , "<c¦? >You are no longer overriding henchmen AI (beta).</c>" );
    }
}
