/*  i_fk_dc_item002
--------
Verbatim
--------
Pools custom item request scripts
---------
Changelog
---------
Date         Name        Reason
------------------------------------------------------------------
2010-11-1    Bruce       Start
2012-02-14   Mathias     Removed the FakeSpell call and applied the new cooldown from the new breath feats.
------------------------------------------------------------------
DC item that mimics an RDD breath with some changes (namely sonic damage and DC/Damage is Character level based.)


*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------

#include "x2_inc_switches"
#include "x0_i0_position"
#include "NW_I0_GENERIC"
#include "amia_include"
//-------------------------------------------------------------------------------
//Prototypes
//-------------------------------------------------------------------------------

void HowlingBreath( object oPC  );
void CycleTargets( object oPC );
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
          string sItemName = GetName( oItem );
          location lTarget = GetLocation( oPC );

              //check block time
              if ( GetIsBlocked( oPC, "ds_RDD_b" ) > 0 ){

                  string sRecharge = IntToString( GetIsBlocked( oPC, "ds_RDD_b" ) );
                  SendMessageToPC( oPC, "Your energy reserves are still recovering, allowing for another howl in " +sRecharge+ " seconds!" );
                  return;
              }

              //find constituation adjustment to block time
              int nCD = 10 * GetAbilityModifier( ABILITY_CONSTITUTION, oPC );
              int nMin;
              int nSec;

              //set cooldown adjustment for later use
              if ( nCD == 0 )
              {
                  nMin = 5;
                  nSec = 0;
              }
              else if ( nCD > 0 && nCD <= 60 )
              {
                  nMin = 4;
                  nSec = ( 60 - nCD );
              }
              else if ( nCD > 60 && nCD <= 120 )
              {
                  nMin = 3;
                  nSec = ( 120 - nCD );
              }
              else if ( nCD > 120 && nCD <= 180 )
              {
                  nMin = 2;
                  nSec = ( 180 - nCD );
              }
              else if ( nCD > 180 && nCD <= 240 )
              {
                  nMin = 1;
                  nSec = ( 240 - nCD );
              }
              else if ( nCD > 240 && nCD <= 300 )
              {
                  nMin = 0;
                  nSec = ( 300 - nCD );
              }
              else if ( nCD > 300 )
              {
                  nMin = 0;
                  nSec = 0;
              }

              //apply the cooldown time
              SetBlockTime( oPC, nMin, nSec, "ds_RDD_b" );
              AssignCommand( oPC, HowlingBreath( oPC ) );

          break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//Definitions
//-------------------------------------------------------------------------------

void HowlingBreath( object oPC ){


    //Throw the howl vfx and apply damage to targets
    ActionDoCommand(CycleTargets (oPC));

}

void CycleTargets( object oPC ){

    //variable block
    object oVictim;
    location lTarget        = GetLocation( oPC );
    int nChar_Rank          = GetLevelByClass( CLASS_TYPE_DRAGONDISCIPLE,oPC );
    int nDC                 = 10 + (nChar_Rank)  + GetAbilityModifier( ABILITY_CONSTITUTION, oPC );
    int nDamage             = 0;
    effect eImp             = EffectVisualEffect( VFX_COM_HIT_SONIC );
    effect eHowlvfx         = EffectVisualEffect(VFX_FNF_HOWL_MIND);
    effect eHit;

    // Apply effects as requested
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHowlvfx, oPC);

    // Acquire targets within a 10-meter sphere about the user.
    oVictim = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, lTarget, FALSE );

    // Iterate through available targets.
    while ( GetIsObjectValid( oVictim ) ){

        // Filter: Not the RDD herself; AND is an enemy of the user.
        if ( oVictim != oPC && GetIsEnemy( oVictim, oPC ) ){

            // Roll a Reflex Save.
            nDamage = GetReflexAdjustedDamage( d8( nChar_Rank ), oVictim, nDC, SAVING_THROW_TYPE_SONIC, oPC );

            // Damage applicable, apply sonic damage.
            if ( nDamage ){

                eHit = EffectLinkEffects( eImp, EffectDamage( nDamage, DAMAGE_TYPE_SONIC ) );

                DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_INSTANT, eHit, oVictim ) );
            }
        }

        oVictim = GetNextObjectInShape( SHAPE_SPHERE, 10.0, lTarget, FALSE );
    }
}
