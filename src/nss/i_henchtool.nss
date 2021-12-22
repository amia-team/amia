/*
 Dec 7 2016 - Maverick00053

 Henchmen tool designed to assign NPCs to PCs using the Henchmen mechanics.
 The mod_mod_load file for the server load in has the MaxHenchman function set to
 50.

*/

#include "x2_inc_switches"
#include "inc_nwnx_events"
#include "inc_lua"
void main()
{
    object oTarget = GetItemActivatedTarget();
    object oWidget = GetItemActivated();
    object oNPCCheck = GetLocalObject( oWidget, "npc_hench");
    object oPCCheck= GetLocalObject( oWidget, "pc_master");
    int nSlot;
    object oSlot;
     //Checks if the target is a PC
     if(GetIsPC(oTarget))
     {
         //If the target is a PC, then is there a valid NPC stored already? If so do the below.
         if(GetIsObjectValid(oNPCCheck))
         {
           // Sets the npc's scripts to the henchmen ones
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',1, 'x0_ch_hen_attack');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',2, 'x0_ch_hen_block');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',3, 'x0_ch_hen_damage');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',4, 'x2_hen_death');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',5, 'x0_ch_hen_conv');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',6, 'x0_ch_hen_distrb');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',7, 'x0_ch_hen_combat');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',8, 'x0_ch_hen_heart');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',9, 'x0_ch_hen_percep');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',10, 'x0_ch_hen_rest');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',11, 'xx0_ch_hen_spawn');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',12, 'x2_hen_spell');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oNPCCheck)+"',13, 'x0_ch_hen_usrdef');");

           // Cycles through NPCs inventory and sets items so they cant be stolen
           object oInventory = GetFirstItemInInventory(oNPCCheck);
           while(GetIsObjectValid(oInventory))
           {
           SetItemCursedFlag(oInventory, TRUE);
           SetPlotFlag(oInventory, TRUE);
           oInventory = GetNextItemInInventory(oNPCCheck);
           }

           // Cycles through NPCs slots and sets items so they cant be stolen

           for (nSlot=0; nSlot < NUM_INVENTORY_SLOTS+1 ; nSlot++)
           {
            oSlot=GetItemInSlot(nSlot, oNPCCheck);

             //Sets curse/plot flags
             if (GetIsObjectValid(oSlot))
             {
                SetItemCursedFlag(oSlot, TRUE);
                SetPlotFlag(oSlot, TRUE);
             }

            }

           //Adds the npc as a henchmen to the targetted PC
           AddHenchman(oTarget,oNPCCheck);
           DelayCommand(0.1,DeleteLocalObject(oWidget, "npc_hench"));
           DelayCommand(0.1,DeleteLocalObject(oWidget, "pc_master"));
         }
         else
         {
          // If there isnt an NPC stored yet it stores the PC for use later
          SetLocalObject(  oWidget,"pc_master",oTarget);
         }


     }
     else
     {
         // If the object isnt a PC then it is assuming it is an NPC. If so it checks to see
         // if there is a PC stored already.
         if(GetIsObjectValid(oPCCheck))
         {
           // Sets the targetted NPC to have the henchmen scripts
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',1, 'x0_ch_hen_attack');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',2, 'x0_ch_hen_block');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',3, 'x0_ch_hen_damage');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',4, 'x2_hen_death');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',5, 'x0_ch_hen_conv');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',6, 'x0_ch_hen_distrb');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',7, 'x0_ch_hen_combat');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',8, 'x0_ch_hen_heart');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',9, 'x0_ch_hen_percep');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',10, 'x0_ch_hen_rest');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',11, 'xx0_ch_hen_spawn');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',12, 'x2_hen_spell');");
           RunLua( "nwn.SetGetScript('"+ObjectToString(oTarget)+"',13, 'x0_ch_hen_usrdef');");

           // Cycles through NPCs inventory and sets items so they cant be stolen
           object oInventory = GetFirstItemInInventory(oTarget);
           while(GetIsObjectValid(oInventory))
           {
           SetItemCursedFlag(oInventory, TRUE);
           SetPlotFlag(oInventory, TRUE);
           oInventory = GetNextItemInInventory(oTarget);
           }

           // Cycles through NPCs slots and sets items so they cant be stolen
           for (nSlot=0; nSlot < NUM_INVENTORY_SLOTS+1 ; nSlot++)
           {
            oSlot=GetItemInSlot(nSlot, oTarget);

             // Sets curse/plot flags
             if (GetIsObjectValid(oSlot))
             {
                SetItemCursedFlag(oSlot, TRUE);
                SetPlotFlag(oSlot, TRUE);
             }

            }

           //Adds the targetted NPC to the stored PC
           AddHenchman(oPCCheck,oTarget);
           DelayCommand(0.1,DeleteLocalObject(oWidget, "npc_hench"));
           DelayCommand(0.1,DeleteLocalObject(oWidget, "pc_master"));
         }
         else
         {
           //If there isnt a stored PC to use, it will store the npc for use later
           SetLocalObject( oWidget,"npc_hench", oTarget);
         }



     }


}
