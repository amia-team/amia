/*
   Actand Demiplane Summoning Reward

  -Maverick00053 11/24/2023
*/

void main()
{
    object oItem = GetItemActivated();
    object oPC = GetItemActivator();
    location lTarget = GetItemActivatedTargetLocation();
    SetLocalObject(oPC,"actandsummonitem",oItem);
    SetLocalLocation(oPC,"actandsummonlocation",lTarget);

    ExecuteScript("actand_summon_fn", oPC);
}
