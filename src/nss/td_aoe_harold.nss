#include "x2_inc_spellhook"
void main(){

    object oTarget = GetEnteringObject();
    string sTag=ObjectToString( oTarget );
    object oPC = GetAreaOfEffectCreator();

    if( oPC == oTarget || !GetIsReactionTypeHostile( oTarget, oPC ) ){
        return;
    }

    if( GetIsImmune( oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC ) || GetLocalInt( OBJECT_SELF, sTag )  )
        return;

    //10 round CD
    SetLocalInt( OBJECT_SELF, sTag, TRUE );
    DelayCommand( RoundsToSeconds( 10 ), DeleteLocalInt( OBJECT_SELF, sTag ) );


    if( MyResistSpell( oPC, oTarget ) > 0 )
        return;

    int nCL = GetLocalInt( oPC, "AOE_CL" );
    int nDC = 16 + GetAbilityModifier( ABILITY_INTELLIGENCE, oPC );

    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_ILLUSION, oPC ) )
        nDC += 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_ILLUSION, oPC ) )
        nDC += 4;
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_ILLUSION, oPC ) )
        nDC += 2;


    if( WillSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC ) < 1 ){

        effect eBad = EffectLinkEffects( EffectFrightened(),EffectVisualEffect( VFX_DUR_CESSATE_NEGATIVE ) );
               eBad = EffectLinkEffects( EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR ), eBad );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBad, oTarget, RoundsToSeconds( nCL/3 ) );

        if( FortitudeSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC ) < 1 ){

            int nDamage = d6(nCL/5);
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nDamage ), oTarget );
        }
    }
}


