// Item event script for Arachnid Empathy. Dominates hostile/neutral Arachnids
// within a howl's radius.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/20/2015 Mahtan Tasadur    Initial release.
// 10/04/2021 Jes               Added appearances.
//

#include "x2_inc_switches"

void KillInvis( object oPC ){

    effect eEff = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEff ) ){
        nType=GetEffectType( eEff );

        if( nType == EFFECT_TYPE_INVISIBILITY || nType == EFFECT_TYPE_ETHEREAL || nType == EFFECT_TYPE_SANCTUARY )
            RemoveEffect( oPC, eEff );

        eEff = GetNextEffect( oPC );
    }
}

void ActivateItem( )
{
    // Main variables.
    object oPC      = GetItemActivator();
    int nDuration   = GetHitDice( oPC );
    int nCount;

    // Effects to be added to Arachnids.
    effect eDom     = EffectCutsceneDominated();
    effect eStr     = EffectAbilityIncrease( ABILITY_STRENGTH, 4 );
    effect eCon     = EffectAbilityIncrease( ABILITY_CONSTITUTION, 4 );
    effect eWis     = EffectAbilityIncrease( ABILITY_WISDOM, d10() );
    effect eAttack  = EffectAttackIncrease( 5 );
    effect eDamage  = EffectDamageIncrease( 5 );

    // Wrap it all together.
    effect eLink    = EffectLinkEffects( eStr, eCon );
           eLink    = EffectLinkEffects( eLink, eAttack );
           eLink    = EffectLinkEffects( eLink, eWis );
           eLink    = EffectLinkEffects( eLink, eDamage );
           eLink    = SupernaturalEffect( eLink );

    // Apply a howl to the PC first!
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_HOWL_MIND ), oPC );

    // Wrap through targets in a colossal radius.
    object oVictim = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), FALSE, OBJECT_TYPE_CREATURE );
    while( oVictim != OBJECT_INVALID && nCount < 3 ) // Cap targets to 3
    {
        if( oVictim != oPC && !GetIsPC(oVictim)) // Can't target yourself or another player!
        {
            // Check for Archnids only.
            if( GetAppearanceType( oVictim ) >= 157 && GetAppearanceType( oVictim ) <= 162 ||
                GetAppearanceType( oVictim ) == 520 ||
                GetAppearanceType( oVictim ) == 521 ||
                GetAppearanceType( oVictim ) >= 903 && GetAppearanceType( oVictim ) <= 905 ||
                GetAppearanceType( oVictim ) == 886 ||
                GetAppearanceType( oVictim ) >= 1172 && GetAppearanceType( oVictim ) <= 1173 ||
                GetAppearanceType( oVictim ) >= 1741 && GetAppearanceType( oVictim ) <= 1745 ||
                GetAppearanceType( oVictim ) >= 1947 && GetAppearanceType( oVictim ) <= 1949 ||
                GetCreatureTailType( oVictim ) == 337 ||
                GetCreatureTailType( oVictim ) == 338 ||
                GetCreatureTailType( oVictim ) >= 473 && GetCreatureTailType( oVictim ) <= 478 ||
                GetCreatureTailType( oVictim ) == 547 ||
                GetCreatureTailType( oVictim ) >= 564 && GetCreatureTailType( oVictim ) <= 566 ||
                GetCreatureTailType( oVictim ) >= 822 && GetCreatureTailType( oVictim ) <= 823 ||
                GetCreatureTailType( oVictim ) >= 1667 && GetCreatureTailType( oVictim ) <= 1669 )
                {
                    // If they're not friendly, dominate them and add them to the PC's party.
                    if( !GetIsFriend( oVictim, oPC ) && GetAssociateType( oVictim )  == ASSOCIATE_TYPE_NONE && GetRacialType( oVictim ) == RACIAL_TYPE_VERMIN && !GetIsPC( oVictim ) )
                    {
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( eDom ), oVictim, TurnsToSeconds( nDuration ) );
                    }

                    // Remove any invisibility effects.
                    KillInvis( oPC );

                    // Apply buffs.
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oVictim, TurnsToSeconds( nDuration ) );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( 685 ), oVictim );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HOLY_AID ), oVictim );

                    // Increment the count.
                    nCount++;
           }
        }
        oVictim = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), FALSE,  OBJECT_TYPE_CREATURE );
        }
     }
void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );
    object oPC = GetItemActivator();

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
        AssignCommand( oPC, ActivateItem() ); // Assign to PC so it dominates targets properly
        break;
    }
}
