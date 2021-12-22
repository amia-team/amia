//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  pos_an_lostcheck
//group:   Shadowscape Wastes
//used as: OnEnter
//date:    May 26 2014
//author:  Anatida
//
// PC enters a trigger. Script determines if the PC gets lost or travels to the
// next area based on a simulated survival skill calculation.
//-----------------------------------------------------------------------------
void main()
{

object oPC = GetEnteringObject();
int nClassLvl;
object oTarget;
location lTarget;


if (!GetIsPC(oPC)) return;
if (GetLocalInt(OBJECT_SELF, "Block")== 1)return;

int nLostDC = GetLocalInt(OBJECT_SELF, "LostDC");           //Get trigger variable for DC
int nRanger = GetLevelByClass(CLASS_TYPE_RANGER, oPC);      //Get Class level to calc DC
int nMasterScout = GetLevelByClass(CLASS_TYPE_HARPER, oPC);

int nWisMod = GetAbilityModifier(ABILITY_WISDOM, oPC);     //Get WIS mod to calc DC
int nAdjLostDC = GetLocalInt(oPC, "AdjLostDC");            //Get Trail mod to calc DC
SetLocalInt(OBJECT_SELF, "Block", 1);  //Prevent yourself from being triggered by other PCs
                                      // So calc is done on first entering party member

if(nRanger > 5)
    {
    nClassLvl = 5;      // Since MS is limited to 5 levels, also limit Ranger to 5
    }                   // for ease of setting DC

else nClassLvl = (nRanger + nMasterScout);

int nMyRoll =(nClassLvl + nWisMod + nAdjLostDC);

if (nMyRoll >= nLostDC)
    {
   //SendMessageToPC(oPC, "Pass Roll = "+IntToString(nMyRoll)+" vs LostDC "+IntToString(nLostDC));
   //SendMessageToPC(oPC, "nClassLvl = "+IntToString(nClassLvl)+" + nWisMod "+IntToString(nWisMod)+" + nAdjLostDC "+IntToString(nAdjLostDC));
    string sDestination = GetLocalString(OBJECT_SELF, "Destination");
    oTarget = GetWaypointByTag(sDestination);

    lTarget = GetLocation(oTarget);
       if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

        oTarget=GetFirstFactionMember(oPC, FALSE);

        while (GetIsObjectValid(oTarget))
        {
        AssignCommand(oTarget, ClearAllActions());

        AssignCommand(oTarget, ActionJumpToLocation(lTarget));
        oTarget=GetNextFactionMember(oPC, FALSE);
        DelayCommand(60.0, DeleteLocalInt(OBJECT_SELF, "Block"));
        }
    }

    else if (nMyRoll < nLostDC)
    {
        object oTarget;
        location lTarget;
      //SendMessageToPC(oPC, "Pass Roll = "+IntToString(nMyRoll)+" vs LostDC "+IntToString(nLostDC));
      //SendMessageToPC(oPC, "nClassLvl = "+IntToString(nClassLvl)+" + nWisMod "+IntToString(nWisMod)+" + nAdjLostDC "+IntToString(nAdjLostDC));
        int i = Random(7) + 1;

        oTarget = GetWaypointByTag("WP_POS_LostDest"+IntToString(i));
     // SendMessageToPC(oPC, "Teleporting you to WP_POS_LostDest"+IntToString(i));
        AssignCommand(oPC, ClearAllActions());

        FadeToBlack(oPC, FADE_SPEED_SLOW);
        lTarget = GetLocation(oTarget);

        if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

        oTarget=GetFirstFactionMember(oPC, FALSE);

        while (GetIsObjectValid(oTarget))
           {
           AssignCommand(oTarget, ClearAllActions());

           DelayCommand(2.0, AssignCommand(oTarget, ActionJumpToLocation(lTarget)));
           oTarget=GetNextFactionMember(oPC, FALSE);
           }

        DelayCommand(4.0, FadeFromBlack(oPC, FADE_SPEED_SLOW));
        DelayCommand(4.5, SendMessageToPC(oPC, "It seems you have gotten lost in the dark swamp!"));
        DelayCommand(60.0, DeleteLocalInt(OBJECT_SELF, "Block"));
     }

}
