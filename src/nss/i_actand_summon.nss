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

    // adding uncursing cause many items where handed out while being cursed
    SetItemCursedFlag( oItem, FALSE );

    ExecuteScript("actand_summon_fn", oPC);
}
