//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ioldiskexit
//group:   Iol Disk Custom Ioun Stone
//used as: OnExit Aura script for Augmented Summoning aura
//date:    August 21, 2014
//author:  Glim

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oTarget = GetExitingObject();
    object oCaster = GetAreaOfEffectCreator(OBJECT_SELF);
    effect eRemove = GetFirstEffect(oTarget);

    // so it doesn't remove iolite effect from other peep's summons
    if (GetMaster(oTarget) != oCaster) return;

    while(GetIsEffectValid(eRemove))
    {
        if(GetEffectTag(eRemove) == "iolite_summ_effect")
            RemoveEffect(oTarget, eRemove);
        eRemove = GetNextEffect(oTarget);
    }
}
