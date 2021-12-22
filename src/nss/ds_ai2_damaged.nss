//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai_damaged
//group:   ds_ai
//used as: OnDamage
//date:    dec 23 2007
//author:  disco

/* Changelog:
    09/11/13    Glim - Added functionality for %health based spell casting.
    02/21/14    Glim - Added functionality for %health based ability usage.
*/

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter     = OBJECT_SELF;
    object oDamager     = GetLastDamager();
    object oTarget      = GetLocalObject( oCritter, L_CURRENTTARGET );
    string sArchetype   = GetLocalString( oCritter, L_ARCHETYPE );
    int nReaction       = GetReaction( oCritter, oDamager );


    if ( nReaction == 2 ){

        if ( GetDistanceBetween( oCritter, oDamager ) < 5.0 ){

            ClearAllActions();
            ActionMoveAwayFromObject( oDamager, TRUE, 10.0 );
            SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
        }
    }
    else if ( nReaction == 1 ){

        if ( oTarget != oDamager ){

            if ( GetObjectSeen( oDamager, oCritter ) && ( d100() - 20 ) < 25 ){

                SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
            }
        }
    }

    //Check for %health based triggers
    int i;
    int nHP = GetPercentageHPLoss( oCritter );

    for( i = 99; i > 0; i-- )
    {
        //Simulated spellcasting (casting time) for custom spells
        if( nHP <= i && GetLocalInt( oCritter, "SpellID_"+IntToString( i ) ) != 0 )
        {
            int nSpellID = GetLocalInt( oCritter, "SpellID_"+IntToString( i ) );
            int nTargetType = GetLocalInt( oCritter, "Target_"+IntToString( i ) );
            object oTarget = FindNPCSpellTarget( oCritter, nTargetType );

            SetLocalInt( oCritter, "OverrideAI", 1 );
            DelayCommand( 4.0, SetLocalInt( oCritter, "OverrideAI", 0 ) );

            ClearAllActions( );

            AssignCommand( oCritter, ActionCastSpellAtObject( nSpellID, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE ) );

            DeleteLocalInt( oCritter, "SpellID_"+IntToString( i ) );
        }

        //Instant ability usage for custom abilities
        if( nHP <= i && GetLocalString( oCritter, "AbilityID_"+IntToString( i ) ) != "" )
        {
            int nTargetType = GetLocalInt( oCritter, "Target_"+IntToString( i ) );
            object oTarget = FindNPCSpellTarget( oCritter, nTargetType );

            SetLocalInt( oCritter, "OverrideAI", 1 );
            DelayCommand( 4.0, SetLocalInt( oCritter, "OverrideAI", 0 ) );

            ClearAllActions( );

            SetLocalObject( oCritter, GetLocalString( oCritter, "AbilityID_"+IntToString( i ) ), oTarget );
            ExecuteScript( GetLocalString( oCritter, "AbilityID_"+IntToString( i ) ), oCritter );

            DeleteLocalString( oCritter, "AbilityID_"+IntToString( i ) );
        }
    }
}
