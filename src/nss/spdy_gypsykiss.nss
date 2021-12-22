// Speedy Messenger Quest.  Conversation action to give PC a slight ability
// decrease after kissing the gypsy.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/25/2003 jpavelch         Initial release.
//

void main( )
{
    object oPC = GetPCSpeaker( );

    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        EffectAbilityDecrease(ABILITY_CONSTITUTION, 2),
        oPC,
        30.0
    );
}
