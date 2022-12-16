//::///////////////////////////////////////////////
//:: [Dominate Monster]
//:: [NW_S0_DomMon.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will save or the target monster is Dominated for
    3 turns +1 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 30, 2001
//:://////////////////////////////////////////////
//:: Modified: July 4 2K6, Permit dominated creatures to area transition.
//:://////////////////////////////////////////////

//-------------------------------------------------------------------------------
// updates
//-------------------------------------------------------------------------------
// 20080216     Disco       Added GS nerf when a level 22+ summon/domination is detected

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "amia_include"
#include "inc_domains"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode()){

    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();


    //--------------------------------------------------------------------------------
    //GS + dominate nerf
    //--------------------------------------------------------------------------------

    if ( GetHitDice( oTarget ) > 22 && GetHasSpellEffect( SPELL_ETHEREALNESS ) ){

        RemoveEffectsBySpell( oCaster, SPELL_ETHEREALNESS );
        SendMessageToPC( oCaster, "Dominating level 23+ monsters removes GS." );
    }

    effect eDom         = EffectDominated();
    eDom                = GetScaledEffect(eDom, oTarget);

    //Is this a dominatee or a summon?
    if ( GetIsObjectValid( GetMaster( oTarget ) ) ){
    eDom    = EffectDazed();
    }

    effect eMind        = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur         = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //added secondary effect for PCs
    effect eDecreaseWill  = EffectSavingThrowDecrease (SAVING_THROW_WILL, 2);

    //Link domination and persistant VFX
    effect eLink        = EffectLinkEffects(eMind, eDom);
    eLink               = EffectLinkEffects(eLink, eDur);

    effect eVis         = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    int nMetaMagic      = GetMetaMagicFeat();
    int nCasterLevel    = GetCasterLevel(oCaster);
    int nDuration       = 3 + nCasterLevel/2;
    //added secondary duration for effect vs. PC
    int nDurationPC     = 5;
    int nSpellDC = GetSpellSaveDC();


    //Item fired stuff
    object oCastFromItem = GetSpellCastItem();
    string sTag;

    if ( GetIsObjectValid( oCastFromItem ) )
    {
        sTag = GetTag( oCastFromItem );

        if ( sTag == "js_dryaddom" )
        {
            nCasterLevel = 26;
            nDuration = 3 + nCasterLevel/2;
            nSpellDC = 38;
            }
    }
    //

    nDuration           = GetScaledDuration(nDuration, oTarget);

    int nRacial         = GetRacialType(oTarget);


    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DOMINATE_MONSTER, FALSE));

    //Make sure the target is a monster
    if(!GetIsReactionTypeFriendly(oTarget)){

          //Make SR Check
          if (!MyResistSpell(oCaster, oTarget)) {

               //Make a Will Save
               if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC, SAVING_THROW_TYPE_MIND_SPELLS)) {

                    //Check for epic spell focus
                    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oCaster)){
                        nDuration += 1;
                        nDurationPC += 1;
                    }
                    //Check for Metamagic extension
                    if (nMetaMagic == METAMAGIC_EXTEND || GetHasFeat( FEAT_TYRANNY_DOMAIN_POWER, OBJECT_SELF)) {
                        nDuration = nDuration * 2;
                        nDurationPC = nDurationPC *2;
                    }

                    // PCs-only.
                    // And summons/dominates
                    // Reduced Duration vs. PC/Summons
                    if( GetIsPC( oTarget ) || GetIsObjectValid( GetMaster( oTarget ) ) ){
                        //Apply linked effects and VFX Impact
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nDurationPC ) );
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDecreaseWill, oTarget, TurnsToSeconds (nDuration));

                    }
                    // Monsters [Creature and non-plot].
                    else if(    GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE    &&
                                !GetPlotFlag( oTarget )                             ){

                        // Dominate the new-tagged one.
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds( nDuration ) );
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );

                    }
                }
           }
     }
}
