//::///////////////////////////////////////////////
//:: Lightning Bolt
//:: NW_S0_LightnBolt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 1d6 per level in a 5ft tube for 30m
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On:  March 8, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 2, 2001

//2007-05-30  disco   general unfucking
//7/25/2016   msheeler  added bonus for spell foci

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_arcanearcher"

void main(){

    // Temp var
    int nExtended = 0;

    if ( GetMetaMagicFeat() == METAMAGIC_EXTEND ){

        nExtended=1;
    }

    // Resolve Arcane Archer Status
    if ( ImbueArrow( OBJECT_SELF, GetSpellId(), GetSpellTargetObject(), GetLastSpellCastClass(), nExtended ) == TRUE ){

        return;
    }

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if ( !X2PreSpellCastCode() ){

    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook


    //Declare major variables
    object oCaster          = OBJECT_SELF;
    vector oCasterPos       = GetPosition(oCaster);
    int nCasterLevel        = GetCasterLevel(oCaster);
    int nBonusMaxDice       = 0;

    //Limit caster level
    if ( nCasterLevel > 10 ){

        nCasterLevel = 10;
    }

    //determine bonus for spell foci
    if (GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nBonusMaxDice = 2;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nBonusMaxDice = 4;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nBonusMaxDice = 6;
    }

    int nMetaMagic          = GetMetaMagicFeat();
    int nDC                 = GetSpellSaveDC();

    //Set the lightning stream to start at the caster's hands
    effect eLightningStream = EffectBeam( VFX_BEAM_LIGHTNING, oCaster, BODY_NODE_HAND );
    effect eLightningVfx    = EffectVisualEffect( VFX_IMP_LIGHTNING_S );
    effect eStun            = EffectStunned();

    location lTarget        = GetLocation(GetSpellTargetObject());
    float fDelay            = 0.0;

    // removed double while loop since it causes TMI's - kfw
    object oTarget          = GetFirstObjectInShape( SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE, oCasterPos );
    object oPreviousTarget  = oTarget;



    // cycle for all victims in a 30-foot straight line
    while ( oTarget != OBJECT_INVALID ){

        // foes only
        if ( GetIsEnemy ( oTarget, oCaster ) == TRUE){

            //Fire cast spell at event for the specified target
            SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_LIGHTNING_BOLT ) );

            // failed spell resistance check
            if ( MyResistSpell( oCaster, oTarget, 0.0 ) < 1 ){

                // lightning damage
                int nLightningDamage;

                // metamagic
                if ( nMetaMagic == METAMAGIC_MAXIMIZE ){

                    nLightningDamage = 6*(nCasterLevel + nBonusMaxDice);

                }
                else if ( nMetaMagic == METAMAGIC_EMPOWER ){

                    nLightningDamage = FloatToInt( IntToFloat( d6( nCasterLevel ) )*1.5 );
                }
                else{

                    nLightningDamage = d6( nCasterLevel + nBonusMaxDice );
                }

                // reflex saving
                nLightningDamage        = GetReflexAdjustedDamage( nLightningDamage, oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY );

                // vfx
                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLightningStream, oTarget, 1.0 ) );

                eLightningStream        = EffectBeam( VFX_BEAM_LIGHTNING, oPreviousTarget, BODY_NODE_CHEST );

                // damage
                effect eLightningDamage = EffectDamage( nLightningDamage, DAMAGE_TYPE_ELECTRICAL );

                eLightningDamage        = EffectLinkEffects( eLightningVfx, eLightningDamage );

                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eLightningDamage, oTarget, 0.0 ) );

                fDelay += 0.1;

                //stun effect for epic spell focus
                if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
                {
                    if (WillSave (oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY, oCaster) == 0)
                    {
                        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1) ) );
                    }
                }
            }

        }

        oPreviousTarget = oTarget;

        oTarget = GetNextObjectInShape( SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE, oCasterPos);
    }

    return;

}
