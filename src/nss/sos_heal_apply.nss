//
// This script will cause Leidende to harm someone with magic
// enough so that they have half their current hitpoints.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2005/01/12 jking            Initial Release.
//

void main()
{
    object oPC       = GetPCSpeaker();
    object oLeidende = OBJECT_SELF;
    object oAltar    = GetObjectByTag("sos_altar_pain");
    int    iDamage   = GetCurrentHitPoints(oPC) / 2;
    int    iFortSave = FortitudeSave(oPC, 18, SAVING_THROW_TYPE_ELECTRICITY, oLeidende);

    if (iFortSave == 1)
        iDamage /= 3;

    if (iFortSave < 2) {
        SetLocalObject(oAltar, "object_to_harm", oPC    );
        SetLocalInt   (oAltar, "amount_to_harm", iDamage);
        ExecuteScript("sos_heal_do", oAltar);   // so we don't stop the conversation in progress
    }

    // control the conversation response
    SetLocalInt(oPC, "leidende_harm", iFortSave);
}
