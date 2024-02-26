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

void main()
{
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator( OBJECT_SELF );
    effect eIolite = SupernaturalEffect(EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 4), EffectAbilityIncrease(ABILITY_CONSTITUTION, 4)));
    eIolite = TagEffect(eIolite, "iolite_summ_effect");

    if (GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oCaster) == oTarget ||
        GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oCaster) == oTarget ||
        GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster) == oTarget ||
        GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oCaster) == oTarget)
    {
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eIolite, oTarget );
    }
}
