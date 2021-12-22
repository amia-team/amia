void main()
{
  object oPC = OBJECT_SELF;
  object oWidget = GetItemPossessedBy(oPC, "ds_pckey");
  int nObtained = GetLocalInt(oPC,"spellsobtained");

  if(GetIsObjectValid(oWidget))
  {
    return;
  }

  if(nObtained == 1)
  {
    return;
  }

  // Base races with spell like abilities
  if(GetRacialType(oPC) == 33)// Drow
  {
    CreateItemOnObject("race_drow_item1",oPC);
    CreateItemOnObject("faeriefire",oPC);
    CreateItemOnObject("dancelight",oPC);
  }
  if(GetRacialType(oPC) == 36)// Svirfneblin
  {
    CreateItemOnObject("race_svirf_item2",oPC);
  }
  if(GetRacialType(oPC) == 37)// Ghostwise Halfling
  {
    CreateItemOnObject("race_ghalf_item1",oPC);
  }
  if(GetRacialType(oPC) == 30)// Duergar
  {
    CreateItemOnObject("race_dgar_item1",oPC);
  }


  // Sub races with spell like abilities
  if(GetSubRace(oPC) == "Aasimar")
  {
    CreateItemOnObject("race_asmar_item1",oPC);
  }
  if(GetSubRace(oPC) == "Feytouched")
  {
    CreateItemOnObject("race_fae_item1",oPC);
  }
  if(GetSubRace(oPC) == "Tiefling")
  {
    CreateItemOnObject("race_drow_item1",oPC);
  }
  if(GetSubRace(oPC) == "Air Genasi")
  {
    CreateItemOnObject("race_anasi_item1",oPC);
  }
  if(GetSubRace(oPC) == "Earth Genasi")
  {
    CreateItemOnObject("race_enasi_item1",oPC);
  }
  if(GetSubRace(oPC) == "Fire Genasi")
  {
    CreateItemOnObject("race_fnasi_item1",oPC);
  }
  if(GetSubRace(oPC) == "Water Genasi")
  {
    CreateItemOnObject("race_wnasi_item1",oPC);
  }
  if(GetSubRace(oPC) == "Fey'ri")
  {
    CreateItemOnObject("race_ghalf_item1",oPC);
  }

  SetLocalInt(oPC,"spellsobtained",1);
}
