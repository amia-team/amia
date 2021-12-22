/*  i_nobelliquor

    --------
    Verbatim
    --------
    Script for a drink that can either raise or lower an attibute.

    ---------
    Changelog
    ---------

    Date    Name        Reason
    ------------------------------------------------------------------
    050106  Disco       Corrected OnActivate event
    ------------------------------------------------------------------


*/

#include "x2_inc_switches"

void ActivateItem(){
    object oPC;
    effect eEffect;
    object oTarget;

    oPC = GetItemActivator();

    if (FortitudeSave(oPC, 22, SAVING_THROW_TYPE_POISON )){

        oTarget = oPC;
        eEffect = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 2);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 120.0f);

    }
    else{

        oTarget = oPC;
        eEffect = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
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


