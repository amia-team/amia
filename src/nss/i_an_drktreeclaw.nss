//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_an_drktreeclaw
//group:   Shadowscape Wastes
//used as: Cutom OnHit
//date:    June 27 2014
//author:  Anatida
//
// Dark Tree (bite) OnHit Grapple Effects - bite & blood drain
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "ds_ai2_include"
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {
        case X2_ITEM_EVENT_ONHITCAST:
        {
            // vars
            object oTarget = GetSpellTargetObject();
            object oCritter = OBJECT_SELF;

            // Check if target has already been successfully grappled this round
            if( GetLocalInt( oTarget, "Grappled" ) == 1 )
            {
                return;
            }

            // Start Grapple and do additional effects if successful
            if( DoGrapple( oTarget, oCritter ) == 1 && GetLocalInt( oCritter, "GrappleEffects" ) == 1 )
            {
                if( GetLocalInt( oCritter, "CrushDamage" ) != 0 )
                {
                    int nBlunt = d6( GetLocalInt( oCritter, "CrushDamage" ) );
                        nBlunt = nBlunt + GetAbilityModifier( ABILITY_STRENGTH, oCritter );
                    effect eBlunt = EffectDamage( nBlunt, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eBlunt, oTarget );
                }
                if( GetLocalInt( oCritter, "AcidDamage" ) != 0 )
                {
                    int nAcid = d6( GetLocalInt( oCritter, "AcidDamage" ) );
                    effect eAcid = EffectDamage( nAcid, DAMAGE_TYPE_ACID, DAMAGE_POWER_ENERGY );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eAcid, oTarget );
                }
                if( GetLocalInt( oCritter, "ColdDamage" ) != 0 )
                {
                    int nCold = d6( GetLocalInt( oCritter, "ColdDamage" ) );
                    effect eCold = EffectDamage( nCold, DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eCold, oTarget );
                }
                if( GetLocalInt( oCritter, "ElecDamage" ) != 0 )
                {
                    int nElec = d6( GetLocalInt( oCritter, "ElecDamage" ) );
                    effect eElec = EffectDamage( nElec, DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_ENERGY );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eElec, oTarget );
                }
                if( GetLocalInt( oCritter, "FireDamage" ) != 0 )
                {
                    int nFire = d6( GetLocalInt( oCritter, "FireDamage" ) );
                    effect eFire = EffectDamage( nFire, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eFire, oTarget );
                }
                if( GetLocalInt( oCritter, "PiercingDamage" ) != 0 )
                {
                    int nPierce = d6( GetLocalInt( oCritter, "PiercingDamage" ) );
                    effect ePierce = EffectDamage( nPierce, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, ePierce, oTarget );
                }
                if( GetLocalInt( oCritter, "CONDamage" ) != 0 )
                {
                    int nConDmg = d4( GetLocalInt( oCritter, "CONDamage" ) );
                    effect eConDmg = EffectAbilityDecrease(ABILITY_CONSTITUTION, nConDmg);
                    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eConDmg, oTarget );
                }

                // Set that the target is already grappled this round and cannot be grappled again
                SetLocalInt( oTarget, "Grappled", 1 );
                DelayCommand( 5.9, DeleteLocalInt( oTarget, "Grappled" ) );
            }
            else if( GetLocalInt( oCritter, "Paralysis" ) == 1 )
            {
                int nParalysisDC = GetLocalInt( oCritter, "ParalysisDC" );

                if( FortitudeSave( oTarget, nParalysisDC, SAVING_THROW_TYPE_NONE, oCritter ) == 0 )
                {
                    float fDur = IntToFloat( d6(3) );
                    effect eParalysis = EffectParalyze();
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eParalysis, oTarget, fDur );
                }
            }
        }
        default:
        {
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
