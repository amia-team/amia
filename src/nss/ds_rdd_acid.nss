//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trans_actions
//group:   rdd customiser
//used as: spell script
//date:    2009-03-15
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int RollD6();

void DoBreath( object oPC, object oTarget, location lTarget );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------



void main(){

    object oPC          = OBJECT_SELF;

    //check block time
    if ( GetLocalInt(oPC,"ds_RDD_b") == 1 ){

        SendMessageToPC( oPC, "Your energy reserves are still recovering.");
        return;
    }
    else
    {

    // New cool down
    int nDDLvl = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oPC);
    int i;
    int nTime;
    int nSec;
    int nMin;

    if(nDDLvl >= 15)
    {
      for(i = 0; i < 4; i++)
      {
        nTime = nTime + RollD6()*6;
      }
    }
    else if(nDDLvl >= 10)
    {
      for(i = 0; i < 6; i++)
      {
        nTime = nTime + RollD6()*6;
      }
    }
    else if(nDDLvl >= 3)
    {
      for(i = 0; i < 8; i++)
      {
        nTime = nTime + RollD6()*6;
      }
    }

    nMin = nTime/60;
    nSec = nTime - (nMin*60);
    //
    int nCooldown = nTime;

    DelayCommand( IntToFloat( nCooldown ), FloatingTextStringOnCreature( "<c þ >You can now use your breath weapon again!</c>", oPC, FALSE ) );

    //apply the cooldown time
    SetLocalInt( oPC, "ds_RDD_b", 1);
    SendMessageToPC( oPC, "Your energy reserves will recover in " + IntToString(nCooldown) + " seconds.");
    DelayCommand( IntToFloat( nCooldown ),SetLocalInt( oPC, "ds_RDD_b", 0));

    location lTarget    = GetSpellTargetLocation( );
    object oTarget      = GetSpellTargetObject( );

    DoBreath( oPC, oTarget, lTarget );

    }
}
//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
int RollD6()
{
  int nRandom = Random(6) + 1;
  return nRandom;
}

void DoBreath( object oPC, object oTarget, location lTarget ){

    object oVictim;
    int nDamageType  = 16;
    int nImp         = 44;
    int nST          = 6;

    if ( GetIsObjectValid( oTarget ) ){

        lTarget = GetLocation( oTarget );
    }

    int nRDD_Rank           = GetLevelByClass( CLASS_TYPE_DRAGON_DISCIPLE, oPC );
    int nDC                 = 10 + nRDD_Rank + GetAbilityModifier( ABILITY_CONSTITUTION, oPC );
    int nDamage             = 0;
    effect eHit;
    effect eImp             = EffectVisualEffect( nImp );
    effect eSlow;
    effect eVFX;

    // Acquire targets within a 20-foot long cone about the RDD.
    oVictim = GetFirstObjectInShape( SHAPE_SPELLCONE, 20.0, lTarget, FALSE );

    if( GetLocalInt( oPC, "special_breath_1" ) > 0 ) // For custom request breathes, may or may not be expanded later
    {
        // Iterate through available targets.
        while ( GetIsObjectValid( oVictim ) ){

            // Filter: Not the RDD herself; AND is an enemy of the RDD.
            if ( oVictim != oPC && GetIsEnemy( oVictim, oPC ) ){

                // Damage applicable, burn 'em!
                if( ReflexSave( oVictim, nDC, SAVING_THROW_TYPE_NONE, oPC ) < 1 ){

                    eSlow = EffectSlow();
                    eVFX = EffectVisualEffect( VFX_IMP_SLOW );

                    DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSlow, oVictim, RoundsToSeconds( nRDD_Rank ) ) );
                    DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oVictim ) );
                }
            }

            oVictim = GetNextObjectInShape( SHAPE_SPELLCONE, 20.0, lTarget, FALSE );
        }
    }
    else
    {
        // Iterate through available targets.
        while ( GetIsObjectValid( oVictim ) ){

            // Filter: Not the RDD herself; AND is an enemy of the RDD.
            if ( oVictim != oPC && GetIsEnemy( oVictim, oPC ) ){

                // Roll a Reflex Save.
                nDamage = GetReflexAdjustedDamage( d10( nRDD_Rank ), oVictim, nDC, nST, oPC );

                // Damage applicable, burn 'em!
                if ( nDamage ){

                    eHit = EffectLinkEffects( eImp, EffectDamage( nDamage, nDamageType ) );

                    DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_INSTANT, eHit, oVictim ) );
                }
            }

            oVictim = GetNextObjectInShape( SHAPE_SPELLCONE, 20.0, lTarget, FALSE );
        }
    }
}

