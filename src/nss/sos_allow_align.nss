// Checks for Loviatar favored alignment
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2005/01/12 jking            Initial Release.
//

int sos_allow_align(object oPC)
{
    int    iLawChaos = GetAlignmentLawChaos(oPC);
    int    iGoodEvil = GetAlignmentGoodEvil(oPC);
    int    iFavor    = TRUE;

    if (iGoodEvil == ALIGNMENT_GOOD ||
        iGoodEvil == ALIGNMENT_NEUTRAL && iLawChaos == ALIGNMENT_CHAOTIC)
            iFavor = FALSE;

    return iFavor;
}

