#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

/*Dark Immolation wrote:
Veil of Defiance

Enchantment 1
Components: Somatic
Spell Resistance: No
Range: Self
Duration: 1 Turn/CL, Extendable
Save: Harmless

The caster taps into his latent feral and unyielding spirit born of the Underdark. He gains a bonus based upon the location and time of casting:

Cast Outside during Daytime: Immunity to Light Sensitivity
Cast Anywhere else at Any other time: +2 Search, +2 Spot, 10% Movement Speed

The effects do not stack, nor do they change over with the time or location. To gain the alternate set of bonuses, the spell must be cast again in the proper location.

VFX: 93: VFX_IMP+_SILENCE*/

void RemoveLightBlindness( object oTarget ){

    object oCaster = GetLocalObject( GetModule(), "ds_areaeffects" );
    effect eEffect = GetFirstEffect( oTarget );
    while( GetIsEffectValid( eEffect ) ){

        if( GetEffectCreator( eEffect )==oCaster ){

            if( GetEffectType( eEffect ) == EFFECT_TYPE_ATTACK_DECREASE ||
                GetEffectType( eEffect ) == EFFECT_TYPE_SKILL_DECREASE ){

                RemoveEffect( oTarget, eEffect );
            }
        }

        eEffect = GetNextEffect( oTarget );
    }
}

void main(){

    object oPC = OBJECT_SELF;
    object oArea = GetArea( oPC );
    if( !GetIsAreaInterior( oArea )                         &&
         GetIsAreaAboveGround( oArea ) == AREA_ABOVEGROUND   &&
         GetIsDay( )                                         &&
         GetLocalInt( oArea, "CloudCover" ) == FALSE         &&
         GetLocalInt( oPC, "jj_darkness_domain" ) != TRUE ){

        RemoveLightBlindness( oPC );
    }
    else{

        effect eNice = EffectLinkEffects( EffectSkillIncrease( SKILL_SPOT, 2 ), EffectSkillIncrease( SKILL_SEARCH, 2 ) );
               eNice = EffectLinkEffects( EffectMovementSpeedIncrease( 10 ), eNice );
               eNice = EffectLinkEffects( EffectVisualEffect( VFX_DUR_CESSATE_NEUTRAL ), eNice );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eNice, oPC, TurnsToSeconds( GetCasterLevel( oPC ) ) );
    }

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SILENCE ), oPC );
}
