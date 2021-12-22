/*
---------------------------------------------------------------------------------
NAME: f_immy_shadow
DESCRIPTION: A custom feat to replace what would have been her (Iim'mur'ss) flight ability. Increasing her abilities based on her direct connection/incorporation and manipulation with the shadowstuff.
LOG:
    Faded Wings [10/19/2015 - Created]
                [11/08/2015 - Updated]
----------------------------------------------------------------------------------
*/

#include "x2_inc_spellhook"
void ShadowAugment( object oPC );

void main()
{
    ShadowAugment( OBJECT_SELF ) ;
}

void ShadowAugment( object oPC )
{
    int skillIncreaseBy = 5;
    int drIncreaseBy = 10;

    effect eHide = EffectSkillIncrease( SKILL_HIDE, skillIncreaseBy );
    effect eMS = EffectSkillIncrease( SKILL_MOVE_SILENTLY, skillIncreaseBy );
    effect eColdDR = EffectDamageResistance( DAMAGE_TYPE_COLD, drIncreaseBy  );

    if( !GetHasSpellEffect( GetSpellId(), oPC ) )
    {
        ApplyEffectToObject ( DURATION_TYPE_PERMANENT, SupernaturalEffect( eMS ), oPC );
        ApplyEffectToObject ( DURATION_TYPE_PERMANENT, SupernaturalEffect( eHide ), oPC );
        ApplyEffectToObject ( DURATION_TYPE_PERMANENT, SupernaturalEffect( eColdDR ), oPC );
    }
    else
    {
        RemoveEffectsFromSpell( oPC, GetSpellId() );
        SendMessageToPC( oPC, "Shadow augment deactivated!" );
    }
}

