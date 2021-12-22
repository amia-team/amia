// Heal spell.
// Heals the target to full unless they are undead.  If undead they
// reduced to 1d4 HP.
//
// Revision History
// Date       Name                Description
// ---------- ----------------    --------------------------------------------
// 01/12/2001 Preston Watamaniuk  Initial release.
// 03/06/2004 jpavelch            Added fortitude save for undead.
// 2008/03/22 disco               new pvp system added
// 20100822   Terra               Restiction on heal from items
// 2012/02/10 Naivatkal           Altered heal pots ber balance discussions
// 2013/01/08 Glim                Added removal of Obyrith Madness

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_ds_died"
#include "amia_include"

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

    //---------------------------------------------------------
    //post pvp use
    //---------------------------------------------------------
    if ( GetIsDead( oTarget ) ){

        int nPvpMode = GetLocalInt( oTarget, DIED_DEAD_MODE );

        if ( nPvpMode == 1 ){

            effect eRaise = EffectResurrection();

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eRaise, oTarget );

            RemoveDeadStatus( oTarget );

            return;
        }
    }

  effect eKill, eHeal;
  int nDamage, nHeal, nModify, nMetaMagic, nTouch;
  effect eSun = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_X);
    //Check to see if the target is an undead
    if ( GetIsUndead(oTarget) )
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL));
            //Make a touch attack
            if (TouchAttackMelee(oTarget))
            {
                //Make SR check
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    //Roll damage
                    nModify = d4();
                    nMetaMagic = GetMetaMagicFeat();
                    //Make metamagic check
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nModify = 1;
                    }
                    //Figure out the amount of damage to inflict
                    nDamage =  GetCurrentHitPoints(oTarget) - nModify;

                    if( MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()) )
                        nDamage /= 2;

                    //Set damage
                    eKill = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
                    //Apply damage effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eSun, oTarget);
                }
            }
        }
    }
    else
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
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL, FALSE));
        //Figure out how much to heal
        nHeal = GetHealAmount( oTarget );
        //Set the heal effect
        eHeal = EffectHeal(nHeal);
        //Apply the heal effect and the VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    }
}

int GetHealAmount( object oTarget ){

    float nBase = IntToFloat( GetMaxHitPoints( oTarget ) );
    if( !GetIsObjectValid( GetSpellCastItem( ) ) )
        return FloatToInt( nBase );
    int nTime = GetRunTime( );
    float nLast = IntToFloat( nTime-GetLocalInt( oTarget, "heal_timestamp" ) );
    float fMod  = 0.80;
    SetLocalInt( oTarget, "heal_timestamp", nTime );

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
