void main()
{
    string SIDE_1_OBJECT_REF = "sidesetter_side1";
    string SIDE_2_OBJECT_REF = "sidesetter_side2";
    object oPC = GetItemActivatedTarget();

    if (GetIsPC(oPC)) {
        object oSide1 = GetObjectByTag(SIDE_1_OBJECT_REF);
        object oSide2 = GetObjectByTag(SIDE_2_OBJECT_REF);
        AdjustReputation(oPC, oSide1, 100);
        AdjustReputation(oPC, oSide2, -100);
    }
}
