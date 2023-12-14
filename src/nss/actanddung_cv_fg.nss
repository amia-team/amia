/*
   Actland dialogue end script for good/evil choice

  - Maverick00053  11/23/2023

*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"

void main()
{
  object oPC = GetPCSpeaker();
  SetPCKEYValue(oPC,"actanddungeon",1);
  DeleteLocalInt(oPC,"ds_check_1");
  DeleteLocalInt(oPC,"ds_check_2");
}
