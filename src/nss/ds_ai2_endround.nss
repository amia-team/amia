//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai2_endround
//group:   ds_ai2
//used as: OnEndOfRound
//date:    dec 23 2007
//author:  disco

/* 01/10/13 - Glim - Added Override LocalInt functionality for using custom
                        non-AI spells through the CastSpellAt & CastFakeSpellAt
                        functions.
   08/11/13 - Glim - Added reset of Improved Grab local int on the creature at
                        end of each round for extra rake/rend/etc attacks.
*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter         = OBJECT_SELF;
    object oCurrentTarget   = GetLocalObject( oCritter, L_CURRENTTARGET );
    int nCount              = GetLocalInt( OBJECT_SELF, L_INACTIVE );

    //Reset Improved Grab counter
    if( GetLocalInt( oCritter, "ImpGrab" ) != 0 )
    {
        SetLocalInt( oCritter, "ImpGrab", 0 );
    }

    //Check for per-round random effects (limit every 6 seconds)
    if( GetLocalInt( oCritter, "Per_Round" ) != 0 && GetLocalInt( oCritter, "EnRoundUsed" ) != 1 )
    {
        int nPer = GetLocalInt( oCritter, "Per_Round" );
        int nRandom = Random( nPer );
        string sRandom = IntToString( nRandom );

        string sChoice = GetLocalString( oCritter, "Random"+sRandom );
        if( sChoice != "" )
        {
            int nTarget = GetLocalInt( oCritter, "R"+sRandom+"_Target" );
            object oTarget = FindNPCSpellTarget( oCritter, nTarget );
            //split between spell or ability
            if( GetSubString( sChoice, 0, 4 ) == "spl_" ||
                GetSubString( sChoice, 0, 3 ) == "nw_" )
            {
                int nSpellID = GetLocalInt( oCritter, "R"+sRandom+"_SpellID" );
                SetLocalInt( oCritter, "OverrideAI", 1 );
                DelayCommand( 1.0, SetLocalInt( oCritter, "OverrideAI", 0 ) );

                ClearAllActions();

                AssignCommand( oCritter, ActionCastSpellAtObject( nSpellID, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE ) );
            }
            else if( GetSubString( sChoice, 0, 4 ) == "abl_" )
            {
                SetLocalObject( oCritter, sChoice, oTarget );
                SetLocalInt( oCritter, "OverrideAI", 1 );
                DelayCommand( 1.0, SetLocalInt( oCritter, "OverrideAI", 0 ) );
                ExecuteScript( sChoice, oCritter );
            }
            else
            {
                SendMessageToAllDMs( "Bug Report: Unrecognized abilty "+sChoice+" on "+GetName( oCritter )+", please report." );
            }
            //ensure it can't spam more than 1 every 6 seconds
            SetLocalInt( oCritter, "EnRoundUsed", 1 );
            DelayCommand( 5.9, SetLocalInt( oCritter, "EnRoundUsed", 0 ) );
        }
    }

    //Allow for custom spellcasting through non-AI scripts using CastSpell functions
    int nOverride = GetLocalInt( oCritter, "OverrideAI" );
    if( nOverride != 0 )
    {
        return;
    }

    if ( GetHasEffect( EFFECT_TYPE_DARKNESS ) && !GetObjectSeen( oCurrentTarget ) ){

        ActionMoveAwayFromLocation( GetLocation( oCritter ), TRUE, 7.0 );
    }
    else if ( PerformAction( oCritter, "ds_ai2_endround" ) > 0 ){

        SetLocalInt( OBJECT_SELF, L_INACTIVE, -1 );
    }
}
