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
    effect eSTR = SupernaturalEffect( EffectAbilityIncrease( ABILITY_STRENGTH, 4 ) );
    effect eCON = SupernaturalEffect( EffectAbilityIncrease( ABILITY_CONSTITUTION, 4 ) );

    if( GetAssociate( ASSOCIATE_TYPE_FAMILIAR, oCaster ) == oTarget ||
        GetAssociate( ASSOCIATE_TYPE_ANIMALCOMPANION, oCaster ) == oTarget ||
        GetAssociate( ASSOCIATE_TYPE_SUMMONED, oCaster ) == oTarget )
    {
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eSTR, oTarget );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCON, oTarget );
    }
}
