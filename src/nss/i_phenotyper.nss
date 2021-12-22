#include "x2_inc_switches"

void ActivateItem()
{
   object oPC = GetItemActivator();
   object oUsed = GetItemActivated();
    {
        int a = GetLocalInt(oUsed,"active");
        int p = GetLocalInt(oUsed,"alt_phenotype");
        int b = GetLocalInt(oUsed,"base_phenotype");
        string n = GetLocalString(oUsed,"phenotype_name");

        if(p != -1 && b != -1 && n != "")
        {
            if (a == 0)
            {
                string sKey = "active";
                int iValue = 1;
                SetLocalInt(oUsed, sKey, iValue);
                SendMessageToPC(oPC, n + " active.");
                SetPhenoType(p, oPC);
            }
            else
            {
                string sKey = "active";
                int iValue = 0;
                SetLocalInt(oUsed, sKey, iValue);
                SendMessageToPC(oPC, n + " inactive.");
                SetPhenoType(b, oPC);
            }
        }
        else
        {
            if(GetIsDM(oPC))
            {
                string m = ""; //message to DM
                int c = 0; //counter

                if(p == -1)
                {
                    m = "alt_phenotype";
                    c = c + 1;
                }
                if(b == -1)
                {
                    if(c != 0)
                    {
                        m = m + ", base_phenotype";
                    }
                    else
                    {
                        m = "base_phenotype";
                    }
                    c = c + 1;
                }
                if(n == "")
                {
                    if(c != 0)
                    {
                        m = m + ", phenotype_name";
                    }
                    else
                    {
                        m = "phenotype_name";
                    }
                }
                SendMessageToPC(oPC, "The ( " + m + " ) variable(s) are missing from this widget!");
            }
            else
            {
                SendMessageToPC(oPC, "This phenotype widget is not properly configured. Please contact a DM.");
            }
        }
    }
}
void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
