//::///////////////////////////////////////////////
//:: Name    cowledheadfix
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*  This script will swap between a character's base head
    and the appropriate cowled/masked head for their
    race and gender.
    Uses references from Amia's Custom Head Pack.
*/
//:://////////////////////////////////////////////
//:: Created By: Ron 'BrainSplitter'
//:: Created On: Feb27 2008
//:://////////////////////////////////////////////

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    object oPC;
    object oItem;
    int    nCurrent;
    int    nBase;
    int    nUnset;
    int    nAlt;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // Set Variables
            oPC      = GetItemActivator();
            oItem    = GetItemActivated();
            nCurrent = GetCreatureBodyPart(CREATURE_PART_HEAD,oPC);

            // Test if tool has been activated
            if ( GetName( oItem ) == "Hooded Cloak (read description!)"  ) {

                if ( GetIsPolymorphed( oPC ) ){

                    SendMessageToPC( oPC, "You are polymorphed!" );
                    return;
                }

                // Test Male(1)/Female(2) (M=True). also check skin
                int nSkin = GetAppearanceType(oPC);

                if ( nSkin == 5 || nSkin > 6 ){

                    SendMessageToPC( oPC, "You can't use this item on your race!" );
                    return;
                }

                // Assign new base head using current head
                SetLocalInt( oItem, "basehead", nCurrent );

                int nSex  = GetGender(oPC);

                if  (nSex == 0) {

                    // Use skin to choose appropriate head via Switch
                    switch (nSkin)  {

                        case 0: nAlt = 18; break;
                        case 1: nAlt = 15; break;
                        case 2: nAlt = 17; break;
                        case 3: nAlt = 17; break;
                        case 4: nAlt = 2; break;
                        case 5: /* No change; race does not have cowled head */ break;
                        case 6: nAlt = 2; break;
                        default: /* No change; race does not have cowled head */ break;

                    }
                }
                else {

                    switch (nSkin) {

                        case 0: nAlt = 14; break;
                        case 1: nAlt = 14; break;
                        case 2: nAlt = 5; break;
                        case 3: nAlt = 3; break;
                        case 4: nAlt = 12; break;
                        case 5: break;  /* No change; race does not have cowled head */
                        case 6: nAlt = 12; break;
                        default: break; /* No change; race does not have cowled head */

                    }
                }

                SetLocalInt( oItem, "althead", nAlt );

                SetName( oItem, "Hooded Cloak: "+GetName( oPC ) );

                IPRemoveMatchingItemProperties( oItem, ITEM_PROPERTY_CAST_SPELL, DURATION_TYPE_PERMANENT );

                ExportSingleCharacter( oPC );
            }

        break;

        case X2_ITEM_EVENT_EQUIP:

            oPC      = GetPCItemLastEquippedBy();        // The player who equipped the item
            oItem    = GetPCItemLastEquipped();         // The item that was equipped
            nCurrent = GetCreatureBodyPart( CREATURE_PART_HEAD, oPC );
            nAlt     = GetLocalInt( oItem, "althead" );

            if ( GetName( oItem ) != "Hooded Cloak (read description!)" ) {

                SetCreatureBodyPart(CREATURE_PART_HEAD,nAlt,oPC);
                SendMessageToPC( oPC, "[Cloak: Setting head to #"+IntToString( nAlt )+"]" );
            }

        break;

        case X2_ITEM_EVENT_UNEQUIP:

            oPC      = GetPCItemLastUnequippedBy();        // The player who equipped the item
            oItem    = GetPCItemLastUnequipped();         // The item that was equipped
            nCurrent = GetCreatureBodyPart(CREATURE_PART_HEAD,oPC);
            nBase    = GetLocalInt( oItem, "basehead" );

            if ( GetName( oItem ) != "Hooded Cloak (read description!)" ) {

                SetCreatureBodyPart(CREATURE_PART_HEAD,nBase,oPC);
                SendMessageToPC( oPC, "[Cloak: Setting head to #"+IntToString( nBase )+"]" );
            }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue( nResult );
}





