/*
  Bank conversation script.

  - Jes 2/6/2024

*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"
#include "inc_ds_actions"

void StorageAmountCheck (object pc);

void main()
{
    object banker = OBJECT_SELF;
    object pc = GetLastSpeaker();

    if(GetIsPC(pc)==FALSE)
    {
        SendMessageToPC(pc,"Only players can use the bank.");
        return;
    }
    clean_vars(pc,4);
    StorageAmountCheck(pc);
    AssignCommand(banker, ActionStartConversation(pc, "c_db_bank_conv", TRUE, TRUE));
}

void StorageAmountCheck (object pc)
{
    object pcKey = GetItemPossessedBy(pc, "ds_pckey");
    int storageAmount = GetLocalInt(pcKey,"storage_cap");

    if (storageAmount == 0){
        //Set default storage limit.
        storageAmount = 20;
        SetLocalInt(pcKey, "storage_cap", storageAmount);
    }

    SetLocalInt(pc,"ds_check_1",1);
    //Display storage limit.
    SetCustomToken(13333330,IntToString(storageAmount));
    //Display next possible storage limit.
    SetCustomToken(13333331,IntToString(storageAmount + 10));
    if (storageAmount == 20){
        //Price of storage upgrade. First time is 20,000gp.
        string upgradeCost = IntToString(storageAmount * 1000);

        SetCustomToken(13333332,upgradeCost);
        SetLocalInt(pc, "upgrade_cost", StringToInt(upgradeCost));
        SetLocalInt(pc, "upgrade_amount", (storageAmount + 10));
    }
    else{
        //Price of storage upgrade. Cost growth.
        int newCap      = storageAmount + 10;
        int capPower    = (newCap - 30) / 10;
        float capPowerF = IntToFloat(capPower);
        int costAdjust  = FloatToInt(pow(2.0, capPowerF));
        int costAmount  = 20000 * costAdjust;

        string upgradeCost = IntToString(costAmount);

        SetCustomToken(13333332,upgradeCost);
        SetLocalInt(pc, "upgrade_cost", StringToInt(upgradeCost));
        SetLocalInt(pc, "upgrade_amount", (storageAmount + 10));
    }
}
