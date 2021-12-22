//::///////////////////////////////////////////////
//:: Bolt: Web
//:: NW_S1_BltWeb
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Glues a single target to the ground with
    sticky strands of webbing.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 28, 2002
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////

// 2007-02-07   Disco   Blocked multiple hits on one target
// 2007-02-07   Disco   Added quick Dex buff at at the end to counter a BioBug

#include "NW_I0_SPELLS"
#include "x2_inc_switches"
void main(){

    object oTarget = GetSpellTargetObject();
    int nHD        = GetHitDice(OBJECT_SELF);
    int nTangled   = GetLocalInt( oTarget, "nTangled" );
    effect eVis    = EffectVisualEffect(VFX_DUR_WEB);
    effect eStick  = EffectEntangle();
    effect eLink   = EffectLinkEffects(eVis, eStick);
    effect eDex   =  EffectAbilityIncrease( ABILITY_DEXTERITY, 1 );

    if ( nTangled ){

        return;
    }

    int nDC = 10 + (nHD/2);
    int nCount = (nHD + 1) / 2;

    //Fire cast spell at event for the specified target
    SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_WEB) );

    // Dirty fix for the spider companion web spam. Will always make sure it only fires once.
    if((GetRacialType(OBJECT_SELF) == RACIAL_TYPE_VERMIN) && (!GetIsPC(OBJECT_SELF)))
    {
      int i;
      for ( i=1; i<(1 + nHD/2); ++i ){
      DecrementRemainingSpellUses(OBJECT_SELF,SPELLABILITY_BOLT_WEB);
      }
    }


    //Make a saving throw check
    if (TouchAttackRanged(oTarget)){

        if( !GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) && GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE ){

            //block
            SetLocalInt( oTarget, "nTangled", 1 );

            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCount) );

            //unfuck DEX
            DelayCommand( ( RoundsToSeconds(nCount) + 1.0 ), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, 1.0 ) );

            //unblock
            DelayCommand( RoundsToSeconds(nCount), DeleteLocalInt( oTarget, "nTangled" ) );

        }
    }
}
