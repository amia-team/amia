void main()
{
   object oPC = GetPCSpeaker();
   object oWidget = GetItemPossessedBy(oPC, "ds_pckey");
   SetLocalInt(oWidget,"BGHAreaSelected",2);
}
