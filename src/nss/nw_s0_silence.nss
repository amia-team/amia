//::///////////////////////////////////////////////
//:: Silence
//:: NW_S0_Silence.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

// 2007-02-12 Rewritten by Disco

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"
void main(){

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    // This is the Object to apply the effect to.
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    effect eSilence;
    effect eDeaf;
    effect eImmunity;
    effect eVis;
    int nDuration  = GetNewCasterLevel( OBJECT_SELF );

    int nMetaMagic = GetMetaMagicFeat();

    if ( nDuration < 1 ){

        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if ( nMetaMagic == METAMAGIC_EXTEND ){

       nDuration = nDuration *2;    //Duration is +100%
    }


    // Must be aimed at person
    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ){

        //feedback
        SendMessageToPC( oCaster, "SPELL CHANGE: this spell can only be cast on creatures!" );

        //get spell target location
        location lTarget = GetSpellTargetLocation();

        //apply misfire vfx
        eVis = EffectVisualEffect( VFX_IMP_WILL_SAVING_THROW_USE );
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eVis, lTarget, 1.0 );

        return;
    }

    if ( !GetIsFriend( oTarget, oCaster ) ){

        if ( MySavingThrow( SAVING_THROW_WILL, oTarget, GetShifterDC( oCaster, GetSpellSaveDC() ) ) ){

            return;
        }
        //neutral and hostile critters get a save
        if ( MyResistSpell( oCaster, oTarget ) > 0 ){

            return;
        }
    }

    // Create the effects
    eSilence  = EffectSilence();
    eDeaf     = EffectDeaf();
    eImmunity = EffectDamageImmunityIncrease( DAMAGE_TYPE_SONIC, 100 );
    eVis      = EffectVisualEffect( VFX_IMP_SILENCE );

    // Apply the effects
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSilence, oTarget, RoundsToSeconds(nDuration) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImmunity, oTarget, RoundsToSeconds(nDuration) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(nDuration) );
}



/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more



    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_SILENCE);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }

    if(!GetIsFriend(oTarget))
    {
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SILENCE));

                //Create an instance of the AOE Object using the Apply Effect function
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, RoundsToSeconds(nDuration));
            }
        }
    }
    else
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SILENCE, FALSE));
        //Create an instance of the AOE Object using the Apply Effect function
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, RoundsToSeconds(nDuration));
    }
}
*/
