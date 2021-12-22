//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai2_perceive
//group:   ds_ai2
//used as: OnPerception
//date:    dec 23 2007
//author:  disco

/* Changelog:
    02/21/14    Glim - Added Override LocalInt functionality for using custom
                       non-AI spells through the CastSpellAt & CastFakeSpellAt
                       functions.
*/

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter = OBJECT_SELF;
    object oTarget  = GetLastPerceived();
    int nCount      = GetLocalInt( OBJECT_SELF, L_INACTIVE );

    //Allow for custom spellcasting through non-AI scripts using CastSpell functions
    int nOverride = GetLocalInt( oCritter, "OverrideAI" );
    if( nOverride != 0 )
    {
        return;
    }

    else
    {
        if ( GetLastPerceptionSeen() || GetLastPerceptionHeard() ){

            if ( nCount != -1 ){

                DebugMessage( "ds_ai_perceive", 1 );

                if ( PerformAction( oCritter, "ds_ai2_perceive" ) > 0 ){

                    SetLocalInt( OBJECT_SELF, L_INACTIVE, -1 );
                }
            }
        }
        else if ( GetLastPerceptionVanished()
                    && GetLocalObject( oCritter, L_CURRENTTARGET ) == oTarget ){

            ClearAllActions( TRUE );

            if ( PerformAction( oCritter, "ds_ai2_perceive" ) > 0 ){

                SetLocalInt( OBJECT_SELF, L_INACTIVE, -1 );
            }
        }
    }
}
