//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_rope
//group: player utilities
//used as: item activation script
//date: december 2008
//author: Disco

//2009-05-15 Added scale down option
//11-06-2017 Added in code to handle grappling hooks
//March 1 2025 - Mav - Added in code for the post you rope to, to break


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "amia_include"


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void MoveAssociates( object oPC, object oTarget ){

    int i;
    object oAssociate;

    for ( i=1; i<6; ++i ){

        oAssociate = GetAssociate( i, oPC );

        if ( GetIsObjectValid( oAssociate ) ){

            AssignCommand( oAssociate, JumpToObject( oTarget ) );
        }
    }
}

int nCheckTargetLocation( object oPC, location lTarget ){


    vector vPC          = GetPosition( oPC );
    vector vTarget      = GetPositionFromLocation( lTarget );
    float fDifferenceX  = vTarget.x - vPC.x;
    float fDifferenceY  = vTarget.y - vPC.y;
    float fDifferenceZ  = vTarget.z - vPC.z;

    SendMessageToPC( oPC, "[debug: X difference: "+ FloatToString( fDifferenceX, 3, 1 ) + "]" );
    SendMessageToPC( oPC, "[debug: Y difference: "+ FloatToString( fDifferenceY, 3, 1 ) + "]" );
    SendMessageToPC( oPC, "[debug: Z difference: "+ FloatToString( fDifferenceZ, 3, 1 ) + "]" );

    if ( fDifferenceZ < -6.5 || fDifferenceZ > -3.8 ){

        SendMessageToPC( oPC, "You can only climb down from one height level to the previous one." );
        return FALSE;
    }

    if ( fabs( fDifferenceX ) > 2.5 || fabs( fDifferenceY ) > 2.5 ){

        SendMessageToPC( oPC, "You can only climb down, not sidewards." );
        return FALSE;
    }


    return TRUE;
}

int nCheckTargetLocationGrapplingHook( object oPC, location lTarget ){


    vector vPC          = GetPosition( oPC );
    vector vTarget      = GetPositionFromLocation( lTarget );
    float fDifferenceX  = vTarget.x - vPC.x;
    float fDifferenceY  = vTarget.y - vPC.y;
    float fDifferenceZ  = vTarget.z - vPC.z;

    SendMessageToPC( oPC, "[debug: X difference: "+ FloatToString( fDifferenceX, 3, 1 ) + "]" );
    SendMessageToPC( oPC, "[debug: Y difference: "+ FloatToString( fDifferenceY, 3, 1 ) + "]" );
    SendMessageToPC( oPC, "[debug: Z difference: "+ FloatToString( fDifferenceZ, 3, 1 ) + "]" );

    if ( fabs( fDifferenceX ) > 6.0 || fabs( fDifferenceY ) > 6.0 || fabs( fDifferenceZ ) > 6.0){

        SendMessageToPC( oPC, "You can not use the grappling hook to climb that far." );
        return FALSE;
    }


    return TRUE;
}

void BreakTarget(object oTarget)
{
  AssignCommand( oTarget, SpeakString( "*breaks just as you finish roping over*" ) );
  DestroyObject(oTarget,0.2);
}
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
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            location lTarget = GetItemActivatedTargetLocation();
            if (GetLocalInt(oTarget, "ms_grapplingHook") == 1)
            {
                if(nCheckTargetLocationGrapplingHook(oPC, lTarget))
                {
                    effect eBeam = EffectBeam( VFX_BEAM_CHAIN, oPC, BODY_NODE_CHEST );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 2.0 );
                    AssignCommand( oPC, SpeakString( "*climbs over to grappling hook*" ) );
                    DelayCommand( 1.0, AssignCommand( oPC, JumpToLocation( lTarget ) ) );
                    DelayCommand( 2.0, MoveAssociates( oPC, oPC ) );
                 }
             }
            else if ( GetLocalInt( oTarget, "ds_rope" ) == 1 ){

                effect eBeam = EffectBeam( VFX_BEAM_CHAIN, oPC, BODY_NODE_CHEST );

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 2.0 );
                AssignCommand( oPC, SpeakString( "*uses rope to get to "+GetStringLowerCase( GetName( oTarget ) )+"*" ) );
                DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oTarget ) ) );
                DelayCommand( 1.0, MoveAssociates( oPC, oTarget ) );
                if(GetLocalInt(oTarget,"ds_break")==1)
                {
                 DelayCommand( 1.2, BreakTarget(oTarget));
                }
            }
            else if ( GetIsPC( oTarget ) ){

                AssignCommand( oPC, SpeakString( "*throws rope to "+GetName( oTarget )+"*" ) );
                AssignCommand( oPC, ActionGiveItem( oItem, oTarget ) );
            }
            else if ( nCheckTargetLocation( oPC, lTarget ) ){

                AssignCommand( oPC, SpeakString( "*uses rope to climb down*" ) );
                DelayCommand( 1.0, AssignCommand( oPC, JumpToLocation( lTarget ) ) );
                DelayCommand( 2.0, MoveAssociates( oPC, oPC ) );

            }


        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}




