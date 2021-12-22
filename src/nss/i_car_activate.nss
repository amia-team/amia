//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:
//group:
//used as: item activation script
//date:
//author:


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"
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

    object oPC;
    object oItem;
    object oTarget;
    string sItemName;
    location lTarget;

    switch ( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            oPC       = GetItemActivator();
            oItem     = GetItemActivated();
            oTarget   = GetItemActivatedTarget();
            sItemName = GetName(oItem);
            lTarget = GetItemActivatedTargetLocation();


            if ( sItemName == "Cursed Ring of the Chieftain" && GetTag( oTarget ) == "car_pond" ){

                int nHour = GetTimeHour();

                if ( nHour == 0 || nHour == 23 ){

                    ActionUnequipItem( oItem );

                    DestroyObject( oItem, 1.0 );

                    AssignCommand( oPC, SpeakString( "*drops something in the pond*" ) );

                    GiveRewardToParty( oPC, 50, 0, "Quest" );
                }
                else{

                    SendMessageToPC( oPC, "Check the time of day?" );
                }
            }
            else{

                SendMessageToPC( oPC, "Nah... doesn't work!" );
            }

            break;

        case X2_ITEM_EVENT_ACQUIRE:

            // item activate variables
            oPC       = GetModuleItemAcquiredBy();
            oItem     = GetModuleItemAcquired();
            sItemName = GetName(oItem);

            if ( sItemName == "Ring of the Chieftain" ){

                SetItemCursedFlag( oItem, TRUE );

                IPRemoveMatchingItemProperties( oItem, ITEM_PROPERTY_DAMAGE_RESISTANCE, DURATION_TYPE_PERMANENT );

                int nStr = GetAbilityModifier( ABILITY_STRENGTH, oPC );

                if ( nStr < 0 ){

                    nStr = 0;
                }
                else if ( nStr > 5 ){

                    nStr = 5;
                }

                itemproperty ipWeight = ItemPropertyWeightIncrease( nStr );

                IPSafeAddItemProperty( oItem, ipWeight );

                SetName( oItem, "Cursed Ring of the Chieftain" );

                SetDescription( oItem, "You 'found' this ring in one of the barrows of Caraigh. It showed the promise of potent magic when you picked it up, but power was turned into weight once it reached your pockets. Throw it in the clouded pond at midnight if you want to part with this ring... or find another way to lift the curse of the Chieftain." );

                object oSpeaker = ds_spawn_critter( oPC, "car_chieftain", GetLocation( oPC ) );

                DelayCommand( 3.0, FloatingTextStringOnCreature( "This ring will be a burden upon you and no profit will come from wearing it. Throw it in the clouded pond at midnight if you want to part with your ill-begotten trophy.", oPC, FALSE ) );
            }

            break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


