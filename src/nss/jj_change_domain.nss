#include "inc_ds_gods"


void main()
{
    object oPC       = GetLastUsedBy();
    object oIdol     = FindIdol( oPC, GetDeity(oPC));
    int nCheck1      = GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0;
    int nCheck2      = GetIsObjectValid(oIdol);
    int nCheck3      = GetPCKEYValue(oPC, "jj_changed_domain_1");
    int nCheck4      = GetPCKEYValue(oPC, "jj_changed_domain_2");
    SendMessageToPC(oPC, IntToString(nCheck3) + " - " + IntToString(nCheck4));

    string sIdolDbg  = GetName( oIdol )
                       + " " + IntToString(GetLocalInt(oIdol, "dom_1"))
                       + " " + IntToString(GetLocalInt(oIdol, "dom_2"))
                       + " " + IntToString(GetLocalInt(oIdol, "dom_3"))
                       + " " + IntToString(GetLocalInt(oIdol, "dom_4"))
                       + " " + IntToString(GetLocalInt(oIdol, "dom_5"))
                       + " " + IntToString(GetLocalInt(oIdol, "dom_6"));

    SendMessageToPC(oPC, sIdolDbg );

    // T1K: Added check to see if the cleric's domains match their patron's.
    // If they don't, reset the changed variables so the PC can swap domains
    // again. It should help refrain from breaking the system in case of conversions
    if ((MatchDomain(oPC,oIdol) == -1) || (MatchDomain( oPC, oIdol, 1 ) == -1)) {
        SetPCKEYValue(oPC, "jj_changed_domain_1", FALSE);
        SetPCKEYValue(oPC, "jj_changed_domain_2", FALSE);
        int nCheck3      = GetPCKEYValue(oPC, "jj_changed_domain_1");
        int nCheck4      = GetPCKEYValue(oPC, "jj_changed_domain_2");
    }

    int nAction      = GetLocalInt(oPC, "ds_node");
    DeleteLocalInt(oPC, "ds_node");
    switch(nAction)
    {
        case 0:
            SetLocalInt(oPC, "ds_check_1", !nCheck1);
            SetLocalInt(oPC, "ds_check_2", !nCheck2);
            SetLocalInt(oPC, "ds_check_3", !nCheck3);
            SetLocalInt(oPC, "ds_check_4", !nCheck4);
            SetLocalString(oPC, "ds_action", "jj_change_domain");
            SetCustomToken( 8000, GetDomainName( GetDomain(oPC,1)));
            SetCustomToken( 8001, GetDomainName( GetDomain(oPC,2)));
            SetCustomToken( 8002, GetDomainName( GetLocalInt(oIdol, "dom_1")));
            SetCustomToken( 8003, GetDomainName( GetLocalInt(oIdol, "dom_2")));
            SetCustomToken( 8004, GetDomainName( GetLocalInt(oIdol, "dom_3")));
            SetCustomToken( 8005, GetDomainName( GetLocalInt(oIdol, "dom_4")));
            SetCustomToken( 8006, GetDomainName( GetLocalInt(oIdol, "dom_5")));
            SetCustomToken( 8007, GetDomainName( GetLocalInt(oIdol, "dom_6")));
            ActionStartConversation(oPC,"jj_domainchanger",TRUE,FALSE);
        break;
        //changing first domain
        case 1: ChangeDomain(oPC, 1, GetLocalInt(oIdol, "dom_1"));
                SetLocalInt( oPC, "ds_check_3", 0 );
                break;
        case 2: ChangeDomain(oPC, 1, GetLocalInt(oIdol, "dom_2"));
                SetLocalInt( oPC, "ds_check_3", 0 );
                break;
        case 3: ChangeDomain(oPC, 1, GetLocalInt(oIdol, "dom_3"));
                SetLocalInt( oPC, "ds_check_3", 0 );
                break;
        case 4: ChangeDomain(oPC, 1, GetLocalInt(oIdol, "dom_4"));
                SetLocalInt( oPC, "ds_check_3", 0 );
                break;
        case 5: ChangeDomain(oPC, 1, GetLocalInt(oIdol, "dom_5"));
                SetLocalInt( oPC, "ds_check_3", 0 );
                break;
        case 6: ChangeDomain(oPC, 1, GetLocalInt(oIdol, "dom_6"));
                SetLocalInt( oPC, "ds_check_3", 0 );
                break;
        //changing second domain
        case 7: ChangeDomain(oPC, 2, GetLocalInt(oIdol, "dom_1"));
                SetLocalInt( oPC, "ds_check_4", 0 );
                break;
        case 8: ChangeDomain(oPC, 2, GetLocalInt(oIdol, "dom_2"));
                SetLocalInt( oPC, "ds_check_4", 0 );
                break;
        case 9: ChangeDomain(oPC, 2, GetLocalInt(oIdol, "dom_3"));
                SetLocalInt( oPC, "ds_check_4", 0 );
                break;
        case 10: ChangeDomain(oPC, 2, GetLocalInt(oIdol, "dom_4"));
                SetLocalInt( oPC, "ds_check_4", 0 );
                break;
        case 11: ChangeDomain(oPC, 2, GetLocalInt(oIdol, "dom_5"));
                SetLocalInt( oPC, "ds_check_4", 0 );
                break;
        case 12: ChangeDomain(oPC, 2, GetLocalInt(oIdol, "dom_6"));
                SetLocalInt( oPC, "ds_check_4", 0 );
                break;
    }
}
