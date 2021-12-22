//::///////////////////////////////////////////////
//:: Time Stop
//:: NW_S0_TimeStop.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All persons in the Area are frozen in time
    except the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Modified: Area-specific effect.
//:: Modified: Duration fix.
//:://////////////////////////////////////////////
// Modified for Amia to make it a cutscene paralysis instead.
// PaladinOfSune: New nerf to make it less hideously overpowered.
//

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    // Declare major variables.
    location lTarget    = GetSpellTargetLocation();
    effect eVis         = EffectVisualEffect( VFX_FNF_TIME_STOP );
    float fDuration     = 9.0;

    // Visuals for immunity sequence.
    object oImmune;

    effect eImmuneVis   = EffectVisualEffect( VFX_IMP_PDK_WRATH );
    effect eImmuneDur   = EffectVisualEffect( VFX_DUR_GLOBE_INVULNERABILITY );

    // General effects/visuals.
    effect eVis2        = EffectVisualEffect( 472 );
    effect eVis3        = EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION );
    effect eStop        = EffectCutsceneParalyze();

    // Damage immunities.
    effect eDamage1     = EffectDamageImmunityIncrease( DAMAGE_TYPE_ACID, 100 );
    effect eDamage2     = EffectDamageImmunityIncrease( DAMAGE_TYPE_BLUDGEONING, 100 );
    effect eDamage3     = EffectDamageImmunityIncrease( DAMAGE_TYPE_COLD, 100 );
    effect eDamage4     = EffectDamageImmunityIncrease( DAMAGE_TYPE_DIVINE, 100 );
    effect eDamage5     = EffectDamageImmunityIncrease( DAMAGE_TYPE_ELECTRICAL, 100 );
    effect eDamage6     = EffectDamageImmunityIncrease( DAMAGE_TYPE_FIRE, 100 );
    effect eDamage7     = EffectDamageImmunityIncrease( DAMAGE_TYPE_MAGICAL, 100 );
    effect eDamage8     = EffectDamageImmunityIncrease( DAMAGE_TYPE_NEGATIVE, 100 );
    effect eDamage9     = EffectDamageImmunityIncrease( DAMAGE_TYPE_PIERCING, 100 );
    effect eDamage10    = EffectDamageImmunityIncrease( DAMAGE_TYPE_POSITIVE, 100 );
    effect eDamage11    = EffectDamageImmunityIncrease( DAMAGE_TYPE_SLASHING, 100 );
    effect eDamage12    = EffectDamageImmunityIncrease( DAMAGE_TYPE_SONIC, 100 );

    // Status immunities.
    effect eImmunity1   = EffectImmunity( IMMUNITY_TYPE_ABILITY_DECREASE );
    effect eImmunity2   = EffectImmunity( IMMUNITY_TYPE_AC_DECREASE );
    effect eImmunity3   = EffectImmunity( IMMUNITY_TYPE_ATTACK_DECREASE );
    effect eImmunity4   = EffectImmunity( IMMUNITY_TYPE_BLINDNESS );
    effect eImmunity5   = EffectImmunity( IMMUNITY_TYPE_CRITICAL_HIT );
    effect eImmunity6   = EffectImmunity( IMMUNITY_TYPE_CURSED );
    effect eImmunity7   = EffectImmunity( IMMUNITY_TYPE_ABILITY_DECREASE );
    effect eImmunity8   = EffectImmunity( IMMUNITY_TYPE_DAMAGE_DECREASE );
    effect eImmunity9   = EffectImmunity( IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE );
    effect eImmunity10  = EffectImmunity( IMMUNITY_TYPE_DEAFNESS );
    effect eImmunity11  = EffectImmunity( IMMUNITY_TYPE_DEATH );
    effect eImmunity12  = EffectImmunity( IMMUNITY_TYPE_DISEASE );
    effect eImmunity13  = EffectImmunity( IMMUNITY_TYPE_ENTANGLE );
    effect eImmunity14  = EffectImmunity( IMMUNITY_TYPE_KNOCKDOWN );
    effect eImmunity15  = EffectImmunity( IMMUNITY_TYPE_MIND_SPELLS );
    effect eImmunity16  = EffectImmunity( IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE );
    effect eImmunity17  = EffectImmunity( IMMUNITY_TYPE_NEGATIVE_LEVEL );
    effect eImmunity18  = EffectImmunity( IMMUNITY_TYPE_POISON );
    effect eImmunity19  = EffectImmunity( IMMUNITY_TYPE_SAVING_THROW_DECREASE );
    effect eImmunity20  = EffectImmunity( IMMUNITY_TYPE_SILENCE );
    effect eImmunity21  = EffectImmunity( IMMUNITY_TYPE_SKILL_DECREASE );
    effect eImmunity22  = EffectImmunity( IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE );
    effect eImmunity23  = EffectImmunity( IMMUNITY_TYPE_SNEAK_ATTACK );
    effect eImmunity24  = EffectImmunity( IMMUNITY_TYPE_SLOW );
    effect eImmunity25  = EffectImmunity( IMMUNITY_TYPE_SLEEP );

    // Spell immunity.
    effect eSpellImmune = EffectSpellImmunity( SPELL_ALL_SPELLS );

    // Link it all together... this goes on a while.
    effect eLink        = EffectLinkEffects( eVis2, eStop );
           eLink        = EffectLinkEffects( eVis3, eLink );
           eLink        = EffectLinkEffects( eDamage1, eLink );
           eLink        = EffectLinkEffects( eDamage2, eLink );
           eLink        = EffectLinkEffects( eDamage3, eLink );
           eLink        = EffectLinkEffects( eDamage4, eLink );
           eLink        = EffectLinkEffects( eDamage5, eLink );
           eLink        = EffectLinkEffects( eDamage6, eLink );
           eLink        = EffectLinkEffects( eDamage7, eLink );
           eLink        = EffectLinkEffects( eDamage8, eLink );
           eLink        = EffectLinkEffects( eDamage9, eLink );
           eLink        = EffectLinkEffects( eDamage10, eLink );
           eLink        = EffectLinkEffects( eDamage11, eLink );
           eLink        = EffectLinkEffects( eDamage12, eLink );
           eLink        = EffectLinkEffects( eImmunity1, eLink );
           eLink        = EffectLinkEffects( eImmunity2, eLink );
           eLink        = EffectLinkEffects( eImmunity3, eLink );
           eLink        = EffectLinkEffects( eImmunity4, eLink );
           eLink        = EffectLinkEffects( eImmunity5, eLink );
           eLink        = EffectLinkEffects( eImmunity6, eLink );
           eLink        = EffectLinkEffects( eImmunity7, eLink );
           eLink        = EffectLinkEffects( eImmunity8, eLink );
           eLink        = EffectLinkEffects( eImmunity9, eLink );
           eLink        = EffectLinkEffects( eImmunity10, eLink );
           eLink        = EffectLinkEffects( eImmunity11, eLink );
           eLink        = EffectLinkEffects( eImmunity12, eLink );
           eLink        = EffectLinkEffects( eImmunity13, eLink );
           eLink        = EffectLinkEffects( eImmunity14, eLink );
           eLink        = EffectLinkEffects( eImmunity15, eLink );
           eLink        = EffectLinkEffects( eImmunity16, eLink );
           eLink        = EffectLinkEffects( eImmunity17, eLink );
           eLink        = EffectLinkEffects( eImmunity18, eLink );
           eLink        = EffectLinkEffects( eImmunity19, eLink );
           eLink        = EffectLinkEffects( eImmunity20, eLink );
           eLink        = EffectLinkEffects( eImmunity21, eLink );
           eLink        = EffectLinkEffects( eImmunity22, eLink );
           eLink        = EffectLinkEffects( eImmunity23, eLink );
           eLink        = EffectLinkEffects( eImmunity24, eLink );
           eLink        = EffectLinkEffects( eImmunity25, eLink );
           eLink        = EffectLinkEffects( eSpellImmune, eLink );

    // Can't be dispelled!
    SupernaturalEffect( eLink );

    // Radius of Colossal x3.
    object oVictim = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL * 3, lTarget, FALSE, OBJECT_TYPE_CREATURE );
    while( oVictim != OBJECT_INVALID )
    {
        // PCs and monsters only. (Exclude Phane and Quarut)
        if( oVictim != OBJECT_SELF &&
            GetIsDM( oVictim ) == FALSE &&
            GetLocalInt(oVictim, "IsPhane") != 2 &&
            GetLocalInt(oVictim, "IsQuarut") != 2)
        {
            // Check for immunity.
            oImmune = GetItemPossessedBy( oVictim, "timedisorder" );
            if( GetIsObjectValid( oImmune ) ) {

                // Create a circle of visuals around the caster.
                location lLocation;
                float fAngle;
                float fDistance;
                int x;

                for ( x = 0; x < 3; x++ ) {
                    lLocation   = GenerateNewLocationFromLocation( GetLocation( oVictim ), fDistance, 0.0, 0.0 );
                    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImmuneVis, lLocation );
                    fDistance   = fDistance + 1.0;
                }

                fDistance = 0.0;

                for ( x = 0; x < 3; x++ ) {
                    lLocation   = GenerateNewLocationFromLocation( GetLocation( oVictim ), fDistance, -90.0, 0.0 );
                    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImmuneVis, lLocation );
                    fDistance   = fDistance + 1.0;
                }

                for ( x = 0; x < 12; x++ ) {
                    lLocation   = GenerateNewLocationFromLocation( GetLocation( oVictim ), 4.0, fAngle, 0.0 );
                    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImmuneVis, lLocation );
                    fAngle      = fAngle + 30;
                }

                DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImmuneDur, oVictim, 1.5 ) );
            }
            else
            {
                // Apply paralysis effects and visuals.
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( eLink ), oVictim, fDuration );

                // Instant visual.
                DelayCommand( fDuration, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(471), oVictim ) );
            }
        }
        //-------------------------------------------------------------
        // Check if a Phane or Quarut will be caught in the effect
        //-------------------------------------------------------------
        else if(GetLocalInt(oVictim, "IsPhane") == 2 || GetLocalInt(oVictim, "IsQuarut") == 2)
        {
            object oCaster = OBJECT_SELF;
            if(LineOfSightObject(oVictim, oCaster) == TRUE)
            {
                location lPort = GetLocation(oCaster);
                string sName = GetName(oCaster);
                string sSpeak = "**The Time Stop has no effect on the creature and teleports to attack " + sName + " instead!**";
                FloatingTextStringOnCreature(sSpeak, oVictim, FALSE);
                SpeakString(sSpeak, TALKVOLUME_TALK);
                AssignCommand(oVictim, ClearAllActions());
                AssignCommand(oVictim, ActionJumpToLocation(lPort));
                AssignCommand(oVictim, ActionAttack(oCaster));
            }
        }
        // Find next target in shape.
        oVictim = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL * 3, lTarget, FALSE, OBJECT_TYPE_CREATURE );
    }

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);

    // Fire off another Time Stop visual just before the duration is over.
    DelayCommand( fDuration-1.5, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, GetLocation( OBJECT_SELF ) ) );
}
