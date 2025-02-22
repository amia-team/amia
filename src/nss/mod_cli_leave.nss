//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: mod_unacq_item
//group: module events
//used as: OnClientEnter
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)

// 2010/02/20   disco       Added some exploit counters
// 2015/06/08   msheeler    Added set variable on PC to reset log in status. This
//                          resets it for mod_cli_enter.

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_userdefconst"
#include "amia_include"
#include "logger"
#include "cs_inc_leto"
#include "inc_ds_records"
#include "inc_lua"
#include "fw_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main( ){

    int SAVE_LOCATION = TRUE;
    int SAVE_LOCATION_SAFE_ONLY = TRUE;
    string LOGOUT_LOCATION = "LOGOUT_LOCATION";
    string RETURN_NO_SET = "RETURN_NO_SET";
    //string RETURN_SPAWN_CHECK = "day_spawn1";

    // Variables
    object oModule          = GetModule( );
    object oPC              = GetExitingObject( );
    object oArea            = GetLocalObject( oPC, "LastArea" );
    object oStain           = GetLocalObject( oPC, "Bloodstain" );
    object oHenchman        = GetLocalObject( oPC, "henchman" );
    object oWidget          = GetItemPossessedBy(oPC, "ds_pckey");
    string sCDKEY           = GetLocalString( oPC, "ds_cdkey" );
    string sPCKEY           = GetLocalString( oPC, "pckey" );
    int nDamage             = GetMaxHitPoints( oPC ) - GetCurrentHitPoints( oPC );
    int nMonkPRC            = GetLocalInt(oPC, "monkprc");
    int eLoopSpellID;
    effect eLoop            = GetFirstEffect(oPC);

  //Death Tracker script.
  int index, iLev;
  string sLevels;
  iLev = GetCurrentHitPoints( oPC );
  sLevels = "HP=" + IntToString( iLev ) + ";";
  for( index = 0; index < 622; index++ )
  {
    iLev = GetHasSpell( index, oPC );
    if ( iLev > 0 )
      sLevels += "S" + IntToString( index ) + "=" + IntToString( iLev ) + ";";
  }
  for( index = 0; index < 480; index++ )
  {
    iLev = GetHasFeat( index, oPC );
    if ( iLev > 0 )
      sLevels += "F" + IntToString( index ) + "=" + IntToString( iLev ) + ";";
  }
  SetCampaignString( "Amia", GetPCPlayerName( oPC ) + GetName( oPC ) + "Levels", sLevels );
  //End Death Tracker script.

    ExportSingleCharacter( oPC );

    //resets logged in status for mod_cli_enter
    SetLocalInt(oPC, "LoggedIn", FALSE);

    /*object oAreaTwo = GetLocalObject(oPC, "last_area");
    //fw_instanceLeave(oAreaTwo);

    if( GetRunTime() < 91 ){

        return;
    }

    if ( GetLocalInt( oPC, "closing" ) == 1 ){

        return;
    }

    SetLocalInt( oModule, sPCKEY, NWNX_GetRunTime() );

    // Send the appropriate user-defined event to the last area the PC
    // was in to decrement the count.
    SignalEvent( oArea, EventUserDefined(AREA_PCEXIT) );*/

    // Remove blood stain, if applicable.
    if( GetIsObjectValid( oStain ) ){

        DeleteLocalObject( oPC, "Bloodstain" );
        DestroyObject( oStain );
    }

    if( GetIsObjectValid( oHenchman ) ){

        SetIsDestroyable( TRUE, FALSE, FALSE );
        DestroyObject( oHenchman );
    }

    // Allows persistence of PvP death info between resets
    // Nice because you're supposed to get a free respawn when killed in PvP.
    int nPvpMode = GetLocalInt( oPC, "pvp_dead_mode" );
    if( nPvpMode > 0 ){

        SetPCKEYValue( oPC, "pvp_dead_mode", nPvpMode );

    }

    //Tell lua a PC left
    //ExecuteLuaFunction( oPC, "PCLeave", ObjectToString( oPC ) );

    //end logging
    ClosePlayerRunTime( oPC, oModule, sCDKEY );

    //The glowy eyes bugs out if not cleared
    ClearEffectMadeByObjectWithTag( oPC, "td_glowy_eyes" );

    // Letoscript Functionality
    string szLetoScript = GetLocalString( oPC, "LetoScript" );

    if( szLetoScript != "" ){

        SetLocalString( oPC, "LetoScript", "" );
    
    // ExecuteLeto( szLetoScript );
    }

    if (GetLocalInt(oPC,"HIPSCooldown") != 0) {
        DeleteLocalInt(oPC,"HIPSCooldown");
    }

    // Remove Monk VFX otherwises it bugs
    if(nMonkPRC == 1)
    {
       while(GetIsEffectValid(eLoop))
       {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((GetEffectType(eLoop)==EFFECT_TYPE_ATTACK_INCREASE) && (eLoopSpellID == 948))
            {
                 RemoveEffect(oPC, eLoop);
            }
                eLoop=GetNextEffect(oPC);
        }
       DeleteLocalInt(oPC,"monkprc");
    }

    if (SAVE_LOCATION == TRUE) {
        object oPCKey = GetPCKEY(oPC);

        location logloc = GetLocation(oPC);
        int iNoCasting = GetLocalInt(oArea, RETURN_NO_SET);
        if (iNoCasting == FALSE) {
            int hasspawns = FALSE;
            string spawnset = GetLocalString(GetArea(oPC), "day_spawn1");
            if (spawnset == "") {
                spawnset = GetLocalString(GetArea(oPC), "night_spawn1");
            }
            if (spawnset != "") {
                hasspawns = TRUE;
            }
            if (SAVE_LOCATION_SAFE_ONLY == TRUE && hasspawns == TRUE) {
                hasspawns = TRUE;
            } else {
                SetLocalLocation(oPCKey, LOGOUT_LOCATION, logloc);
            }
        }
    }

    return;
}