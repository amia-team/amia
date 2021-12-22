/*
---------------------------------------------------------------------------------
NAME: i_arctic_mid

Range: personal: 4d6 cold damage
Area of effect: 10 meter radius
Limit: 1 creature per 2 BG levels (8)
DC for the Fort save: 10 Base + CL + Cha mod = DC 35 IF the charisma is fully buffed.
Duration:
On PC Rounds/BG levels + wis mod (can do without the wis mod too if it makes it too complicated, it's just a 12 sec diffrence anyways)
On NPC until Un-Petrified.
Additional: Using this feat drains the use of Smite Good. By that it is by default limited to once per day.

LOG:
    Faded Wings [10/19/2015 - Created]
    PaladinOfSune [04/03/2016 - Restructured, bug fixes]
----------------------------------------------------------------------------------
*/

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void RemoveInvisEffects( object oPC );
void ActivateItem();
void DoArcticMidnight();

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem();
            break;
    }
}

void ActivateItem( ) {

    object oPC = GetItemActivator();

    if( !GetHasFeat( FEAT_SMITE_GOOD, oPC ) ) {
        FloatingTextStringOnCreature( "<cþ>- You do not have any remaining uses for this ability! -</c>", oPC, FALSE );
        return;
    }

    DecrementRemainingFeatUses( oPC, FEAT_SMITE_GOOD );

    RemoveInvisEffects( oPC );

    AssignCommand( oPC, DoArcticMidnight() );
}

void RemoveInvisEffects( object oPC ) {

    effect eEffect = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEffect ) ) {
        nType = GetEffectType( eEffect );
        if( nType == EFFECT_TYPE_INVISIBILITY || nType == EFFECT_TYPE_ETHEREAL || nType == EFFECT_TYPE_SANCTUARY ) {
            RemoveEffect( oPC, eEffect );
        }
        eEffect = GetNextEffect( oPC );
    }
}

void DoArcticMidnight()
{
    object oPC = OBJECT_SELF;

    int nLevel = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );
    int nWis = GetAbilityModifier( ABILITY_WISDOM, oPC );
    int nCha = GetAbilityModifier( ABILITY_CHARISMA, oPC );

    int nDC = 10 + nLevel + nCha;
    int nDur = nLevel + nWis;

    int nTargets = nLevel / 2;
    int nTargetsAffected = 0;

    effect ePetrify = EffectPetrify();
    effect eLink = EffectLinkEffects( ePetrify, EffectVisualEffect( VFX_DUR_ICESKIN ) );
    location lLocation = GetLocation( oPC );

    effect eDamage;
    float fDelay;

    if ( nTargets > 8 ) {
        nTargets = 8;
    } else if ( nTargets < 1 ) {
        nTargets = 1;
    }

    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_WIND ), lLocation );
    DelayCommand( 0.1, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_COLD ), lLocation ) );
    DelayCommand( 0.3, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_LOS_NORMAL_30 ), lLocation ) );

    object oTarget = GetFirstObjectInShape ( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation );
    while ( GetIsObjectValid ( oTarget ) && ( nTargetsAffected < ( nTargets + 1 ) ) ) {

        if( GetIsEnemy( oTarget, oPC ) ) {

            fDelay = GetDistanceBetweenLocations( lLocation, GetLocation( oTarget ) ) / 20;

            //Set the damage effect
            eDamage = EffectDamage( d6( 4 ), DAMAGE_TYPE_COLD ) ;

            // Apply effects to the currently selected target.
            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget ) );
            // Apply vfx to target
            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_FROST_L ), oTarget ) );

            if( !MySavingThrow ( SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD, oPC, fDelay ) ) {
                // turn into special effect
                if( GetIsPC( oTarget ) ) {
                    DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nDur ) ) );
                } else {
                    DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oTarget ) );
                }

                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( 1046 ), oTarget, 4.0 ) );

                //Increment targets affected
                nTargetsAffected++;
            }
       }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape ( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation ) ;
    }
}
