//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//filename: i_hatchanger
//date: 2021/02/12
//author: Raphel Gray
//adapted from i_maskchanger - Thanks Faded Wings


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// privateMethods:
//-------------------------------------------------------------------------------
int getVFXNum(int hatCalled, object oTarget, int nHatRace, object oHatBox)
{
    int PCRace = GetRacialType(oTarget);
    int fVFX = 0;
    int PCGender = GetGender(oTarget);
    effect eHatVFX;
    effect eExtraordinaryHatVFX;
    object oPC = oTarget;

    //SendMessageToPC(oTarget,"Racial Type: " + IntToString(PCRace) + "& Subrace: " + GetSubRace(oTarget) + " & Size: " + IntToString(GetCreatureSize(oTarget)));

    switch(hatCalled)
    {
        case 1:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1284, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1285, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1286, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1287, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1288, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1289, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1290, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1291, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1292, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1293, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1294, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1295, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1296, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1297, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            break;
        }
        case 2:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1298, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1299, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1300, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1301, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1302, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1303, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1304, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1305, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1306, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1307, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1308, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1309, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1310, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1311, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            break;
        }
        case 3:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1411, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1410, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1413, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1412, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1415, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1414, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1417, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1416, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1421, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1420, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1419, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1418, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1421, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1420, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            break;
        }
        case 4:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1423, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1422, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1425, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1424, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1427, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1426, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1429, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1428, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1433, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1432, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1431, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1430, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1433, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1432, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            break;
        }
        case 5:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1435, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1434, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1437, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1436, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1439, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1438, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1441, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1440, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1445, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1444, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1443, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1442, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1445, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1444, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            break;
        }
        case 6:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1447, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1446, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1449, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1448, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1451, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1450, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1453, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1452, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1457, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1456, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1455, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1454, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1457, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1456, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            break;
        }
        case 7:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1459, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1458, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1461, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1460, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1463, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1462, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1465, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1464, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1469, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1468, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1467, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1466, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1469, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1468, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            break;
        }
        case 8:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1471, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1470, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1473, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1472, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1475, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1474, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1477, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1476, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1481, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1480, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1479, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1478, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1481, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1480, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            break;
        }
        case 9:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1483, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1482, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1485, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1484, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1487, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1486, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1489, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1488, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1493, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1492, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1491, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1490, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1493, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1492, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            break;
        }
        case 10:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1495, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1494, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1493, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1492, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1495, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1494, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1497, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1496, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1505, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1504, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1503, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1504, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1505, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1504, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            break;
        }
        case 11:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1507, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1506, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   eHatVFX = EffectVisualEffect(1509, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
               else
               {
                   eHatVFX = EffectVisualEffect(1508, FALSE);
                   eExtraordinaryHatVFX = ExtraordinaryEffect(eHatVFX);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryHatVFX, oPC);
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1511;
               }
               else
               {
                   fVFX = 1510;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1513;
               }
               else
               {
                   fVFX = 1512;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1517;
               }
               else
               {
                   fVFX = 1516;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1515;
               }
               else
               {
                   fVFX = 1514;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1517;
               }
               else
               {
                   fVFX = 1516;
               }
            }
            break;
        }
        case 12:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1519;
               }
               else
               {
                   fVFX = 1518;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1521;
               }
               else
               {
                   fVFX = 1520;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1523;
               }
               else
               {
                   fVFX = 1522;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1525;
               }
               else
               {
                   fVFX = 1524;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1529;
               }
               else
               {
                   fVFX = 1528;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1527;
               }
               else
               {
                   fVFX = 1526;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1529;
               }
               else
               {
                   fVFX = 1528;
               }
            }
            break;
        }
        case 13:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1531;
               }
               else
               {
                   fVFX = 1530;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1533;
               }
               else
               {
                   fVFX = 1532;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1535;
               }
               else
               {
                   fVFX = 1534;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1537;
               }
               else
               {
                   fVFX = 1536;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1541;
               }
               else
               {
                   fVFX = 1540;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1539;
               }
               else
               {
                   fVFX = 1538;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1541;
               }
               else
               {
                   fVFX = 1540;
               }
            }
            break;
        }
        case 14:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1543;
               }
               else
               {
                   fVFX = 1542;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1545;
               }
               else
               {
                   fVFX = 1544;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1547;
               }
               else
               {
                   fVFX = 1546;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1549;
               }
               else
               {
                   fVFX = 1548;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1553;
               }
               else
               {
                   fVFX = 1552;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1551;
               }
               else
               {
                   fVFX = 1550;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1553;
               }
               else
               {
                   fVFX = 1552;
               }
            }
            break;
        }
        case 15:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1312;
               }
               else
               {
                   fVFX = 1313;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1314;
               }
               else
               {
                   fVFX = 1315;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1316;
               }
               else
               {
                   fVFX = 1317;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1318;
               }
               else
               {
                   fVFX = 1319;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1320;
               }
               else
               {
                   fVFX = 1321;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1322;
               }
               else
               {
                   fVFX = 1323;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1324;
               }
               else
               {
                   fVFX = 1325;
               }
            }
            break;
        }
        case 16:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1326;
               }
               else
               {
                   fVFX = 1327;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1328;
               }
               else
               {
                   fVFX = 1329;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1330;
               }
               else
               {
                   fVFX = 1331;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1332;
               }
               else
               {
                   fVFX = 1333;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1334;
               }
               else
               {
                   fVFX = 1335;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1336;
               }
               else
               {
                   fVFX = 1337;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1338;
               }
               else
               {
                   fVFX = 1339;
               }
            }
            break;
        }
        case 17:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1340;
               }
               else
               {
                   fVFX = 1341;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1342;
               }
               else
               {
                   fVFX = 1343;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1344;
               }
               else
               {
                   fVFX = 1345;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1346;
               }
               else
               {
                   fVFX = 1347;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1348;
               }
               else
               {
                   fVFX = 1349;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1350;
               }
               else
               {
                   fVFX = 1351;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1352;
               }
               else
               {
                   fVFX = 1353;
               }
            }
            break;
        }
        case 18:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1354;
               }
               else
               {
                   fVFX = 1355;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1356;
               }
               else
               {
                   fVFX = 1357;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1358;
               }
               else
               {
                   fVFX = 1359;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1360;
               }
               else
               {
                   fVFX = 1361;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1362;
               }
               else
               {
                   fVFX = 1363;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1364;
               }
               else
               {
                   fVFX = 1365;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1366;
               }
               else
               {
                   fVFX = 1367;
               }
            }
            break;
        }
        case 19:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1368;
               }
               else
               {
                   fVFX = 1369;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1370;
               }
               else
               {
                   fVFX = 1371;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1372;
               }
               else
               {
                   fVFX = 1373;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1374;
               }
               else
               {
                   fVFX = 1375;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1376;
               }
               else
               {
                   fVFX = 1377;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1378;
               }
               else
               {
                   fVFX = 1379;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1380;
               }
               else
               {
                   fVFX = 1381;
               }
            }
            break;
        }
        case 20:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1382;
               }
               else
               {
                   fVFX = 1383;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1384;
               }
               else
               {
                   fVFX = 1385;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1386;
               }
               else
               {
                   fVFX = 1387;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1388;
               }
               else
               {
                   fVFX = 1389;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1390;
               }
               else
               {
                   fVFX = 1391;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1392;
               }
               else
               {
                   fVFX = 1393;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1394;
               }
               else
               {
                   fVFX = 1395;
               }
            }
            break;
        }
    }
    return fVFX;
}


