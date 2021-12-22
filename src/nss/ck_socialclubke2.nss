//::///////////////////////////////////////////////
//:: FileName ck_socialclubke2
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 8/27/2004 9:11:30 PM
//:: Updated: 090806 (kfw), RP Change, sell to any evil alignment.
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional( ){

    // Variables.
    object oPC          = GetPCSpeaker( );
    int nAlign          = GetAlignmentGoodEvil( oPC );


    // Verify an evil alignment.
    if( nAlign == ALIGNMENT_EVIL )
        return( TRUE );
    else
        return( FALSE );

}
