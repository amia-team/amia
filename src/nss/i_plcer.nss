/*  DC Item :: SFX Effector :: Visual & Sound Animation, Visual and Sound Refs Stored On Item

    --------
    Verbatim
    --------
    This script will execute each animation by using the variables stored on the item itself.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    071906  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "x0_i0_position"

/* Constants */
const string VFX                    = "cs_vfx";
const string SFX                    = "cs_sfx";
const string PLC                    = "cs_plc_ref";
const string DUR                    = "cs_duration";
const string TOGGLEABLE             = "cs_toggle";
const string SPAWNED                = "cs_spawned";
const string TAG                    = "PLCER";

void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables.
            object oItem            = GetItemActivated( );
            object oPC              = GetItemActivator( );
            location lOrigin        = GetItemActivatedTargetLocation( );
            int nVFX                = GetLocalInt( oItem, VFX );
            string szSFX            = GetLocalString( oItem, SFX );
            string szPLC            = GetLocalString( oItem, PLC );
            float fDuration         = GetLocalFloat( oItem, DUR );
            int nToggle             = GetLocalInt( oItem, TOGGLEABLE );
            int nSpawned            = GetLocalInt( oPC, SPAWNED );
            object oPLC             = OBJECT_INVALID;


            // Toggle-type item, check for spawn status.
            if( nToggle ){
                // PLC spawned, despawn it.
                if( nSpawned ){
                    object oPLC = GetNearestObjectByTag( TAG, oPC );
                    // Not found, notify and bug out.
                    if( !GetIsObjectValid( oPLC ) ){
                        SendMessageToPC( oPC, "- Error: Can't find despawn your PLC! Move closer or try again. -" );
                        break;
                    }
                    // Purge.
                    DestroyObject( oPLC );
                    SetLocalInt( oPC, SPAWNED, FALSE );
                    break;
                }
                // PLC not spawned, spawn it.
                else
                    SetLocalInt( oPC, SPAWNED, TRUE );
            }


            // Visual candy.
            if( nVFX )
                ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX ), lOrigin );

            // Audio candy.
            if( szSFX != "" )
                AssignCommand( oPC, PlaySound( szSFX ) );

            // Spawn PLC, and make it face the creator.
            if( szPLC != "" ){
                oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, szPLC, lOrigin, FALSE, TAG );
                TurnToFaceObject( oPC, oPLC );
            }

            // Set the duration, if applicable.
            if( fDuration != 0.0 )
                DelayCommand( fDuration, DestroyObject( oPLC ) );

            break;

        }

        default:{
            nResult                 = X2_EXECUTE_SCRIPT_CONTINUE;
            break;
        }

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
