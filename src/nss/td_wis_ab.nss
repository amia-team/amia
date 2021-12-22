#include "x2_inc_spellhook"
void IntuitiveAttack( object oPC );

void main(){

    IntuitiveAttack( OBJECT_SELF );
}

void IntuitiveAttack( object oPC )
{
    int nSTR     = GetAbilityModifier( ABILITY_STRENGTH, oPC );
    int nWIS     = GetAbilityModifier( ABILITY_WISDOM, oPC );

    effect eSTRMalus = EffectAttackDecrease( nSTR );
    effect eWISBonus = EffectAttackIncrease( nWIS );

    if( !GetHasSpellEffect( GetSpellId(), oPC ) )
    {
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( eSTRMalus ), oPC );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( eWISBonus ), oPC );
        SendMessageToPC( oPC, "Intuitive Attack activated!" );
    }
    else
    {
        RemoveEffectsFromSpell( oPC, GetSpellId() );
        SendMessageToPC( oPC, "Intuitive Attack deactivated!" );
    }
}
