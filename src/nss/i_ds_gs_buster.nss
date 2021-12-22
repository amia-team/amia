//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:
//group:
//used as: activation script
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "nw_i0_spells"
#include "amia_include"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget;
            location lTarget = GetItemActivatedTargetLocation();

            effect eBurst = EffectVisualEffect( VFX_FNF_DISPEL );
            effect eHit   = EffectVisualEffect( VFX_DUR_SPELLTURNING );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBurst, oPC, 1.0 );

            oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE );

            //Cycle through the targets within the spell shape until an invalid object is captured.
            while ( GetIsObjectValid( oTarget ) ) {

                //if ( !GetIsReactionTypeFriendly( oTarget ) ) {

                    // Handle saving throws, damage, effects etc.
                    nResult = RemoveEffectsBySpell ( oTarget, SPELL_ETHEREALNESS );

                    if ( nResult > 0 ){

                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHit, oTarget, 1.0 );
                    }

                //}

               //Select the next target within the spell shape.
               oTarget = GetNextObjectInShape( SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}




