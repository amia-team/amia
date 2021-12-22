//::///////////////////////////////////////////////
//:: FileName ck_hasbark
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 01/09/2005 21:02:23
//:: Updated for dialog convo entry repition: 073106 (kfw).
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Variables.
    object oPC          = GetPCSpeaker( );

    // Verify player has Duir Bark.
    if( GetTag( GetLocalObject( oPC, "ds_bark" ) ) == "ds_grove" ){

        return( TRUE );
    }
    else{

        object oBark = GetItemPossessedBy( oPC, "ds_grove" );

        if ( GetIsObjectValid( oBark ) ){

            SetLocalObject( oPC, "ds_bark", oBark );

            return TRUE;
        }
    }

    return( FALSE );
}
