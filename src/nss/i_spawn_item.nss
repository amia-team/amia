void main()
{
    object pc        = GetItemActivator();
    object spawner   = GetItemActivated();
    object itemSpawn = GetItemActivatedTarget();
    int itemCost     = GetGoldPieceValue(itemSpawn);

    if(GetIsDM(pc)){
        string itemName = GetName(itemSpawn);
        json store      = ObjectToJson(itemSpawn, TRUE);

        SetLocalJson(spawner, "item_stored", store);
        SetLocalString(spawner, "item_name", itemName);
        SetLocalInt(spawner, "cost", itemCost);
        SetLocalInt(spawner, "quantity", 1);
        FloatingTextStringOnCreature("Item Spawner set to " + itemName + "! You can now give the item to the player.",pc, TRUE);
        SetName(spawner, "<cíÿ¡>Item Spawner: " + itemName + "</c>");
        SetDescription(spawner, "Use this item on yourself to spawn 1 <cíÿ¡>" + itemName + "</c> for " + IntToString(itemCost) + " gold coins. Use this item on itself to change the quantity spawned.");
    }

    else{
        string itemName = GetLocalString(spawner, "item_name");
        int cost        = GetLocalInt(spawner, "cost");
        int quantity    = GetLocalInt(spawner, "quantity");
        int totalCost   = cost * quantity;

        if(itemSpawn == spawner){
            if(quantity == 1){
                SetLocalInt(spawner, "quantity", 5);
                int newCost = cost * 5;
                FloatingTextStringOnCreature("Item Spawner quantity set to 5. Cost is " + IntToString(newCost) + " gold pieces.", pc, TRUE);
                SetDescription(spawner, "Use this item on yourself to spawn 5 <cíÿ¡>" + itemName + "</c> for " + IntToString(newCost) + " gold coins. Use this item on itself to change the quantity spawned.");
            }
            if(quantity == 5){
                SetLocalInt(spawner, "quantity", 10);
                int newCost = cost * 10;
                FloatingTextStringOnCreature("Item Spawner quantity set to 10. Cost is " + IntToString(newCost) + " gold pieces.", pc, TRUE);
                SetDescription(spawner, "Use this item on yourself to spawn 10 <cíÿ¡>" + itemName + "</c> for " + IntToString(newCost) + " gold coins. Use this item on itself to change the quantity spawned.");
            }
            if(quantity == 10){
                SetLocalInt(spawner, "quantity", 1);
                int newCost = cost * 1;
                FloatingTextStringOnCreature("Item Spawner quantity set to 1. Cost is " + IntToString(newCost) + " gold pieces.", pc, TRUE);
                SetDescription(spawner, "Use this item on yourself to spawn 1 <cíÿ¡>" + itemName + "</c> for " + IntToString(newCost) + " gold coins. Use this item on itself to change the quantity spawned.");
            }
        }

        else if(itemSpawn == pc){
            int totalCost = quantity * cost;
            int hasGold   = GetGold(pc);

            if(totalCost > hasGold){
                FloatingTextStringOnCreature("You do not have enough gold to spawn these items.", pc, TRUE);
            }

            else{
                int i = quantity;
                while (i > 0){
                    location pcSpot = GetLocation(pc);
                    json stored     = GetLocalJson(spawner, "item_stored");
                    object spawned  = JsonToObject(stored, pcSpot, pc, TRUE);
                    SetStolenFlag(spawned, 1);
                    i = i - 1;
                }
                AssignCommand(pc, TakeGoldFromCreature(totalCost, pc, TRUE));
            }
        }

        else{
            SendMessageToPC(pc, "Use this widget on itself to set the quantity; it will toggle between 1, 5, and 10. Use it on yourself to spawn a quantity of the stored item.");
        }
    }
}
