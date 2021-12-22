/*

    Set Custom Tokens for merchant scripts

*/
void main()
{
   object oPC = GetPCSpeaker();
   object oInventoryItem = GetFirstItemInInventory(oPC);
   object oJobJournal;

    // We search for their journal
    while(GetIsObjectValid(oInventoryItem))
    {
        if(GetResRef(oInventoryItem) == "jobjournal")
        {
          oJobJournal = oInventoryItem;
          break;
        }
      oInventoryItem = GetNextItemInInventory(oPC);
    }

    // For loop to set all the custom tokens etc
    int i;
    for(i=1; i < 31; i++)
    {
      if(GetLocalString(oJobJournal,"storagename"+IntToString(i)) != "")
      {
        SetCustomToken(92308831+i,GetLocalString(oJobJournal,"storagename"+IntToString(i))+", Units Stored: " + IntToString(GetLocalInt(oJobJournal,"storagebox"+IntToString(i)+"amount")));
      }
      else
      {
        SetCustomToken(92308831+i,"Empty Storage Chest");
      }
    }

}
