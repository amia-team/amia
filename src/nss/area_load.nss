//Functions for area loading and creation
//this is pretty rudimentary at present
#include "nwnx_area"
//void main (){}
void recreate_area(string areastring)
{
    object oArea;
    oArea = GetObjectByTag(areastring);
    if (GetIsObjectValid(oArea))
            {
                //make sure area is empty
                int playersinarea;
                playersinarea = NWNX_Area_GetNumberOfPlayersInArea(oArea);
                if(playersinarea== 0)
                {
                    DestroyArea(oArea);
                    PrintString("Managed to destroy");
                    CreateArea(areastring);
                }
                else
                {
                    SendMessageToAllDMs("Could not destroy area - Area not empty");
                }
            }
            else
            {
                object area;
                area = GetArea(OBJECT_SELF);
                SendMessageToAllDMs("Area resref invalid");

            }
        }

