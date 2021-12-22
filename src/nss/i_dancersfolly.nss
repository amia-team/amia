/*  i_dancersfolly

    --------
    Verbatim
    --------
    Description

    ---------
    Changelog
    ---------

    Date    Name        Reason
    ------------------------------------------------------------------
    2008-06-04  Disco       Corrected OnActivate event
    ------------------------------------------------------------------


*/
#include "x2_inc_switches"

void ActivateItem(){

    effect eEffect;
    object oTarget;
    object oPC  = GetItemActivator();

    if (FortitudeSave(oPC, 22, SAVING_THROW_TYPE_POISON )){
       oTarget = oPC;

       eEffect = EffectAbilityIncrease(ABILITY_CHARISMA, 2);

       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 120.0f);

    }
    else {
       oTarget = oPC;

       eEffect = EffectAbilityDecrease(ABILITY_WISDOM, 2);

       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 120.0f);
   }
}


void main( ){

    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}


