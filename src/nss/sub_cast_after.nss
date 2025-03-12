#include "nwnx_creature"


// DEPRECATED
const int WARLOCK = 57;
void main()
{
    // Restore warlock spells...their invocations are infinite.
    if(GetLevelByClass(WARLOCK) > 0)
    {
       //NWNX_Creature_RestoreSpells(OBJECT_SELF);
    }
}
