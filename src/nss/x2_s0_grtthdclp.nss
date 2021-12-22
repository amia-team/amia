//::///////////////////////////////////////////////
//:: Great Thunderclap
//:: X2_S0_GrtThdclp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You create a loud noise equivalent to a peal of
// thunder and its acommpanying shock wave. The
// spell has three effects. First, all creatures
// in the area must make Will saves to avoid being
// stunned for 1 round. Second, the creatures must
// make Fortitude saves or be deafened for 1 minute.
// Third, they must make Reflex saves or fall prone.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 20, 2002
//:: Updated On: Oct 20, 2003 - some nice Vfx:)
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x0_i0_spells"

#include "x2_inc_spellhook"

void main()
{

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_GREAT_THUNDERCLAP ) );

    if ( GetIsObjectValid( GetSpellCastItem() ) ) {

        nTransmutation = 1;
    }
    // Vars
    location lTarget = GetSpellTargetLocation();
    effect eExplode = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
    effect eShake = EffectVisualEffect(356);
    int nDC = GetSpellSaveDC();
    int nDurationBonus = 0;
    float fDelay;
    object oTarget;

    //Orginal spellscript
    if( nTransmutation <= 1 )
    {
    effect eVis  = EffectVisualEffect(VFX_IMP_SONIC);
    effect eVis2 = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eVis3 = EffectVisualEffect(VFX_IMP_STUN);
    effect eDeaf = EffectDeaf();
    effect eKnock = EffectKnockdown();
    effect eStun = EffectStunned();

    //determin bonus for spell foci
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nDurationBonus = 1;
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, 2.0f);
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(10 + nDurationBonus)));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
            }
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1 + nDurationBonus)));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 6.0f));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis3, oTarget,4.0f));
            }
        }

       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
    return;
    }//---End trans 1

    if( nTransmutation == 2 )
    {
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eExplode, lTarget );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, 2.0f );

    int iCL    = GetCasterLevel( OBJECT_SELF );
    int nCap   = 10;

    //determin bonus for spell foci
    if (GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nCap = 12;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nCap = 14;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nCap = 16;
    }

    int nDamage =  GetNewCasterLevel(OBJECT_SELF);
    if (nDamage > nCap)
    {
        nDamage = nCap;
    }
    if( iCL > nCap ) iCL = nCap;

    int iSonic = 0;
    int iElect = 0;

    effect eElect = EffectDamage( iElect, DAMAGE_TYPE_ELECTRICAL);
    effect eSonic = EffectDamage( iSonic, DAMAGE_TYPE_SONIC);

    effect eSonicVis = EffectVisualEffect( VFX_IMP_SONIC );
    effect eElectVis = EffectVisualEffect( VFX_IMP_LIGHTNING_S );

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while (GetIsObjectValid(oTarget))
        {
            if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
            {
            //Singal the event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId( ) ) );
            //Calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation( oTarget ) )/20;
            //Calculate damage
            iSonic = d6( iCL );
            iElect = GetReflexAdjustedDamage( d6( iCL ), oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY );

            if( MySavingThrow( SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SONIC ) )
            iSonic = iSonic/2;

            //Set the effects and apply them
            eElect = EffectDamage( iElect, DAMAGE_TYPE_ELECTRICAL);
            eSonic = EffectDamage( iSonic, DAMAGE_TYPE_SONIC);

            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSonicVis, oTarget ) );
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eElectVis, oTarget ) );

            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eElect, oTarget ) );
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSonic, oTarget ) );
            }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE );
        }
    return;
    }
}

