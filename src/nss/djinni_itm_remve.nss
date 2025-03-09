/*
   Entry script to script people of the Djinni temple items

   - Maverick00053, March 2025
*/


void RemoveItems(object oPC);

void main()
{
  object oArea = GetArea(OBJECT_SELF);
  object oPC = GetEnteringObject();

  RemoveItems(oPC);


}

void RemoveItems(object oPC)
{
   object oItem = GetFirstItemInInventory(oPC);
   int nRemove;

   while(GetIsObjectValid(oItem))
   {
     if((GetResRef(oItem)=="djinnikey1") || (GetResRef(oItem)=="djinnikey2") || (GetResRef(oItem)=="djinnikey3") || (GetResRef(oItem)=="djinnikey4")
     || (GetResRef(oItem)=="djinnikey5") || (GetResRef(oItem)=="djinnikey6") || (GetResRef(oItem)=="djinniorb") || (GetResRef(oItem)=="djinniweapon")
      || (GetResRef(oItem)=="djinniwand") || (GetResRef(oItem)=="djinnibook"))
     {
       DestroyObject(oItem);
       nRemove=1;
     }
     oItem = GetNextItemInInventory(oPC);
   }

   if(nRemove==1)
   {
     SendMessageToPC(oPC,"*You feel your bags get lighter as item(s) disappear.*");
   }
}
