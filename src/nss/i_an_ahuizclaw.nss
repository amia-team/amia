//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_an_ahuizclaw
//group:   Shadowscape Wastes
//used as: Cutom OnHit
//date:    June 27 2014
//author:  Anatida
//
// Ahuizotl (tail hand) OnHit Grapple Effects - drown
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
                if ( GetLocalInt( oCritter, "Drown" ) != 0 )
                {

                    if ( GetIsPC( oTarget ) == TRUE )
                    {

                        if ( ds_check_uw_items ( oTarget ) )
                        {

                            SendMessageToPC( oTarget, "<c¥  >Drown Test: You are protected from drowning."+"</c>" );
                            //DelayCommand( 6.0, ds_drown( oTarget ) );
                        }
                        else if ( FortitudeSave( oTarget, 24 ) > 0 )
                        {

                            SendMessageToPC( oTarget, "<c¥  >Drown Test: Made Fort save"+"</c>" );
                           // DelayCommand( fInterval, ds_drown( oTarget ) );
                        }
                        else
                        {

                            SendMessageToPC( oTarget, "<c¥  >Drown Test: Failed Fort save"+"</c>" );
                            effect eDeath = EffectDeath();
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget );
                        }
                     }
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
