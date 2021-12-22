//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  nw_s0_sumshad02
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
    //negative plane avatar
    sum_DeathDomainSummon( OBJECT_SELF, GetCasterLevel( OBJECT_SELF ), GetSpellTargetLocation() );
}
