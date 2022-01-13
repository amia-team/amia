#include "x0_i0_partywide"

void main()
{
    object PC       = GetItemActivator();
    object Heart    = GetItemActivated();
    object Innocent = GetObjectByTag("innocent_fey");

    AssignCommand(PC,ActionSpeakString("*Bites into a juicy, bleeding heart.*",TALKVOLUME_TALK)); // yuck
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_BALLISTA), PC);
    DestroyObject(Heart);
    CreateItemOnObject("bleedheart2", PC, 1, "");
    AdjustReputation(PC, Innocent, 100);
}

