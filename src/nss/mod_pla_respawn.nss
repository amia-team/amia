//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: mod_pla_respawn
//group: module events
//used as: OnPlayerRespawn
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "inc_ds_died"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC = GetLastRespawnButtonPresser();
    int nClassBG      = GetLevelByClass(31,oPC);
    object area = GetArea(oPC);
    string areaTag = GetTag(area);
    int rescueZone = GetLocalInt(area, "FreeRespawn");
    object rescueWP = GetWaypointByTag(areaTag + "_wp");
    string rescueMessage = GetLocalString(area, "rescue_message");

    if (GetLocalInt(oPC, "StasisDeath") == TRUE)
    {
        SetLocalInt(oPC, "StasisDeath", FALSE);
    }

    if ( !ResolvePvpRespawn( oPC ) ){

        ResolveNormalRespawn( oPC );
        ExecuteScript("race_effects", oPC);
        ExecuteScript("subrace_effects", oPC);
    }

    // BG Aura of Despair.
    if(nClassBG >= 3){
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ExtraordinaryEffect( EffectAreaOfEffect( 56, "bg_des_en", "****", "bg_des_ex" ) ), oPC );
    }
    // Free Respawn areas with rescue waypoints
    if(rescueZone == 1 && GetIsObjectValid(rescueWP)){
        DelayCommand( 1.1, AssignCommand(oPC, JumpToObject(rescueWP, 0)));
        if(rescueMessage != ""){
            FloatingTextStringOnCreature(rescueMessage, oPC, TRUE, TRUE);
        }
    }
}
