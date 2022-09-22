/*
   Merchant Mini Chest Script - Targetting Script

   Maverick00053 - 7.28.22

*/

void main()
{
    object oPC = GetItemActivator();
    object oChest = GetItemActivated();
    object oTarget = GetItemActivatedTarget();
    object oPLC;
    location lTarget = GetItemActivatedTargetLocation();
    string sStoredItem = GetLocalString(oChest,"storagebox");
    string sStoredItemName = GetLocalString(oChest,"storageboxname");
    int nStoredItemCount = GetLocalInt(oChest,"storageboxcount");
    int nChestOut = GetLocalInt(oPC,"minimercchestout");

    // If they target an object we do a seperate check
    if(GetIsObjectValid(oTarget))
    {
      if((GetSubString(GetResRef(oTarget),0,3) == "js_"))
      {
	  
	  int nStackSize = GetItemStackSize(oTarget);
	  
        if(sStoredItem == "")
        {
          SetName(oChest,"<c~Îë>"+"Storage Chest: " + GetName(oTarget) + "</c>");
          SetLocalString(oChest,"storagebox",GetResRef(oTarget));
          SetLocalString(oChest,"storageboxname",GetName(oTarget));
          SetLocalInt(oChest,"storageboxcount",nStackSize);
          SetDescription(oChest,"Item Count Stored: " + IntToString(nStoredItemCount+nStackSize));
          DestroyObject(oTarget);
          SendMessageToPC(oPC,"Chest Set");
        }
        else if(GetResRef(oTarget) == sStoredItem)
        {
          SetLocalInt(oChest,"storageboxcount",nStoredItemCount+nStackSize);
          SetDescription(oChest,"Item Count Stored: " + IntToString(nStoredItemCount+nStackSize));
          DestroyObject(oTarget);
          SendMessageToPC(oPC,"Item Stored");
        }
        else if(GetResRef(oTarget) == "js_mini_merchest")   // Transfer mini chest to mini chest
        {
          string sStoredItemTarget = GetLocalString(oTarget,"storagebox");
          int nStoredItemCountTarget = GetLocalInt(oTarget,"storageboxcount");

          if(sStoredItem == sStoredItemTarget)
          {
           SendMessageToPC(oPC,"Items transferred");
           SetLocalInt(oChest,"storageboxcount",0);
           SetDescription(oChest,"Item Count Stored: " + IntToString(0));
           SetLocalInt(oTarget,"storageboxcount",nStoredItemCountTarget+nStoredItemCount);
           SetDescription(oTarget,"Item Count Stored: " + IntToString(nStoredItemCountTarget+nStoredItemCount));

          }
          else
          {
           SendMessageToPC(oPC,"Items stored do not match");
          }

        }
        /*
        else if(GetResRef(oTarget) == "js_jobjournal")  // Transfer from mini chest to job journal
        {

        }
        */
      }
      else
      {
        SendMessageToPC(oPC,"Target must be a Job System Item!");
      }
    }
    else   // This means clicked a location
    {
       if((nChestOut == 0))
       {
         oPLC = CreateObject(OBJECT_TYPE_PLACEABLE,"js_merchantbox_2",lTarget);
         SetLocalObject(oPLC,"oChest",oChest);
         SetLocalInt(oPC,"minimercchestout",1);
         SetLocalString(oPLC,"owner",GetName(oPC));
         SetDroppableFlag(oChest, FALSE);
         if(GetLocalString(oChest,"storagebox") != "")
         {
           SetName(oPLC,"<c~Îë>"+GetLocalString(oChest,"storageboxname")+" Miniature Storage Box"+"</c>");
         }
         else
         {
           SetName(oPLC,"<c~Îë>Empty Miniature Storage Box</c>");
         }
       }
       else
       {
         SendMessageToPC(oPC,"Miniature chest is already out!");
       }

    }
}
