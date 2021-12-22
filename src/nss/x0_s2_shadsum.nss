//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  x0_s2_shadsum
//group:   summons
//used as: special ability script (doesn't trigger spellhook)
//date:    jan 20 2008
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_summons"
#include "X0_I0_SPELLS"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //Trigger spellhook
    if (!X2PreSpellCastCode())
        return;

    sum_SD_Shadow( OBJECT_SELF, GetSpellTargetLocation() );
}