void changeHat(object oPC, int nNode, int nHat, int nHatRace, object oHatBox)
{
    AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD) ) ;
    int newVFXNo = getVFXNum(nNode, oPC, nHatRace, oHatBox);
    effect eEffect  = EffectVisualEffect(newVFXNo);
    eEffect = SupernaturalEffect(eEffect);
    SetLocalInt(oPC, "fw_hat", 1);
    clean_vars ( oPC, 4 );
    DeleteLocalString(oPC, "ds_action");
    DelayCommand('1.0', ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC));
}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
/*void main(){

    object oPC = GetItemActivator();
    object oHatBox = GetItemActivated();
    int nHat = GetLocalInt(oPC, "fw_hat");
    int nHatSetup = GetLocalInt(oHatBox, "hatSetup");
    string scriptCalled = GetLocalString(oPC, "ds_action");

    if (nHatSetup == 0)
        {
            SetLocalString( oPC, "ds_action", "i_hatchanger" );
            if (scriptCalled == "") {
                AssignCommand( oPC, ActionStartConversation( oPC, "hatracesel_conv", TRUE, FALSE ) );
            }
            int nNode = GetLocalInt( oPC, "ds_node" );
            if (nNode != 0)
            {
                nHatSetup = nNode;
                SetLocalInt(oHatBox, "hatSetup", nHatSetup);
                SendMessageToPC(oPC,"Your race has been set.");
                DeleteLocalString(oPC, "ds_action");
            }
         } else {
            int nHatRace = nHatSetup;
            if(scriptCalled != "" && scriptCalled == "i_hatchanger")
            {
                int nNode = GetLocalInt( oPC, "ds_node" );
                changeHat(oPC, nNode, nHat, nHatRace, oHatBox);
            }
            else
            {
                //event variables
                int nEvent  = GetUserDefinedItemEventNumber();
                int nResult = X2_EXECUTE_SCRIPT_END;

                switch (nEvent){

                    case X2_ITEM_EVENT_ACTIVATE:

                        if(nHat == 0)
                        {
                            SetLocalString( oPC, "ds_action", "i_hatchanger" );
                            SetLocalObject( oPC, "ds_target", oPC );
                            AssignCommand( oPC, ActionStartConversation( oPC, "hatchanger_conv", TRUE, FALSE ) );
                        }
                        else
                        {
                            AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD) ) ;
                            effect eLoop=GetFirstEffect(oPC);
                            while (GetIsEffectValid(eLoop))
                            {
                                if (GetEffectType(eLoop)==EFFECT_TYPE_VISUALEFFECT)
                                {
                                    RemoveEffect(oPC, eLoop);
                                }
                                eLoop=GetNextEffect(oPC);
                            }
                            SetLocalInt(oPC, "fw_hat", 0);
                        }
                    break;
                }
            //Pass the return value back to the calling script
            SetExecutedScriptReturnValue(nResult);
         }
    }
}*/
