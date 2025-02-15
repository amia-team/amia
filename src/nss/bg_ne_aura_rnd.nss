//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  gbbrng_aura_rnd
//group:   gbbrng
//used as: OnHeartbeat Aura script for Gibbering Mouther
//date:    sept 21 2012
//author:  Glim

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x0_i0_enemy"
#include "ds_ai2_include"
#include "X0_I0_SPELLS"
#include "inc_td_shifter"
//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void MassBlindDeaf( object oCritter, object oTarget );
void FireStorm( object oCritter );
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oCritter = GetAreaOfEffectCreator( OBJECT_SELF );
    location lCritter = GetLocation( oCritter );
    int nAttacks = 1;
    int nTargets = 1;
    object oTarget;


    object oNearestEnemy = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,1,oCritter,1,CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);

    if((GetDistanceBetween(oCritter,oNearestEnemy) <= 5.0) && (GetLocalInt(oCritter, "spellcd") <= 0) && GetIsEnemy(oNearestEnemy,oCritter))
    {
      int nSwitch  = d6(1);
      string sSpeak;

      switch(nSwitch)
      {
         case 1:   sSpeak = "<cûü >**Flicks its fingers towards the nearest enemy casting Mass Blindness**</c>"; MassBlindDeaf(oCritter,oNearestEnemy); break;
         case 2:   sSpeak = "<cûü >**Summons down a Fire Storm spell around him**</c>"; FireStorm(oCritter); break;
         case 3:   sSpeak = "<cûü >**Flicks its fingers towards the nearest enemy casting Mass Blindness**</c>"; MassBlindDeaf(oCritter,oNearestEnemy); break;
         case 4:   sSpeak = "<cûü >**Flicks its fingers towards the nearest enemy casting Mass Blindness**</c>"; MassBlindDeaf(oCritter,oNearestEnemy); break;
         case 5:   sSpeak = "<cûü >**Summons down a Fire Storm spell around him**</c>"; FireStorm(oCritter); break;
         case 6:   sSpeak = "<cûü >**Flicks its fingers towards the nearest enemy casting Mass Blindness**</c>"; MassBlindDeaf(oCritter,oNearestEnemy); break;
         default:  break;
      }


      AssignCommand( oCritter, SpeakString( sSpeak ) );
      SetLocalInt(oCritter,"spellcd",5);

    }
    else
    {
      int nCD = GetLocalInt(oCritter, "spellcd");
      SetLocalInt(oCritter,"spellcd",nCD-1);
    }

}

void MassBlindDeaf( object oCritter, object oTarget )
{
    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = 15;
    effect eBlind =  EffectBlindness();
    effect eDeaf = EffectDeaf();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    location lTarget = GetLocation(oTarget);

    //Link the blindness and deafness effects
    effect eLink = EffectLinkEffects(eBlind, eDeaf);
    eLink = EffectLinkEffects(eLink, eDur);
    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eXpl = EffectVisualEffect(VFX_FNF_BLINDDEAF);

    //Play area impact VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eXpl, lTarget);
    //Get the first target in the spell area
    object oTargetFirst = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    while (GetIsObjectValid(oTargetFirst))
    {
        if (spellsIsTarget(oTargetFirst, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTargetFirst, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_BLINDNESS_AND_DEAFNESS));
            //Make SR check
            if (!MyResistSpell(OBJECT_SELF, oTargetFirst))
            {
                //Make Fort save
                if (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, 38))
                {
                    //Apply the linked effects and the VFX impact
                    if( GetLocalInt( oTarget, "blind_immune" ) != 1 )
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTargetFirst, RoundsToSeconds(nDuration));
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTargetFirst);
                    }
                }
            }
        }
        //Get next object in spell area
        oTargetFirst = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,lTarget);
    }


}

void FireStorm( object oCritter)
{

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nDamage2;
    int nCasterLevel = 15;
    int nCap = 20;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eFireStorm = EffectVisualEffect(VFX_FNF_FIRESTORM);
    float fDelay;


    //Apply Fire and Forget Visual in the area;
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFireStorm, GetLocation(oCritter));
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCritter), OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        //This spell smites everyone who is more than 2 meters away from the caster.
        //if (GetDistanceBetween(oTarget, OBJECT_SELF) > 2.0)
        //{
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCritter) && oTarget != oCritter)
            {
                fDelay = GetRandomDelay(1.5, 2.5);
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oCritter, SPELL_FIRE_STORM));
                //Make SR check, and appropriate saving throw(s).
                if (!MyResistSpell(oCritter, oTarget, fDelay))
                {
                      //Roll Damage
                      nDamage = d6(nCasterLevel);
                      //Save versus both holy and fire damage
                      nDamage2 = GetReflexAdjustedDamage(nDamage/2, oTarget, 28, SAVING_THROW_TYPE_DIVINE);
                      nDamage = GetReflexAdjustedDamage(nDamage/2, oTarget, 28, SAVING_THROW_TYPE_FIRE);
                    if(nDamage > 0)
                    {
                          // Apply effects to the currently selected target.  For this spell we have used
                          //both Divine and Fire damage.
                          effect eDivine = EffectDamage(nDamage2, DAMAGE_TYPE_DIVINE);
                          effect eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDivine, oTarget));
                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                }
            //}
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCritter), OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }


}

