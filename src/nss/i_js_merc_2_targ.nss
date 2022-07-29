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

    // If they target an object we a seperate check
    if(GetIsObjectValid(oTarget))
    {
      if((GetSubString(GetResRef(oTarget),0,3) == "js_"))
      {
        if(sStoredItem == "")
        {
          SetName(oChest,"<c~Îë>"+"Storage Chest: " + GetName(oTarget) + "</c>");
          SetLocalString(oChest,"storagebox",GetResRef(oTarget));
          SetLocalString(oChest,"storageboxname",GetName(oTarget));
          SetLocalInt(oChest,"storageboxcount",1);
          SetDescription(oChest,"Item Count Stored: 1");
          DestroyObject(oTarget);
          SendMessageToPC(oPC,"Chest Set");
        }
        else if(GetResRef(oTarget) == sStoredItem)
        {
          SetLocalInt(oChest,"storageboxcount",nStoredItemCount+1);
          SetDescription(oChest,"Item Count Stored: " + IntToString(nStoredItemCount+1));
          SetLocalInt(oChest,"storageboxcount",nStoredItemCount+1);
          DestroyObject(oTarget);
          SendMessageToPC(oPC,"Item Stored");
        }
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
