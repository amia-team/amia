/*
---------------------------------------------------------------------------------
NAME: obscuring_en
Description: This is the onenter script of the obscuring aura.
LOG:
    Faded Wings [1/9/2016 - born]
----------------------------------------------------------------------------------
*/

/* Original Description

Obscuring Aura (Su): Sepulchral thieves are shrouded in a mind- and senses-clouding aura of negative energy.
Living creatures in a 30-foot radius must succeed on a Will save or be affected by the aura.
Creatures with fewer than one-half the sepulchral thief's Hit Dice are blinded and deafened.
For example, if the sepulchral thief has 9 HD, this applies to creatures of 4 HD or fewer.
All other creatures take a -2 penalty on Listen, Search, and Spot checks.
A creature that successfully saves cannot be affected again by the same thief's aura for 24 hours.    <--- did not do this

*/

void main()
{
    // Variables.
    object oCreature        = GetEnteringObject( );
    object oPC              = GetAreaOfEffectCreator( );
    int iDC                 = GetHitDice( oPC ) / 2;

    // Prevent stacking.
    if( GetLocalInt( oCreature, "fw_obscuring" ) )
        return;
    else
        SetLocalInt( oCreature, "fw_obscuring", 1 );

    // Creature is hostile.
    if( GetIsEnemy( oCreature, oPC ) ){

        // Build Effects
        effect eVFX = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
        effect eBlind = EffectBlindness();
        effect eDeaf = EffectDeaf();
        effect eListenPen = EffectSkillDecrease( SKILL_LISTEN, 2 );
        effect eSearchPen = EffectSkillDecrease( SKILL_SEARCH, 2 );
        effect eSpotPen = EffectSkillDecrease( SKILL_SPOT, 2 );
        effect eLink = EffectLinkEffects(eVFX, eBlind);
               eLink = EffectLinkEffects(eLink,eDeaf);
               eLink = EffectLinkEffects(eLink,eListenPen);
               eLink = EffectLinkEffects(eLink,eSearchPen);
               eLink = EffectLinkEffects(eLink,eSpotPen);

        // Apply Effect
        int iAfflicted = WillSave( oCreature, iDC, SAVING_THROW_TYPE_NEGATIVE, oPC );

        if( !iAfflicted ) {
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oCreature );
        }
    }

    return;
}
