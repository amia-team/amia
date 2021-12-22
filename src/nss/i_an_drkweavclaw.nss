//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_an_drkweavclaw
//group:   Shadowscape Wastes
//used as: Cutom OnHit
//date:    June 27 2014
//author:  Anatida
//
// Darkweaver (tentacle rake) OnHit Grapple Effects - bite & Strenth damage
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "ds_ai2_include"

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
                if( GetLocalInt( oCritter, "PiercingDamage" ) != 0 )
                {
                    int nPierce = d6( GetLocalInt( oCritter, "PiercingDamage" ) );
                        nPierce = nPierce + GetAbilityModifier( ABILITY_STRENGTH, oCritter );
                    effect ePierce = EffectDamage( nPierce, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, ePierce, oTarget );
                }
                if( GetLocalInt( oCritter, "STRDamage" ) != 0 )
                {
                    int nSTRDmg = d4( GetLocalInt( oCritter, "STRDamage" ) );
                    effect eSTRDmg = EffectAbilityDecrease(ABILITY_STRENGTH, nSTRDmg);
                    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eSTRDmg, oTarget );
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
