//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_qst_items
//group:
//used as: activation script
//date:    nov 03 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_records"

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
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);
            location lTarget = GetItemActivatedTargetLocation();

            //SendMessageToPC( oPC, "check" );

            if ( sItemName == "Soapweed Roots" && GetName( oTarget ) == "Bucket of Water" ){

                SetName( oTarget, "Bucket of Soapy Water" );
                DestroyObject( oItem );

            }
            else if ( sItemName == "Bucket of Soapy Water" && GetName( oTarget ) == "Idol of Eilistraee" ){

                AssignCommand( oPC, SpeakString( "*cleans the statue*" ) );
                DestroyObject( oItem );

                if ( GetPCKEYValue( oPC, "ds_quest_6" ) == 1 ){

                    SendMessageToPC( oPC, "Your humble work earns you 250 XP!" );

                    GiveCorrectedXP( oPC, 250, "Quest", 0 );

                    ds_quest( oPC, "ds_quest_6", 2 );
                }
            }
            else if ( sItemName == "Pocket Golem" ){

                object oGolem = CreateObject( OBJECT_TYPE_CREATURE, "summon_poc_golem", GetLocation( oPC ), 1, "pocket_golem" );
                AddHenchman( oPC, oGolem );

                effect eSmoke = EffectVisualEffect( VFX_DUR_SMOKE );
                ApplyEffectToObject( DURATION_TYPE_PERMANENT, eSmoke, oGolem );

                SetLocalObject( oPC, "henchman", oGolem );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//----------------------------





