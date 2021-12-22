//
// When the PC puts his or her hands on the Altar of Pain, the altar
// checks to see if they are the appropriate alignment for worship.
// This is also used to control the store from the sos_check_evil script.
//
// You must be LE, LN, NE, CE, or TN to gain Loviatar's favor.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2005/01/12 jking            Initial Release.
//

//#include "x0_i0_position"
#include "sos_allow_align"

void main()
{
    object oPC    = GetPCSpeaker();

//    TurnToFaceObject(GetObjectByTag("sos_altar_pain"), oPC);

    effect eCheck = EffectVisualEffect(VFX_IMP_EVIL_HELP);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCheck, oPC);
//    DelayCommand(3.0f, TurnToFaceObject(GetObjectByTag("sos_leidende"), oPC));

    // Control Leidende's reply
    SetLocalInt(oPC, "loviatar_favor", sos_allow_align(oPC));
}
