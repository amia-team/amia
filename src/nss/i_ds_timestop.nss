//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_timestop
//group:   dm tools
//used as: item activation script
//date:    may 06 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "nw_i0_spells"
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oArea     = GetArea( oPC );
            int nSwitch      = GetLocalInt( oArea, "ds_timestop" );
            int nFaction;

            if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ){

                DestroyObject( GetItemActivated() );
                SendMessageToPC( oPC, "Oi! You can only use this as a DM!" );
                return;
            }

            //effects to apply
            effect eParalyse = EffectCutsceneParalyze();

            //visual portion of the effect
            effect eEnemy     = EffectVisualEffect(VFX_DUR_GLOW_RED);
            effect eFriend    = EffectVisualEffect(VFX_DUR_GLOW_GREEN);
            effect eNeutral   = EffectVisualEffect(VFX_DUR_GLOW_BLUE);

            //link up later
            effect eLink;

            //loop
            object oObject   = GetFirstObjectInArea( oArea );

            while( GetIsObjectValid( oObject ) ){

                if( GetObjectType( oObject ) == OBJECT_TYPE_CREATURE ){

                    nFaction = GetStandardFactionReputation( STANDARD_FACTION_COMMONER, oObject );

                    if ( GetIsDM( oObject ) || GetIsDMPossessed( oObject ) || oObject == oPC ){

                        //don't paralyse

                    }
                    else if ( nSwitch != 1 ){

                        //block
                        SetBlockTime( oArea, 0, 12, "ds_timeblock" );

                        //set switch
                        SetLocalInt( oArea, "ds_timestop", 1 );

                        //unplot
                        if ( GetPlotFlag( oObject ) == TRUE ){

                            SetLocalInt( oObject, "ds_plot", 1 );
                            SetPlotFlag( oObject, FALSE );
                        }


                        // apply glows
                        if ( nFaction < 11 ){

                            eLink = EffectLinkEffects( eEnemy, eParalyse );
                        }
                        else if ( nFaction > 89 ){

                            eLink = EffectLinkEffects( eFriend, eParalyse );
                        }
                        else{

                            eLink = EffectLinkEffects( eNeutral, eParalyse );
                        }

                        // apply paralyse + glow to any nearby creatures
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oObject, 600.0 );

                        //plot
                        SetPlotFlag( oObject, TRUE );

                        //message
                        if ( GetIsPC( oObject ) ){

                            SendMessageToPC( oObject, "You have been paralysed by "+GetName( oPC )+". The effect will automatically go away after 10 minutes ( the DM will probably cancel it a lot earlier, though)." );
                        }
                        SendMessageToPC( oPC, "You have paralysed "+GetName( oObject) );
                    }
                    else{

                        if ( GetIsBlocked( oArea, "ds_timeblock" ) > 0 ){

                            SendMessageToPC( oPC, "You need to let the break last for at least 12 seconds." );
                            return;
                        }

                        //set switch
                        SetLocalInt( oArea, "ds_timestop", 0 );


                        //plot setting
                        if ( GetLocalInt( oObject, "ds_plot" ) != 1 ){

                            SetPlotFlag( oObject, FALSE );
                        }

                        // remove paralysis + glow
                        RemoveSpecificEffect( EFFECT_TYPE_CUTSCENE_PARALYZE, oObject );

                        //reactivate AI
                        SignalEvent( oObject, EventSpellCastAt( oObject, -1 ) );

                        //message
                        if ( GetIsPC( oObject ) ){

                            SendMessageToPC( oObject, "You have been deparalysed by "+GetName( oPC ) );
                        }

                        SendMessageToPC( oPC, "You have deparalysed "+GetName( oObject) );
                    }
                }

                oObject = GetNextObjectInArea( oArea );
            }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue( nResult );
}



