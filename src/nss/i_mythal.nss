/*  Mythal Crafting :: Conversation Initialize

    --------
    Verbatim
    --------
    Initializes the mythal crafting conversation

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    20050606  kfw       Initial Release.
    20080901  Terra     Epic clean up
    20111028  Selmak    Recompile for containers
                        Support was added for interaction for Recall Portals
    20231208  Maverick  Added in support for Raid Boss charging
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "x2_inc_itemprop"

#include "inc_td_mythal"
#include "inc_ds_porting"
#include "inc_recall_chg"
#include "inc_recall_stne"

// Checker for if PCKEYs are already used on the raid summoner
int CheckPCKEYAlreadyUsed(object oPC, object oItem);

// Spawns Raid Boss if conditions are meet
void SpawnBoss(object oItem);

void main( ){

    // Variables
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            object oMythal      = GetNearestObjectByTag( MYTHAL_FORGE, oPC );
            object oReagent     = GetItemActivated( );
            object oItem        = GetItemActivatedTarget( );

            // Charge raid boss summoning statue and summon
            if(GetResRef(oItem)=="raidsummoner")
            {
              int nCharge = GetLocalInt(oItem,"charge");
              int nPlayerMin = GetLocalInt(oItem,"playerMin");
              string sMessage = GetLocalString(oItem,"bossMessage");
              string sActiveMessage = GetLocalString(oItem,"bossActiveMessage");
              string sMythalResRef = GetLocalString(oItem,"mythal");

              if(sMythalResRef == "") // Defaults to Greater Mythal if not set
              {
                sMythalResRef="mythal4";
              }

              if(GetResRef(oReagent) != sMythalResRef)  // Checks that your mythal matches
              {
               SendMessageToPC(oPC,"The device rejects your mythal. This is not the right type of Mythal.");
               return;
              }

              // Checks the condition of the boss first and rejects if they are out
              if(GetLocalInt(oItem,"bossOut")==1)
              {
               if(sActiveMessage=="")
               {
                 AssignCommand(oItem,ActionSpeakString("*Cannot summon while a boss is already active!*"));
               }
               else
               {
                 AssignCommand(oItem,ActionSpeakString(sActiveMessage));
               }
               return;
              }

              // Checks for if you already used a Mythal this reset and returns 1 for yes, and 0 for no
              if(CheckPCKEYAlreadyUsed(oPC,oItem)==1)
              {
               SendMessageToPC(oPC,"The device rejects your mythal. You have already contributed today!");
               return;
              }

              if((nCharge+1)>=nPlayerMin) // Charge Counter Total Meet or Exceeded - Spawn Boss
              {
                SetLocalInt(oItem,"charge",0);
                if(sMessage=="")
                {
                  AssignCommand(oItem,ActionSpeakString("*The device lets out a powerful burst of magic and calls forth something!*"));
                }
                else
                {
                  AssignCommand(oItem,ActionSpeakString(sMessage));
                }
                DestroyObject(oReagent);
                SpawnBoss(oItem);
              }
              else if((nCharge+1)<nPlayerMin) // Add to charge counter of the raidsummoner
              {
                SetLocalInt(oItem,"charge",nCharge+1);
                DestroyObject(oReagent);
                AssignCommand(oItem,ActionSpeakString("*The device glows brightly as its charge builds*"));
              }

              return;
            }
            //

            //Recharge Enhanced Recall Stone
            if ( GetTag( oItem ) == "recall_enh" ){
                if (ChargesToAdd(oReagent) == 100){
                    string recallCarry = GetLocalString(oItem, LVAR_RECALL_WP);
                    object divineStone = CreateItemOnObject("recall_div", oPC, 1);
                    string oldName     = GetName(oItem);
                    string divName     = GetSubString(oldName, 15, 50);

                    SetLocalString(divineStone, LVAR_RECALL_WP, recallCarry);
                    SetName(divineStone, "<cÿÓ'>Divine "+divName);
                    DestroyObject(oReagent);
                    DestroyObject(oItem);
                    FloatingTextStringOnCreature("Recall Stone upgraded to Divine!", oPC, FALSE);
                    return;
                }
                if(ChargesToAdd(oReagent) == 15){
                    if (GetLocalInt(oItem, "size") < 15){
                        string bioQty    = GetDescription(oItem, FALSE, TRUE);
                        string bioFirst  = GetSubString(bioQty, 0, 13);
                        string bioLast   = GetSubString(bioQty, 16, 500);
                        SetLocalInt(oItem, "size", 15);
                        SetItemCharges(oItem, 15);
                        DestroyObject(oReagent);
                        FloatingTextStringOnCreature("Recall Stone upgraded to hold 15 charges!", oPC, FALSE);
                        SetDescription(oItem, bioFirst+"15 "+bioLast);
                        return;
                    }
                    if (CanAddCharges(oReagent, oItem) == TRUE){
                        SafeAddCharges(oItem, oReagent, ChargesToAdd(oReagent));
                        DestroyObject(oReagent);
                        FloatingTextStringOnCreature("Added 15 Charges!", oPC, FALSE);
                        return;
                    }
                    else{
                        FloatingTextStringOnCreature("This mythal is too powerful. Use a smaller mythal reagent or upgrade your recall stone first.", oPC, FALSE);
                        return;
                    }
                }
                if(ChargesToAdd(oReagent) == 20){
                    if (GetLocalInt(oItem, "size") < 20){
                        string bioQty    = GetDescription(oItem, FALSE, TRUE);
                        string bioFirst  = GetSubString(bioQty, 0, 13);
                        string bioLast   = GetSubString(bioQty, 16, 500);
                        SetLocalInt(oItem, "size", 20);
                        SetItemCharges(oItem, 20);
                        DestroyObject(oReagent);
                        FloatingTextStringOnCreature("Recall Stone upgraded to hold 20 charges!", oPC, FALSE);
                        SetDescription(oItem, bioFirst+"20 "+bioLast);
                        return;
                    }
                    if (CanAddCharges(oReagent, oItem) == TRUE){
                        SafeAddCharges(oItem, oReagent, ChargesToAdd(oReagent));
                        DestroyObject(oReagent);
                        FloatingTextStringOnCreature("Added 20 Charges!", oPC, FALSE);
                        return;
                    }
                    else{
                        FloatingTextStringOnCreature("This mythal is too powerful. Use a smaller mythal reagent or upgrade your recall stone first.", oPC, FALSE);
                        return;
                    }
                }
                else{
                    if (CanAddCharges(oReagent, oItem) == TRUE){
                        int chargeAdd = ChargesToAdd(oReagent);
                        SafeAddCharges(oItem, oReagent, ChargesToAdd(oReagent));
                        DestroyObject(oReagent);
                        FloatingTextStringOnCreature("Added "+IntToString(chargeAdd)+" Charge(s)!", oPC, FALSE);
                        return;
                    }
                    else{
                        FloatingTextStringOnCreature("This mythal is too powerful. Use a smaller mythal reagent or upgrade your recall stone first.", oPC, FALSE);
                        return;
                    }
                }
            }
            if ( GetTag( oItem ) == "recall_div" ){
                FloatingTextStringOnCreature("You do not need to recharge a Divine Recall Stone!", oPC, FALSE);
                return;
            }

            // Strip temporary item effects
            if( GetObjectType( oItem ) == OBJECT_TYPE_ITEM )
            {
            itemproperty IP = GetFirstItemProperty( oItem );

                while( GetIsItemPropertyValid( IP ) )
                {
                    if( GetItemPropertyDurationType( IP ) == DURATION_TYPE_TEMPORARY ){
                    RemoveItemProperty( oItem , IP );
                    }
                IP = GetNextItemProperty( oItem );
                }

            SendMessageToPC( oPC, "<cÌ&Ì>- The mythal seems to strip your item of its temporary enchantments-</c>" );
            }

            // Player must be within 5 feet of a mythal forge (and the forget itself must exist).
            if( !GetIsObjectValid( oMythal ) || GetDistanceBetween( oPC, oMythal ) > 5.0 ){

                // Notify the player.
                SendMessageToPC(
                    oPC,
                    "<cÌ&Ì>- Mythal Crafting - <cþ  >Error</c> - <cþþþ>You aren't near a Mythal Forge to craft.</c> -" );

                // Candy.
                AssignCommand( oPC, PlaySound( "sff_spellfail" ) );

                break;

            }

            // Player must own the item they want to craft.
            if( GetItemPossessor( oItem ) != oPC ){

                // Notify the player.
                SendMessageToPC(
                    oPC,
                    "<cÌ&Ì>- Mythal Forge - <cþ  >Error</c> - <cþþþ>You cannot craft items that you don't own.</c> -" );

                // Candy.
                AssignCommand( oPC, PlaySound( "sff_spellfail" ) );

                break;

            }

            // Plot or Stolen Items aren't permitted. Checks separate variable to block mythals.
            if( GetPlotFlag( oItem ) || ( GetLocalInt( oItem, "mythalblock" ) == 1 )) {

                // Notify the player.
                SendMessageToPC(
                    oPC,
                    "<cÌ&Ì>- Mythal Forge - <cþ  >Error</c> - <cþþþ>Item is too powerful to be crafted.</c> -" );

                break;

            }

            /* Store variables on player object. */
            /* Setup temporary custom tokens for strings in Conversation. */
            /* Initialize conversation. */
            SetMythalChecks( oPC , oItem , oReagent , oMythal , "mythal" );




            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}

