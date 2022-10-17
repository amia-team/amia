// Set Factions for Army Pen

void main()
{
    string ARMY_PEN_FACTION = "ARMY_PEN_FACTION";

    object oArea = GetArea(OBJECT_SELF);
    int iFaction = GetLocalInt(OBJECT_SELF, ARMY_PEN_FACTION);
    SetLocalInt(oArea, ARMY_PEN_FACTION, iFaction);

}
