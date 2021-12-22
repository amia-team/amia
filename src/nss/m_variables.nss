// Module variable utilities.
//
// Revision History
// Date       Name               Description
// ---------- ----------------   ---------------------------------------------
// 20050214   jking              Initial Release

//
// Constants
//
const string REST_DELAY                      = "RestDelay";
const int    REST_DELAY_DEFAULT              = 8;

const string TREASURE_CHANCE_PERCENT         = "TreasureChancePercent";
const int    TREASURE_CHANCE_PERCENT_DEFAULT = 1;

const string DREAMCOIN_XP                    = "DreamcoinXP";
const int    DREAMCOIN_XP_DEFAULT            = 250;
const string DREAMCOIN_GP                    = "DreamcoinGP";
const int    DREAMCOIN_GP_DEFAULT            = 1000;

const string TREASURE_BIN_PREFIX             = "TreasureBinCR";

const string DESPAWN_DELAY                   = "DespawnDelay";
const int    DESPAWN_DELAY_DEFAULT           = 120;

const string LOOTCORPSE_DECAY                = "LootCorpseDecay";
const int    LOOTCORPSE_DECAY_DEFAULT        = 300;

int GetDefaultModuleInt(string sVarName, int iDefault)
{
    int iVal = GetLocalInt(GetModule(), sVarName);
    if (!iVal) iVal = iDefault;
    return iVal;
}


