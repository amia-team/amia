//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ioldiskenter
//group:   Iol Disk Custom Ioun Stone
//used as: OnEnter Aura script for Augmented Summoning aura
//date:    August 21, 2014
//author:  Glim

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void ApplyIolite(object oTarget, object oCaster, effect eIolite)
{
    if (GetMaster(oTarget) == oCaster && GetAssociateType(oTarget) != ASSOCIATE_TYPE_DOMINATED)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIolite, oTarget);
    }
}

void main()
{
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator(OBJECT_SELF);
    effect eIolite = SupernaturalEffect(EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 4), EffectAbilityIncrease(ABILITY_CONSTITUTION, 4)));
    eIolite = TagEffect(eIolite, "iolite_summ_effect");

    DelayCommand(1.0f, ApplyIolite(oTarget, oCaster, eIolite));
}