// OnConversation action: playerrest: rest
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/25/2005 jking            Initial release
// 06/11/2017 msheeler         Added check to catch death's from debuffs on rest.

//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ca_rest_rest
//description: Set AR_RestChoice to non-zero so that when we re-call the rest script it
// actually begins the rest (if time permits..)
//used as: Rest Script
//date:    03/25/2005
//author:  jking



void main()
{
    object oPC = GetPCSpeaker();
    SetLocalInt(oPC, "AR_RestChoice", 1);
    AssignCommand( oPC, ActionRest() );

    if (GetCurrentHitPoints(oPC) < -9)
    {
        if (GetIsPC(oPC))
        {
            ExecuteScript("mod_pla_death", oPC);
        }
    }
}

