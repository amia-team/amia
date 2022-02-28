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

    //SendMessageToPC(oTarget,"Racial Type: " + IntToString(PCRace) + "& Subrace: " + GetSubRace(oTarget) + " & Size: " + IntToString(GetCreatureSize(oTarget)));

    switch(hatCalled)
    {
        case 1:
        {
            if(nHatRace = 1) //Dwarf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1284;
               }
               else
               {
                   fVFX = 1285;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1286;
               }
               else
               {
                   fVFX = 1287;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1288;
               }
               else
               {
                   fVFX = 1289;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1290;
               }
               else
               {
                   fVFX = 1291;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1292;
               }
               else
               {
                   fVFX = 1293;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1294;
               }
               else
               {
                   fVFX = 1295;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1296;
               }
               else
               {
                   fVFX = 1297;
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
                   fVFX = 1298;
               }
               else
               {
                   fVFX = 1299;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1300;
               }
               else
               {
                   fVFX = 1301;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1302;
               }
               else
               {
                   fVFX = 1303;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1304;
               }
               else
               {
                   fVFX = 1305;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1306;
               }
               else
               {
                   fVFX = 1307;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1308;
               }
               else
               {
                   fVFX = 1309;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1310;
               }
               else
               {
                   fVFX = 1311;
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
                   fVFX = 1411;
               }
               else
               {
                   fVFX = 1410;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1413;
               }
               else
               {
                   fVFX = 1412;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1415;
               }
               else
               {
                   fVFX = 1414;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1417;
               }
               else
               {
                   fVFX = 1416;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1421;
               }
               else
               {
                   fVFX = 1420;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1419;
               }
               else
               {
                   fVFX = 1418;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1421;
               }
               else
               {
                   fVFX = 1420;
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
                   fVFX = 1423;
               }
               else
               {
                   fVFX = 1422;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1425;
               }
               else
               {
                   fVFX = 1424;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1427;
               }
               else
               {
                   fVFX = 1426;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1429;
               }
               else
               {
                   fVFX = 1428;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1433;
               }
               else
               {
                   fVFX = 1432;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1431;
               }
               else
               {
                   fVFX = 1430;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1433;
               }
               else
               {
                   fVFX = 1432;
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
                   fVFX = 1435;
               }
               else
               {
                   fVFX = 1434;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1437;
               }
               else
               {
                   fVFX = 1436;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1439;
               }
               else
               {
                   fVFX = 1438;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1441;
               }
               else
               {
                   fVFX = 1440;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1445;
               }
               else
               {
                   fVFX = 1444;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1443;
               }
               else
               {
                   fVFX = 1442;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1445;
               }
               else
               {
                   fVFX = 1444;
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
                   fVFX = 1447;
               }
               else
               {
                   fVFX = 1446;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1449;
               }
               else
               {
                   fVFX = 1448;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1451;
               }
               else
               {
                   fVFX = 1450;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1453;
               }
               else
               {
                   fVFX = 1452;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1457;
               }
               else
               {
                   fVFX = 1456;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1455;
               }
               else
               {
                   fVFX = 1454;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1457;
               }
               else
               {
                   fVFX = 1456;
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
                   fVFX = 1459;
               }
               else
               {
                   fVFX = 1458;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1461;
               }
               else
               {
                   fVFX = 1460;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1463;
               }
               else
               {
                   fVFX = 1462;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1465;
               }
               else
               {
                   fVFX = 1464;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1469;
               }
               else
               {
                   fVFX = 1468;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1467;
               }
               else
               {
                   fVFX = 1466;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1469;
               }
               else
               {
                   fVFX = 1468;
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
                   fVFX = 1471;
               }
               else
               {
                   fVFX = 1470;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1473;
               }
               else
               {
                   fVFX = 1472;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1475;
               }
               else
               {
                   fVFX = 1474;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1477;
               }
               else
               {
                   fVFX = 1476;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1481;
               }
               else
               {
                   fVFX = 1480;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1479;
               }
               else
               {
                   fVFX = 1478;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1481;
               }
               else
               {
                   fVFX = 1480;
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
                   fVFX = 1483;
               }
               else
               {
                   fVFX = 1482;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1485;
               }
               else
               {
                   fVFX = 1484;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1487;
               }
               else
               {
                   fVFX = 1486;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1489;
               }
               else
               {
                   fVFX = 1488;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1493;
               }
               else
               {
                   fVFX = 1492;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1491;
               }
               else
               {
                   fVFX = 1490;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1493;
               }
               else
               {
                   fVFX = 1492;
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
                   fVFX = 1495;
               }
               else
               {
                   fVFX = 1494;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1493;
               }
               else
               {
                   fVFX = 1492;
               }
            }
            else if(nHatRace = 3) //Gnome
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1495;
               }
               else
               {
                   fVFX = 1494;
               }
            }
            else if(nHatRace = 4) //Halfling
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1497;
               }
               else
               {
                   fVFX = 1496;
               }
            }
            else if(nHatRace = 5) //Half - Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1505;
               }
               else
               {
                   fVFX = 1504;
               }
            }
            else if(nHatRace = 6) //Half - Orc
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1503;
               }
               else
               {
                   fVFX = 1504;
               }
            }
            else if(nHatRace = 7) //Human
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1505;
               }
               else
               {
                   fVFX = 1504;
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
                   fVFX = 1507;
               }
               else
               {
                   fVFX = 1506;
               }
            }
            else if(nHatRace = 2) //Elf
            {
               if(PCGender == GENDER_MALE)
               {
                   fVFX = 1509;
               }
               else
               {
                   fVFX = 1508;
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

