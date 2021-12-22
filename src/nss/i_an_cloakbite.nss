//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_an_cloakbite
//group:   Shadowscape Wastes
//used as: Cutom OnHit
//date:    June 27 2014
//author:  Anatida
//
// Cloaker (bite) Grapple, Engulf effects - Bite(Piercing) damage
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "ds_ai2_include"
//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void DoGrappleEngulf( object oCritter, object oTarget, string sTarget );
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
            string sTarget = GetName( oTarget );

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
                if( GetLocalInt( oCritter, "Engulf" ) != 0 )
                {
                    DoGrappleEngulf(oCritter, oTarget, sTarget );
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

void DoGrappleEngulf( object oCritter, object oTarget, string sTarget )
{
    if( GetLocalInt( oCritter, "Engulf" ) == 1 )
    {
        return;
    }

    if( DoGrapple( oTarget, oCritter ) == 1 )
    {
        effect eTrap = EffectCutsceneParalyze();
        effect eInvis = EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY );
        effect eLink1 = EffectLinkEffects( eTrap, eInvis );
        eLink1 = SupernaturalEffect( eLink1 );


        AssignCommand( oTarget, ActionJumpToLocation( GetLocation( oCritter ) ) );
        DelayCommand( 0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, 5.5 ) );

        string sName = GetName( oTarget );
        string sEngulf = "<c¥  >**Engulfs "+sName+", wrapping them in the folds of its body, and sinking its teeth in!**</c>";
        SpeakString( sEngulf, TALKVOLUME_TALK );
        FloatingTextStringOnCreature( sEngulf, oCritter, FALSE );

        SetLocalInt( oCritter, "Engulf", 1 );
        SetLocalInt( oTarget, "Engulfed", 1 );
        SetLocalObject( oCritter, "Engulfed", oTarget );
        DelayCommand( 5.5, DeleteLocalInt( oCritter, "Engulf" ) );
        DelayCommand( 6.5, DeleteLocalInt( oTarget, "Engulfed" ) );
        DelayCommand( 6.5, DeleteLocalObject( oCritter, "Engulfed" ) );
    }
}

