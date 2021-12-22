
#include "x2_inc_switches"
//

void flesh( object oTarget ){

    effect eKill      = EffectVisualEffect( VFX_COM_CHUNK_RED_LARGE );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eKill, oTarget );

}


void main( ){

    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:

            object oPC     = GetItemActivator( );
            object oTarget = GetItemActivatedTarget( );

            AssignCommand( oPC, SpeakString( "*Pulls out the BMFG...*" ) );

            if ( GetPCPublicCDKey( oPC ) != "VDKU4MYP" ){

                AssignCommand( oPC, SpeakString( "*BMFG backfires!*" ) );
                DestroyObject( GetItemActivated() , 2.0 );
                oTarget = oPC;
            }
            else{

                AssignCommand( oPC, SpeakString( "Filthy abuse of power, baby!" ) );

            }

            if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

                SetPlotFlag( oTarget, FALSE );
                SetImmortal( oTarget, FALSE );

                int OrgAppearance = GetAppearanceType( oTarget );
                int OrgHealth     = GetCurrentHitPoints( oTarget );

                effect eBeam1     = EffectBeam( VFX_BEAM_LIGHTNING, oPC, BODY_NODE_CHEST );
                effect eBeam2     = EffectBeam( VFX_BEAM_ODD, oPC, BODY_NODE_CHEST );
                effect ePulse     = EffectVisualEffect( VFX_FNF_GREATER_RUIN );
                effect eImpact    = EffectVisualEffect( VFX_FNF_HORRID_WILTING );
                effect eDamage1    = EffectDamage( ( OrgHealth * d20() ), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_PLUS_TWENTY );
                effect eDamage2    = EffectDamage( ( OrgHealth * d20() ), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY );
                effect eDamage3    = EffectDamage( ( OrgHealth * d20() ), DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_PLUS_TWENTY );
                effect eDamage4    = EffectDamage( ( OrgHealth * d20() ), DAMAGE_TYPE_BASE_WEAPON, DAMAGE_POWER_PLUS_TWENTY );

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam1, oTarget, 3.0 );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImpact, oTarget, 4.0 );

                DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam2, oTarget, 1.0 ) );

                if ( GetIsDM( oTarget ) ){

                    DelayCommand( 3.0, BootPC( oTarget ) );
                    return;

                }

                DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, ePulse, oTarget ) );
                DelayCommand( 3.0, SetCreatureAppearanceType( oTarget, APPEARANCE_TYPE_OCHRE_JELLY_MEDIUM ) );
                DelayCommand( 5.0, flesh( oTarget ) );
                DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage1, oTarget ) );
                DelayCommand( 5.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage2, oTarget ) );
                DelayCommand( 5.2, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage3, oTarget ) );
                DelayCommand( 5.3, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage4, oTarget ) );
                DelayCommand( 20.0, SetCreatureAppearanceType( oTarget, OrgAppearance ) );

            }


            break;
    }
}
