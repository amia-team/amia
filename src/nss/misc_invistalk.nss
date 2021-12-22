void main()
{
    object oPC = GetEnteringObject();
    object oShaman = GetNearestObjectByTag("orcwiz");

    if (GetIsPC(oPC) == TRUE && GetIsObjectValid(oShaman))
    {
        FloatingTextStringOnCreature("A sense of evil from the altar permeates the room", oPC);
    }
}

