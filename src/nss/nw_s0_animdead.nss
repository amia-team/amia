// Completed by Kungfoowiz on the 24th September 2005.

// Version 1.0.

// This script replaces the spell animate dead for a better version.


// Animate Dead (Clerics, Sorcerers, Wizards, and Palemasters[SL-Ability])
//#include "x2_inc_spellhook"
//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  nw_s0_animdead
//group:   summons
//used as: special ability script (doesn't trigger spellhook)
//date:    feb 29 2008
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_summons"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //Trigger spellhook
    if (!X2PreSpellCastCode())
        return;

    sum_AnimateDead( OBJECT_SELF, GetCasterLevel(OBJECT_SELF), GetSpellTargetLocation() );

}
