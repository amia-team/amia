 //-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai2_spellcast
//group:   ds_ai2
//used as: OnSpellCastAt
//date:    dec 23 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter = OBJECT_SELF;
    object oTarget  = GetLastSpellCaster();
    int nCount      = GetLocalInt( OBJECT_SELF, L_INACTIVE );

    if ( ( nCount == 0 || nCount > 1 ) && GetIsEnemy( oCritter, oTarget ) ){

        if ( PerformAction( oCritter, "ds_ai2_spellcast" ) > 0 ){

            SetLocalInt( OBJECT_SELF, L_INACTIVE, 0 );
        }
    }
}
