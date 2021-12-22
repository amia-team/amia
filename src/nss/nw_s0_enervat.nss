//::///////////////////////////////////////////////
//:: Enervation
//:: NW_S0_Enervat.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target Loses 1d4 levels for 1 hour per caster
    level
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//2007/10/25    disco       added PM levels to the equation
//2007/10/26    disco       disabled


#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"
#include "inc_arcanearcher"
#include "amia_include"

void main()
{

    // Temp var
    int nExtended = 0;
    if( GetMetaMagicFeat() == METAMAGIC_EXTEND ){

        nExtended = 1;

    }

    // Resolve Arcane Archer Status
    if(ImbueArrow(
        OBJECT_SELF,
        GetSpellId(),
        GetSpellTargetObject(),
        GetLastSpellCastClass(),
        nExtended)==TRUE){

        return;

    }

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
    effect eVis         = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    object oTarget      = GetSpellTargetObject();
    int nPMLevel        = GetLevelByClass( CLASS_TYPE_PALEMASTER, OBJECT_SELF );
    int nDuration       = GetCasterLevel( OBJECT_SELF ) + nPMLevel;
    int nMetaMagic      = GetMetaMagicFeat();
    int nDrain          = d4();
    effect eDur         = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Enter Metamagic conditions
    if ( nMetaMagic == METAMAGIC_MAXIMIZE ){

        nDrain = 4;//Damage is at max
    }
    else if ( nMetaMagic == METAMAGIC_EMPOWER ){

        nDrain = nDrain + (nDrain/2); //Damage/Healing is +50%
    }
    else if ( nMetaMagic == METAMAGIC_EXTEND ){

        nDuration = nDuration *2; //Duration is +100%
    }

    effect eDrain       = EffectNegativeLevel( nDrain );
    effect eLink        = EffectLinkEffects( eDrain, eDur );

    if ( !GetIsReactionTypeFriendly( oTarget ) ){

        //Fire cast spell at event for the specified target
        SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_ENERVATION ) );

        //Resist magic check
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectSpellResistanceDecrease( nPMLevel ), oTarget, 0.5 );
        if ( !MyResistSpell( OBJECT_SELF, oTarget ) ){

            if ( !MySavingThrow( SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE ) ){

                //Apply the VFX impact and effects
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, NewHoursToSeconds( nDuration ) );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
            }
        }
    }
}

