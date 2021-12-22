// A tag that prevents multiple blessings from clerics / priests and
// is now also used to prevent multiple conversations with some NPCs in
// the shadow realm academy.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050502   jking            Initial Release

const int ALL_BLESSINGS     = 0;    // for clearing from startup script
const int STANDARD_BLESSING = 1;
const int ACADEMY_TEACH_0   = 2;
const int ACADEMY_TEACH_1   = 3;
const int ACADEMY_TEACH_2   = 4;
const int HAMAR_PISSOFF     = 5;

const string BLESSING_VARNAME_PREFIX = "AR_Blessing_";

// Sets the piss-off flag on a PC.
//
void SetBlessing( object oPC, int iType )
{
    SetLocalInt( oPC, BLESSING_VARNAME_PREFIX + IntToString(iType), 1 );
}

// Checks to see if the piss-off flag is there
//
int IsBlessed( object oPC, int iType )
{
    return GetLocalInt( oPC, BLESSING_VARNAME_PREFIX + IntToString(iType) );
}

// Clears the piss-off flag on a PC.
//
void ClearBlessing( object oPC, int iType )
{
    if (iType == ALL_BLESSINGS) {
        ClearBlessing(oPC, STANDARD_BLESSING);
        ClearBlessing(oPC, ACADEMY_TEACH_0);
        ClearBlessing(oPC, ACADEMY_TEACH_1);
        ClearBlessing(oPC, ACADEMY_TEACH_2);
        ClearBlessing(oPC, HAMAR_PISSOFF);
    } else {
        DeleteLocalInt( oPC, BLESSING_VARNAME_PREFIX + IntToString(iType) );
    }
}

