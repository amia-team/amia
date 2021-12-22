/*
   Monster PC Check - If they are good it will shift them to neutral.

   - Maverick00053 - 8/17/2020
*/

void main()
{
    object oPC = OBJECT_SELF;
    int nRacialType = GetRacialType(oPC);
    if(GetItemPossessedBy(oPC,"goodboi") != OBJECT_INVALID) return;
    // Check for PC monsterous races
    if(((nRacialType == 38) ||  (nRacialType == 39) ||  (nRacialType == 43)  ||
    (nRacialType == 44)  ||  (nRacialType == 45)  ||  (nRacialType == 30)  ||
    (nRacialType == 42)) && (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD))
    {
       AdjustAlignment(oPC,ALIGNMENT_EVIL,31,FALSE);
    }
}
