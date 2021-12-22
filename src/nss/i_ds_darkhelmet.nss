//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:
//group: DC requests
//used as: Frey's helmet
//date:
//author:


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void CreateEyes( object oPC );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;
    object oPC;
    object oItem;

    switch (nEvent){

        case X2_ITEM_EVENT_EQUIP:

            // item activate variables
            oPC       = GetPCItemLastEquippedBy();
            oItem     = GetPCItemLastEquipped();

            AssignCommand( oPC, CreateEyes( oPC ) );

        break;

        case X2_ITEM_EVENT_UNEQUIP:

            // item activate variables
            oPC       = GetPCItemLastUnequippedBy();
            oItem     = GetPCItemLastUnequipped();

            effect eOnPC = GetFirstEffect( oPC );

            while ( GetIsEffectValid( eOnPC ) ){

                if ( GetEffectType( eOnPC ) == EFFECT_TYPE_VISUALEFFECT && GetEffectCreator( eOnPC ) == oPC ){

                    RemoveEffect( oPC, eOnPC );
                }

                eOnPC = GetNextEffect( oPC );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void CreateEyes( object oPC ){

    effect eEyes = EffectVisualEffect( VFX_EYES_RED_FLAME_HUMAN_MALE );

    eEyes = SupernaturalEffect( eEyes );

    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEyes, oPC ) );
}