int CheckPCKEYAlreadyUsed(object oPC, object oItem)
{
  object oPCKEY = GetPCKEY(oPC);
  string sPCKEYName = GetName(oPCKEY);
  string sPCKEYNameSub = GetSubString(sPCKEYName,0,8);
  int nStored = GetLocalInt(oItem,"stored"); // Internal counter to know how many PCKEYS are stored on the device
  int nCheck;

  if(nStored==0) // If non are stored, just go ahead and store it in PCKEY0
  {
    SetLocalString(oItem,"PCKEY"+IntToString(nStored),sPCKEYNameSub);
    SetLocalInt(oItem,"stored",nStored+1);
    return 0;
  }
  else
  {
    int i;
    for(i=0;i<nStored+1;++i)
    {
      if(sPCKEYNameSub==GetLocalString(oItem,"PCKEY"+IntToString(i))) // If their PCKEY matches saved, break the loop and set check to 1
      {
        nCheck=1;
        break;
      }
    }

    if(nCheck==1)
    {
     return 1;
    }
    else
    {
     SetLocalString(oItem,"PCKEY"+IntToString(nStored),sPCKEYNameSub);
     SetLocalInt(oItem,"stored",nStored+1);
     return 0;
    }
  }
}


void SpawnBoss(object oItem)
{
  string sBossResRef = GetLocalString(oItem,"bossResRef");
  string sWaypointBoss = GetLocalString(oItem,"bossWP");
  string sPLCClear1 = GetLocalString(oItem,"PLC1");
  string sPLCClear2 = GetLocalString(oItem,"PLC2");
  string sPLCClear3 = GetLocalString(oItem,"PLC3");
  string sSpawnPLC1 = GetLocalString(oItem,"spawnPLC1");
  string sSpawnWP1 = GetLocalString(oItem,"spawnWP1");
  string sUnlockDoor1 = GetLocalString(oItem,"unlockDoor1");

  object oWaypoint = GetWaypointByTag(sWaypointBoss);
  location lWaypoint = GetLocation(oWaypoint);
  object oWPSpawn1 = GetWaypointByTag(sSpawnWP1);
  location lWPSpawn1 = GetLocation(oWPSpawn1);
  object oPLC1 = GetObjectByTag(sPLCClear1);
  object oPLC2 = GetObjectByTag(sPLCClear2);
  object oPLC3 = GetObjectByTag(sPLCClear3);
  object oUnlockDoor1 = GetObjectByTag(sUnlockDoor1);

  if(sUnlockDoor1 != "")
  {
    SetLocked(oUnlockDoor1,FALSE);
    SetLockKeyRequired(oUnlockDoor1, FALSE);
  }

  if(sPLCClear1 != "")
  {
    DestroyObject(oPLC1);
  }

  if(sPLCClear2 != "")
  {
    DestroyObject(oPLC2);
  }

  if(sPLCClear3 != "")
  {
    DestroyObject(oPLC3);
  }

  if(sSpawnPLC1 != "")
  {
   CreateObject(OBJECT_TYPE_PLACEABLE,sSpawnPLC1,lWPSpawn1,TRUE);
  }

  CreateObject(OBJECT_TYPE_CREATURE,sBossResRef,lWaypoint,TRUE);
  SetLocalInt(oItem,"bossOut",1);

}
