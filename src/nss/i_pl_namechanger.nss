/*
  Player Temporary Name Changer
  Maverick00053 - 7/14/22

  changlog:
  26-Sep-2023   Frozen  Added random name function
*/

#include "nwnx_rename"
#include "nwnx"

void main()
{
  object oPC            = GetItemActivator();
  object oWidget        = GetItemActivated();
  string sWidgetSetName = GetLocalString(oWidget, "newName");
  string sOverwriteName = NWNX_Rename_GetPCNameOverride(oPC);
  int nRandom           = GetLocalInt(oWidget,"random");
  int nWidgetNameSet    = GetLocalInt(oWidget,"widgetSet");


  if(nRandom == 1 && sOverwriteName != sWidgetSetName)
  {
    int nGender = GetGender (oPC);
    int nRace   = GetAppearanceType (oPC);

    if (nGender == GENDER_MALE){
        if      (nRace == APPEARANCE_TYPE_DWARF){sWidgetSetName = RandomName (NAME_FIRST_DWARF_FEMALE);}
        else if (nRace == 1){sWidgetSetName = RandomName (NAME_FIRST_ELF_MALE);}
        else if (nRace == 2){sWidgetSetName = RandomName (NAME_FIRST_GNOME_MALE);}
        else if (nRace == 3){sWidgetSetName = RandomName (NAME_FIRST_HALFLING_MALE);}
        else if (nRace == 4){sWidgetSetName = RandomName (NAME_FIRST_HALFELF_MALE);}
        else if (nRace == 5){sWidgetSetName = RandomName (NAME_FIRST_HALFORC_MALE);}
        else if (nRace == 6){sWidgetSetName = RandomName (NAME_FIRST_HUMAN_MALE);}
        else                {sWidgetSetName = RandomName (NAME_FAMILIAR);}
    }
    else if (nGender == GENDER_FEMALE){
        if      (nRace == APPEARANCE_TYPE_DWARF){sWidgetSetName = RandomName (NAME_FIRST_DWARF_FEMALE);}
        else if (nRace == 1){sWidgetSetName = RandomName (NAME_FIRST_ELF_FEMALE);}
        else if (nRace == 2){sWidgetSetName = RandomName (NAME_FIRST_GNOME_FEMALE);}
        else if (nRace == 3){sWidgetSetName = RandomName (NAME_FIRST_HALFLING_FEMALE);}
        else if (nRace == 4){sWidgetSetName = RandomName (NAME_FIRST_HALFELF_FEMALE);}
        else if (nRace == 5){sWidgetSetName = RandomName (NAME_FIRST_HALFORC_FEMALE);}
        else if (nRace == 6){sWidgetSetName = RandomName (NAME_FIRST_HUMAN_FEMALE);}
        else                {sWidgetSetName = RandomName (NAME_FAMILIAR);}
    }
  }

  else if(sWidgetSetName == "")
  {
    sWidgetSetName = "Mysterious Individual";
  }

  if(nWidgetNameSet == 0)
  {
    SetLocalInt(oWidget,"widgetSet",1);
    if   (nRandom == 0){SetName(oWidget,"Temporary Name Changer: " + sWidgetSetName);}
    else {SetName(oWidget,"Temporary Name Changer: Random");}
  }

  if(sOverwriteName == sWidgetSetName)
  {
    NWNX_Rename_ClearPCNameOverride(oPC,OBJECT_INVALID,TRUE);
    SendMessageToPC(oPC,"Clearing Temporary Name");
  }
  else
  {
    NWNX_Rename_SetPCNameOverride(oPC,sWidgetSetName);
    SendMessageToPC(oPC,"Setting Temporary Name");
    if(nRandom == 1){SetLocalString(oWidget, "newName", sWidgetSetName);}
  }
}
