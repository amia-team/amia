// Mass Heal spell.
// Heals all friendly targets within 10ft to full unless they are undead.
// If undead they reduced to 1d4 HP.
//
// Revision History
// Date       Name                Description
// ---------- ----------------    --------------------------------------------
// 04/11/2001 Preston Watamaniuk  Initial release.
// 03/06/2004 jpavelch            Added fortitude save for undead.
// 2013/01/08 Glim                Added removal of Obyrith Madness
//

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"


int GetIsUndead( object oCreature )
{
    return ( GetRacialType(oCreature) == RACIAL_TYPE_UNDEAD
            || GetLevelByClass(CLASS_TYPE_UNDEAD, oCreature) > 0 );
}


void main( )
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


  //Declare major variables
  effect eKill;
  effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eHeal;
  effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
  effect eStrike = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
  int nTouch, nModify, nDamage, nHeal;
  int nMetaMagic = GetMetaMagicFeat();
  float fDelay;
  location lLoc =  GetSpellTargetLocation();

  //Apply VFX area impact
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, lLoc);
  //Get first target in spell area
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
  while(GetIsObjectValid(oTarget))
  {
      fDelay = GetRandomDelay();
      //Check to see if the target is an undead
      if ( GetIsUndead(oTarget) && !GetIsReactionTypeFriendly(oTarget))
      {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HEAL));
            //Make a touch attack
            nTouch = TouchAttackRanged(oTarget);
            if (nTouch > 0)
            {
                if(!GetIsReactionTypeFriendly(oTarget))
                {
                    //Make an SR check
                    if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                    {
                        //Roll damage
                        nModify = d4();
                        //make metamagic check
                        if (nMetaMagic == METAMAGIC_MAXIMIZE)
                        {
                            nModify = 1;
                        }
                        //Detemine the damage to inflict to the undead
                        nDamage =  GetCurrentHitPoints(oTarget) - nModify;
                        if ( MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()) )
                            nDamage /= 2;

                        //Set the damage effect
                        eKill = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
                        //Apply the VFX impact and damage effect
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                 }
            }
      }
      else
      {
            //Make a faction check
            if(GetIsFriend(oTarget) && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
            {
                //Cure Obyrith Madness if target is affected
                int nMadness = GetLocalInt( oTarget, "ObyMad" );
                if( nMadness == 1 )
                {
                    effect eRemove = GetFirstEffect( oTarget );
                    object oObyrith = GetLocalObject( oTarget, "Obyrith" );

                    while ( GetIsEffectValid( eRemove ) )
                    {
                        if( GetEffectCreator( eRemove ) == oObyrith )
                        {
                            RemoveEffect( oTarget, eRemove );
                        }
                        eRemove = GetNextEffect( oTarget );
                    }
                    SetLocalInt( oTarget, "Heal", 1 );
                    SetLocalInt( oTarget, "ObyMad", 2 );
                    DeleteLocalObject( oTarget, "Obyrith" );
                }

                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HEAL, FALSE));
                //Determine amount to heal
                nHeal = GetMaxHitPoints(oTarget);
                //Set the damage effect
                eHeal = EffectHeal(nHeal);
                //Apply the VFX impact and heal effect
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
            }
      }
      //Get next target in the spell area
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
   }
}
