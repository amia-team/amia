//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  djinni_aura_sent
//group:   djinni
//used as: Enter Aura script for djinni sentinel
//date:    Feb 2025
//author:  Maverick

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


void ApplyTeleEffect(object oTarget);
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oCritter = GetAreaOfEffectCreator();
    location lCritter = GetLocation( oCritter );
    object oTarget = GetEnteringObject();

    if(!GetIsPC(oTarget))
    {
     return;
    }

    if((GetSkillRank(SKILL_HIDE,oTarget)<60) || (GetSkillRank(SKILL_MOVE_SILENTLY,oTarget)<60) || (GetStealthMode(oTarget)==STEALTH_MODE_DISABLED))
    {
     if((GetLocalInt(oCritter, "shutdown") <= 0))
     {
      ApplyTeleEffect(oTarget);
     }
    }

}

void ApplyTeleEffect(object oTarget)
{
  effect eDamage = EffectDamage(100,DAMAGE_TYPE_MAGICAL);
  effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
  effect eLink = EffectLinkEffects(eDamage,eVis);
  object oWP = GetWaypointByTag("djinni_respawn");

  ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget);

  DelayCommand( 0.1, AssignCommand( oTarget, ClearAllActions() ) );
  DelayCommand( 0.2, AssignCommand( oTarget, JumpToObject( oWP, 0 ) ) );

}
