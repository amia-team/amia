/*  i_fk_dc_item001
--------
Verbatim
--------
Pools custom item request scripts
---------
Changelog
---------
Date         Name        Reason
------------------------------------------------------------------
2010-10-29   Bruce       Start
------------------------------------------------------------------
A DC item that generates 5x darkness spells about the 'caster' with a duration of turn/SD level

*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------

#include "x2_inc_switches"
#include "x0_i0_position"

//-------------------------------------------------------------------------------
//Prototypes
//-------------------------------------------------------------------------------

void PervasiveDarkness( );

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

          if ( sItemName == "Pervasive Darkness" ){
               AssignCommand( oPC, PervasiveDarkness() );
          }
          break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//Definitions
//-------------------------------------------------------------------------------

void PervasiveDarkness( ){

    //Grab shadowdancer levels
    int iDuration   =   GetLevelByClass( CLASS_TYPE_SHADOWDANCER, OBJECT_SELF ) * 10;  //SD levels *10 to reflect turn duration
    location lSelf  =   GetLocation( OBJECT_SELF );
    float fAngle    =   90.0f;
    int i;

    //If you do not have SD levels you should not have this item; and do nothing.
    if (iDuration <1){
       return;
    }

    //set custom duration for the darkness spell
    SetLocalInt( OBJECT_SELF, "darkduration", iDuration );

    //center on caster in case any of the below for fall on invalid ground targets
    ActionCastSpellAtLocation( SPELL_DARKNESS, lSelf, METAMAGIC_ANY, TRUE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);

    //Create 4 instances of the AOE Effect in the NW, NE, SE, SW directions for  1 Turn/SD levels
    //with caster at the epicenter.
    for( i = 0; i < 4 ; i++ ){
       location lCorner    =   GenerateNewLocationFromLocation(lSelf, 10.0f, fAngle, 0.0f);
       ActionCastSpellAtLocation( SPELL_DARKNESS, lCorner, METAMAGIC_ANY, TRUE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
       fAngle += 90.0;
    }

    return;
}

