/* Wand of faerie fire:
    -   Duration: 7 turns
    -   AB -2, Hide -20, glow a random color

  Modified April 22nd 2020 - Maverick00053
  - Added in a Save versus Reflex, SR will be taken into account
*/


// includes
#include "x2_inc_switches"

void ApplyFaerieFire( object oCaster, object oTarget, int nGlow ){

       // Combining all the effects so they act as one
       effect eSkillDecrease = EffectSkillDecrease( SKILL_HIDE, 20 );
       effect eAttackDecrease = EffectAttackDecrease( 2 );
       effect eVisualEffect =  EffectVisualEffect( nGlow );
       effect eLink = EffectLinkEffects(eSkillDecrease,eAttackDecrease);
       eLink = EffectLinkEffects(eVisualEffect,eLink);

       int iSpellPen = 0;
       if(GetHasFeat(FEAT_SPELL_PENETRATION,oCaster))
       {
          iSpellPen = iSpellPen + 2;
       }

       if(GetHasFeat(FEAT_GREATER_SPELL_PENETRATION,oCaster))
       {
          iSpellPen = iSpellPen + 2;
       }

       if(GetHasFeat(FEAT_EPIC_SPELL_PENETRATION,oCaster))
       {
          iSpellPen = iSpellPen + 2;
       }
       // Max DC is 34. Level 28 + 6 added.
       int iCasterLvl = 6 + GetLevelByPosition(1,oCaster) + GetLevelByPosition(2,oCaster) + GetLevelByPosition(3,oCaster);
       int iTargetSR = GetSpellResistance(oTarget);
       int iCasterSpellPen = ((Random(20) + 1)) + iCasterLvl + iSpellPen;



    if( !GetIsObjectValid( oTarget ) )
        return;

    else if( oCaster == oTarget ){

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oCaster, TurnsToSeconds( 7 ));
        return;
    }

    else if( TouchAttackRanged( oTarget, TRUE ) != 0 ){


    // SR save
    if(iCasterSpellPen >= iTargetSR)
    {
      FloatingTextStringOnCreature("Failled spell resistance save.",oTarget);
      // Reflex save - DC is decided by PC level
      if(!ReflexSave(oTarget, iCasterLvl, SAVING_THROW_TYPE_SPELL, oTarget))
      {
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds( 7 ) );
        FloatingTextStringOnCreature("Failed reflex save.",oTarget);
        return;
      }
      else
      {
        FloatingTextStringOnCreature("Successful reflex save.",oTarget);
      }
    }
    else
    {
        FloatingTextStringOnCreature("Successful spell resistance save.",oTarget);
    }


    }


}

void main(){

    int nEvent=GetUserDefinedItemEventNumber();

    if( nEvent == X2_ITEM_EVENT_ACTIVATE ){

        object oTarget = GetItemActivatedTarget();
        object oCaster = GetItemActivator();

        int nGlow = 0;

        switch( d6() ){

            case 1:nGlow = VFX_DUR_GLOW_ORANGE;break;

            case 2:nGlow = VFX_DUR_GLOW_PURPLE;break;

            case 3:nGlow = VFX_DUR_GLOW_RED;break;

            case 4:nGlow = VFX_DUR_GLOW_YELLOW;break;

            case 5:nGlow = VFX_DUR_GLOW_GREEN;break;

            case 6:nGlow = VFX_DUR_GLOW_WHITE;break;

            default:nGlow = VFX_DUR_GLOW_BLUE;break;
        }

        AssignCommand( oCaster, ApplyFaerieFire( oCaster, oTarget, nGlow ) );

    }

    SetExecutedScriptReturnValue( X2_EXECUTE_SCRIPT_END );
}
