/*  i_fk_dc_item003
--------
Verbatim
--------
Pools custom item request scripts
---------
Changelog
---------
Date         Name        Reason
------------------------------------------------------------------
2010-11-1   Bruce       Start
------------------------------------------------------------------

DC Item that creates a vortex of leaves upon an object.

*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------

#include "x2_inc_switches"
#include "x0_i0_position"

//-------------------------------------------------------------------------------
//Prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
//main
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
          object oTarget   = GetItemActivatedTarget();
          string sItemName = GetName( oItem );
          location lTarget = GetItemActivatedTargetLocation();
          effect eShield = EffectVisualEffect( 679 );

          if ( sItemName == "Leaf" ){

                if ( GetIsObjectValid( oTarget ) ){
                    AssignCommand( oPC, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield, oTarget, 600.0 ));
                }else{
                    //if ground targetted, generate a walkable object otherwise the effect will only last 1 round.
                    object oLeafVortex = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_invis_object2", lTarget, FALSE, "");
                    AssignCommand( oPC, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield, oLeafVortex, 600.0 ));
                    SetUseableFlag(oLeafVortex, FALSE);
                    //clean up after ourselves.
                    DelayCommand(600.0, DestroyObject(oLeafVortex));
                }
          }
          break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//Definitions
//-------------------------------------------------------------------------------


