//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:   ds_cb_
//group:    chickenball
//used as:  OnConversation
//date:     2009-07-10
//author:   Disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_cb"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oCreature = OBJECT_SELF;
    string sTag      = GetTag( oCreature );

    if ( sTag == CB_CHICKEN ){

        object oClosest   = GetNearestCreature( CREATURE_TYPE_IS_ALIVE, TRUE );
        effect eGlow      = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eGlow, oCreature );

        ActionMoveAwayFromObject( oClosest, FALSE, 10.0f );
    }
}
