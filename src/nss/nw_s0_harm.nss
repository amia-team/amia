// Harm Spell.
// Reduces target to 1d4 HP on successful touch attack.  If the target is
// undead it is healed.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/18/2001 Keith Soleski    Initial release.
// 03/06/2004 jpavelch         Added fortitude save for half damage.
// 12/13/2004 jpavelch         Merged NWN patch 1.65 changes.
//

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "amia_include"
#include "inc_td_shifter"
int GetIsUndead( object oCreature )
{
    return ( GetRacialType(oCreature) == RACIAL_TYPE_UNDEAD
            || GetLevelByClass(CLASS_TYPE_UNDEAD, oCreature) > 0 );
}
int GetHealAmount( object oTarget );

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
    object oTarget = GetSpellTargetObject();

    if ( GetObjectType(oTarget) != OBJECT_TYPE_CREATURE )
        return;


    int nDamage, nHeal;
    int nMetaMagic = GetMetaMagicFeat();
    int nTouch = TouchAttackMelee(oTarget);
    effect eVis = EffectVisualEffect(246);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
    effect eHeal, eDam;
    //Check that the target is undead
    if ( GetIsUndead(oTarget) )
    {
        if( GetIsPolymorphed( oTarget ) && oTarget == OBJECT_SELF )
            return;

        //Figure out the amount of damage to heal
        nHeal = GetHealAmount( oTarget );
        //Set the heal effect
        eHeal = EffectHeal(nHeal);
        //Apply heal effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HARM, FALSE));
    }
    else if (nTouch != FALSE)  //GZ: Fixed boolean check to work in NWScript. 1 or 2 are valid return numbers from TouchAttackMelee
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HARM));
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                nDamage = GetCurrentHitPoints(oTarget) - d4(1);
                //Check for metamagic
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = GetCurrentHitPoints(oTarget) - 1;
                }

                if( MySavingThrow(SAVING_THROW_FORT, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC())) )
                    nDamage /= 2;

                eDam = EffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}

int GetHealAmount( object oTarget ){

    float nBase = IntToFloat( GetMaxHitPoints( oTarget ) );
    if( !GetIsObjectValid( GetSpellCastItem( ) ) )
        return FloatToInt( nBase );
    int nTime = GetRunTime( );
    float nLast = IntToFloat( nTime-GetLocalInt( oTarget, "harm_timestamp" ) );
    float fMod  = 0.80;
    SetLocalInt( oTarget, "harm_timestamp", nTime );

    //Lazy
    if( nLast <= RoundsToSeconds( 1 ) )
        fMod = 0.05;
    else if( nLast <= RoundsToSeconds( 2 ) )
        fMod = 0.1;
    else if( nLast <= RoundsToSeconds( 3 ) )
        fMod = 0.15;
    else if( nLast <= RoundsToSeconds( 4 ) )
        fMod = 0.20;
    else if( nLast <= RoundsToSeconds( 5 ) )
        fMod = 0.25;
    else if( nLast <= RoundsToSeconds( 6 ) )
        fMod = 0.30;
    else if( nLast <= RoundsToSeconds( 7 ) )
        fMod = 0.35;
    else if( nLast <= RoundsToSeconds( 8 ) )
        fMod = 0.40;
    else if( nLast <= RoundsToSeconds( 9 ) )
        fMod = 0.45;
    else if( nLast <= RoundsToSeconds( 10 ) )
        fMod = 0.50;
    else if( nLast <= RoundsToSeconds( 11 ) )
        fMod = 0.55;
    else if( nLast <= RoundsToSeconds( 12 ) )
        fMod = 0.60;
    else if( nLast <= RoundsToSeconds( 13 ) )
        fMod = 0.65;
    else if( nLast <= RoundsToSeconds( 14 ) )
        fMod = 0.70;
    else if( nLast <= RoundsToSeconds( 15 ) )
        fMod = 0.75;

    SendMessageToPC( OBJECT_SELF, "Healing reduced to: "+IntToString( FloatToInt( fMod*100 ) )+"%" );

    nBase = nBase * fMod;

    return FloatToInt( nBase );
}
