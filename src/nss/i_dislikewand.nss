// PC Dislike wand
//obsolete?
#include "x2_inc_switches"
void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACTIVATE:{

            // vars
            object oVictim=GetItemActivatedTarget();
            object oPC=GetItemActivator();
            object oArea = GetArea( oPC );


            // Filter: Bug out in 'NoCasting' Zones.
            if( GetLocalInt( oArea, "NoCasting" ) ){

                FloatingTextStringOnCreature(
                    "<cþ  >You may not use the Dislike Wand in a No-PvP or No-Casting Zone!</c>",
                    oPC,
                    FALSE );

                break;

            }

            // only PCs not in your own party are permitted to be disliked
            if( GetIsPC(oVictim)==FALSE             ||
                (GetName(GetFactionLeader(oPC))  ==
                GetName(GetFactionLeader(oVictim))) ){

                FloatingTextStringOnCreature(
                    "<cþ  >You may only like or dislike PCs that aren't in your own party!</c>",
                    oPC,
                    FALSE);

                break;

            }

            // if disliked, set them to like
            if(GetIsEnemy(
                oVictim,
                oPC)==TRUE){

                SetPCLike(
                    oPC,
                    oVictim);

            }
            // if liked, set them to dislike
            else{

                SetPCDislike(
                    oPC,
                    oVictim);

            }

            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
