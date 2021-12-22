#include "nwnx_creature"
#include "inc_amia_databas"

void main()
{
    object player = OBJECT_SELF;
    string playerGod = DB_GetPlayerDeity(player);
    string idol = GetLocalString(player, "idol_deity");
    string idolAlignments = GetLocalString(player, "idol_alignments");

    if(idol == "")
    {
        WriteTimestampedLogEntry("zol_idols_new: ERROR setting player's deity.\n\tPotential causes: Did someone mess up and call this script anywhere other than a deity idol? Were the correct variable names set? (see documentation)");
    }

    // Don't let players swap deities without a DM, but we allow deity changes for levels 10 and below.
    if(playerGod != "" && GetHitDice(player) > 10)
    {
        FloatingTextStringOnCreature("You already have a deity. The gods do not favor the disloyal...", player, FALSE);
        return;
    }

    DB_SetPlayerDeity(player, idol);
}
