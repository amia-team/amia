//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ss_an_trailcnt
//group:   Shadowscape Wastes
//used as: OnEnter
//date:    June 27 2014
//author:  Anatida
//
// Keep a running adjustment for the DC check to be handled later with
// ss_an_lostcheck Script
//-----------------------------------------------------------------------------
void main()
{

object oPC = GetEnteringObject();
string sType = GetLocalString(OBJECT_SELF, "TrailType");
int nOffTrail;
int nOnTrail;
int nAdjLostDC;

    if (GetIsPC(oPC))
    {
        if (sType == "OffTrail")
        {
        nAdjLostDC = GetLocalInt(oPC, "AdjLostDC");

       nAdjLostDC--;

        SetLocalInt(oPC, "AdjLostDC", nAdjLostDC);
        //SendMessageToPC(oPC, "Your Get Lost Adjustment = "+IntToString(nAdjLostDC));

        }
        else if (sType == "OnTrail")
        {
        nAdjLostDC = GetLocalInt(oPC, "AdjLostDC");

        nAdjLostDC++;

        SetLocalInt(oPC, "AdjLostDC", nAdjLostDC);
        //SendMessageToPC(oPC, "Your Get Lost Adjustment = "+IntToString(nAdjLostDC));

        }
    }
 }
