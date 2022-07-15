/*
  Player Temporary Name Changer
  Maverick00053 - 7/14/22
*/

#include "nwnx_rename"
#include "nwnx"

void main()
{
  object oPC = GetItemActivator();
  object oWidget = GetItemActivated();
  string sWidgetSetName = GetLocalString(oWidget, "newName");
  int nWidgetNameSet = GetLocalInt(oWidget,"widgetSet");


  if(sWidgetSetName == "")
  {
    sWidgetSetName = "Mysterious Individual";
  }

  if(nWidgetNameSet == 0)
  {
    SetLocalInt(oWidget,"widgetSet",1);
    SetName(oWidget,"Temporary Name Changer: " + sWidgetSetName);
  }

  if(NWNX_Rename_GetPCNameOverride(oPC) == sWidgetSetName)
  {
    NWNX_Rename_ClearPCNameOverride(oPC,OBJECT_INVALID,TRUE);
    SendMessageToPC(oPC,"Clearing Temporary Name");
  }
  else
  {
    NWNX_Rename_SetPCNameOverride(oPC,sWidgetSetName);
    SendMessageToPC(oPC,"Setting Temporary Name");
  }
}
