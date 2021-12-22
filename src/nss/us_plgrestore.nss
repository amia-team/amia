// OnUsed event for placeable that casts Greater Restore on player.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/30/2003 jpavelch         Initial Release.
// 12/22/2005 kfw              Spam protection

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_func_classes"


void main()
{
    object oPC = GetLastUsedBy( );

    if ( !GetIsPC( oPC ) ){

        return;
    }

    // Spam protection status
    if ( GetLocalInt( oPC, "pf" ) == 1 ){

        return;
    }

    // Set spam protection control variable
    SetLocalInt( oPC, "pf", 1 );

    // Unset spam protection control variable
    DelayCommand( 2.0, SetLocalInt( oPC, "pf", 0 ) );

    // Purify the PC
    ActionCastSpellAtObject( SPELL_GREATER_RESTORATION, oPC, METAMAGIC_ANY, TRUE );

    //counter ECL bug
    GetECL( oPC );

    //log_to_exploits( oPC, "Fountain", GetName( GetArea( oPC ) ) );
}
